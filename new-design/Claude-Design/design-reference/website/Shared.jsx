// hi-ha.be — composants partagés : thème, marque, header, footer
const { useState, useEffect, useRef, useCallback } = React;

// ---- Icône Lucide (re-render à chaque mount) ----
function Icon({ name, ...rest }) {
  const ref = useRef(null);
  useEffect(() => {
    if (ref.current && window.lucide) {
      ref.current.innerHTML = '';
      const el = document.createElement('i');
      el.setAttribute('data-lucide', name);
      ref.current.appendChild(el);
      window.lucide.createIcons({ attrs: { 'stroke-width': 1.75 }, nameAttr: 'data-lucide' });
    }
  }, [name]);
  return <span ref={ref} style={{ display: 'inline-flex' }} {...rest}></span>;
}

// ---- Thème (clair par défaut, persisté) ----
function useTheme() {
  const [theme, setTheme] = useState(() => localStorage.getItem('hh-theme') || 'light');
  useEffect(() => {
    document.documentElement.setAttribute('data-theme', theme);
    localStorage.setItem('hh-theme', theme);
  }, [theme]);
  const toggle = useCallback(() => setTheme(t => (t === 'light' ? 'dark' : 'light')), []);
  return { theme, toggle };
}

function Brand({ className = '' }) {
  return (
    <a className={`brand ${className}`} href="#" onClick={e => e.preventDefault()}>
      <img src="assets/symbol-flat-light.svg" alt="" aria-hidden="true" />
      <span>hi-ha.be</span>
    </a>
  );
}

function ThemeToggle({ theme, toggle }) {
  return (
    <button className="iconbtn" onClick={toggle} aria-label="Basculer le thème" title="Clair / sombre">
      <Icon name={theme === 'light' ? 'moon' : 'sun'} />
    </button>
  );
}

// Structure de navigation — menus verticaux pilotés par les données.
// `view` cible une vue du proto ; en prod ce sont des routes (ex. /services/conseil).
const NAV = [
  { label: 'Services', items: [
    { t: 'Conseil & stratégie', icon: 'message-circle', view: 'home',
      children: ['Audit IA', 'Feuille de route', 'Cadrage de projet'] },
    { t: 'Formations', icon: 'graduation-cap', view: 'home',
      children: ['Sessions sur mesure', 'Ateliers pratiques'] },
    { t: 'Automatisation n8n', icon: 'workflow', view: 'home',
      children: ['Intégrations', 'Agents & déclencheurs'] },
    { t: 'IA locale & agents', icon: 'server', view: 'home',
      children: ['Déploiement on-premise', 'Assistants métiers'] },
  ]},
  { label: 'Formations', items: [
    { t: 'Sensibilisation', icon: 'lightbulb', view: 'home' },
    { t: 'Ateliers pratiques', icon: 'wrench', view: 'home' },
    { t: 'Parcours équipe', icon: 'users', view: 'home' },
  ]},
  { label: 'Souveraineté', view: 'home' },
  { label: 'Approche', items: [
    { t: 'Méthodologie', icon: 'route', view: 'home' },
    { t: 'Domaines', icon: 'layout-grid', view: 'home' },
    { t: 'Témoignages', icon: 'quote', view: 'home' },
  ]},
  { label: 'Calendrier', view: 'calendrier' },
];

