// hi-ha.be — panneau d'administration de contenu léger (CMS)
const { useState: useStateAdmin } = React;

const CONTENT = [
  { t: 'Donner du sens à l\'IA', type: 'Page', sec: 'Accueil', status: 'pub', maj: '2 juin' },
  { t: 'Souveraineté des données', type: 'Page', sec: 'Approche', status: 'pub', maj: '28 mai' },
  { t: 'Automatiser avec n8n', type: 'Article', sec: 'Blog', status: 'review', maj: '4 juin' },
  { t: 'Formation IA pour équipes', type: 'Page', sec: 'Formations', status: 'pub', maj: '21 mai' },
  { t: 'Agents métiers : 3 cas concrets', type: 'Article', sec: 'Blog', status: 'draft', maj: '5 juin' },
  { t: 'IA locale & open source', type: 'Page', sec: 'Approche', status: 'pub', maj: '19 mai' },
  { t: 'Mentions légales', type: 'Page', sec: 'Légal', status: 'pub', maj: '12 avr.' },
];

const STATUS = { pub: 'Publié', draft: 'Brouillon', review: 'En revue' };

function StatCard({ icon, k, v, c }) {
  return (
    <div className="stat">
      <div className="sk"><Icon name={icon} /> {k}</div>
      <div className="sv">{v}</div>
      {c && <div className="sc">{c}</div>}
    </div>
  );
}

// Éditeur d'apparence — bornes STRICTES aux tokens du design system.
// Tout choix reste "dans le style du site" : pas de couleur/rayon libre.
const ACCENTS = [
  { id: 'lilas', label: 'Lilas froid', ink: '#7E7BC4', soft: '#DAD9EE' },
  { id: 'peche', label: 'Pêche douce', ink: '#C98E76', soft: '#ECDAD3' },
  { id: 'rose', label: 'Rose brume', ink: '#BE8791', soft: '#E2D0D4' },
  { id: 'graphite', label: 'Graphite', ink: '#363B41', soft: '#DFE1E9' },
];
const BTN_STYLES = [
  { id: 'primary', label: 'Plein' },
  { id: 'accent', label: 'Iridescent' },
  { id: 'secondary', label: 'Contour' },
];
const RADII = [
  { id: 'md', label: 'Doux', v: '14px' },
  { id: 'lg', label: 'Ample', v: '20px' },
  { id: 'pill', label: 'Pilule', v: '999px' },
];
const WEIGHTS = [
  { id: '600', label: 'SemiBold' },
  { id: '700', label: 'Bold' },
  { id: '800', label: 'ExtraBold' },
];
// Boutons individuels du site + variantes autorisées par la charte
const SITE_BUTTONS = [
  { id: 'hero-audit', label: 'Accueil — Demander un audit', text: 'Demander un audit', def: 'plein' },
  { id: 'hero-demo', label: 'Accueil — Réserver une démo', text: 'Réserver une démo', def: 'entoure' },
  { id: 'header-cta', label: 'Header — Demander un audit', text: 'Demander un audit', def: 'plein' },
  { id: 'cta-band', label: 'Bande CTA — Demander un audit', text: 'Demander un audit', def: 'plein' },
];
const INDIV_VARIANTS = [
  { id: 'plein', label: 'Plein' },
  { id: 'entoure', label: 'Entouré' },
  { id: 'transparent', label: 'Transparent' },
];
// Recettes bornées à la charte (mêmes styles que le site)
function variantStyle(variant, a, rad) {
  const base = { fontFamily: 'var(--font-display)', fontWeight: 600, fontSize: 14, padding: '10px 18px', borderRadius: rad, cursor: 'pointer', whiteSpace: 'nowrap' };
  if (variant === 'plein') return { ...base, background: 'var(--fg)', color: 'var(--bg)', border: '1px solid transparent' };
  if (variant === 'entoure') return { ...base, background: 'transparent', color: 'var(--fg)', border: `1px solid ${a.ink}` };
  return { ...base, background: 'transparent', color: a.ink, border: '1px solid transparent' }; // transparent
}

function Swatches({ value, onChange }) {
  return (
    <div className="ap-swatches">
      {ACCENTS.map(a => (
        <button key={a.id} className={`ap-sw ${value === a.id ? 'on' : ''}`} onClick={() => onChange(a.id)} title={a.label}>
          <span className="ap-dot" style={{ background: `linear-gradient(135deg, ${a.soft}, ${a.ink})` }}></span>
          <span className="ap-swlabel">{a.label}</span>
          {value === a.id && <span className="ap-check"><Icon name="check" /></span>}
        </button>
      ))}
    </div>
  );
}
function Seg({ options, value, onChange }) {
  return (
    <div className="seg" style={{ width: '100%' }}>
      {options.map(o => (
        <button key={o.id} className={value === o.id ? 'on' : ''} style={{ flex: 1 }} onClick={() => onChange(o.id)}>{o.label}</button>
      ))}
    </div>
  );
}

