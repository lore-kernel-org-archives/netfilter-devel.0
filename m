From: Peter Riley <Peter.Riley@hotpop.com>
Subject: Re: [PATCH] Last vestiges of NFC
Date: Sat, 01 Sep 2007 12:31:54 -0700
Message-ID: <46D9BE2A.4070901@hotpop.com>
References: <46D06522.2090509@hotpop.com>	<46D06FF8.5090004@hotpop.com>	<46D5A5B9.2030107@trash.net>	<46D6DEAF.9010009@hotpop.com>	<Pine.LNX.4.64.0708302040350.24730@fbirervta.pbzchgretzou.qr>	<46D824EA.1060406@hotpop.com>
	<46D83F90.5060600@trash.net>
Reply-To: Peter.Riley@hotpop.com
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="------------040703060306000105060903"
Cc: Jan Engelhardt <jengelh@computergmbh.de>,
	netfilter-devel@lists.netfilter.org
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
In-Reply-To: <46D83F90.5060600@trash.net>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: </pipermail/netfilter-devel>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
Sender: netfilter-devel-bounces@lists.netfilter.org
Errors-To: netfilter-devel-bounces@lists.netfilter.org
List-Id: netfilter-devel.vger.kernel.org

This is a multi-part message in MIME format.
--------------040703060306000105060903
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit

Patrick McHardy wrote:
> Peter Riley wrote:
>> Jan Engelhardt wrote:
>>> On Aug 30 2007 08:13, Peter Riley wrote:
>>>> Patrick McHardy wrote:
>>>>>
>>>>> I count 132 occurences of nfcache (a few are in headers that must stay
>>>>> though). I'll happily apply a patch that kills them all.
>>>>>
> [...]
> We don't care about binary compatiblity between different userspace
> releases. All we care about is not breaking userspace<->kernel
> compatiblity.

Ahh, ok ok. I was thrown off by "a few are in headers that must stay."
Since the only occurrences in iptables headers are the prototypes for
the ->init() and ->parse() members in the extensions API, that implied
nearly all occurrences really had to stay.

Attached patch *does* change that header incompatibly.

>> [...]
>>   At least keep this bit:  printf("Cache: %08X ", e->nfcache);
> 
> The kernel doesn't use it, its *always* zero.

heh, well the whole point of this thread was about dealing with the
fact that it isn't!  :-P  But no matter, it's all cool now..

In the end I kept that one line in dump_entry() in libip[46]tc.c,
only for the sake of completeness. The dump_entry() function exists
to dump out the members of an ipt_entry. As you said, nfcache must
remain in the struct.  Please delete the line if you still really
want it gone.

> I prefer to get rid of all of them where possible, but if you want

Gotcha, patch attached.

I think there should at least be some kind of prominent changelog or
warning notice somewhere that "prototypes in the iptables extension
API have changed incompatibly after so many years so your custom match
extension may now segmentation fault upon parsing if not updated".

p-o-m-ng probably needs patching now too.  I'll take a look...

Best Regards,
Peter






--------------040703060306000105060903
Content-Type: text/plain;
 name="iptables-nfcache-enema2.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="iptables-nfcache-enema2.patch"

Index: include/xtables.h
===================================================================
--- include/xtables.h	(revision 7013)
+++ include/xtables.h	(working copy)
@@ -80,14 +80,13 @@
 	void (*help)(void);
 
 	/* Initialize the match. */
-	void (*init)(struct xt_entry_match *m, unsigned int *nfcache);
+	void (*init)(struct xt_entry_match *m);
 
 	/* Function which parses command options; returns true if it
            ate an option */
 	/* entry is struct ipt_entry for example */
 	int (*parse)(int c, char **argv, int invert, unsigned int *flags,
 		     const void *entry,
-		     unsigned int *nfcache,
 		     struct xt_entry_match **match);
 
 	/* Final check; exit if not ok. */
@@ -137,7 +136,7 @@
 	void (*help)(void);
 
 	/* Initialize the target. */
-	void (*init)(struct xt_entry_target *t, unsigned int *nfcache);
+	void (*init)(struct xt_entry_target *t);
 
 	/* Function which parses command options; returns true if it
            ate an option */
Index: iptables.c
===================================================================
--- iptables.c	(revision 7013)
+++ iptables.c	(working copy)
@@ -1687,7 +1687,7 @@
 				set_revision(target->t->u.user.name,
 					     target->revision);
 				if (target->init != NULL)
-					target->init(target->t, &fw.nfcache);
+					target->init(target->t);
 				opts = merge_options(opts, target->extra_opts, &target->option_offset);
 			}
 			break;
@@ -1739,7 +1739,7 @@
 			strcpy(m->m->u.user.name, m->name);
 			set_revision(m->m->u.user.name, m->revision);
 			if (m->init != NULL)
-				m->init(m->m, &fw.nfcache);
+				m->init(m->m);
 			if (m != m->next)
 				/* Merge options for non-cloned matches */
 				opts = merge_options(opts, m->extra_opts, &m->option_offset);
@@ -1832,7 +1832,6 @@
 						     argv, invert,
 						     &matchp->match->mflags,
 						     &fw,
-						     &fw.nfcache,
 						     &matchp->match->m))
 						break;
 				}
@@ -1885,7 +1884,7 @@
 					set_revision(m->m->u.user.name,
 						     m->revision);
 					if (m->init != NULL)
-						m->init(m->m, &fw.nfcache);
+						m->init(m->m);
 
 					opts = merge_options(opts,
 					    m->extra_opts, &m->option_offset);
@@ -2016,7 +2015,7 @@
 				set_revision(target->t->u.user.name,
 					     target->revision);
 			if (target->init != NULL)
-				target->init(target->t, &fw.nfcache);
+				target->init(target->t);
 		}
 
 		if (!target) {
Index: libiptc/libip4tc.c
===================================================================
--- libiptc/libip4tc.c	(revision 7013)
+++ libiptc/libip4tc.c	(working copy)
@@ -148,10 +148,7 @@
 	printf("Invflags: %02X\n", e->ip.invflags);
 	printf("Counters: %llu packets, %llu bytes\n",
 	       (unsigned long long)e->counters.pcnt, (unsigned long long)e->counters.bcnt);
-	printf("Cache: %08X ", e->nfcache);
-	if (e->nfcache & NFC_ALTERED) printf("ALTERED ");
-	if (e->nfcache & NFC_UNKNOWN) printf("UNKNOWN ");
-	printf("\n");
+	printf("Cache: %08X\n", e->nfcache);
 
 	IPT_MATCH_ITERATE(e, print_match);
 
@@ -204,8 +201,7 @@
 			return NULL;
 	}
 