function Header({ theme, toggle, onNavigate }) {
  const [menu, setMenu] = useState(false);       // overlay mobile
  const [open, setOpen] = useState(null);        // index du menu desktop ouvert
  const [fly, setFly] = useState(null);          // index du sous-sous-menu (flyout) ouvert
  const [mobOpen, setMobOpen] = useState(null);  // accordéon mobile ouvert
  const closeTimer = useRef(null);

  const enter = i => { clearTimeout(closeTimer.current); setOpen(i); setFly(null); };
  const leave = () => { closeTimer.current = setTimeout(() => { setOpen(null); setFly(null); }, 160); };

  const go = (v) => { setOpen(null); setFly(null); setMenu(false); onNavigate(v || 'home'); };

  return (
    <header className={`header ${menu ? 'menu-open' : ''}`}>
      <div className="container">
        <div className="header-inner">
          <Brand />
          <nav className="nav" onMouseLeave={leave}>
            {NAV.map((item, i) => (
              <div key={item.label} className="navitem"
                   onMouseEnter={() => item.items ? enter(i) : (setOpen(null), setFly(null))}>
                <button className={`navlink ${open === i ? 'active' : ''}`}
                        aria-haspopup={!!item.items} aria-expanded={open === i}
                        onClick={() => item.items ? setOpen(open === i ? null : i) : go(item.view)}>
                  {item.label}
                </button>
                {item.items && (
                  <div className={`mega ${open === i ? 'show' : ''}`} onMouseEnter={() => enter(i)}>
                    <div className="mega-inner vmenu">
                      {item.items.map((it, idx) => (
                        <div className={`vrow-wrap ${fly === idx ? 'flyopen' : ''}`} key={it.t}
                             onMouseEnter={() => setFly(it.children ? idx : null)}>
                          <button className="vrow" onClick={() => go(it.view)}>
                            {it.icon && <span className="vrow-ic"><Icon name={it.icon} /></span>}
                            <span className="vrow-t">{it.t}</span>
                            {it.children && <Icon name="chevron-right" className="vrow-arrow" />}
                          </button>
                          {it.children && (
                            <div className={`flyout ${fly === idx ? 'show' : ''}`}>
                              {it.children.map(c => (
                                <button className="vsub" key={c} onClick={() => go(it.view)}>
                                  <span className="vsub-dot"></span>{c}
                                </button>
                              ))}
                            </div>
                          )}
                        </div>
                      ))}
                    </div>
                  </div>
                )}
              </div>
            ))}
          </nav>
          <div className="header-actions">
            <ThemeToggle theme={theme} toggle={toggle} />
            <button className="btn btn-accent btn-sm" onClick={() => go('contact')}>
              Demander un audit
            </button>
            <button className={`iconbtn menutoggle burger ${menu ? 'open' : ''}`} onClick={() => { setOpen(null); setMenu(m => !m); }} aria-label="Menu" aria-expanded={menu}>
              <span></span><span></span><span></span>
            </button>
          </div>
        </div>
      </div>

      <div className={`mobile-menu ${menu ? 'open' : ''}`}>
        <div className="mm-top">
          <Brand />
          <div className="mm-actions">
            <ThemeToggle theme={theme} toggle={toggle} />
            <button className="iconbtn burger open" onClick={() => setMenu(false)} aria-label="Fermer">
              <span></span><span></span><span></span>
            </button>
          </div>
        </div>
        <div className="mm-list">
          {NAV.map((item, i) => item.items ? (
            <div className="m-acc" key={item.label}>
              <button className="m-acc-head" onClick={() => setMobOpen(mobOpen === i ? null : i)}>
                {item.label}<Icon name="chevron-down" className={`chev ${mobOpen === i ? 'up' : ''}`} />
              </button>
              <div className={`m-acc-body ${mobOpen === i ? 'show' : ''}`}>
                {item.items.map(it => (
                  <div className="m-itemgrp" key={it.t}>
                    <a className="m-item" href="#" onClick={e => { e.preventDefault(); go(it.view); }}>
                      {it.icon && <Icon name={it.icon} className="m-item-ic" />}{it.t}
                    </a>
                    {it.children && (
                      <div className="m-children">
                        {it.children.map(c => (
                          <a key={c} href="#" onClick={e => { e.preventDefault(); go(it.view); }}>{c}</a>
                        ))}
                      </div>
                    )}
                  </div>
                ))}
              </div>
            </div>
          ) : (
            <a key={item.label} className="m-toplink" href="#" onClick={e => { e.preventDefault(); go(item.view); }}>{item.label}</a>
          ))}
        </div>
        <button className="btn btn-accent mm-cta" onClick={() => go('contact')}>Demander un audit</button>
      </div>
    </header>
  );
}

function Footer({ onNavigate }) {
  return (
    <footer className="footer">
      <div className="container">
        <div className="footer-grid">
          <div>
            <Brand />
            <p className="tagline">Conseil, formation et intégration en IA &amp; automatisation pour les organisations. Belgique francophone.</p>
          </div>
          <div>
            <h5>Offre</h5>
            <ul>
              <li><a href="#" onClick={e => e.preventDefault()}>Services</a></li>
              <li><a href="#" onClick={e => e.preventDefault()}>Formations</a></li>
              <li><a href="#" onClick={e => e.preventDefault()}>Souveraineté</a></li>
              <li><a href="#" onClick={e => e.preventDefault()}>Automatisation n8n</a></li>
              <li><a href="#" onClick={e => e.preventDefault()}>IA locale &amp; agents</a></li>
            </ul>
          </div>
          <div>
            <h5>Approche</h5>
            <ul>
              <li><a href="#" onClick={e => e.preventDefault()}>Méthodologie</a></li>
              <li><a href="#" onClick={e => e.preventDefault()}>Domaines</a></li>
              <li><a href="#" onClick={e => e.preventDefault()}>Témoignages</a></li>
              <li><a href="#" onClick={e => { e.preventDefault(); onNavigate('calendrier'); }}>Calendrier</a></li>
            </ul>
          </div>
          <div>
            <h5>Contact</h5>
            <ul>
              <li><a href="#" onClick={e => { e.preventDefault(); onNavigate('contact'); }}>Demander un audit</a></li>
              <li><a href="#" onClick={e => e.preventDefault()}>info@hi-ha.be</a></li>
              <li><a href="#" onClick={e => e.preventDefault()}>LinkedIn</a></li>
            </ul>
          </div>
          <div>
            <h5>Légal</h5>
            <ul>
              <li><a href="#" onClick={e => e.preventDefault()}>Mentions légales</a></li>
              <li><a href="#" onClick={e => e.preventDefault()}>Conditions générales</a></li>
            </ul>
          </div>
        </div>
        <div className="footer-bottom">
          <span>© 2026 hi-ha.be — Tous droits réservés.</span>
          <span className="mono">Conçu en Belgique · IA humaine</span>
        </div>
      </div>
    </footer>
  );
}

Object.assign(window, { Icon, useTheme, Brand, ThemeToggle, Header, Footer });
