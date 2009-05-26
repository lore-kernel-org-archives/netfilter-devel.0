From: Jan Engelhardt <jengelh@medozas.de>
Subject: [PATCH 2/5] extensions: add const qualifiers in print/save functions
Date: Tue, 26 May 2009 13:26:24 +0200
Message-ID: <1243337187-18216-3-git-send-email-jengelh@medozas.de>
References: <1243337187-18216-1-git-send-email-jengelh@medozas.de>
Cc: netfilter-devel@vger.kernel.org
To: kaber@trash.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:34626 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751560AbZEZL0a (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 26 May 2009 07:26:30 -0400
In-Reply-To: <1243337187-18216-1-git-send-email-jengelh@medozas.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Signed-off-by: Jan Engelhardt <jengelh@medozas.de>
---
 extensions/libip6t_hl.c        |    2 +-
 extensions/libipt_DNAT.c       |    4 ++--
 extensions/libipt_MASQUERADE.c |   10 ++++------
 extensions/libipt_NETMAP.c     |    5 ++---
 extensions/libipt_REDIRECT.c   |   10 ++++------
 extensions/libipt_SAME.c       |   10 ++++------
 extensions/libipt_SET.c        |    6 ++----
 extensions/libipt_SNAT.c       |    4 ++--
 extensions/libipt_realm.c      |    4 ++--
 extensions/libipt_set.c        |    6 ++----
 extensions/libxt_CONNSECMARK.c |    6 +++---
 extensions/libxt_RATEEST.c     |    2 +-
 extensions/libxt_SECMARK.c     |    6 +++---
 extensions/libxt_comment.c     |    4 ++--
 extensions/libxt_connbytes.c   |    8 ++++----
 extensions/libxt_connmark.c    |    4 ++--
 extensions/libxt_conntrack.c   |    5 +++--
 extensions/libxt_hashlimit.c   |    6 ++----
 extensions/libxt_helper.c      |    4 ++--
 extensions/libxt_limit.c       |    4 ++--
 extensions/libxt_mark.c        |    4 ++--
 extensions/libxt_physdev.c     |    6 ++----
 extensions/libxt_pkttype.c     |    6 +++---
 extensions/libxt_quota.c       |    4 ++--
 extensions/libxt_rateest.c     |    7 ++++---
 extensions/libxt_state.c       |    4 ++--
 extensions/libxt_statistic.c   |    4 ++--
 extensions/libxt_time.c        |    2 +-
 28 files changed, 67 insertions(+), 80 deletions(-)

diff --git a/extensions/libip6t_hl.c b/extensions/libip6t_hl.c
index 9252c3d..ff76b74 100644
--- a/extensions/libip6t_hl.c
+++ b/extensions/libip6t_hl.c
@@ -89,7 +89,7 @@ static void hl_check(unsigned int flags)
 static void hl_print(const void *ip, const struct xt_entry_match *match,
                      int numeric)
 {
-	static const char *op[] = {
+	static const char *const op[] = {
 		[IP6T_HL_EQ] = "==",
 		[IP6T_HL_NE] = "!=",
 		[IP6T_HL_LT] = "<",
diff --git a/extensions/libipt_DNAT.c b/extensions/libipt_DNAT.c
index dc79b44..8b2caec 100644
--- a/extensions/libipt_DNAT.c
+++ b/extensions/libipt_DNAT.c
@@ -219,7 +219,7 @@ static void print_range(const struct nf_nat_range *r)
 static void DNAT_print(const void *ip, const struct xt_entry_target *target,
                        int numeric)
 {
-	struct ipt_natinfo *info = (void *)target;
+	const struct ipt_natinfo *info = (const void *)target;
 	unsigned int i = 0;
 
 	printf("to:");
@@ -235,7 +235,7 @@ static void DNAT_print(const void *ip, const struct xt_entry_target *target,
 
 static void DNAT_save(const void *ip, const struct xt_entry_target *target)
 {
-	struct ipt_natinfo *info = (void *)target;
+	const struct ipt_natinfo *info = (const void *)target;
 	unsigned int i = 0;
 
 	for (i = 0; i < info->mr.rangesize; i++) {
diff --git a/extensions/libipt_MASQUERADE.c b/extensions/libipt_MASQUERADE.c
index 82c2230..90084d8 100644
--- a/extensions/libipt_MASQUERADE.c
+++ b/extensions/libipt_MASQUERADE.c
@@ -111,9 +111,8 @@ static void
 MASQUERADE_print(const void *ip, const struct xt_entry_target *target,
                  int numeric)
 {
-	struct nf_nat_multi_range *mr
-		= (struct nf_nat_multi_range *)target->data;
-	struct nf_nat_range *r = &mr->range[0];
+	const struct nf_nat_multi_range *mr = (const void *)target->data;
+	const struct nf_nat_range *r = &mr->range[0];
 
 	if (r->flags & IP_NAT_RANGE_PROTO_SPECIFIED) {
 		printf("masq ports: ");
@@ -130,9 +129,8 @@ MASQUERADE_print(const void *ip, const struct xt_entry_target *target,
 static void
 MASQUERADE_save(const void *ip, const struct xt_entry_target *target)
 {
-	struct nf_nat_multi_range *mr
-		= (struct nf_nat_multi_range *)target->data;
-	struct nf_nat_range *r = &mr->range[0];
+	const struct nf_nat_multi_range *mr = (const void *)target->data;
+	const struct nf_nat_range *r = &mr->range[0];
 
 	if (r->flags & IP_NAT_RANGE_PROTO_SPECIFIED) {
 		printf("--to-ports %hu", ntohs(r->min.tcp.port));
diff --git a/extensions/libipt_NETMAP.c b/extensions/libipt_NETMAP.c
index 9820230..f03c05b 100644
--- a/extensions/libipt_NETMAP.c
+++ b/extensions/libipt_NETMAP.c
@@ -140,9 +140,8 @@ static void NETMAP_check(unsigned int flags)
 static void NETMAP_print(const void *ip, const struct xt_entry_target *target,
                          int numeric)
 {
-	struct nf_nat_multi_range *mr
-		= (struct nf_nat_multi_range *)target->data;
-	struct nf_nat_range *r = &mr->range[0];
+	const struct nf_nat_multi_range *mr = (const void *)target->data;
+	const struct nf_nat_range *r = &mr->range[0];
 	struct in_addr a;
 	int bits;
 
diff --git a/extensions/libipt_REDIRECT.c b/extensions/libipt_REDIRECT.c
index 658f933..01f9d0f 100644
--- a/extensions/libipt_REDIRECT.c
+++ b/extensions/libipt_REDIRECT.c
@@ -124,9 +124,8 @@ static int REDIRECT_parse(int c, char **argv, int invert, unsigned int *flags,
 static void REDIRECT_print(const void *ip, const struct xt_entry_target *target,
                            int numeric)
 {
-	struct nf_nat_multi_range *mr
-		= (struct nf_nat_multi_range *)target->data;
-	struct nf_nat_range *r = &mr->range[0];
+	const struct nf_nat_multi_range *mr = (const void *)target->data;
+	const struct nf_nat_range *r = &mr->range[0];
 
 	if (r->flags & IP_NAT_RANGE_PROTO_SPECIFIED) {
 		printf("redir ports ");
@@ -141,9 +140,8 @@ static void REDIRECT_print(const void *ip, const struct xt_entry_target *target,
 
 static void REDIRECT_save(const void *ip, const struct xt_entry_target *target)
 {
-	struct nf_nat_multi_range *mr
-		= (struct nf_nat_multi_range *)target->data;
-	struct nf_nat_range *r = &mr->range[0];
+	const struct nf_nat_multi_range *mr = (const void *)target->data;
+	const struct nf_nat_range *r = &mr->range[0];
 
 	if (r->flags & IP_NAT_RANGE_PROTO_SPECIFIED) {
 		printf("--to-ports ");
diff --git a/extensions/libipt_SAME.c b/extensions/libipt_SAME.c
index a07d9f4..5cb0d3f 100644
--- a/extensions/libipt_SAME.c
+++ b/extensions/libipt_SAME.c
@@ -138,14 +138,13 @@ static void SAME_print(const void *ip, const struct xt_entry_target *target,
                        int numeric)
 {
 	unsigned int count;
-	struct ipt_same_info *mr
-		= (struct ipt_same_info *)target->data;
+	const struct ipt_same_info *mr = (const void *)target->data;
 	int random_selection = 0;
 	
 	printf("same:");
 	
 	for (count = 0; count < mr->rangesize; count++) {
-		struct nf_nat_range *r = &mr->range[count];
+		const struct nf_nat_range *r = &mr->range[count];
 		struct in_addr a;
 
 		a.s_addr = r->min_ip;
@@ -171,12 +170,11 @@ static void SAME_print(const void *ip, const struct xt_entry_target *target,
 static void SAME_save(const void *ip, const struct xt_entry_target *target)
 {
 	unsigned int count;
-	struct ipt_same_info *mr
-		= (struct ipt_same_info *)target->data;
+	const struct ipt_same_info *mr = (const void *)target->data;
 	int random_selection = 0;
 
 	for (count = 0; count < mr->rangesize; count++) {
-		struct nf_nat_range *r = &mr->range[count];
+		const struct nf_nat_range *r = &mr->range[count];
 		struct in_addr a;
 
 		a.s_addr = r->min_ip;
diff --git a/extensions/libipt_SET.c b/extensions/libipt_SET.c
index 5da41a0..b717a88 100644
--- a/extensions/libipt_SET.c
+++ b/extensions/libipt_SET.c
@@ -129,8 +129,7 @@ print_target(const char *prefix, const struct ipt_set_info *info)
 static void SET_print(const void *ip, const struct xt_entry_target *target,
                       int numeric)
 {
-	struct ipt_set_info_target *info =
-	    (struct ipt_set_info_target *) target->data;
+	const struct ipt_set_info_target *info = (const void *)target->data;
 
 	print_target("add-set", &info->add_set);
 	print_target("del-set", &info->del_set);
@@ -138,8 +137,7 @@ static void SET_print(const void *ip, const struct xt_entry_target *target,
 
 static void SET_save(const void *ip, const struct xt_entry_target *target)
 {
-	struct ipt_set_info_target *info =
-	    (struct ipt_set_info_target *) target->data;
+	const struct ipt_set_info_target *info = (const void *)target->data;
 
 	print_target("--add-set", &info->add_set);
 	print_target("--del-set", &info->del_set);
diff --git a/extensions/libipt_SNAT.c b/extensions/libipt_SNAT.c
index 9609ad9..e592d80 100644
--- a/extensions/libipt_SNAT.c
+++ b/extensions/libipt_SNAT.c
@@ -219,7 +219,7 @@ static void print_range(const struct nf_nat_range *r)
 static void SNAT_print(const void *ip, const struct xt_entry_target *target,
                        int numeric)
 {
-	struct ipt_natinfo *info = (void *)target;
+	const struct ipt_natinfo *info = (const void *)target;
 	unsigned int i = 0;
 
 	printf("to:");
@@ -235,7 +235,7 @@ static void SNAT_print(const void *ip, const struct xt_entry_target *target,
 
 static void SNAT_save(const void *ip, const struct xt_entry_target *target)
 {
-	struct ipt_natinfo *info = (void *)target;
+	const struct ipt_natinfo *info = (const void *)target;
 	unsigned int i = 0;
 
 	for (i = 0; i < info->mr.rangesize; i++) {
diff --git a/extensions/libipt_realm.c b/extensions/libipt_realm.c
index 3dd63d3..0580610 100644
--- a/extensions/libipt_realm.c
+++ b/extensions/libipt_realm.c
@@ -207,7 +207,7 @@ print_realm(unsigned long id, unsigned long mask, int numeric)
 static void realm_print(const void *ip, const struct xt_entry_match *match,
                         int numeric)
 {
-	struct ipt_realm_info *ri = (struct ipt_realm_info *) match->data;
+	const struct ipt_realm_info *ri = (const void *)match->data;
 
 	if (ri->invert)
 		printf("! ");
@@ -218,7 +218,7 @@ static void realm_print(const void *ip, const struct xt_entry_match *match,
 
 static void realm_save(const void *ip, const struct xt_entry_match *match)
 {
-	struct ipt_realm_info *ri = (struct ipt_realm_info *) match->data;
+	const struct ipt_realm_info *ri = (const void *)match->data;
 
 	if (ri->invert)
 		printf("! ");
diff --git a/extensions/libipt_set.c b/extensions/libipt_set.c
index 845b2b0..33a2c8b 100644
--- a/extensions/libipt_set.c
+++ b/extensions/libipt_set.c
@@ -121,16 +121,14 @@ print_match(const char *prefix, const struct ipt_set_info *info)
 static void set_print(const void *ip, const struct xt_entry_match *match,
                       int numeric)
 {
-	struct ipt_set_info_match *info = 
-		(struct ipt_set_info_match *) match->data;
+	const struct ipt_set_info_match *info = (const void *)match->data;
 
 	print_match("set", &info->match_set);
 }
 
 static void set_save(const void *ip, const struct xt_entry_match *match)
 {
-	struct ipt_set_info_match *info = 
-		(struct ipt_set_info_match *) match->data;
+	const struct ipt_set_info_match *info = (const void *)match->data;
 
 	print_match("--set", &info->match_set);
 }
diff --git a/extensions/libxt_CONNSECMARK.c b/extensions/libxt_CONNSECMARK.c
index 1515f6f..11ec01a 100644
--- a/extensions/libxt_CONNSECMARK.c
+++ b/extensions/libxt_CONNSECMARK.c
@@ -69,7 +69,7 @@ static void CONNSECMARK_check(unsigned int flags)
 		           "or --restore is allowed");
 }
 
-static void print_connsecmark(struct xt_connsecmark_target_info *info)
+static void print_connsecmark(const struct xt_connsecmark_target_info *info)
 {
 	switch (info->mode) {
 	case CONNSECMARK_SAVE:
@@ -89,7 +89,7 @@ static void
 CONNSECMARK_print(const void *ip, const struct xt_entry_target *target,
                   int numeric)
 {
-	struct xt_connsecmark_target_info *info =
+	const struct xt_connsecmark_target_info *info =
 		(struct xt_connsecmark_target_info*)(target)->data;
 
 	printf("CONNSECMARK ");
@@ -99,7 +99,7 @@ CONNSECMARK_print(const void *ip, const struct xt_entry_target *target,
 static void
 CONNSECMARK_save(const void *ip, const struct xt_entry_target *target)
 {
-	struct xt_connsecmark_target_info *info =
+	const struct xt_connsecmark_target_info *info =
 		(struct xt_connsecmark_target_info*)target->data;
 
 	printf("--");
diff --git a/extensions/libxt_RATEEST.c b/extensions/libxt_RATEEST.c
index d4fd6dd..1a7b0a9 100644
--- a/extensions/libxt_RATEEST.c
+++ b/extensions/libxt_RATEEST.c
@@ -174,7 +174,7 @@ RATEEST_final_check(unsigned int flags)
 static void
 __RATEEST_print(const struct xt_entry_target *target, const char *prefix)
 {
-	struct xt_rateest_target_info *info = (void *)target->data;
+	const struct xt_rateest_target_info *info = (const void *)target->data;
 	unsigned int local_interval;
 	unsigned int local_ewma_log;
 
diff --git a/extensions/libxt_SECMARK.c b/extensions/libxt_SECMARK.c
index 9db2327..0c09c88 100644
--- a/extensions/libxt_SECMARK.c
+++ b/extensions/libxt_SECMARK.c
@@ -61,7 +61,7 @@ static void SECMARK_check(unsigned int flags)
 		xtables_error(PARAMETER_PROBLEM, PFX "parameter required");
 }
 
-static void print_secmark(struct xt_secmark_target_info *info)
+static void print_secmark(const struct xt_secmark_target_info *info)
 {
 	switch (info->mode) {
 	case SECMARK_MODE_SEL:
@@ -76,7 +76,7 @@ static void print_secmark(struct xt_secmark_target_info *info)
 static void SECMARK_print(const void *ip, const struct xt_entry_target *target,
                           int numeric)
 {
-	struct xt_secmark_target_info *info =
+	const struct xt_secmark_target_info *info =
 		(struct xt_secmark_target_info*)(target)->data;
 
 	printf("SECMARK ");
@@ -85,7 +85,7 @@ static void SECMARK_print(const void *ip, const struct xt_entry_target *target,
 
 static void SECMARK_save(const void *ip, const struct xt_entry_target *target)
 {
-	struct xt_secmark_target_info *info =
+	const struct xt_secmark_target_info *info =
 		(struct xt_secmark_target_info*)target->data;
 
 	printf("--");
diff --git a/extensions/libxt_comment.c b/extensions/libxt_comment.c
index 67d7f99..5f393bb 100644
--- a/extensions/libxt_comment.c
+++ b/extensions/libxt_comment.c
@@ -71,7 +71,7 @@ static void comment_check(unsigned int flags)
 static void
 comment_print(const void *ip, const struct xt_entry_match *match, int numeric)
 {
-	struct xt_comment_info *commentinfo = (struct xt_comment_info *)match->data;
+	struct xt_comment_info *commentinfo = (void *)match->data;
 
 	commentinfo->comment[XT_MAX_COMMENT_LEN-1] = '\0';
 	printf("/* %s */ ", commentinfo->comment);
@@ -81,7 +81,7 @@ comment_print(const void *ip, const struct xt_entry_match *match, int numeric)
 static void
 comment_save(const void *ip, const struct xt_entry_match *match)
 {
-	struct xt_comment_info *commentinfo = (struct xt_comment_info *)match->data;
+	struct xt_comment_info *commentinfo = (void *)match->data;
 
 	commentinfo->comment[XT_MAX_COMMENT_LEN-1] = '\0';
 	printf("--comment ");
diff --git a/extensions/libxt_connbytes.c b/extensions/libxt_connbytes.c
index 9f6af1c..c7bdff0 100644
--- a/extensions/libxt_connbytes.c
+++ b/extensions/libxt_connbytes.c
@@ -102,7 +102,7 @@ static void connbytes_check(unsigned int flags)
 			   "`--connbytes-dir' and `--connbytes-mode'");
 }
 
-static void print_mode(struct xt_connbytes_info *sinfo)
+static void print_mode(const struct xt_connbytes_info *sinfo)
 {
 	switch (sinfo->what) {
 		case XT_CONNBYTES_PKTS:
@@ -120,7 +120,7 @@ static void print_mode(struct xt_connbytes_info *sinfo)
 	}
 }
 
-static void print_direction(struct xt_connbytes_info *sinfo)
+static void print_direction(const struct xt_connbytes_info *sinfo)
 {
 	switch (sinfo->direction) {
 		case XT_CONNBYTES_DIR_ORIGINAL:
@@ -141,7 +141,7 @@ static void print_direction(struct xt_connbytes_info *sinfo)
 static void
 connbytes_print(const void *ip, const struct xt_entry_match *match, int numeric)
 {
-	struct xt_connbytes_info *sinfo = (struct xt_connbytes_info *)match->data;
+	const struct xt_connbytes_info *sinfo = (const void *)match->data;
 
 	if (sinfo->count.from > sinfo->count.to) 
 		printf("connbytes ! %llu:%llu ",
@@ -161,7 +161,7 @@ connbytes_print(const void *ip, const struct xt_entry_match *match, int numeric)
 
 static void connbytes_save(const void *ip, const struct xt_entry_match *match)
 {
-	struct xt_connbytes_info *sinfo = (struct xt_connbytes_info *)match->data;
+	const struct xt_connbytes_info *sinfo = (const void *)match->data;
 
 	if (sinfo->count.from > sinfo->count.to) 
 		printf("! --connbytes %llu:%llu ",
diff --git a/extensions/libxt_connmark.c b/extensions/libxt_connmark.c
index 2dca5a5..ce2002c 100644
--- a/extensions/libxt_connmark.c
+++ b/extensions/libxt_connmark.c
@@ -121,7 +121,7 @@ static void connmark_mt_check(unsigned int flags)
 static void
 connmark_print(const void *ip, const struct xt_entry_match *match, int numeric)
 {
-	struct xt_connmark_info *info = (struct xt_connmark_info *)match->data;
+	const struct xt_connmark_info *info = (const void *)match->data;
 
 	printf("CONNMARK match ");
 	if (info->invert)
@@ -142,7 +142,7 @@ connmark_mt_print(const void *ip, const struct xt_entry_match *match, int numeri
 
 static void connmark_save(const void *ip, const struct xt_entry_match *match)
 {
-	struct xt_connmark_info *info = (struct xt_connmark_info *)match->data;
+	const struct xt_connmark_info *info = (const void *)match->data;
 
 	if (info->invert)
 		printf("! ");
diff --git a/extensions/libxt_conntrack.c b/extensions/libxt_conntrack.c
index 358b255..96ea3ec 100644
--- a/extensions/libxt_conntrack.c
+++ b/extensions/libxt_conntrack.c
@@ -779,7 +779,8 @@ conntrack_dump_addr(const union nf_inet_addr *addr,
 }
 
 static void
-print_addr(struct in_addr *addr, struct in_addr *mask, int inv, int numeric)
+print_addr(const struct in_addr *addr, const struct in_addr *mask,
+           int inv, int numeric)
 {
 	char buf[BUFSIZ];
 
@@ -801,7 +802,7 @@ print_addr(struct in_addr *addr, struct in_addr *mask, int inv, int numeric)
 static void
 matchinfo_print(const void *ip, const struct xt_entry_match *match, int numeric, const char *optpfx)
 {
-	struct xt_conntrack_info *sinfo = (void *)match->data;
+	const struct xt_conntrack_info *sinfo = (const void *)match->data;
 
 	if(sinfo->flags & XT_CONNTRACK_STATE) {
         	if (sinfo->invflags & XT_CONNTRACK_STATE)
diff --git a/extensions/libxt_hashlimit.c b/extensions/libxt_hashlimit.c
index 9a7e5de..aa56c65 100644
--- a/extensions/libxt_hashlimit.c
+++ b/extensions/libxt_hashlimit.c
@@ -525,8 +525,7 @@ static void print_mode(unsigned int mode, char separator)
 static void hashlimit_print(const void *ip,
                             const struct xt_entry_match *match, int numeric)
 {
-	struct xt_hashlimit_info *r = 
-		(struct xt_hashlimit_info *)match->data;
+	const struct xt_hashlimit_info *r = (const void *)match->data;
 	fputs("limit: avg ", stdout); print_rate(r->cfg.avg);
 	printf("burst %u ", r->cfg.burst);
 	fputs("mode ", stdout);
@@ -590,8 +589,7 @@ hashlimit_mt6_print(const void *ip, const struct xt_entry_match *match,
 
 static void hashlimit_save(const void *ip, const struct xt_entry_match *match)
 {
-	struct xt_hashlimit_info *r = 
-		(struct xt_hashlimit_info *)match->data;
+	const struct xt_hashlimit_info *r = (const void *)match->data;
 
 	fputs("--hashlimit ", stdout); print_rate(r->cfg.avg);
 	if (r->cfg.burst != XT_HASHLIMIT_BURST)
diff --git a/extensions/libxt_helper.c b/extensions/libxt_helper.c
index 8378be7..7b56bef 100644
--- a/extensions/libxt_helper.c
+++ b/extensions/libxt_helper.c
@@ -55,14 +55,14 @@ static void helper_check(unsigned int flags)
 static void
 helper_print(const void *ip, const struct xt_entry_match *match, int numeric)
 {
-	struct xt_helper_info *info = (struct xt_helper_info *)match->data;
+	const struct xt_helper_info *info = (const void *)match->data;
 
 	printf("helper match %s\"%s\" ", info->invert ? "! " : "", info->name);
 }
 
 static void helper_save(const void *ip, const struct xt_entry_match *match)
 {
-	struct xt_helper_info *info = (struct xt_helper_info *)match->data;
+	const struct xt_helper_info *info = (const void *)match->data;
 
 	printf("%s--helper ",info->invert ? "! " : "");
 	xtables_save_string(info->name);
diff --git a/extensions/libxt_limit.c b/extensions/libxt_limit.c
index f785d2d..18224f3 100644
--- a/extensions/libxt_limit.c
+++ b/extensions/libxt_limit.c
@@ -144,14 +144,14 @@ static void print_rate(u_int32_t period)
 static void
 limit_print(const void *ip, const struct xt_entry_match *match, int numeric)
 {
-	struct xt_rateinfo *r = (struct xt_rateinfo *)match->data;
+	const struct xt_rateinfo *r = (const void *)match->data;
 	printf("limit: avg "); print_rate(r->avg);
 	printf("burst %u ", r->burst);
 }
 
 static void limit_save(const void *ip, const struct xt_entry_match *match)
 {
-	struct xt_rateinfo *r = (struct xt_rateinfo *)match->data;
+	const struct xt_rateinfo *r = (const void *)match->data;
 
 	printf("--limit "); print_rate(r->avg);
 	if (r->burst != XT_LIMIT_BURST)
diff --git a/extensions/libxt_mark.c b/extensions/libxt_mark.c
index ceca995..0edff74 100644
--- a/extensions/libxt_mark.c
+++ b/extensions/libxt_mark.c
@@ -110,7 +110,7 @@ mark_mt_print(const void *ip, const struct xt_entry_match *match, int numeric)
 static void
 mark_print(const void *ip, const struct xt_entry_match *match, int numeric)
 {
-	struct xt_mark_info *info = (struct xt_mark_info *)match->data;
+	const struct xt_mark_info *info = (const void *)match->data;
 
 	printf("MARK match ");
 
@@ -134,7 +134,7 @@ static void mark_mt_save(const void *ip, const struct xt_entry_match *match)
 static void
 mark_save(const void *ip, const struct xt_entry_match *match)
 {
-	struct xt_mark_info *info = (struct xt_mark_info *)match->data;
+	const struct xt_mark_info *info = (const void *)match->data;
 
 	if (info->invert)
 		printf("! ");
diff --git a/extensions/libxt_physdev.c b/extensions/libxt_physdev.c
index c87779b..5522a32 100644
--- a/extensions/libxt_physdev.c
+++ b/extensions/libxt_physdev.c
@@ -114,8 +114,7 @@ static void physdev_check(unsigned int flags)
 static void
 physdev_print(const void *ip, const struct xt_entry_match *match, int numeric)
 {
-	struct xt_physdev_info *info =
-		(struct xt_physdev_info*)match->data;
+	const struct xt_physdev_info *info = (const void *)match->data;
 
 	printf("PHYSDEV match");
 	if (info->bitmask & XT_PHYSDEV_OP_ISIN)
@@ -139,8 +138,7 @@ physdev_print(const void *ip, const struct xt_entry_match *match, int numeric)
 
 static void physdev_save(const void *ip, const struct xt_entry_match *match)
 {
-	struct xt_physdev_info *info =
-		(struct xt_physdev_info*)match->data;
+	const struct xt_physdev_info *info = (const void *)match->data;
 
 	if (info->bitmask & XT_PHYSDEV_OP_ISIN)
 		printf("%s--physdev-is-in ",
diff --git a/extensions/libxt_pkttype.c b/extensions/libxt_pkttype.c
index 0fa933f..50af3ed 100644
--- a/extensions/libxt_pkttype.c
+++ b/extensions/libxt_pkttype.c
@@ -111,7 +111,7 @@ static void pkttype_check(unsigned int flags)
 		xtables_error(PARAMETER_PROBLEM, "You must specify \"--pkt-type\"");
 }
 
-static void print_pkttype(struct xt_pkttype_info *info)
+static void print_pkttype(const struct xt_pkttype_info *info)
 {
 	unsigned int	i;
 	
@@ -130,7 +130,7 @@ static void print_pkttype(struct xt_pkttype_info *info)
 static void pkttype_print(const void *ip, const struct xt_entry_match *match,
                           int numeric)
 {
-	struct xt_pkttype_info *info = (struct xt_pkttype_info *)match->data;
+	const struct xt_pkttype_info *info = (const void *)match->data;
 	
 	printf("PKTTYPE %s= ", info->invert?"!":"");
 	print_pkttype(info);
@@ -138,7 +138,7 @@ static void pkttype_print(const void *ip, const struct xt_entry_match *match,
 
 static void pkttype_save(const void *ip, const struct xt_entry_match *match)
 {
-	struct xt_pkttype_info *info = (struct xt_pkttype_info *)match->data;
+	const struct xt_pkttype_info *info = (const void *)match->data;
 	
 	printf("%s--pkt-type ", info->invert ? "! " : "");
 	print_pkttype(info);
diff --git a/extensions/libxt_quota.c b/extensions/libxt_quota.c
index 2657b2a..4c1bcb0 100644
--- a/extensions/libxt_quota.c
+++ b/extensions/libxt_quota.c
@@ -25,14 +25,14 @@ static void quota_help(void)
 static void
 quota_print(const void *ip, const struct xt_entry_match *match, int numeric)
 {
-	struct xt_quota_info *q = (struct xt_quota_info *) match->data;
+	const struct xt_quota_info *q = (const void *)match->data;
 	printf("quota: %llu bytes", (unsigned long long) q->quota);
 }
 
 static void
 quota_save(const void *ip, const struct xt_entry_match *match)
 {
-	struct xt_quota_info *q = (struct xt_quota_info *) match->data;
+	const struct xt_quota_info *q = (const void *)match->data;
 	printf("--quota %llu ", (unsigned long long) q->quota);
 }
 
diff --git a/extensions/libxt_rateest.c b/extensions/libxt_rateest.c
index 3cff07d..9f3a436 100644
--- a/extensions/libxt_rateest.c
+++ b/extensions/libxt_rateest.c
@@ -332,7 +332,8 @@ rateest_print_rate(u_int32_t rate, int numeric)
 }
 
 static void
-rateest_print_mode(struct xt_rateest_match_info *info, const char *prefix)
+rateest_print_mode(const struct xt_rateest_match_info *info,
+                   const char *prefix)
 {
 	if (info->flags & XT_RATEEST_MATCH_INVERT)
 		printf("! ");
@@ -355,7 +356,7 @@ rateest_print_mode(struct xt_rateest_match_info *info, const char *prefix)
 static void
 rateest_print(const void *ip, const struct xt_entry_match *match, int numeric)
 {
-	struct xt_rateest_match_info *info = (void *)match->data;
+	const struct xt_rateest_match_info *info = (const void *)match->data;
 
 	printf("rateest match ");
 
@@ -405,7 +406,7 @@ rateest_print(const void *ip, const struct xt_entry_match *match, int numeric)
 static void
 rateest_save(const void *ip, const struct xt_entry_match *match)
 {
-	struct xt_rateest_match_info *info = (void *)match->data;
+	const struct xt_rateest_match_info *info = (const void *)match->data;
 
 	if (info->flags & XT_RATEEST_MATCH_REL) {
 		printf("--rateest1 %s ", info->name1);
diff --git a/extensions/libxt_state.c b/extensions/libxt_state.c
index 0f26443..7387e26 100644
--- a/extensions/libxt_state.c
+++ b/extensions/libxt_state.c
@@ -124,7 +124,7 @@ state_print(const void *ip,
       const struct xt_entry_match *match,
       int numeric)
 {
-	struct xt_state_info *sinfo = (struct xt_state_info *)match->data;
+	const struct xt_state_info *sinfo = (const void *)match->data;
 
 	printf("state ");
 	state_print_state(sinfo->statemask);
@@ -132,7 +132,7 @@ state_print(const void *ip,
 
 static void state_save(const void *ip, const struct xt_entry_match *match)
 {
-	struct xt_state_info *sinfo = (struct xt_state_info *)match->data;
+	const struct xt_state_info *sinfo = (const void *)match->data;
 
 	printf("--state ");
 	state_print_state(sinfo->statemask);
diff --git a/extensions/libxt_statistic.c b/extensions/libxt_statistic.c
index fa044ad..5b03686 100644
--- a/extensions/libxt_statistic.c
+++ b/extensions/libxt_statistic.c
@@ -146,7 +146,7 @@ static void print_match(const struct xt_statistic_info *info, char *prefix)
 static void
 statistic_print(const void *ip, const struct xt_entry_match *match, int numeric)
 {
-	struct xt_statistic_info *info = (struct xt_statistic_info *)match->data;
+	const struct xt_statistic_info *info = (const void *)match->data;
 
 	printf("statistic ");
 	print_match(info, "");
@@ -154,7 +154,7 @@ statistic_print(const void *ip, const struct xt_entry_match *match, int numeric)
 
 static void statistic_save(const void *ip, const struct xt_entry_match *match)
 {
-	struct xt_statistic_info *info = (struct xt_statistic_info *)match->data;
+	const struct xt_statistic_info *info = (const void *)match->data;
 
 	print_match(info, "--");
 }
diff --git a/extensions/libxt_time.c b/extensions/libxt_time.c
index eb8b671..1c81260 100644
--- a/extensions/libxt_time.c
+++ b/extensions/libxt_time.c
@@ -406,7 +406,7 @@ static inline void divide_time(unsigned int fulltime, unsigned int *hours,
 static void time_print(const void *ip, const struct xt_entry_match *match,
                        int numeric)
 {
-	struct xt_time_info *info = (void *)match->data;
+	const struct xt_time_info *info = (const void *)match->data;
 	unsigned int h, m, s;
 
 	printf("TIME ");
-- 
1.6.3.1