-	if (a->nfcache != b->nfcache
-	    || a->target_offset != b->target_offset
+	if (a->target_offset != b->target_offset
 	    || a->next_offset != b->next_offset)
 		return NULL;
 
Index: libiptc/libip6tc.c
===================================================================
--- libiptc/libip6tc.c	(revision 7013)
+++ libiptc/libip6tc.c	(working copy)
@@ -179,10 +179,7 @@
 	printf("Invflags: %02X\n", e->ipv6.invflags);
 	printf("Counters: %llu packets, %llu bytes\n",
 	       (unsigned long long)e->counters.pcnt, (unsigned long long)e->counters.bcnt);
-	printf("Cache: %08X ", e->nfcache);
-	if (e->nfcache & NFC_ALTERED) printf("ALTERED ");
-	if (e->nfcache & NFC_UNKNOWN) printf("UNKNOWN ");
-	printf("\n");
+	printf("Cache: %08X\n", e->nfcache);
 	
 	IP6T_MATCH_ITERATE(e, print_match);
 
@@ -236,8 +233,7 @@
 			return NULL;
 	}
 
-	if (a->nfcache != b->nfcache
-	    || a->target_offset != b->target_offset
+	if (a->target_offset != b->target_offset
 	    || a->next_offset != b->next_offset)
 		return NULL;
 
Index: extensions/libxt_connlimit.c
===================================================================
--- extensions/libxt_connlimit.c	(revision 7013)
+++ extensions/libxt_connlimit.c	(working copy)
@@ -24,7 +24,7 @@
 	{NULL},
 };
 