const ADMIN_TITLES = {
  tableau: ['Tableau de bord', "Vue d'ensemble"],
  contenu: ['Contenus', 'Gérez les pages et articles du site'],
  pages: ['Pages', 'Afficher / masquer les pages et choisir leur emplacement'],
  temoignages: ['Témoignages', 'Photo, citation, nom, titre, entreprise'],
  demandes: ['Demandes', 'Soumissions du formulaire de contact'],
  medias: ['Médias', 'Bibliothèque (Garage S3)'],
  apparence: ['Apparence', 'Personnalisez le style — dans les limites du design system'],
  reglages: ['Réglages', 'Coordonnées, réseaux, textes globaux'],
};

const SITE_PAGES = [
  { id: 'accueil', t: 'Accueil', locked: true, visible: true, place: 'both' },
  { id: 'services', t: 'Services', visible: true, place: 'both' },
  { id: 'formations', t: 'Formations', visible: true, place: 'both' },
  { id: 'souverainete', t: 'Souveraineté', visible: true, place: 'both' },
  { id: 'methodologie', t: 'Méthodologie', visible: true, place: 'nav' },
  { id: 'domaines', t: 'Domaines', visible: true, place: 'nav' },
  { id: 'temoignages', t: 'Témoignages', visible: true, place: 'footer' },
  { id: 'calendrier', t: 'Calendrier', visible: false, place: 'nav' },
  { id: 'mentions', t: 'Mentions légales', visible: true, place: 'footer' },
  { id: 'confidentialite', t: 'Politique de confidentialité', visible: false, place: 'footer' },
  { id: 'cookies', t: 'Politique cookies', visible: false, place: 'footer' },
  { id: 'cgv', t: 'Conditions générales', visible: true, place: 'footer' },
];
const PLACES = [{ id: 'nav', label: 'Nav' }, { id: 'footer', label: 'Footer' }, { id: 'both', label: 'Les deux' }, { id: 'none', label: 'Aucun' }];

function PagesManager() {
  const [pages, setPages] = useStateAdmin(SITE_PAGES);
  const upd = (id, patch) => setPages(ps => ps.map(p => p.id === id ? { ...p, ...patch } : p));
  return (
    <React.Fragment>
      <p className="pm-help"><Icon name="info" /> Une page <strong>masquée</strong> disparaît automatiquement de la nav, du footer et du sitemap. Activez-la quand son texte est prêt.</p>
      <div className="tablecard">
        <div className="trow pm-row thead"><span>Page</span><span className="hidecol">Visibilité</span><span className="hidecol">Emplacement</span><span></span></div>
        {pages.map(p => (
          <div className="trow pm-row" key={p.id}>
            <div><div className="tt">{p.t}</div>{p.locked && <div className="tmeta">Toujours visible</div>}</div>
            <span className="hidecol">
              <button className={`toggle ${p.visible ? 'on' : ''}`} disabled={p.locked} onClick={() => upd(p.id, { visible: !p.visible })} aria-label="Visible">
                <span className="toggle-dot"></span>
              </button>
              <span className="toggle-lbl">{p.visible ? 'Visible' : 'Masquée'}</span>
            </span>
            <span className="hidecol">
              <select className="pm-select" value={p.place} disabled={!p.visible} onChange={e => upd(p.id, { place: e.target.value })}>
                {PLACES.map(pl => <option key={pl.id} value={pl.id}>{pl.label}</option>)}
              </select>
            </span>
            <div className="tactions"><button className="iconbtn" aria-label="Éditer"><Icon name="pencil" /></button></div>
          </div>
        ))}
      </div>
    </React.Fragment>
  );
}

const ADMIN_TESTIMONIALS = [
  { id: 1, initials: 'CD', name: 'Camille Dupont', role: 'Directrice des opérations', company: 'Atelier Verrier SA', visible: true },
  { id: 2, initials: 'ML', name: 'Marc Lemaire', role: 'Secrétaire général', company: 'Commune de Wavre', visible: true },
  { id: 3, initials: 'SR', name: 'Sophie Renard', role: 'Coordinatrice pédagogique', company: 'Haute École Namur', visible: true },
];

