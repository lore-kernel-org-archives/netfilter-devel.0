From: Richard Guy Briggs <rgb@redhat.com>
Subject: Re: [RFC PATCH ghak86 V1] audit: eliminate audit_enabled magic
	number comparison
Date: Tue, 12 Jun 2018 16:45:40 -0400
Message-ID: <20180612204539.ccvlox67annsikmw@madcap2.tricolour.ca>
References: <490a00a7902582823fe8c532f5dd995a1da61fb1.1528214962.git.rgb@redhat.com>
	<CAHC9VhQuLbbRp4ETzonD0XYQ3oQP9fuq-f7zrytQY7BQ0ANCZA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: Linux NetDev Upstream Mailing List <netdev@vger.kernel.org>,
	LKML <linux-kernel@vger.kernel.org>,
	Linux Security Module list <linux-security-module@vger.kernel.org>,
	Linux-Audit Mailing List <linux-audit@redhat.com>,
	Netfilter Devel List <netfilter-devel@vger.kernel.org>
To: Paul Moore <paul@paul-moore.com>
Return-path: <linux-audit-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <CAHC9VhQuLbbRp4ETzonD0XYQ3oQP9fuq-f7zrytQY7BQ0ANCZA@mail.gmail.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/linux-audit>,
	<mailto:linux-audit-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/linux-audit>
List-Post: <mailto:linux-audit@redhat.com>
List-Help: <mailto:linux-audit-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/linux-audit>,
	<mailto:linux-audit-request@redhat.com?subject=subscribe>
Sender: linux-audit-bounces@redhat.com
Errors-To: linux-audit-bounces@redhat.com
List-Id: netfilter-devel.vger.kernel.org

On 2018-06-12 16:33, Paul Moore wrote:
> On Tue, Jun 5, 2018 at 7:20 PM, Richard Guy Briggs <rgb@redhat.com> wrote:
> > Remove comparison of audit_enabled to magic numbers outside of audit.
> >
> > Related: https://github.com/linux-audit/audit-kernel/issues/86
> >
> > Signed-off-by: Richard Guy Briggs <rgb@redhat.com>
> > ---
> >  drivers/tty/tty_audit.c      | 2 +-
> >  include/linux/audit.h        | 5 ++++-
> >  include/net/xfrm.h           | 2 +-
> >  kernel/audit.c               | 3 ---
> >  net/netfilter/xt_AUDIT.c     | 2 +-
> >  net/netlabel/netlabel_user.c | 2 +-
> >  6 files changed, 8 insertions(+), 8 deletions(-)
> 
> An improvement, thank you.  Thankfully there are no tariffs on patches
> so I've queued this up for after the merge window.

Check with the So Called Ruler Of The United States first just to be
sure.  I'll dress it up in a kurta if that helps.

> > diff --git a/drivers/tty/tty_audit.c b/drivers/tty/tty_audit.c
> > index e30aa6b..50f567b 100644
> > --- a/drivers/tty/tty_audit.c
> > +++ b/drivers/tty/tty_audit.c
> > @@ -92,7 +92,7 @@ static void tty_audit_buf_push(struct tty_audit_buf *buf)
> >  {
> >         if (buf->valid == 0)
> >                 return;
> > -       if (audit_enabled == 0) {
> > +       if (audit_enabled == AUDIT_OFF) {
> >                 buf->valid = 0;
> >                 return;
> >         }
> > diff --git a/include/linux/audit.h b/include/linux/audit.h
> > index 69c7847..9334fbe 100644
> > --- a/include/linux/audit.h
> > +++ b/include/linux/audit.h
> > @@ -117,6 +117,9 @@ struct audit_field {
> >
> >  extern void audit_log_session_info(struct audit_buffer *ab);
> >
> > +#define AUDIT_OFF      0
> > +#define AUDIT_ON       1
> > +#define AUDIT_LOCKED   2
> >  #ifdef CONFIG_AUDIT
> >  /* These are defined in audit.c */
> >                                 /* Public API */
> > @@ -202,7 +205,7 @@ static inline int audit_log_task_context(struct audit_buffer *ab)
> >  static inline void audit_log_task_info(struct audit_buffer *ab,
> >                                        struct task_struct *tsk)
> >  { }
> > -#define audit_enabled 0
> > +#define audit_enabled AUDIT_OFF
> >  #endif /* CONFIG_AUDIT */
> >
> >  #ifdef CONFIG_AUDIT_COMPAT_GENERIC
> > diff --git a/include/net/xfrm.h b/include/net/xfrm.h
> > index 7f2e31a..ce995a1 100644
> > --- a/include/net/xfrm.h
> > +++ b/include/net/xfrm.h
> > @@ -734,7 +734,7 @@ static inline struct audit_buffer *xfrm_audit_start(const char *op)
> >  {
> >         struct audit_buffer *audit_buf = NULL;
> >
> > -       if (audit_enabled == 0)
> > +       if (audit_enabled == AUDIT_OFF)
> >                 return NULL;
> >         audit_buf = audit_log_start(audit_context(), GFP_ATOMIC,
> >                                     AUDIT_MAC_IPSEC_EVENT);
> > diff --git a/kernel/audit.c b/kernel/audit.c
> > index e7478cb..8442c65 100644
> > --- a/kernel/audit.c
> > +++ b/kernel/audit.c
> > @@ -83,9 +83,6 @@
> >  #define AUDIT_INITIALIZED      1
> >  static int     audit_initialized;
> >
> > -#define AUDIT_OFF      0
> > -#define AUDIT_ON       1
> > -#define AUDIT_LOCKED   2
> >  u32            audit_enabled = AUDIT_OFF;
> >  bool           audit_ever_enabled = !!AUDIT_OFF;
> >
> > diff --git a/net/netfilter/xt_AUDIT.c b/net/netfilter/xt_AUDIT.c
> > index f368ee6..af883f1 100644
> > --- a/net/netfilter/xt_AUDIT.c
> > +++ b/net/netfilter/xt_AUDIT.c
> > @@ -72,7 +72,7 @@ static bool audit_ip6(struct audit_buffer *ab, struct sk_buff *skb)
> >         struct audit_buffer *ab;
> >         int fam = -1;
> >
> > -       if (audit_enabled == 0)
> > +       if (audit_enabled == AUDIT_OFF)
> >                 goto errout;
> >         ab = audit_log_start(NULL, GFP_ATOMIC, AUDIT_NETFILTER_PKT);
> >         if (ab == NULL)
> > diff --git a/net/netlabel/netlabel_user.c b/net/netlabel/netlabel_user.c
> > index 2f328af..4676f5b 100644
> > --- a/net/netlabel/netlabel_user.c
> > +++ b/net/netlabel/netlabel_user.c
> > @@ -101,7 +101,7 @@ struct audit_buffer *netlbl_audit_start_common(int type,
> >         char *secctx;
> >         u32 secctx_len;
> >
> > -       if (audit_enabled == 0)
> > +       if (audit_enabled == AUDIT_OFF)
> >                 return NULL;
> >
> >         audit_buf = audit_log_start(audit_context(), GFP_ATOMIC, type);
> 
> paul moore

- RGB

--
Richard Guy Briggs <rgb@redhat.com>
Sr. S/W Engineer, Kernel Security, Base Operating Systems
Remote, Ottawa, Red Hat Canada
IRC: rgb, SunRaycer
Voice: +1.647.777.2635, Internal: (81) 32635