-static void connlimit_init(struct ipt_entry_match *match, unsigned int *nfc)
+static void connlimit_init(struct ipt_entry_match *match)
 {
 	struct xt_connlimit_info *info = (void *)match->data;
 	info->v4_mask = 0xFFFFFFFFUL;
@@ -101,7 +101,6 @@
 
 static int connlimit_parse4(int c, char **argv, int invert,
                             unsigned int *flags, const void *entry,
-                            unsigned int *nfcache,
                             struct xt_entry_match **match)
 {
 	return connlimit_parse(c, argv, invert, flags,
@@ -110,7 +109,6 @@
 
 static int connlimit_parse6(int c, char **argv, int invert,
                             unsigned int *flags, const void *entry,
-                            unsigned int *nfcache,
                             struct xt_entry_match **match)
 {
 	return connlimit_parse(c, argv, invert, flags,
Index: extensions/libxt_comment.c
===================================================================
--- extensions/libxt_comment.c	(revision 7013)
+++ extensions/libxt_comment.c	(working copy)
@@ -46,7 +46,6 @@
 static int
 parse(int c, char **argv, int invert, unsigned int *flags,
       const void *entry,
-      unsigned int *nfcache,
       struct xt_entry_match **match)
 {
 	struct xt_comment_info *commentinfo = (struct xt_comment_info *)(*match)->data;
Index: extensions/libipt_TTL.c
===================================================================
--- extensions/libipt_TTL.c	(revision 7013)
+++ extensions/libipt_TTL.c	(working copy)
@@ -16,7 +16,7 @@
 
 #define IPT_TTL_USED	1
 
-static void init(struct xt_entry_target *t, unsigned int *nfcache)
+static void init(struct xt_entry_target *t)
 {
 }
 
Index: extensions/libxt_string.c
===================================================================
--- extensions/libxt_string.c	(revision 7013)
+++ extensions/libxt_string.c	(working copy)
@@ -54,7 +54,7 @@
 };
 
 static void
-init(struct xt_entry_match *m, unsigned int *nfcache)
+init(struct xt_entry_match *m)
 {
 	struct xt_string_info *i = (struct xt_string_info *) m->data;
 
@@ -171,7 +171,6 @@
 static int
 parse(int c, char **argv, int invert, unsigned int *flags,
       const void *entry,
-      unsigned int *nfcache,
       struct xt_entry_match **match)
 {
 	struct xt_string_info *stringinfo = (struct xt_string_info *)(*match)->data;
Index: extensions/libxt_TCPMSS.c
===================================================================
--- extensions/libxt_TCPMSS.c	(revision 7013)
+++ extensions/libxt_TCPMSS.c	(working copy)
@@ -44,7 +44,7 @@
 
 /* Initialize the target. */
 static void
-init(struct xt_entry_target *t, unsigned int *nfcache)
+init(struct xt_entry_target *t)
 {
 }
 
Index: extensions/libipt_MIRROR.c
===================================================================
--- extensions/libipt_MIRROR.c	(revision 7013)
+++ extensions/libipt_MIRROR.c	(working copy)
@@ -18,7 +18,7 @@
 
 /* Initialize the target. */
 static void
-init(struct xt_entry_target *t, unsigned int *nfcache)
+init(struct xt_entry_target *t)
 {
 }
 
Index: extensions/libip6t_ah.c
===================================================================
--- extensions/libip6t_ah.c	(revision 7013)
+++ extensions/libip6t_ah.c	(working copy)
@@ -72,7 +72,7 @@
 
 /* Initialize the match. */
 static void
-init(struct xt_entry_match *m, unsigned int *nfcache)
+init(struct xt_entry_match *m)
 {
 	struct ip6t_ah *ahinfo = (struct ip6t_ah *)m->data;
 
@@ -86,7 +86,6 @@
 static int
 parse(int c, char **argv, int invert, unsigned int *flags,
       const void *entry,
-      unsigned int *nfcache,
       struct xt_entry_match **match)
 {
 	struct ip6t_ah *ahinfo = (struct ip6t_ah *)(*match)->data;
Index: extensions/libipt_conntrack.c
===================================================================
--- extensions/libipt_conntrack.c	(revision 7013)
+++ extensions/libipt_conntrack.c	(working copy)
@@ -168,7 +168,6 @@
 static int
 parse(int c, char **argv, int invert, unsigned int *flags,
       const void *entry,
-      unsigned int *nfcache,
       struct xt_entry_match **match)
 {
 	struct ipt_conntrack_info *sinfo = (struct ipt_conntrack_info *)(*match)->data;
Index: extensions/libxt_SECMARK.c
===================================================================
--- extensions/libxt_SECMARK.c	(revision 7013)
+++ extensions/libxt_SECMARK.c	(working copy)
@@ -29,7 +29,7 @@
 };
 
 /* Initialize the target. */
-static void init(struct xt_entry_target *t, unsigned int *nfcache)
+static void init(struct xt_entry_target *t)
 { }
 
 /*
Index: extensions/libxt_quota.c
===================================================================
--- extensions/libxt_quota.c	(revision 7013)
+++ extensions/libxt_quota.c	(working copy)
@@ -60,7 +60,7 @@
 static int
 parse(int c, char **argv, int invert, unsigned int *flags,
       const void *entry,
-      unsigned int *nfcache, struct xt_entry_match **match)
+      struct xt_entry_match **match)
 {
         struct xt_quota_info *info = (struct xt_quota_info *) (*match)->data;
 
Index: extensions/libxt_multiport.c
===================================================================
--- extensions/libxt_multiport.c	(revision 7013)
+++ extensions/libxt_multiport.c	(working copy)
@@ -135,7 +135,7 @@
 
 /* Initialize the match. */
 static void
-init(struct xt_entry_match *m, unsigned int *nfcache)
+init(struct xt_entry_match *m)
 {
 }
 
@@ -213,7 +213,6 @@
 static int
 parse(int c, char **argv, int invert, unsigned int *flags,
 	 const void *e,
-	 unsigned int *nfcache,
 	 struct xt_entry_match **match)
 {
 	const struct ipt_entry *entry = e;
@@ -224,7 +223,6 @@
 static int
 parse6(int c, char **argv, int invert, unsigned int *flags,
 	 const void *e,
-	 unsigned int *nfcache,
 	 struct xt_entry_match **match)
 {
 	const struct ip6t_entry *entry = (const struct ip6t_entry *)e;
@@ -280,7 +278,6 @@
 static int
 parse_v1(int c, char **argv, int invert, unsigned int *flags,
 	 const void *e,
-	 unsigned int *nfcache,
 	 struct xt_entry_match **match)
 {
 	const struct ipt_entry *entry = e;
@@ -291,7 +288,6 @@
 static int
 parse6_v1(int c, char **argv, int invert, unsigned int *flags,
 	  const void *e,
-	  unsigned int *nfcache,
 	  struct xt_entry_match **match)
 {
 	const struct ip6t_entry *entry = (const struct ip6t_entry *)e;
Index: extensions/libxt_mac.c
===================================================================
--- extensions/libxt_mac.c	(revision 7013)
+++ extensions/libxt_mac.c	(working copy)
@@ -57,7 +57,6 @@
 static int
 parse(int c, char **argv, int invert, unsigned int *flags,
       const void *entry,
-      unsigned int *nfcache,
       struct xt_entry_match **match)
 {
 	struct xt_mac_info *macinfo = (struct xt_mac_info *)(*match)->data;
Index: extensions/libxt_NOTRACK.c
===================================================================
--- extensions/libxt_NOTRACK.c	(revision 7013)
+++ extensions/libxt_NOTRACK.c	(working copy)
@@ -18,7 +18,7 @@
 
 /* Initialize the target. */
 static void
-init(struct xt_entry_target *t, unsigned int *nfcache)
+init(struct xt_entry_target *t)
 {
 }
 
Index: extensions/libipt_REDIRECT.c
===================================================================
--- extensions/libipt_REDIRECT.c	(revision 7013)
+++ extensions/libipt_REDIRECT.c	(working copy)
@@ -30,7 +30,7 @@
 
 /* Initialize the target. */
 static void
-init(struct xt_entry_target *t, unsigned int *nfcache)
+init(struct xt_entry_target *t)
 {
 	struct ip_nat_multi_range *mr = (struct ip_nat_multi_range *)t->data;
 
Index: extensions/libxt_statistic.c
===================================================================
--- extensions/libxt_statistic.c	(revision 7013)
+++ extensions/libxt_statistic.c	(working copy)
@@ -36,7 +36,6 @@
 static int
 parse(int c, char **argv, int invert, unsigned int *flags,
       const void *entry,
-      unsigned int *nfcache,
       struct xt_entry_match **match)
 {
 	double prob;
Index: extensions/libxt_CONNMARK.c
===================================================================
--- extensions/libxt_CONNMARK.c	(revision 7013)
+++ extensions/libxt_CONNMARK.c	(working copy)
@@ -58,7 +58,7 @@
 
 /* Initialize the target. */
 static void
-init(struct xt_entry_target *t, unsigned int *nfcache)
+init(struct xt_entry_target *t)
 {
 }
 
Index: extensions/libxt_NFQUEUE.c
===================================================================
--- extensions/libxt_NFQUEUE.c	(revision 7013)
+++ extensions/libxt_NFQUEUE.c	(working copy)
@@ -14,7 +14,7 @@
 #include <linux/netfilter/x_tables.h>
 #include <linux/netfilter/xt_NFQUEUE.h>
 
-static void init(struct xt_entry_target *t, unsigned int *nfcache)
+static void init(struct xt_entry_target *t)
 {
 }
 
Index: extensions/libxt_connmark.c
===================================================================
--- extensions/libxt_connmark.c	(revision 7013)
+++ extensions/libxt_connmark.c	(working copy)
@@ -49,7 +49,6 @@
 static int
 parse(int c, char **argv, int invert, unsigned int *flags,
       const void *entry,
-      unsigned int *nfcache,
       struct xt_entry_match **match)
 {
 	struct xt_connmark_info *markinfo = (struct xt_connmark_info *)(*match)->data;
Index: extensions/libxt_sctp.c
===================================================================
--- extensions/libxt_sctp.c	(revision 7013)
+++ extensions/libxt_sctp.c	(working copy)
@@ -42,8 +42,7 @@
 
 /* Initialize the match. */
 static void
-init(struct xt_entry_match *m,
-     unsigned int *nfcache)
+init(struct xt_entry_match *m)
 {
 	int i;
 	struct xt_sctp_info *einfo = (struct xt_sctp_info *)m->data;
@@ -263,7 +262,6 @@
 static int
 parse(int c, char **argv, int invert, unsigned int *flags,
       const void *entry,
-      unsigned int *nfcache,
       struct xt_entry_match **match)
 {
 	struct xt_sctp_info *einfo
Index: extensions/libipt_addrtype.c
===================================================================
--- extensions/libipt_addrtype.c	(revision 7013)
+++ extensions/libipt_addrtype.c	(working copy)
@@ -82,7 +82,7 @@
 #define IPT_ADDRTYPE_OPT_DSTTYPE	0x2
 
 static int parse(int c, char **argv, int invert, unsigned int *flags,
-		const void *entry, unsigned int *nfcache,
+		const void *entry,
 		struct xt_entry_match **match)
 {
 	struct ipt_addrtype_info *info =
Index: extensions/libxt_helper.c
===================================================================
--- extensions/libxt_helper.c	(revision 7013)
+++ extensions/libxt_helper.c	(working copy)
@@ -29,7 +29,6 @@
 static int
 parse(int c, char **argv, int invert, unsigned int *flags,
       const void *entry,
-      unsigned int *nfcache,
       struct xt_entry_match **match)
 {
 	struct xt_helper_info *info = (struct xt_helper_info *)(*match)->data;
Index: extensions/libxt_hashlimit.c
===================================================================
--- extensions/libxt_hashlimit.c	(revision 7013)
+++ extensions/libxt_hashlimit.c	(working copy)
@@ -96,7 +96,7 @@
 
 /* Initialize the match. */
 static void
-init(struct xt_entry_match *m, unsigned int *nfcache)
+init(struct xt_entry_match *m)
 {
 	struct xt_hashlimit_info *r = (struct xt_hashlimit_info *)m->data;
 
@@ -152,7 +152,6 @@
 static int
 parse(int c, char **argv, int invert, unsigned int *flags,
       const void *entry,
-      unsigned int *nfcache,
       struct xt_entry_match **match)
 {
 	struct xt_hashlimit_info *r = 
Index: extensions/libxt_esp.c
===================================================================
--- extensions/libxt_esp.c	(revision 7013)
+++ extensions/libxt_esp.c	(working copy)
@@ -71,7 +71,7 @@
 
 /* Initialize the match. */
 static void
-init(struct xt_entry_match *m, unsigned int *nfcache)
+init(struct xt_entry_match *m)
 {
 	struct xt_esp *espinfo = (struct xt_esp *)m->data;
 
@@ -85,7 +85,6 @@
 static int
 parse(int c, char **argv, int invert, unsigned int *flags,
       const void *entry,
-      unsigned int *nfcache,
       struct xt_entry_match **match)
 {
 	struct xt_esp *espinfo = (struct xt_esp *)(*match)->data;
Index: extensions/libipt_MASQUERADE.c
===================================================================
--- extensions/libipt_MASQUERADE.c	(revision 7013)
+++ extensions/libipt_MASQUERADE.c	(working copy)
@@ -31,7 +31,7 @@
 
 /* Initialize the target. */
 static void
-init(struct xt_entry_target *t, unsigned int *nfcache)
+init(struct xt_entry_target *t)
 {
 	struct ip_nat_multi_range *mr = (struct ip_nat_multi_range *)t->data;
 
Index: extensions/libipt_set.c
===================================================================
--- extensions/libipt_set.c	(revision 7013)
+++ extensions/libipt_set.c	(working copy)
@@ -38,7 +38,7 @@
 };
 
 /* Initialize the match. */
-static void init(struct xt_entry_match *match, unsigned int *nfcache)
+static void init(struct xt_entry_match *match)
 {
 	struct ipt_set_info_match *info = 
 		(struct ipt_set_info_match *) match->data;
@@ -52,7 +52,7 @@
 static int
 parse(int c, char **argv, int invert, unsigned int *flags,
       const void *entry,
-      unsigned int *nfcache, struct xt_entry_match **match)
+      struct xt_entry_match **match)
 {
 	struct ipt_set_info_match *myinfo = 
 		(struct ipt_set_info_match *) (*match)->data;
Index: extensions/libxt_pkttype.c
===================================================================
--- extensions/libxt_pkttype.c	(revision 7013)
+++ extensions/libxt_pkttype.c	(working copy)
@@ -87,7 +87,6 @@
 
 static int parse(int c, char **argv, int invert, unsigned int *flags,
       const void *entry,
-      unsigned int *nfcache,
       struct xt_entry_match **match)
 {
 	struct xt_pkttype_info *info = (struct xt_pkttype_info *)(*match)->data;
Index: extensions/libipt_realm.c
===================================================================
--- extensions/libipt_realm.c	(revision 7013)
+++ extensions/libipt_realm.c	(working copy)
@@ -157,7 +157,6 @@
 static int
 parse(int c, char **argv, int invert, unsigned int *flags,
       const void *entry,
-      unsigned int *nfcache,
       struct xt_entry_match **match)
 {
 	struct ipt_realm_info *realminfo = (struct ipt_realm_info *)(*match)->data;
Index: extensions/libxt_connbytes.c
===================================================================
--- extensions/libxt_connbytes.c	(revision 7013)
+++ extensions/libxt_connbytes.c	(working copy)
@@ -50,7 +50,6 @@
 static int
 parse(int c, char **argv, int invert, unsigned int *flags,
       const void *entry,
-      unsigned int *nfcache,
       struct xt_entry_match **match)
 {
 	struct xt_connbytes_info *sinfo = (struct xt_connbytes_info *)(*match)->data;
Index: extensions/libipt_tos.c
===================================================================
--- extensions/libipt_tos.c	(revision 7013)
+++ extensions/libipt_tos.c	(working copy)
@@ -77,7 +77,6 @@
 static int
 parse(int c, char **argv, int invert, unsigned int *flags,
       const void *entry,
-      unsigned int *nfcache,
       struct xt_entry_match **match)
 {
 	struct ipt_tos_info *tosinfo = (struct ipt_tos_info *)(*match)->data;
Index: extensions/libip6t_LOG.c
===================================================================
--- extensions/libip6t_LOG.c	(revision 7013)
+++ extensions/libip6t_LOG.c	(working copy)
@@ -44,7 +44,7 @@
 
 /* Initialize the target. */
 static void
-init(struct xt_entry_target *t, unsigned int *nfcache)
+init(struct xt_entry_target *t)
 {
 	struct ip6t_log_info *loginfo = (struct ip6t_log_info *)t->data;
 
Index: extensions/libxt_dccp.c
===================================================================
--- extensions/libxt_dccp.c	(revision 7013)
+++ extensions/libxt_dccp.c	(working copy)
@@ -26,8 +26,7 @@
 
 /* Initialize the match. */
 static void
-init(struct xt_entry_match *m,
-     unsigned int *nfcache)
+init(struct xt_entry_match *m)
 {
 	struct xt_dccp_info *einfo = (struct xt_dccp_info *)m->data;
 
@@ -135,7 +134,6 @@
 static int
 parse(int c, char **argv, int invert, unsigned int *flags,
       const void *entry,
-      unsigned int *nfcache,
       struct xt_entry_match **match)
 {
 	struct xt_dccp_info *einfo
Index: extensions/libxt_CLASSIFY.c
===================================================================
--- extensions/libxt_CLASSIFY.c	(revision 7013)
+++ extensions/libxt_CLASSIFY.c	(working copy)
@@ -28,7 +28,7 @@
 
 /* Initialize the target. */
 static void
-init(struct xt_entry_target *t, unsigned int *nfcache)
+init(struct xt_entry_target *t)
 {
 }
 
Index: extensions/libipt_recent.c
===================================================================
--- extensions/libipt_recent.c	(revision 7013)
+++ extensions/libipt_recent.c	(working copy)
@@ -68,7 +68,7 @@
   
 /* Initialize the match. */
 static void
-init(struct xt_entry_match *match, unsigned int *nfcache)
+init(struct xt_entry_match *match)
 {
 	struct ipt_recent_info *info = (struct ipt_recent_info *)(match)->data;
 
@@ -85,7 +85,6 @@
 static int
 parse(int c, char **argv, int invert, unsigned int *flags,
       const void *entry,
-      unsigned int *nfcache,
       struct xt_entry_match **match)
 {
 	struct ipt_recent_info *info = (struct ipt_recent_info *)(*match)->data;
Index: extensions/libxt_physdev.c
===================================================================
--- extensions/libxt_physdev.c	(revision 7013)
+++ extensions/libxt_physdev.c	(working copy)
@@ -35,14 +35,13 @@
 };
 
 static void
-init(struct xt_entry_match *m, unsigned int *nfcache)
+init(struct xt_entry_match *m)
 {
 }
 
 static int
 parse(int c, char **argv, int invert, unsigned int *flags,
       const void *entry,
-      unsigned int *nfcache,
       struct xt_entry_match **match)
 {
 	struct xt_physdev_info *info =
Index: extensions/libipt_unclean.c
===================================================================
--- extensions/libipt_unclean.c	(revision 7013)
+++ extensions/libipt_unclean.c	(working copy)
@@ -18,7 +18,6 @@
 static int
 parse(int c, char **argv, int invert, unsigned int *flags,
       const void *entry,
-      unsigned int *nfcache,
       struct xt_entry_match **match)
 {
 	return 0;
Index: extensions/libipt_ah.c
===================================================================
--- extensions/libipt_ah.c	(revision 7013)
+++ extensions/libipt_ah.c	(working copy)
@@ -68,7 +68,7 @@
 
 /* Initialize the match. */
 static void
-init(struct xt_entry_match *m, unsigned int *nfcache)
+init(struct xt_entry_match *m)
 {
 	struct ipt_ah *ahinfo = (struct ipt_ah *)m->data;
 
@@ -82,7 +82,6 @@
 static int
 parse(int c, char **argv, int invert, unsigned int *flags,
       const void *entry,
-      unsigned int *nfcache,
       struct xt_entry_match **match)
 {
 	struct ipt_ah *ahinfo = (struct ipt_ah *)(*match)->data;
Index: extensions/libxt_dscp.c
===================================================================
--- extensions/libxt_dscp.c	(revision 7013)
+++ extensions/libxt_dscp.c	(working copy)
@@ -76,7 +76,6 @@
 static int
 parse(int c, char **argv, int invert, unsigned int *flags,
       const void *entry,
-      unsigned int *nfcache,
       struct xt_entry_match **match)
 {
 	struct xt_dscp_info *dinfo
Index: extensions/libxt_mark.c
===================================================================
--- extensions/libxt_mark.c	(revision 7013)
+++ extensions/libxt_mark.c	(working copy)
@@ -30,7 +30,6 @@
 static int
 parse(int c, char **argv, int invert, unsigned int *flags,
       const void *entry,
-      unsigned int *nfcache,
       struct xt_entry_match **match)
 {
 	struct xt_mark_info *markinfo = (struct xt_mark_info *)(*match)->data;
Index: extensions/libxt_TRACE.c
===================================================================
--- extensions/libxt_TRACE.c	(revision 7013)
+++ extensions/libxt_TRACE.c	(working copy)
@@ -18,7 +18,7 @@
 
 /* Initialize the target. */
 static void
-init(struct xt_entry_target *t, unsigned int *nfcache)
+init(struct xt_entry_target *t)
 {
 }
 
Index: extensions/libxt_standard.c
===================================================================
--- extensions/libxt_standard.c	(revision 7013)
+++ extensions/libxt_standard.c	(working copy)
@@ -18,7 +18,7 @@
 
 /* Initialize the target. */
 static void
-init(struct xt_entry_target *t, unsigned int *nfcache)
+init(struct xt_entry_target *t)
 {
 }
 
Index: extensions/libipt_ttl.c
===================================================================
--- extensions/libipt_ttl.c	(revision 7013)
+++ extensions/libipt_ttl.c	(working copy)
@@ -25,7 +25,7 @@
 }
 
 static int parse(int c, char **argv, int invert, unsigned int *flags,
-		const void *entry, unsigned int *nfcache,
+		const void *entry,
 		struct xt_entry_match **match)
 {
 	struct ipt_ttl_info *info = (struct ipt_ttl_info *) (*match)->data;
Index: extensions/libip6t_state.c
===================================================================
--- extensions/libip6t_state.c	(revision 7013)
+++ extensions/libip6t_state.c	(working copy)
@@ -66,7 +66,6 @@
 static int
 parse(int c, char **argv, int invert, unsigned int *flags,
       const void *entry,
-      unsigned int *nfcache,
       struct xt_entry_match **match)
 {
 	struct ipt_state_info *sinfo = (struct ipt_state_info *)(*match)->data;
Index: extensions/libipt_connrate.c
===================================================================
--- extensions/libipt_connrate.c	(revision 7013)
+++ extensions/libipt_connrate.c	(working copy)
@@ -77,7 +77,6 @@
 static int
 parse(int c, char **argv, int invert, unsigned int *flags,
       const void *entry,
-      unsigned int *nfcache,
       struct xt_entry_match **match)
 {
 	struct ipt_connrate_info *sinfo = (struct ipt_connrate_info *)(*match)->data;
Index: extensions/libxt_limit.c
===================================================================
--- extensions/libxt_limit.c	(revision 7013)
+++ extensions/libxt_limit.c	(working copy)
@@ -74,7 +74,7 @@
 
 /* Initialize the match. */
 static void
-init(struct xt_entry_match *m, unsigned int *nfcache)
+init(struct xt_entry_match *m)
 {
 	struct xt_rateinfo *r = (struct xt_rateinfo *)m->data;
 
@@ -94,7 +94,6 @@
 static int
 parse(int c, char **argv, int invert, unsigned int *flags,
       const void *entry,
-      unsigned int *nfcache,
       struct xt_entry_match **match)
 {
 	struct xt_rateinfo *r = (struct xt_rateinfo *)(*match)->data;
Index: extensions/libip6t_dst.c
===================================================================
--- extensions/libip6t_dst.c	(revision 7013)
+++ extensions/libip6t_dst.c	(working copy)
@@ -118,7 +118,7 @@
 
 /* Initialize the match. */
 static void
-init(struct xt_entry_match *m, unsigned int *nfcache)
+init(struct xt_entry_match *m)
 {
 	struct ip6t_opts *optinfo = (struct ip6t_opts *)m->data;
 
@@ -133,7 +133,6 @@
 static int
 parse(int c, char **argv, int invert, unsigned int *flags,
       const void *entry,
-      unsigned int *nfcache,
       struct xt_entry_match **match)
 {
 	struct ip6t_opts *optinfo = (struct ip6t_opts *)(*match)->data;
Index: extensions/libip6t_owner.c
===================================================================
--- extensions/libip6t_owner.c	(revision 7013)
+++ extensions/libip6t_owner.c	(working copy)
@@ -52,7 +52,6 @@
 static int
 parse(int c, char **argv, int invert, unsigned int *flags,
       const void *entry,
-      unsigned int *nfcache,
       struct xt_entry_match **match)
 {
 	struct ip6t_owner_info *ownerinfo = (struct ip6t_owner_info *)(*match)->data;
Index: extensions/libip6t_HL.c
===================================================================
--- extensions/libip6t_HL.c	(revision 7013)
+++ extensions/libip6t_HL.c	(working copy)
@@ -16,7 +16,7 @@
 
 #define IP6T_HL_USED	1
 
-static void init(struct xt_entry_target *t, unsigned int *nfcache)
+static void init(struct xt_entry_target *t)
 {
 }
 
Index: extensions/libipt_owner.c
===================================================================
--- extensions/libipt_owner.c	(revision 7013)
+++ extensions/libipt_owner.c	(working copy)
@@ -54,7 +54,6 @@
 static int
 parse(int c, char **argv, int invert, unsigned int *flags,
       const void *entry,
-      unsigned int *nfcache,
       struct xt_entry_match **match)
 {
 	struct ipt_owner_info *ownerinfo = (struct ipt_owner_info *)(*match)->data;
Index: extensions/libip6t_REJECT.c
===================================================================
--- extensions/libip6t_REJECT.c	(revision 7013)
+++ extensions/libip6t_REJECT.c	(working copy)
@@ -72,7 +72,7 @@
 
 /* Allocate and initialize the target. */
 static void
-init(struct xt_entry_target *t, unsigned int *nfcache)
+init(struct xt_entry_target *t)
 {
 	struct ip6t_reject_info *reject = (struct ip6t_reject_info *)t->data;
 
Index: extensions/libipt_ECN.c
===================================================================
--- extensions/libipt_ECN.c	(revision 7013)
+++ extensions/libipt_ECN.c	(working copy)
@@ -17,7 +17,7 @@
 #include <linux/netfilter_ipv4/ip_tables.h>
 #include <linux/netfilter_ipv4/ipt_ECN.h>
 
-static void init(struct xt_entry_target *t, unsigned int *nfcache)
+static void init(struct xt_entry_target *t)
 {
 }
 
Index: extensions/libip6t_rt.c
===================================================================
--- extensions/libip6t_rt.c	(revision 7013)
+++ extensions/libip6t_rt.c	(working copy)
@@ -139,7 +139,7 @@
 
 /* Initialize the match. */
 static void
-init(struct xt_entry_match *m, unsigned int *nfcache)
+init(struct xt_entry_match *m)
 {
 	struct ip6t_rt *rtinfo = (struct ip6t_rt *)m->data;
 
@@ -157,7 +157,6 @@
 static int
 parse(int c, char **argv, int invert, unsigned int *flags,
       const void *entry,
-      unsigned int *nfcache,
       struct xt_entry_match **match)
 {
 	struct ip6t_rt *rtinfo = (struct ip6t_rt *)(*match)->data;
Index: extensions/libip6t_condition.c
===================================================================
--- extensions/libip6t_condition.c	(revision 7013)
+++ extensions/libip6t_condition.c	(working copy)
@@ -26,7 +26,7 @@
 
 static int
 parse(int c, char **argv, int invert, unsigned int *flags,
-      const void *entry, unsigned int *nfcache,
+      const void *entry,
       struct xt_entry_match **match)
 {
 	struct condition6_info *info =
Index: extensions/libxt_length.c
===================================================================
--- extensions/libxt_length.c	(revision 7013)
+++ extensions/libxt_length.c	(working copy)
@@ -67,7 +67,6 @@
 static int
 parse(int c, char **argv, int invert, unsigned int *flags,
       const void *entry,
-      unsigned int *nfcache,
       struct xt_entry_match **match)
 {
 	struct xt_length_info *info = (struct xt_length_info *)(*match)->data;
Index: extensions/libip6t_eui64.c
===================================================================
--- extensions/libip6t_eui64.c	(revision 7013)
+++ extensions/libip6t_eui64.c	(working copy)
@@ -27,7 +27,6 @@
 static int
 parse(int c, char **argv, int invert, unsigned int *flags,
       const void *entry,
-      unsigned int *nfcache,
       struct xt_entry_match **match)
 {
 	return 0;
Index: extensions/libipt_SAME.c
===================================================================
--- extensions/libipt_SAME.c	(revision 7013)
+++ extensions/libipt_SAME.c	(working copy)
@@ -38,7 +38,7 @@
 
 /* Initialize the target. */
 static void
-init(struct xt_entry_target *t, unsigned int *nfcache)
+init(struct xt_entry_target *t)
 {
 	struct ipt_same_info *mr = (struct ipt_same_info *)t->data;
 
Index: extensions/libip6t_policy.c
===================================================================
--- extensions/libip6t_policy.c	(revision 7013)
+++ extensions/libip6t_policy.c	(working copy)
@@ -133,9 +133,8 @@
 
 /* End duplicated code from ip6tables.c */
 
-static void init(struct xt_entry_match *m, unsigned int *nfcache)
+static void init(struct xt_entry_match *m)
 {
-	*nfcache |= NFC_UNKNOWN;
 }
 
 static int parse_direction(char *s)
@@ -167,7 +166,6 @@
 
 static int parse(int c, char **argv, int invert, unsigned int *flags,
                  const void *entry,
-                 unsigned int *nfcache,
                  struct xt_entry_match **match)
 {
 	struct ip6t_policy_info *info = (void *)(*match)->data;
Index: extensions/libipt_condition.c
===================================================================
--- extensions/libipt_condition.c	(revision 7013)
+++ extensions/libipt_condition.c	(working copy)
@@ -26,7 +26,7 @@
 
 static int
 parse(int c, char **argv, int invert, unsigned int *flags,
-      const void *entry, unsigned int *nfcache,
+      const void *entry,
       struct xt_entry_match **match)
 {
 	struct condition_info *info =
Index: extensions/libxt_udp.c
===================================================================
--- extensions/libxt_udp.c	(revision 7013)
+++ extensions/libxt_udp.c	(working copy)
@@ -55,7 +55,7 @@
 
 /* Initialize the match. */
 static void
-init(struct xt_entry_match *m, unsigned int *nfcache)
+init(struct xt_entry_match *m)
 {
 	struct xt_udp *udpinfo = (struct xt_udp *)m->data;
 
@@ -70,7 +70,6 @@
 static int
 parse(int c, char **argv, int invert, unsigned int *flags,
       const void *entry,
-      unsigned int *nfcache,
       struct xt_entry_match **match)
 {
 	struct xt_udp *udpinfo = (struct xt_udp *)(*match)->data;
Index: extensions/libipt_icmp.c
===================================================================
--- extensions/libipt_icmp.c	(revision 7013)
+++ extensions/libipt_icmp.c	(working copy)
@@ -169,7 +169,7 @@
 
 /* Initialize the match. */
 static void
-init(struct xt_entry_match *m, unsigned int *nfcache)
+init(struct xt_entry_match *m)
 {
 	struct ipt_icmp *icmpinfo = (struct ipt_icmp *)m->data;
 
@@ -182,7 +182,6 @@
 static int
 parse(int c, char **argv, int invert, unsigned int *flags,
       const void *entry,
-      unsigned int *nfcache,
       struct xt_entry_match **match)
 {
 	struct ipt_icmp *icmpinfo = (struct ipt_icmp *)(*match)->data;
Index: extensions/libip6t_mh.c
===================================================================
--- extensions/libip6t_mh.c	(revision 7013)
+++ extensions/libip6t_mh.c	(working copy)
@@ -67,7 +67,7 @@
 	print_types_all();
 }
 
-static void init(struct xt_entry_match *m, unsigned int *nfcache)
+static void init(struct xt_entry_match *m)
 {
 	struct ip6t_mh *mhinfo = (struct ip6t_mh *)m->data;
 
@@ -127,7 +127,6 @@
 
 static int parse(int c, char **argv, int invert, unsigned int *flags,
 		 const void *entry,
-		 unsigned int *nfcache,
 		 struct xt_entry_match **match)
 {
 	struct ip6t_mh *mhinfo = (struct ip6t_mh *)(*match)->data;
Index: extensions/libip6t_frag.c
===================================================================
--- extensions/libip6t_frag.c	(revision 7013)
+++ extensions/libip6t_frag.c	(working copy)
@@ -78,7 +78,7 @@
 
 /* Initialize the match. */
 static void
-init(struct xt_entry_match *m, unsigned int *nfcache)
+init(struct xt_entry_match *m)
 {
 	struct ip6t_frag *fraginfo = (struct ip6t_frag *)m->data;
 
@@ -94,7 +94,6 @@
 static int
 parse(int c, char **argv, int invert, unsigned int *flags,
       const void *entry,
-      unsigned int *nfcache,
       struct xt_entry_match **match)
 {
 	struct ip6t_frag *fraginfo = (struct ip6t_frag *)(*match)->data;
Index: extensions/libipt_ULOG.c
===================================================================
--- extensions/libipt_ULOG.c	(revision 7013)
+++ extensions/libipt_ULOG.c	(working copy)
@@ -53,7 +53,7 @@
 };
 
 /* Initialize the target. */
-static void init(struct xt_entry_target *t, unsigned int *nfcache)
+static void init(struct xt_entry_target *t)
 {
 	struct ipt_ulog_info *loginfo = (struct ipt_ulog_info *) t->data;
 
Index: extensions/libip6t_ipv6header.c
===================================================================
--- extensions/libip6t_ipv6header.c	(revision 7013)
+++ extensions/libip6t_ipv6header.c	(working copy)
@@ -155,7 +155,7 @@
 };
 
 static void
-init(struct xt_entry_match *m, unsigned int *nfcache)
+init(struct xt_entry_match *m)
 {
 	struct ip6t_ipv6header_info *info = (struct ip6t_ipv6header_info *)m->data;
 
@@ -186,7 +186,6 @@
 static int
 parse(int c, char **argv, int invert, unsigned int *flags,
       const void *entry,
-      unsigned int *nfcache,
       struct xt_entry_match **match)
 {
 	struct ip6t_ipv6header_info *info = (struct ip6t_ipv6header_info *)(*match)->data;
Index: extensions/libxt_tcp.c
===================================================================
--- extensions/libxt_tcp.c	(revision 7013)
+++ extensions/libxt_tcp.c	(working copy)
@@ -131,7 +131,7 @@
 
 /* Initialize the match. */
 static void
-init(struct xt_entry_match *m, unsigned int *nfcache)
+init(struct xt_entry_match *m)
 {
 	struct xt_tcp *tcpinfo = (struct xt_tcp *)m->data;
 
@@ -148,7 +148,6 @@
 static int
 parse(int c, char **argv, int invert, unsigned int *flags,
       const void *entry,
-      unsigned int *nfcache,
       struct xt_entry_match **match)
 {
 	struct xt_tcp *tcpinfo = (struct xt_tcp *)(*match)->data;
Index: extensions/libip6t_hl.c
===================================================================
--- extensions/libip6t_hl.c	(revision 7013)
+++ extensions/libip6t_hl.c	(working copy)
@@ -26,7 +26,7 @@
 }
 
 static int parse(int c, char **argv, int invert, unsigned int *flags,
-		const void *entry, unsigned int *nfcache,
+		const void *entry,
 		struct xt_entry_match **match)
 {
 	struct ip6t_hl_info *info = (struct ip6t_hl_info *) (*match)->data;
Index: extensions/libip6t_icmp6.c
===================================================================
--- extensions/libip6t_icmp6.c	(revision 7013)
+++ extensions/libip6t_icmp6.c	(working copy)
@@ -145,7 +145,7 @@
 
 /* Initialize the match. */
 static void
-init(struct xt_entry_match *m, unsigned int *nfcache)
+init(struct xt_entry_match *m)
 {
 	struct ip6t_icmp *icmpv6info = (struct ip6t_icmp *)m->data;
 
@@ -157,7 +157,6 @@
 static int
 parse(int c, char **argv, int invert, unsigned int *flags,
       const void *entry,
-      unsigned int *nfcache,
       struct xt_entry_match **match)
 {
 	struct ip6t_icmp *icmpv6info = (struct ip6t_icmp *)(*match)->data;
Index: extensions/libxt_tcpmss.c
===================================================================
--- extensions/libxt_tcpmss.c	(revision 7013)
+++ extensions/libxt_tcpmss.c	(working copy)
@@ -61,7 +61,6 @@
 static int
 parse(int c, char **argv, int invert, unsigned int *flags,
       const void *entry,
-      unsigned int *nfcache,
       struct xt_entry_match **match)
 {
 	struct xt_tcpmss_match_info *mssinfo =
Index: extensions/libipt_REJECT.c
===================================================================
--- extensions/libipt_REJECT.c	(revision 7013)
+++ extensions/libipt_REJECT.c	(working copy)
@@ -87,7 +87,7 @@
 
 /* Allocate and initialize the target. */
 static void
-init(struct xt_entry_target *t, unsigned int *nfcache)
+init(struct xt_entry_target *t)
 {
 	struct ipt_reject_info *reject = (struct ipt_reject_info *)t->data;
 
Index: extensions/libipt_LOG.c
===================================================================
--- extensions/libipt_LOG.c	(revision 7013)
+++ extensions/libipt_LOG.c	(working copy)
@@ -44,7 +44,7 @@
 
 /* Initialize the target. */
 static void
-init(struct xt_entry_target *t, unsigned int *nfcache)
+init(struct xt_entry_target *t)
 {
 	struct ipt_log_info *loginfo = (struct ipt_log_info *)t->data;
 
Index: extensions/libipt_NETMAP.c
===================================================================
--- extensions/libipt_NETMAP.c	(revision 7013)
+++ extensions/libipt_NETMAP.c	(working copy)
@@ -56,7 +56,7 @@
 
 /* Initialize the target. */
 static void
-init(struct xt_entry_target *t, unsigned int *nfcache)
+init(struct xt_entry_target *t)
 {
 	struct ip_nat_multi_range *mr = (struct ip_nat_multi_range *)t->data;
 
Index: extensions/libxt_DSCP.c
===================================================================
--- extensions/libxt_DSCP.c	(revision 7013)
+++ extensions/libxt_DSCP.c	(working copy)
@@ -22,7 +22,7 @@
 #include "libipt_dscp_helper.c"
 
 
-static void init(struct xt_entry_target *t, unsigned int *nfcache)
+static void init(struct xt_entry_target *t)
 {
 }
 
Index: extensions/libxt_MARK.c
===================================================================
--- extensions/libxt_MARK.c	(revision 7013)
+++ extensions/libxt_MARK.c	(working copy)
@@ -30,7 +30,7 @@
 
 /* Initialize the target. */
 static void
-init(struct xt_entry_target *t, unsigned int *nfcache)
+init(struct xt_entry_target *t)
 {
 }
 
Index: extensions/libipt_SET.c
===================================================================
--- extensions/libipt_SET.c	(revision 7013)
+++ extensions/libipt_SET.c	(working copy)
@@ -41,7 +41,7 @@
 };
 
 /* Initialize the target. */
-static void init(struct xt_entry_target *target, unsigned int *nfcache)
+static void init(struct xt_entry_target *target)
 {
 	struct ipt_set_info_target *info =
 	    (struct ipt_set_info_target *) target->data;
Index: extensions/libipt_policy.c
===================================================================
--- extensions/libipt_policy.c	(revision 7013)
+++ extensions/libipt_policy.c	(working copy)
@@ -93,9 +93,8 @@
 	{ }
 };
 
-static void init(struct xt_entry_match *m, unsigned int *nfcache)
+static void init(struct xt_entry_match *m)
 {
-	*nfcache |= NFC_UNKNOWN;
 }
 
 static int parse_direction(char *s)
@@ -127,7 +126,6 @@
 
 static int parse(int c, char **argv, int invert, unsigned int *flags,
                  const void *entry,
-                 unsigned int *nfcache,
                  struct xt_entry_match **match)
 {
 	struct ipt_policy_info *info = (void *)(*match)->data;
Index: extensions/libxt_NFLOG.c
===================================================================
--- extensions/libxt_NFLOG.c	(revision 7013)
+++ extensions/libxt_NFLOG.c	(working copy)
@@ -32,7 +32,7 @@
 	       IPTABLES_VERSION);
 }
 
-static void init(struct xt_entry_target *t, unsigned int *nfcache)
+static void init(struct xt_entry_target *t)
 {
 	struct xt_nflog_info *info = (struct xt_nflog_info *)t->data;
 
Index: extensions/libipt_ecn.c
===================================================================
--- extensions/libipt_ecn.c	(revision 7013)
+++ extensions/libipt_ecn.c	(working copy)
@@ -36,7 +36,6 @@
 static int
 parse(int c, char **argv, int invert, unsigned int *flags,
       const void *entry,
-      unsigned int *nfcache,
       struct xt_entry_match **match)
 {
 	unsigned int result;
Index: extensions/libipt_TOS.c
===================================================================
--- extensions/libipt_TOS.c	(revision 7013)
+++ extensions/libipt_TOS.c	(working copy)
@@ -54,7 +54,7 @@
 
 /* Initialize the target. */
 static void
-init(struct xt_entry_target *t, unsigned int *nfcache)
+init(struct xt_entry_target *t)
 {
 }
 
Index: extensions/libipt_CLUSTERIP.c
===================================================================
--- extensions/libipt_CLUSTERIP.c	(revision 7013)
+++ extensions/libipt_CLUSTERIP.c	(working copy)
@@ -55,7 +55,7 @@
 };
 
 static void
-init(struct xt_entry_target *t, unsigned int *nfcache)
+init(struct xt_entry_target *t)
 {
 }
 
Index: extensions/libxt_state.c
===================================================================
--- extensions/libxt_state.c	(revision 7013)
+++ extensions/libxt_state.c	(working copy)
@@ -66,7 +66,6 @@
 static int
 parse(int c, char **argv, int invert, unsigned int *flags,
       const void *entry,
-      unsigned int *nfcache,
       struct xt_entry_match **match)
 {
 	struct xt_state_info *sinfo = (struct xt_state_info *)(*match)->data;
Index: extensions/libipt_iprange.c
===================================================================
--- extensions/libipt_iprange.c	(revision 7013)
+++ extensions/libipt_iprange.c	(working copy)
@@ -57,7 +57,6 @@
 static int
 parse(int c, char **argv, int invert, unsigned int *flags,
       const void *entry,
-      unsigned int *nfcache,
       struct xt_entry_match **match)
 {
 	struct ipt_iprange_info *info = (struct ipt_iprange_info *)(*match)->data;
Index: extensions/libip6t_hbh.c
===================================================================
--- extensions/libip6t_hbh.c	(revision 7013)
+++ extensions/libip6t_hbh.c	(working copy)
@@ -117,7 +117,7 @@
 
 /* Initialize the match. */
 static void
-init(struct xt_entry_match *m, unsigned int *nfcache)
+init(struct xt_entry_match *m)
 {
 	struct ip6t_opts *optinfo = (struct ip6t_opts *)m->data;
 
@@ -132,7 +132,6 @@
 static int
 parse(int c, char **argv, int invert, unsigned int *flags,
       const void *entry,
-      unsigned int *nfcache,
       struct xt_entry_match **match)
 {
 	struct ip6t_opts *optinfo = (struct ip6t_opts *)(*match)->data;
Index: ip6tables.c
===================================================================
--- ip6tables.c	(revision 7013)
+++ ip6tables.c	(working copy)
@@ -1627,7 +1627,7 @@
 				target->t->u.target_size = size;
 				strcpy(target->t->u.user.name, jumpto);
 				if (target->init != NULL)
-					target->init(target->t, &fw.nfcache);
+					target->init(target->t);
 				opts = merge_options(opts, target->extra_opts, &target->option_offset);
 			}
 			break;
@@ -1673,7 +1673,7 @@
 			strcpy(m->m->u.user.name, m->name);
 			set_revision(m->m->u.user.name, m->revision);
 			if (m->init != NULL)
-				m->init(m->m, &fw.nfcache);
+				m->init(m->m);
 			if (m != m->next)
 				/* Merge options for non-cloned matches */
 				opts = merge_options(opts, m->extra_opts, &m->option_offset);
@@ -1766,7 +1766,6 @@
 						     argv, invert,
 						     &matchp->match->mflags,
 						     &fw,
-						     &fw.nfcache,
 						     &matchp->match->m))
 						break;
 				}
@@ -1819,7 +1818,7 @@
 					set_revision(m->m->u.user.name,
 						     m->revision);
 					if (m->init != NULL)
-						m->init(m->m, &fw.nfcache);
+						m->init(m->m);
 
 					opts = merge_options(opts,
 					    m->extra_opts, &m->option_offset);
@@ -1948,7 +1947,7 @@
 			target->t->u.target_size = size;
 			strcpy(target->t->u.user.name, jumpto);
 			if (target->init != NULL)
-				target->init(target->t, &fw.nfcache);
+				target->init(target->t);
 		}
 
 		if (!target) {








--------------040703060306000105060903--
