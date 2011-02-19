From: Jan Engelhardt <jengelh@medozas.de>
Subject: [PATCH 3/8] extensions: remove redundant init functions
Date: Sat, 19 Feb 2011 20:04:13 +0100
Message-ID: <1298142259-11213-4-git-send-email-jengelh@medozas.de>
References: <1298142259-11213-1-git-send-email-jengelh@medozas.de>
Cc: netfilter-devel@vger.kernel.org
To: kaber@trash.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from borg.medozas.de ([188.40.89.202]:42361 "EHLO borg.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755386Ab1BSTEh (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 19 Feb 2011 14:04:37 -0500
In-Reply-To: <1298142259-11213-1-git-send-email-jengelh@medozas.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

The main program already zeroes the per-extension data block.

Signed-off-by: Jan Engelhardt <jengelh@medozas.de>
---
 extensions/libip6t_ah.c         |    2 --
 extensions/libip6t_dst.c        |   11 -----------
 extensions/libip6t_frag.c       |    4 ----
 extensions/libip6t_hbh.c        |   11 -----------
 extensions/libip6t_ipv6header.c |   10 ----------
 extensions/libip6t_rt.c         |    6 ------
 extensions/libipt_SAME.c        |   12 ------------
 extensions/libxt_NFLOG.c        |    1 -
 extensions/libxt_RATEEST.c      |    8 --------
 extensions/libxt_TCPOPTSTRIP.c  |    9 ---------
 extensions/libxt_dccp.c         |    8 --------
 extensions/libxt_hashlimit.c    |    1 -
 extensions/libxt_sctp.c         |    2 --
 extensions/libxt_string.c       |    3 +--
 14 files changed, 1 insertions(+), 87 deletions(-)

diff --git a/extensions/libip6t_ah.c b/extensions/libip6t_ah.c
index 5fa0d2d..2922047 100644
--- a/extensions/libip6t_ah.c
+++ b/extensions/libip6t_ah.c
@@ -73,8 +73,6 @@ static void ah_init(struct xt_entry_match *m)
 	struct ip6t_ah *ahinfo = (struct ip6t_ah *)m->data;
 
 	ahinfo->spis[1] = 0xFFFFFFFF;
-	ahinfo->hdrlen = 0;
-	ahinfo->hdrres = 0;
 }
 
 static int ah_parse(int c, char **argv, int invert, unsigned int *flags,
diff --git a/extensions/libip6t_dst.c b/extensions/libip6t_dst.c
index 3ba804f..8b656a6 100644
--- a/extensions/libip6t_dst.c
+++ b/extensions/libip6t_dst.c
@@ -106,16 +106,6 @@ parse_options(const char *optsstr, uint16_t *opts)
 	return i;
 }
 
