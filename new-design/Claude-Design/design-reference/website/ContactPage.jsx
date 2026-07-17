// hi-ha.be — page contact : formulaire dynamique par étapes (5 étapes)
const { useState: useStateWiz } = React;

const ORG_TYPES = [
  { id: 'pme', icon: 'building-2', t: 'PME / indépendant', d: 'Entreprise ou activité indépendante' },
  { id: 'ecole', icon: 'graduation-cap', t: 'École / institution', d: 'Enseignement, formation' },
  { id: 'public', icon: 'landmark', t: 'Secteur public', d: 'Administration, collectivité' },
  { id: 'asbl', icon: 'heart-handshake', t: 'ASBL / association', d: 'Organisation à but non lucratif' },
];

const MATURITY = [
  { id: 'decouverte', icon: 'sparkles', t: 'Découverte', d: "On commence à s'y intéresser." },
  { id: 'essais', icon: 'flask-conical', t: 'Premiers essais', d: 'Quelques outils testés, sans cadre.' },
  { id: 'deploiement', icon: 'rocket', t: 'En déploiement', d: "Des cas d'usage en production." },
  { id: 'avance', icon: 'trophy', t: 'Avancé', d: "L'IA est intégrée à nos process." },
];

const NEEDS = [
  { id: 'conseil', icon: 'message-circle', t: 'Conseil & stratégie', d: "Cadrer les cas d'usage" },
  { id: 'formation', icon: 'graduation-cap', t: 'Formation', d: 'Monter en compétence' },
  { id: 'auto', icon: 'workflow', t: 'Automatisation n8n', d: 'Relier mes outils' },
  { id: 'locale', icon: 'server', t: 'IA locale & agents', d: 'Déployer chez moi' },
];

const STEPS = [
  { n: 1, label: 'Profil' },
  { n: 2, label: 'Maturité' },
  { n: 3, label: 'Besoins' },
  { n: 4, label: 'Échange' },
  { n: 5, label: 'Confirmation' },
];

// Faux créneaux Cal.com (démo) — en prod : embed Cal.com auto-hébergé, stylé aux tokens.
const CAL_DAYS = [
  { d: 'Lun', n: '9' }, { d: 'Mar', n: '10' }, { d: 'Mer', n: '11' }, { d: 'Jeu', n: '12' }, { d: 'Ven', n: '13' },
];
const CAL_SLOTS = ['09:30', '10:15', '11:00', '14:00', '14:45', '16:30'];

function StepIndicator({ current }) {
  return (
    <div className="steps">
      {STEPS.map(s => {
        const state = current > s.n ? 'done' : current === s.n ? 'active' : '';
        return (
          <div className={`step ${state}`} key={s.n}>
            <div className="dot">{current > s.n ? <Icon name="check" /> : s.n}</div>
            <span className="slabel">{s.label}</span>
            <div className="bar"></div>
          </div>
        );
      })}
    </div>
  );
}

function OptGrid({ options, value, multi, onPick }) {
  const isSel = id => multi ? value.includes(id) : value === id;
  return (
    <div className="opt-grid">
      {options.map(o => (
        <button key={o.id} className={`opt ${isSel(o.id) ? 'sel' : ''}`} onClick={() => onPick(o.id)}>
          <div className="oi"><Icon name={o.icon} /></div>
          <div><div className="ot">{o.t}</div><div className="od">{o.d}</div></div>
          <div className="check"><Icon name="check" /></div>
        </button>
      ))}
    </div>
  );
}

function CalEmbed({ day, slot, onDay, onSlot }) {
  return (
    <div className="cal-embed">
      <div className="cal-embed-head">
        <span className="cal-brand"><Icon name="video" /> Visio · 30 min</span>
        <span className="cal-tz">Europe/Bruxelles</span>
      </div>
      <div className="cal-days">
        {CAL_DAYS.map(d => (
          <button key={d.n} className={`cal-day ${day === d.n ? 'on' : ''}`} onClick={() => onDay(d.n)}>
            <span className="cal-day-d">{d.d}</span><span className="cal-day-n">{d.n}</span>
          </button>
        ))}
      </div>
      <div className="cal-slots">
        {CAL_SLOTS.map(s => (
          <button key={s} className={`cal-slot ${slot === s ? 'on' : ''}`} disabled={!day} onClick={() => onSlot(s)}>{s}</button>
        ))}
      </div>
      <p className="cal-note"><Icon name="lock" /> Agenda Cal.com auto-hébergé, intégré au style du site.</p>
    </div>
  );
}

