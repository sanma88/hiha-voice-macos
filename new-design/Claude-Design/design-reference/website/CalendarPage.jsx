// hi-ha.be — page Calendrier / Agenda (masquée par défaut, activable en admin)
const { useState: useStateCal } = React;

const EVENTS = [
  { id: 1, type: 'formation', day: '18', mon: 'JUIN', title: "Atelier n8n : automatiser sans coder", format: 'Présentiel · Namur', desc: "Une demi-journée pour construire vos premiers workflows fiables.", cta: "S'inscrire" },
  { id: 2, type: 'evenement', day: '25', mon: 'JUIN', title: "Midi de l'IA souveraine", format: 'Visio · 12h30', desc: "Retour d'expérience : déployer un modèle open source en local.", cta: 'Participer' },
  { id: 3, type: 'formation', day: '03', mon: 'JUIL', title: "Initiation : l'IA pour les équipes", format: 'Présentiel · Bruxelles', desc: "Comprendre les usages concrets et les bonnes pratiques.", cta: "S'inscrire" },
  { id: 4, type: 'evenement', day: '11', mon: 'JUIL', title: "Atelier agents métiers", format: 'Hybride · Liège', desc: "Concevoir un assistant utile, sous votre contrôle.", cta: 'Participer' },
];

const TYPE_LABEL = { formation: 'Formation', evenement: 'Événement' };

function CalendarPage({ onNavigate }) {
  const [filter, setFilter] = useStateCal('all');
  const list = EVENTS.filter(e => filter === 'all' || e.type === filter);
  return (
    <div className="section" style={{ paddingTop: 56 }}>
      <div className="container">
        <div className="shead center reveal">
          <span className="overline">Agenda</span>
          <h2>Formations et événements à venir.</h2>
          <p>Retrouvez nos prochaines sessions — en présentiel, en visio ou en hybride.</p>
        </div>

        <div className="cal-filters reveal d1">
          {[['all', 'Tous'], ['formation', 'Formations'], ['evenement', 'Événements']].map(([id, lbl]) => (
            <button key={id} className={`cal-filter ${filter === id ? 'on' : ''}`} onClick={() => setFilter(id)}>{lbl}</button>
          ))}
        </div>

        {list.length === 0 ? (
          <div className="cal-empty"><Icon name="calendar-clock" /><p>Aucun événement programmé pour l'instant. Revenez bientôt&nbsp;!</p></div>
        ) : (
          <div className="evt-list">
            {list.map(e => (
              <article className="evt reveal" key={e.id}>
                <div className="evt-date"><span className="evt-day">{e.day}</span><span className="evt-mon">{e.mon}</span></div>
                <div className="evt-body">
                  <span className={`evt-chip ${e.type}`}>{TYPE_LABEL[e.type]}</span>
                  <h3 className="evt-title">{e.title}</h3>
                  <div className="evt-format"><Icon name="map-pin" />{e.format}</div>
                  <p className="evt-desc">{e.desc}</p>
                </div>
                <button className="btn btn-secondary btn-sm evt-cta" onClick={() => onNavigate('contact')}>{e.cta} <Icon name="arrow-right" /></button>
              </article>
            ))}
          </div>
        )}
      </div>
    </div>
  );
}

Object.assign(window, { CalendarPage });