-static void dst_init(struct xt_entry_match *m)
-{
-	struct ip6t_opts *optinfo = (struct ip6t_opts *)m->data;
-
-	optinfo->hdrlen = 0;
-	optinfo->flags = 0;
-	optinfo->invflags = 0;
-	optinfo->optsnr = 0;
-}
-
 static int dst_parse(int c, char **argv, int invert, unsigned int *flags,
                      const void *entry, struct xt_entry_match **match)
 {
@@ -227,7 +217,6 @@ static struct xtables_match dst_mt6_reg = {
 	.size          = XT_ALIGN(sizeof(struct ip6t_opts)),
 	.userspacesize = XT_ALIGN(sizeof(struct ip6t_opts)),
 	.help          = dst_help,
-	.init          = dst_init,
 	.parse         = dst_parse,
 	.print         = dst_print,
 	.save          = dst_save,
diff --git a/extensions/libip6t_frag.c b/extensions/libip6t_frag.c
index ac9bd2e..19aca4c 100644
--- a/extensions/libip6t_frag.c
+++ b/extensions/libip6t_frag.c
@@ -78,11 +78,7 @@ static void frag_init(struct xt_entry_match *m)
 {
 	struct ip6t_frag *fraginfo = (struct ip6t_frag *)m->data;
 
-	fraginfo->ids[0] = 0x0L;
 	fraginfo->ids[1] = 0xFFFFFFFF;
-	fraginfo->hdrlen = 0;
-	fraginfo->flags = 0;
-	fraginfo->invflags = 0;
 }
 
 static int frag_parse(int c, char **argv, int invert, unsigned int *flags,
diff --git a/extensions/libip6t_hbh.c b/extensions/libip6t_hbh.c
index e51569e..9eb504e 100644
--- a/extensions/libip6t_hbh.c
+++ b/extensions/libip6t_hbh.c
@@ -100,16 +100,6 @@ parse_options(const char *optsstr, uint16_t *opts)
 	return i;
 }
 
-static void hbh_init(struct xt_entry_match *m)
-{
-	struct ip6t_opts *optinfo = (struct ip6t_opts *)m->data;
-
-	optinfo->hdrlen = 0;
-	optinfo->flags = 0;
-	optinfo->invflags = 0;
-	optinfo->optsnr = 0;
-}
-
 static int hbh_parse(int c, char **argv, int invert, unsigned int *flags,
                      const void *entry, struct xt_entry_match **match)
 {
@@ -211,7 +201,6 @@ static struct xtables_match hbh_mt6_reg = {
 	.size		= XT_ALIGN(sizeof(struct ip6t_opts)),
 	.userspacesize	= XT_ALIGN(sizeof(struct ip6t_opts)),
 	.help		= hbh_help,
-	.init		= hbh_init,
 	.parse		= hbh_parse,
 	.print		= hbh_print,
 	.save		= hbh_save,
diff --git a/extensions/libip6t_ipv6header.c b/extensions/libip6t_ipv6header.c
index da832e2..187e0a4 100644
--- a/extensions/libip6t_ipv6header.c
+++ b/extensions/libip6t_ipv6header.c
@@ -146,15 +146,6 @@ static const struct option ipv6header_opts[] = {
 	XT_GETOPT_TABLEEND,
 };
 
-static void ipv6header_init(struct xt_entry_match *m)
-{
-	struct ip6t_ipv6header_info *info = (struct ip6t_ipv6header_info *)m->data;
-
-	info->matchflags = 0x00;
-	info->invflags = 0x00;
-	info->modeflag = 0x00;
-}
-
 static unsigned int
 parse_header(const char *flags) {
         unsigned int ret = 0;
@@ -273,7 +264,6 @@ static struct xtables_match ipv6header_mt6_reg = {
 	.size		= XT_ALIGN(sizeof(struct ip6t_ipv6header_info)),
 	.userspacesize	= XT_ALIGN(sizeof(struct ip6t_ipv6header_info)),
 	.help		= ipv6header_help,
-	.init		= ipv6header_init,
 	.parse		= ipv6header_parse,
 	.final_check	= ipv6header_check,
 	.print		= ipv6header_print,
diff --git a/extensions/libip6t_rt.c b/extensions/libip6t_rt.c
index ec492c1..333350d 100644
--- a/extensions/libip6t_rt.c
+++ b/extensions/libip6t_rt.c
@@ -140,13 +140,7 @@ static void rt_init(struct xt_entry_match *m)
 {
 	struct ip6t_rt *rtinfo = (struct ip6t_rt *)m->data;
 
-	rtinfo->rt_type = 0x0L;
-	rtinfo->segsleft[0] = 0x0L;
 	rtinfo->segsleft[1] = 0xFFFFFFFF;
-	rtinfo->hdrlen = 0;
-	rtinfo->flags = 0;
-	rtinfo->invflags = 0;
-	rtinfo->addrnr = 0;
 }
 
 static int rt_parse(int c, char **argv, int invert, unsigned int *flags,
diff --git a/extensions/libipt_SAME.c b/extensions/libipt_SAME.c
index 9c548f5..b18351e 100644
--- a/extensions/libipt_SAME.c
+++ b/extensions/libipt_SAME.c
@@ -32,17 +32,6 @@ static const struct option SAME_opts[] = {
 	XT_GETOPT_TABLEEND,
 };
 
-static void SAME_init(struct xt_entry_target *t)
-{
-	struct ipt_same_info *mr = (struct ipt_same_info *)t->data;
-
-	/* Set default to 0 */
-	mr->rangesize = 0;
-	mr->info = 0;
-	mr->ipnum = 0;
-	
-}
-
 /* Parses range of IPs */
 static void
 parse_to(char *arg, struct nf_nat_range *range)
@@ -197,7 +186,6 @@ static struct xtables_target same_tg_reg = {
 	.size		= XT_ALIGN(sizeof(struct ipt_same_info)),
 	.userspacesize	= XT_ALIGN(sizeof(struct ipt_same_info)),
 	.help		= SAME_help,
-	.init		= SAME_init,
 	.parse		= SAME_parse,
 	.final_check	= SAME_check,
 	.print		= SAME_print,
diff --git a/extensions/libxt_NFLOG.c b/extensions/libxt_NFLOG.c
index b4fdc48..61c9741 100644
--- a/extensions/libxt_NFLOG.c
+++ b/extensions/libxt_NFLOG.c
@@ -36,7 +36,6 @@ static void NFLOG_init(struct xt_entry_target *t)
 {
 	struct xt_nflog_info *info = (struct xt_nflog_info *)t->data;
 
-	info->group	= 0;
 	info->threshold	= XT_NFLOG_DEFAULT_THRESHOLD;
 }
 
diff --git a/extensions/libxt_RATEEST.c b/extensions/libxt_RATEEST.c
index eb3cdd9..6369e9e 100644
--- a/extensions/libxt_RATEEST.c
+++ b/extensions/libxt_RATEEST.c
@@ -82,13 +82,6 @@ RATEEST_print_time(unsigned int time)
 		printf(" %uus", time);
 }
 
-static void
-RATEEST_init(struct xt_entry_target *target)
-{
-	interval = 0;
-	ewma_log = 0;
-}
-
 static int
 RATEEST_parse(int c, char **argv, int invert, unsigned int *flags,
 	      const void *entry, struct xt_entry_target **target)
@@ -206,7 +199,6 @@ static struct xtables_target rateest_tg_reg = {
 	.size		= XT_ALIGN(sizeof(struct xt_rateest_target_info)),
 	.userspacesize	= XT_ALIGN(sizeof(struct xt_rateest_target_info)),
 	.help		= RATEEST_help,
-	.init		= RATEEST_init,
 	.parse		= RATEEST_parse,
 	.final_check	= RATEEST_final_check,
 	.print		= RATEEST_print,
diff --git a/extensions/libxt_TCPOPTSTRIP.c b/extensions/libxt_TCPOPTSTRIP.c
index 34f3562..338a311 100644
--- a/extensions/libxt_TCPOPTSTRIP.c
+++ b/extensions/libxt_TCPOPTSTRIP.c
@@ -56,14 +56,6 @@ static void tcpoptstrip_tg_help(void)
 		printf("    %-14s    strip \"%s\" option\n", w->name, w->desc);
 }
 
-static void tcpoptstrip_tg_init(struct xt_entry_target *t)
-{
-	struct xt_tcpoptstrip_target_info *info = (void *)t->data;
-
-	/* strictly necessary? play safe for now. */
-	memset(info->strip_bmap, 0, sizeof(info->strip_bmap));
-}
-
 static void parse_list(struct xt_tcpoptstrip_target_info *info, char *arg)
 {
 	unsigned int option;
@@ -184,7 +176,6 @@ static struct xtables_target tcpoptstrip_tg_reg = {
 	.size          = XT_ALIGN(sizeof(struct xt_tcpoptstrip_target_info)),
 	.userspacesize = XT_ALIGN(sizeof(struct xt_tcpoptstrip_target_info)),
 	.help          = tcpoptstrip_tg_help,
-	.init          = tcpoptstrip_tg_init,
 	.parse         = tcpoptstrip_tg_parse,
 	.final_check   = tcpoptstrip_tg_check,
 	.print         = tcpoptstrip_tg_print,
diff --git a/extensions/libxt_dccp.c b/extensions/libxt_dccp.c
index 3b2dc6b..ee8e009 100644
--- a/extensions/libxt_dccp.c
+++ b/extensions/libxt_dccp.c
@@ -26,13 +26,6 @@
 #define DEBUGP(format, fist...) 
 #endif
 
-static void dccp_init(struct xt_entry_match *m)
-{
-	struct xt_dccp_info *einfo = (struct xt_dccp_info *)m->data;
-
-	memset(einfo, 0, sizeof(struct xt_dccp_info));
-}
-
 static void dccp_help(void)
 {
 	printf(
@@ -340,7 +333,6 @@ static struct xtables_match dccp_match = {
 	.size		= XT_ALIGN(sizeof(struct xt_dccp_info)),
 	.userspacesize	= XT_ALIGN(sizeof(struct xt_dccp_info)),
 	.help		= dccp_help,
-	.init		= dccp_init,
 	.parse		= dccp_parse,
 	.print		= dccp_print,
 	.save		= dccp_save,
diff --git a/extensions/libxt_hashlimit.c b/extensions/libxt_hashlimit.c
index d766987..cd057c5 100644
--- a/extensions/libxt_hashlimit.c
+++ b/extensions/libxt_hashlimit.c
@@ -134,7 +134,6 @@ static void hashlimit_init(struct xt_entry_match *m)
 {
 	struct xt_hashlimit_info *r = (struct xt_hashlimit_info *)m->data;
 
-	r->cfg.mode = 0;
 	r->cfg.burst = XT_HASHLIMIT_BURST;
 	r->cfg.gc_interval = XT_HASHLIMIT_GCINTERVAL;
 	r->cfg.expire = XT_HASHLIMIT_EXPIRE;
diff --git a/extensions/libxt_sctp.c b/extensions/libxt_sctp.c
index 718d4c4..d3379d3 100644
--- a/extensions/libxt_sctp.c
+++ b/extensions/libxt_sctp.c
@@ -35,8 +35,6 @@ static void sctp_init(struct xt_entry_match *m)
 	int i;
 	struct xt_sctp_info *einfo = (struct xt_sctp_info *)m->data;
 
-	memset(einfo, 0, sizeof(struct xt_sctp_info));
-
 	for (i = 0; i < XT_NUM_SCTP_FLAGS; i++) {
 		einfo->flag_info[i].chunktype = -1;
 	}
diff --git a/extensions/libxt_string.c b/extensions/libxt_string.c
index 4f75757..1030d2e 100644
--- a/extensions/libxt_string.c
+++ b/extensions/libxt_string.c
@@ -58,8 +58,7 @@ static void string_init(struct xt_entry_match *m)
 {
 	struct xt_string_info *i = (struct xt_string_info *) m->data;
 
-	if (i->to_offset == 0)
-		i->to_offset = UINT16_MAX;
+	i->to_offset = UINT16_MAX;
 }
 
 static void
-- 
1.7.1