function ContactPage() {
  const [step, setStep] = useStateWiz(1);
  const [org, setOrg] = useStateWiz(null);
  const [maturity, setMaturity] = useStateWiz(null);
  const [needs, setNeeds] = useStateWiz([]);
  const [channel, setChannel] = useStateWiz(null); // 'message' | 'visio'
  const [form, setForm] = useStateWiz({ nom: '', email: '', tel: '', org: '', message: '' });
  const [cal, setCal] = useStateWiz({ day: null, slot: null });

  const toggleNeed = id => setNeeds(n => n.includes(id) ? n.filter(x => x !== id) : [...n, id]);
  const set = (k, v) => setForm(f => ({ ...f, [k]: v }));
  const reset = () => { setStep(1); setOrg(null); setMaturity(null); setNeeds([]); setChannel(null); setForm({ nom: '', email: '', tel: '', org: '', message: '' }); setCal({ day: null, slot: null }); };

  const step4Valid = channel === 'message' ? (form.nom && form.email)
    : channel === 'visio' ? (cal.day && cal.slot && form.nom && form.email) : false;
  const canNext = step === 1 ? !!org : step === 2 ? !!maturity : step === 3 ? needs.length > 0 : step === 4 ? step4Valid : true;

  const orgLabel = ORG_TYPES.find(o => o.id === org)?.t || '—';
  const matLabel = MATURITY.find(m => m.id === maturity)?.t || '—';
  const needLabels = NEEDS.filter(n => needs.includes(n.id)).map(n => n.t).join(', ') || '—';

  return (
    <div className="wizard-wrap">
      <div className="wizard">
        <div className="wizard-head">
          <span className="overline">Parlons de votre projet</span>
          <h1>Demander un audit</h1>
          <p>Quelques questions pour préparer un premier échange utile.</p>
        </div>
        <StepIndicator current={step} />

        <div className="wcard">
          {step === 1 && (
            <React.Fragment>
              <h2>Vous représentez…</h2>
              <p className="sub">Cela nous aide à adapter notre approche et nos exemples.</p>
              <OptGrid options={ORG_TYPES} value={org} onPick={setOrg} />
            </React.Fragment>
          )}

          {step === 2 && (
            <React.Fragment>
              <h2>Où en êtes-vous avec l'IA&nbsp;?</h2>
              <p className="sub">Votre niveau de maturité nous aide à préparer un échange juste.</p>
              <OptGrid options={MATURITY} value={maturity} onPick={setMaturity} />
            </React.Fragment>
          )}

          {step === 3 && (
            <React.Fragment>
              <h2>De quoi avez-vous besoin&nbsp;?</h2>
              <p className="sub">Plusieurs choix possibles — on affinera ensemble.</p>
              <OptGrid options={NEEDS} value={needs} multi onPick={toggleNeed} />
            </React.Fragment>
          )}

          {step === 4 && (
            <React.Fragment>
              <h2>Comment vous recontacter&nbsp;?</h2>
              <p className="sub">Choisissez la voie qui vous convient.</p>
              <div className="channel-switch">
                <button className={`channel ${channel === 'message' ? 'sel' : ''}`} onClick={() => setChannel('message')}>
                  <div className="oi"><Icon name="mail" /></div>
                  <div><div className="ot">Par message</div><div className="od">On revient vers vous sous 48h</div></div>
                </button>
                <button className={`channel ${channel === 'visio' ? 'sel' : ''}`} onClick={() => setChannel('visio')}>
                  <span className="channel-badge">Recommandé</span>
                  <div className="oi"><Icon name="video" /></div>
                  <div><div className="ot">Prévoir une visio</div><div className="od">Choisissez un créneau, maintenant</div></div>
                </button>
              </div>

              {channel === 'visio' && (
                <CalEmbed day={cal.day} slot={cal.slot}
                  onDay={d => setCal(c => ({ ...c, day: d }))} onSlot={s => setCal(c => ({ ...c, slot: s }))} />
              )}

              {channel && (
                <div style={{ marginTop: 22 }}>
                  <div className="field-row">
                    <div className="field"><label>Nom complet *</label>
                      <input value={form.nom} onChange={e => set('nom', e.target.value)} placeholder="Camille Dupont" /></div>
                    <div className="field"><label>E-mail professionnel *</label>
                      <input type="email" value={form.email} onChange={e => set('email', e.target.value)} placeholder="camille@organisation.be" /></div>
                  </div>
                  {channel === 'message' && (
                    <div className="field"><label>Votre contexte (optionnel)</label>
                      <textarea value={form.message} onChange={e => set('message', e.target.value)} placeholder="Décrivez brièvement votre situation et vos objectifs…"></textarea></div>
                  )}
                </div>
              )}
            </React.Fragment>
          )}

          {step === 5 && (
            <div className="success">
              <div className="big"><Icon name={channel === 'visio' ? 'video' : 'check'} /></div>
              <h2>{channel === 'visio' ? 'Visio confirmée\u00a0!' : "Merci, c'est noté\u00a0!"}</h2>
              <p className="sub" style={{ marginBottom: 22 }}>
                {channel === 'visio'
                  ? `Rendez-vous le ${cal.day} à ${cal.slot}. Vous recevez l'invitation par e-mail.`
                  : 'Récapitulatif de votre demande — nous revenons vers vous très vite.'}
              </p>
              <div className="summary" style={{ textAlign: 'left' }}>
                <div className="srow"><span className="k">Profil</span><span className="v">{orgLabel}</span></div>
                <div className="srow"><span className="k">Maturité</span><span className="v">{matLabel}</span></div>
                <div className="srow"><span className="k">Besoins</span><span className="v">{needLabels}</span></div>
                <div className="srow"><span className="k">{channel === 'visio' ? 'Visio' : 'Contact'}</span>
                  <span className="v">{form.nom || '—'}<br />{form.email || ''}</span></div>
              </div>
            </div>
          )}

          <div className="wnav">
            {step > 1 && step < 5
              ? <button className="btn btn-ghost" onClick={() => setStep(s => s - 1)}><Icon name="arrow-left" /> Retour</button>
              : <span></span>}
            {step < 4 && <button className="btn btn-primary" disabled={!canNext} style={{ opacity: canNext ? 1 : .45 }} onClick={() => canNext && setStep(s => s + 1)}>Continuer <Icon name="arrow-right" /></button>}
            {step === 4 && <button className="btn btn-accent" disabled={!canNext} style={{ opacity: canNext ? 1 : .45 }} onClick={() => canNext && setStep(5)}>
              {channel === 'visio' ? <React.Fragment>Confirmer la visio <Icon name="video" /></React.Fragment> : <React.Fragment>Envoyer la demande <Icon name="send" /></React.Fragment>}
            </button>}
            {step === 5 && <button className="btn btn-secondary" onClick={reset} style={{ marginLeft: 'auto' }}>Nouvelle demande</button>}
          </div>
        </div>
      </div>
    </div>
  );
}

Object.assign(window, { ContactPage });