function TestimonialsManager() {
  const [list, setList] = useStateAdmin(ADMIN_TESTIMONIALS);
  return (
    <div className="tm-grid">
      {list.map(t => (
        <div className="tm-card" key={t.id}>
          <div className="tm-top">
            <span className="tm-photo">{t.initials}</span>
            <div className="tm-id"><span className="tm-name">{t.name}</span><span className="tm-role">{t.role}</span><span className="tm-company">{t.company}</span></div>
            <button className={`toggle sm ${t.visible ? 'on' : ''}`} onClick={() => setList(l => l.map(x => x.id === t.id ? { ...x, visible: !x.visible } : x))} aria-label="Visible"><span className="toggle-dot"></span></button>
          </div>
          <div className="tm-photohint"><Icon name="image" /> Photo / logo</div>
          <div className="tm-actions"><button className="iconbtn" aria-label="Éditer"><Icon name="pencil" /></button><button className="iconbtn" aria-label="Supprimer"><Icon name="trash-2" /></button></div>
        </div>
      ))}
      <button className="tm-add"><Icon name="plus" /> Ajouter un témoignage</button>
    </div>
  );
}

function AppearanceEditor() {
  const [accent, setAccent] = useStateAdmin('lilas');
  const [btn, setBtn] = useStateAdmin('accent');
  const [radius, setRadius] = useStateAdmin('pill');
  const [weight, setWeight] = useStateAdmin('700');
  const [overrides, setOverrides] = useStateAdmin(() => Object.fromEntries(SITE_BUTTONS.map(b => [b.id, b.def])));
  const setOv = (id, v) => setOverrides(o => ({ ...o, [id]: v }));

  const a = ACCENTS.find(x => x.id === accent);
  const rad = RADII.find(x => x.id === radius).v;
  const previewVars = { '--accent-ink': a.ink, '--accent-lilas': a.soft };

  // styles de bouton dérivés (mêmes recettes que le site)
  const btnStyle = btn === 'primary'
    ? { background: 'var(--fg)', color: 'var(--bg)', border: '1px solid transparent' }
    : btn === 'accent'
    ? { background: `linear-gradient(120deg, ${a.soft}, #E2D0D4 50%, #DAD9EE)`, color: '#363B41', border: '1px solid transparent' }
    : { background: 'var(--surface)', color: 'var(--fg)', border: '1px solid var(--border-strong)' };

  return (
    <div className="ap-grid">
      <div className="ap-controls">
        <div className="ap-card">
          <div className="ap-h"><Icon name="droplet" /> Couleur d'accent</div>
          <p className="ap-help">Utilisée pour les liens, icônes actives et boutons iridescents.</p>
          <Swatches value={accent} onChange={setAccent} />
        </div>
        <div className="ap-card">
          <div className="ap-h"><Icon name="mouse-pointer-click" /> Style de bouton</div>
          <div className="ap-field"><label>Apparence</label><Seg options={BTN_STYLES} value={btn} onChange={setBtn} /></div>
          <div className="ap-field"><label>Rayon des coins</label><Seg options={RADII} value={radius} onChange={setRadius} /></div>
        </div>
        <div className="ap-card">
          <div className="ap-h"><Icon name="type" /> Titres</div>
          <div className="ap-field"><label>Graisse (Manrope)</label><Seg options={WEIGHTS} value={weight} onChange={setWeight} /></div>
        </div>
        <div className="ap-card ap-card-wide">
          <div className="ap-h"><Icon name="square-mouse-pointer" /> Boutons individuels</div>
          <p className="ap-help">Choisissez le style de chaque bouton du site : plein, entouré ou transparent (sans fond).</p>
          {SITE_BUTTONS.map(b => (
            <div className="ap-btnrow" key={b.id}>
              <div className="ap-btnrow-top">
                <span className="ap-btnlabel">{b.label}</span>
                <button style={variantStyle(overrides[b.id], a, rad)}>{b.text}</button>
              </div>
              <Seg options={INDIV_VARIANTS} value={overrides[b.id]} onChange={v => setOv(b.id, v)} />
            </div>
          ))}
        </div>
        <p className="ap-note"><Icon name="lock" /> Les options sont limitées aux tokens du design system : impossible de sortir de la charte.</p>
      </div>

      <div className="ap-preview" style={previewVars}>
        <div className="ap-pvlabel">Aperçu en direct</div>
        <div className="ap-pvcard">
          <span className="overline" style={{ color: a.ink }}>Conseil · Formation · Intégration</span>
          <h3 style={{ fontFamily: 'var(--font-display)', fontWeight: Number(weight), fontSize: 26, letterSpacing: '-.01em', color: 'var(--fg)', margin: '10px 0 8px' }}>
            Donner du sens à l'IA.
          </h3>
          <p style={{ fontSize: 14.5, lineHeight: 1.55, color: 'var(--fg-3)', marginBottom: 18 }}>
            Des solutions humaines, claires et durables pour vos équipes.
          </p>
          <div style={{ display: 'flex', gap: 10, flexWrap: 'wrap', alignItems: 'center' }}>
            <button style={{ ...btnStyle, fontFamily: 'var(--font-display)', fontWeight: 600, fontSize: 15, padding: '12px 22px', borderRadius: rad, cursor: 'pointer' }}>
              Demander un audit
            </button>
            <a style={{ color: a.ink, fontWeight: 600, fontSize: 14.5 }}>En savoir plus →</a>
          </div>
          <div style={{ marginTop: 20, display: 'flex', gap: 10 }}>
            {['n8n', 'Open source', 'IA locale'].map(t => (
              <span key={t} style={{ fontFamily: 'var(--font-body)', fontWeight: 500, fontSize: 13, padding: '6px 14px', borderRadius: rad === '999px' ? '999px' : '10px', background: a.soft, color: '#41454D' }}>{t}</span>
            ))}
          </div>
        </div>
      </div>
    </div>
  );
}

