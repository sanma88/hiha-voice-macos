// hi-ha.be — page marketing (accueil)
const { useState: useStateHome } = React;

function Hero({ onNavigate }) {
  return (
    <section className="hero">
      <div className="container">
        <div className="hero-grid">
          <div>
            <span className="overline reveal">Conseil · Formation · Intégration IA</span>
            <h1 className="reveal d1">Donner du sens à l'IA pour booster vos équipes.</h1>
            <p className="lead reveal d2">Des solutions humaines, claires et durables.</p>
            <p className="desc reveal d2">
              hi-ha.be accompagne les organisations dans l'adoption concrète de l'intelligence
              artificielle et de l'automatisation. Pédagogie, technique et design réunis pour des
              résultats simples, utiles et mesurables.
            </p>
            <div className="hero-cta reveal d3">
              <button className="btn btn-accent btn-lg" onClick={() => onNavigate('contact')}>
                Demander un audit <Icon name="arrow-right" />
              </button>
              <button className="btn btn-secondary btn-lg" onClick={() => onNavigate('contact')}>
                Réserver une démo
              </button>
            </div>
            <div className="hero-meta reveal d4">
              <div className="m"><b>n8n</b><span>Automatisation</span></div>
              <div className="m"><b>Local</b><span>IA open source</span></div>
              <div className="m"><b>100%</b><span>Vos données chez vous</span></div>
            </div>
          </div>
          <div className="hero-visual reveal d2">
            <div className="glow"></div>
            <img className="symbol" src="assets/symbol-frosted.png" alt="Symbole hi-ha.be en verre givré" />
          </div>
        </div>
      </div>
    </section>
  );
}

const SERVICES = [
  { icon: 'message-circle', t: 'Conseil & stratégie', d: "On clarifie les cas d'usage à fort impact et on trace une feuille de route réaliste." },
  { icon: 'graduation-cap', t: 'Formations', d: "Des sessions concrètes pour rendre vos équipes autonomes avec l'IA au quotidien." },
  { icon: 'workflow', t: 'Automatisation n8n', d: 'Des workflows fiables qui relient vos outils et libèrent du temps utile.' },
  { icon: 'server', t: 'IA locale & agents', d: 'Assistants métiers déployés en local, open source, sous votre contrôle.' },
];

function Services() {
  return (
    <section className="section" id="services">
      <div className="container">
        <div className="shead">
          <span className="overline">Ce que nous faisons</span>
          <h2>Quatre façons de rendre l'IA concrète chez vous.</h2>
          <p>Du premier atelier au déploiement, on relie pédagogie et technique — sans jargon, sans promesses creuses.</p>
        </div>
        <div className="cards">
          {SERVICES.map((s, i) => (
            <article className="scard" key={s.t}>
              <div className="ic"><Icon name={s.icon} /></div>
              <h3>{s.t}</h3>
              <p>{s.d}</p>
              <span className="more">En savoir plus <Icon name="arrow-right" /></span>
            </article>
          ))}
        </div>
      </div>
    </section>
  );
}