function Editor({ item, onClose }) {
  const [tab, setTab] = useStateAdmin('contenu');
  const [status, setStatus] = useStateAdmin(item ? item.status : 'draft');
  return (
    <React.Fragment>
      <div className={`drawer-scrim ${item ? 'open' : ''}`} onClick={onClose}></div>
      <aside className={`drawer ${item ? 'open' : ''}`}>
        {item && (
          <React.Fragment>
            <div className="drawer-head">
              <h3>Éditer le contenu</h3>
              <button className="iconbtn" onClick={onClose} aria-label="Fermer"><Icon name="x" /></button>
            </div>
            <div className="drawer-body">
              <div className="seg" style={{ marginBottom: 22 }}>
                <button className={tab === 'contenu' ? 'on' : ''} onClick={() => setTab('contenu')}>Contenu</button>
                <button className={tab === 'seo' ? 'on' : ''} onClick={() => setTab('seo')}>SEO</button>
              </div>
              {tab === 'contenu' ? (
                <React.Fragment>
                  <div className="field"><label>Titre</label><input defaultValue={item.t} /></div>
                  <div className="field-row">
                    <div className="field"><label>Type</label>
                      <select defaultValue={item.type}><option>Page</option><option>Article</option></select></div>
                    <div className="field"><label>Section</label>
                      <select defaultValue={item.sec}><option>Accueil</option><option>Approche</option><option>Formations</option><option>Blog</option><option>Légal</option></select></div>
                  </div>
                  <div className="field"><label>Extrait</label>
                    <textarea defaultValue="Des solutions humaines, claires et durables pour adopter l'IA concrètement."></textarea></div>
                  <div className="field"><label>Statut</label>
                    <div className="seg" style={{ width: '100%' }}>
                      {Object.keys(STATUS).map(s => (
                        <button key={s} className={status === s ? 'on' : ''} style={{ flex: 1 }} onClick={() => setStatus(s)}>{STATUS[s]}</button>
                      ))}
                    </div>
                  </div>
                </React.Fragment>
              ) : (
                <React.Fragment>
                  <div className="field"><label>Titre SEO</label><input defaultValue={`${item.t} — hi-ha.be`} /></div>
                  <div className="field"><label>Slug</label><input defaultValue={'/' + item.t.toLowerCase().replace(/[^a-z]+/g, '-').slice(0, 24)} /></div>
                  <div className="field"><label>Meta description</label><textarea defaultValue="Conseil, formation et intégration en IA & automatisation."></textarea></div>
                </React.Fragment>
              )}
            </div>
            <div className="drawer-foot">
              <button className="btn btn-ghost" onClick={onClose}>Annuler</button>
              <button className="btn btn-primary" onClick={onClose}>Enregistrer</button>
            </div>
          </React.Fragment>
        )}
      </aside>
    </React.Fragment>
  );
}

function AdminPage({ theme, toggle, onNavigate }) {
  const [editing, setEditing] = useStateAdmin(null);
  const [nav, setNav] = useStateAdmin('contenu');
  return (
    <div className="admin">
      <aside className="asidebar">
        <a className="brand" href="#" onClick={e => e.preventDefault()}>
          <img src="assets/symbol-flat-light.svg" alt="" /><span>hi-ha.be</span>
        </a>
        <div className="agroup">Gestion</div>
        <div className={`anav ${nav === 'tableau' ? 'active' : ''}`} onClick={() => setNav('tableau')}><Icon name="layout-dashboard" /> Tableau de bord</div>
        <div className={`anav ${nav === 'contenu' ? 'active' : ''}`} onClick={() => setNav('contenu')}><Icon name="file-text" /> Contenus <span className="badge">7</span></div>
        <div className={`anav ${nav === 'pages' ? 'active' : ''}`} onClick={() => setNav('pages')}><Icon name="layers" /> Pages</div>
        <div className={`anav ${nav === 'temoignages' ? 'active' : ''}`} onClick={() => setNav('temoignages')}><Icon name="quote" /> Témoignages</div>
        <div className={`anav ${nav === 'demandes' ? 'active' : ''}`} onClick={() => setNav('demandes')}><Icon name="inbox" /> Demandes <span className="badge">3</span></div>
        <div className={`anav ${nav === 'medias' ? 'active' : ''}`} onClick={() => setNav('medias')}><Icon name="image" /> Médias</div>
        <div className="agroup">Système</div>
        <div className={`anav ${nav === 'apparence' ? 'active' : ''}`} onClick={() => setNav('apparence')}><Icon name="palette" /> Apparence</div>
        <div className={`anav ${nav === 'reglages' ? 'active' : ''}`} onClick={() => setNav('reglages')}><Icon name="settings" /> Réglages</div>
        <div className="anav" onClick={() => onNavigate('home')} style={{ marginTop: 'auto' }}><Icon name="external-link" /> Voir le site</div>
      </aside>

      <div className="amain">
        <div className="atop">
          <div>
            <h1>{ADMIN_TITLES[nav] ? ADMIN_TITLES[nav][0] : 'Contenus'}</h1>
            <div className="sub">{ADMIN_TITLES[nav] ? ADMIN_TITLES[nav][1] : 'Gérez les pages et articles du site'}</div>
          </div>
          <div className="spacer"></div>
          {!['apparence', 'pages'].includes(nav) && <div className="search"><Icon name="search" /><input placeholder="Rechercher…" /></div>}
          <ThemeToggle theme={theme} toggle={toggle} />
          {nav === 'apparence'
            ? <button className="btn btn-accent btn-sm"><Icon name="check" /> Enregistrer</button>
            : nav === 'temoignages'
            ? <button className="btn btn-accent btn-sm"><Icon name="plus" /> Nouveau témoignage</button>
            : nav === 'pages'
            ? <span></span>
            : <button className="btn btn-accent btn-sm" onClick={() => setEditing({ t: 'Nouveau contenu', type: 'Page', sec: 'Accueil', status: 'draft' })}>
                <Icon name="plus" /> Nouveau
              </button>}
        </div>
        <div className="abody">
          {nav === 'apparence' ? <AppearanceEditor />
          : nav === 'pages' ? <PagesManager />
          : nav === 'temoignages' ? <TestimonialsManager />
          : (
          <React.Fragment>
          <div className="statcards">
            <StatCard icon="file-text" k="Contenus" v="7" c="↑ 2 ce mois" />
            <StatCard icon="eye" k="Vues / mois" v="3,4k" c="↑ 18%" />
            <StatCard icon="inbox" k="Demandes" v="12" c="3 nouvelles" />
            <StatCard icon="clock" k="En revue" v="1" />
          </div>
          <div className="tablecard">
            <div className="trow thead">
              <span>Titre</span><span className="hidecol">Section</span><span className="hidecol">Statut</span><span></span>
            </div>
            {CONTENT.map((c, i) => (
              <div className="trow" key={i}>
                <div>
                  <div className="tt">{c.t}</div>
                  <div className="tmeta">{c.type} · maj {c.maj}</div>
                </div>
                <span className="hidecol" style={{ fontSize: 13.5, color: 'var(--fg-2)' }}>{c.sec}</span>
                <span className="hidecol"><span className="statusdot"><span className={`d ${c.status}`}></span>{STATUS[c.status]}</span></span>
                <div className="tactions">
                  <button className="iconbtn" onClick={() => setEditing(c)} aria-label="Éditer"><Icon name="pencil" /></button>
                  <button className="iconbtn" aria-label="Plus"><Icon name="more-horizontal" /></button>
                </div>
              </div>
            ))}
          </div>
          </React.Fragment>
          )}
        </div>
      </div>

      <Editor item={editing} onClose={() => setEditing(null)} />
    </div>
  );
}

Object.assign(window, { AdminPage });