function Feature() {
  const checks = [
    'Déploiement en local : vos données ne quittent pas votre infrastructure.',
    'Modèles open source, audités et maîtrisés — pas de boîte noire.',
    "Automatisation n8n et agents métiers conçus pour durer.",
  ];
  return (
    <section className="section" id="souverainete" style={{ paddingTop: 0 }}>
      <div className="container">
        <div className="feature">
          <div>
            <span className="overline">Souveraineté des données</span>
            <h2 style={{ fontFamily: 'var(--font-display)', fontWeight: 600, fontSize: 'clamp(26px,3.4vw,36px)', letterSpacing: '-.02em', lineHeight: 1.15, color: 'var(--fg)', marginTop: 14 }}>
              Au-delà du simple branchement d'une API cloud.
            </h2>
            <p style={{ fontSize: 16, lineHeight: 1.6, color: 'var(--fg-3)', marginTop: 14, maxWidth: 460 }}>
              Notre différence : une IA déployée chez vous, sur des briques open source.
              Vous gardez la main sur vos données, vos coûts et votre conformité.
            </p>
            <ul className="checks">
              {checks.map(c => (
                <li key={c}><span className="ck"><Icon name="check" /></span>{c}</li>
              ))}
            </ul>
          </div>
          <div className="panel">
            <div className="flow">
              <div className="flownode"><div className="fi"><Icon name="database" /></div>
                <div><div className="ft">Vos données</div><div className="fd">on-premise · chiffrées</div></div></div>
              <div className="flowarrow"><Icon name="arrow-down" /></div>
              <div className="flownode"><div className="fi"><Icon name="server" /></div>
                <div><div className="ft">Modèle IA local</div><div className="fd">open source · audité</div></div></div>
              <div className="flowarrow"><Icon name="arrow-down" /></div>
              <div className="flownode"><div className="fi"><Icon name="workflow" /></div>
                <div><div className="ft">Agents &amp; workflows n8n</div><div className="fd">métiers · automatisés</div></div></div>
              <div className="flowarrow"><Icon name="arrow-down" /></div>
              <div className="flownode"><div className="fi"><Icon name="users" /></div>
                <div><div className="ft">Vos équipes</div><div className="fd">autonomes · accompagnées</div></div></div>
            </div>
          </div>
        </div>
      </div>
    </section>
  );
}

const TESTIMONIALS = [
  { quote: "hi-ha.be a transformé notre manière de travailler : nos équipes gagnent un temps précieux, sans jamais perdre la main sur nos données.", name: "Camille Dupont", role: "Directrice des opérations", company: "Atelier Verrier SA", initials: "CD" },
  { quote: "Pédagogues et précis. On a enfin compris où l'IA crée de la valeur chez nous — et on l'a déployée en local, sereinement.", name: "Marc Lemaire", role: "Secrétaire général", company: "Commune de Wavre", initials: "ML" },
  { quote: "Des formations concrètes, sans jargon. Nos enseignants sont repartis avec des usages applicables dès le lendemain.", name: "Sophie Renard", role: "Coordinatrice pédagogique", company: "Haute École Namur", initials: "SR" },
];

function Testimonials() {
  return (
    <section className="section" id="temoignages" style={{ paddingTop: 0 }}>
      <div className="container">
        <div className="shead center">
          <span className="overline">Ils nous font confiance</span>
          <h2>Des résultats concrets, racontés par celles et ceux qui les vivent.</h2>
        </div>
        <div className="tcards">
          {TESTIMONIALS.map(t => (
            <figure className="tcard" key={t.name}>
              <span className="tquote-mark" aria-hidden="true">&ldquo;</span>
              <blockquote className="tquote">{t.quote}</blockquote>
              <figcaption className="tmeta">
                <span className="tphoto" aria-hidden="true">{t.initials}</span>
                <span className="tperson">
                  <span className="tname">{t.name}</span>
                  <span className="trole">{t.role}</span>
                  <span className="tcompany">{t.company}</span>
                </span>
              </figcaption>
            </figure>
          ))}
        </div>
      </div>
    </section>
  );
}

function CtaBand({ onNavigate }) {
  return (
    <section className="section ctaband" style={{ paddingTop: 0 }}>
      <div className="container">
        <div className="inner">
          <h2>L'IA ne remplace pas l'humain. Elle révèle son potentiel.</h2>
          <p>Parlons de votre contexte. Un premier échange, sans engagement.</p>
          <div className="hero-cta">
            <button className="btn btn-accent btn-lg" onClick={() => onNavigate('contact')}>
              Demander un audit <Icon name="arrow-right" />
            </button>
          </div>
        </div>
      </div>
    </section>
  );
}

function HomePage({ onNavigate }) {
  return (
    <React.Fragment>
      <Hero onNavigate={onNavigate} />
      <Services />
      <Feature />
      <Testimonials />
      <CtaBand onNavigate={onNavigate} />
    </React.Fragment>
  );
}

Object.assign(window, { HomePage });
