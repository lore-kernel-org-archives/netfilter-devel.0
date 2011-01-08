From: Jan Engelhardt <jengelh@medozas.de>
Subject: [PATCH 02/13] src: const annotations
Date: Sat,  8 Jan 2011 16:20:03 +0100
Message-ID: <1294500015-10691-3-git-send-email-jengelh@medozas.de>
References: <1294500015-10691-1-git-send-email-jengelh@medozas.de>
Cc: kaber@trash.net, netfilter-devel@vger.kernel.org
To: pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from borg.medozas.de ([188.40.89.202]:32884 "EHLO borg.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752505Ab1AHPUS (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 8 Jan 2011 10:20:18 -0500
In-Reply-To: <1294500015-10691-1-git-send-email-jengelh@medozas.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Also one int -> uint here on the way through.

Signed-off-by: Jan Engelhardt <jengelh@medozas.de>
---
 ip6tables.c |   27 ++++++++++++++-------------
 iptables.c  |   25 +++++++++++++------------
 2 files changed, 27 insertions(+), 25 deletions(-)

diff --git a/ip6tables.c b/ip6tables.c
index 9b1629e..0284791 100644
--- a/ip6tables.c
+++ b/ip6tables.c
@@ -160,7 +160,7 @@ struct xtables_globals ip6tables_globals = {
  *     optional
  */
 
-static char commands_v_options[NUMBER_OF_CMD][NUMBER_OF_OPT] =
+static const char commands_v_options[NUMBER_OF_CMD][NUMBER_OF_OPT] =
 /* Well, it's better than "Re: Linux vs FreeBSD" */
 {
 	/*     -n  -s  -d  -p  -j  -v  -x  -i  -o --line -c */
@@ -180,7 +180,7 @@ static char commands_v_options[NUMBER_OF_CMD][NUMBER_OF_OPT] =
 /*LIST_RULES*/{'x','x','x','x','x',' ','x','x','x','x','x'}
 };
 
-static int inverse_for_options[NUMBER_OF_OPT] =
+static const unsigned int inverse_for_options[NUMBER_OF_OPT] =
 {
 /* -n */ 0,
 /* -s */ IP6T_INV_SRCIP,
@@ -201,7 +201,7 @@ static int inverse_for_options[NUMBER_OF_OPT] =
 /* A few hardcoded protocols for 'all' and in case the user has no
    /etc/protocols */
 struct pprot {
-	char *name;
+	const char *name;
 	u_int8_t num;
 };
 
@@ -211,7 +211,7 @@ proto_to_name(u_int8_t proto, int nolookup)
 	unsigned int i;
 
 	if (proto && !nolookup) {
-		struct protoent *pent = getprotobynumber(proto);
+		const struct protoent *pent = getprotobynumber(proto);
 		if (pent)
 			return pent->p_name;
 	}
@@ -235,7 +235,7 @@ exit_tryhelp(int status)
 }
 
 static void
-exit_printhelp(struct xtables_rule_match *matches)
+exit_printhelp(const struct xtables_rule_match *matches)
 {
 	printf("%s v%s\n\n"
 "Usage: %s -[AD] chain rule-specification [options]\n"
@@ -569,7 +569,7 @@ print_match(const struct ip6t_entry_match *m,
 	    const struct ip6t_ip6 *ip,
 	    int numeric)
 {
-	struct xtables_match *match =
+	const struct xtables_match *match =
 		xtables_find_match(m->u.user.name, XTF_TRY_LOAD, NULL);
 
 	if (match) {
@@ -593,7 +593,7 @@ print_firewall(const struct ip6t_entry *fw,
 	       unsigned int format,
 	       struct ip6tc_handle *const handle)
 {
-	struct xtables_target *target = NULL;
+	const struct xtables_target *target = NULL;
 	const struct ip6t_entry_target *t;
 	u_int8_t flags;
 	char buf[BUFSIZ];
@@ -804,12 +804,12 @@ insert_entry(const ip6t_chainlabel chain,
 }
 
 static unsigned char *
-make_delete_mask(struct xtables_rule_match *matches,
+make_delete_mask(const struct xtables_rule_match *matches,
 		 const struct xtables_target *target)
 {
 	/* Establish mask for comparison */
 	unsigned int size;
-	struct xtables_rule_match *matchp;
+	const struct xtables_rule_match *matchp;
 	unsigned char *mask, *mptr;
 
 	size = sizeof(struct ip6t_entry);
@@ -1035,7 +1035,7 @@ static void print_proto(u_int16_t proto, int invert)
 		unsigned int i;
 		const char *invertstr = invert ? "! " : "";
 
-		struct protoent *pent = getprotobynumber(proto);
+		const struct protoent *pent = getprotobynumber(proto);
 		if (pent) {
 			printf("%s-p %s ",
 			       invertstr, pent->p_name);
@@ -1056,7 +1056,7 @@ static void print_proto(u_int16_t proto, int invert)
 static int print_match_save(const struct ip6t_entry_match *e,
 			const struct ip6t_ip6 *ip)
 {
-	struct xtables_match *match =
+	const struct xtables_match *match =
 		xtables_find_match(e->u.user.name, XTF_TRY_LOAD, NULL);
 
 	if (match) {
@@ -1077,7 +1077,8 @@ static int print_match_save(const struct ip6t_entry_match *e,
 }
 
 /* print a given ip including mask if neccessary */
-static void print_ip(char *prefix, const struct in6_addr *ip, const struct in6_addr *mask, int invert)
+static void print_ip(const char *prefix, const struct in6_addr *ip,
+		     const struct in6_addr *mask, int invert)
 {
 	char buf[51];
 	int l = ipv6_prefix_length(mask);
@@ -1101,7 +1102,7 @@ static void print_ip(char *prefix, const struct in6_addr *ip, const struct in6_a
 void print_rule(const struct ip6t_entry *e,
 		       struct ip6tc_handle *h, const char *chain, int counters)
 {
-	struct ip6t_entry_target *t;
+	const struct ip6t_entry_target *t;
 	const char *target_name;
 
 	/* print counters for iptables-save */
diff --git a/iptables.c b/iptables.c
index 1127bdd..342ea04 100644
--- a/iptables.c
+++ b/iptables.c
@@ -160,7 +160,7 @@ struct xtables_globals iptables_globals = {
  *     optional
  */
 
-static char commands_v_options[NUMBER_OF_CMD][NUMBER_OF_OPT] =
+static const char commands_v_options[NUMBER_OF_CMD][NUMBER_OF_OPT] =
 /* Well, it's better than "Re: Linux vs FreeBSD" */
 {
 	/*     -n  -s  -d  -p  -j  -v  -x  -i  -o  -f --line -c */
@@ -180,7 +180,7 @@ static char commands_v_options[NUMBER_OF_CMD][NUMBER_OF_OPT] =
 /*LIST_RULES*/{'x','x','x','x','x',' ','x','x','x','x','x','x'}
 };
 
-static int inverse_for_options[NUMBER_OF_OPT] =
+static const int inverse_for_options[NUMBER_OF_OPT] =
 {
 /* -n */ 0,
 /* -s */ IPT_INV_SRCIP,
@@ -248,7 +248,7 @@ exit_tryhelp(int status)
 }
 
 static void
-exit_printhelp(struct xtables_rule_match *matches)
+exit_printhelp(const struct xtables_rule_match *matches)
 {
 	printf("%s v%s\n\n"
 "Usage: %s -[AD] chain rule-specification [options]\n"
@@ -573,7 +573,7 @@ print_match(const struct ipt_entry_match *m,
 	    const struct ipt_ip *ip,
 	    int numeric)
 {
-	struct xtables_match *match =
+	const struct xtables_match *match =
 		xtables_find_match(m->u.user.name, XTF_TRY_LOAD, NULL);
 
 	if (match) {
@@ -597,7 +597,7 @@ print_firewall(const struct ipt_entry *fw,
 	       unsigned int format,
 	       struct iptc_handle *const handle)
 {
-	struct xtables_target *target = NULL;
+	const struct xtables_target *target = NULL;
 	const struct ipt_entry_target *t;
 	u_int8_t flags;
 	char buf[BUFSIZ];
@@ -806,12 +806,12 @@ insert_entry(const ipt_chainlabel chain,
 }
 
 static unsigned char *
-make_delete_mask(struct xtables_rule_match *matches,
+make_delete_mask(const struct xtables_rule_match *matches,
 		 const struct xtables_target *target)
 {
 	/* Establish mask for comparison */
 	unsigned int size;
-	struct xtables_rule_match *matchp;
+	const struct xtables_rule_match *matchp;
 	unsigned char *mask, *mptr;
 
 	size = sizeof(struct ipt_entry);
@@ -1008,7 +1008,7 @@ static void print_proto(u_int16_t proto, int invert)
 		unsigned int i;
 		const char *invertstr = invert ? "! " : "";
 
-		struct protoent *pent = getprotobynumber(proto);
+		const struct protoent *pent = getprotobynumber(proto);
 		if (pent) {
 			printf("%s-p %s ", invertstr, pent->p_name);
 			return;
@@ -1064,7 +1064,7 @@ print_iface(char letter, const char *iface, const unsigned char *mask,
 static int print_match_save(const struct ipt_entry_match *e,
 			const struct ipt_ip *ip)
 {
-	struct xtables_match *match =
+	const struct xtables_match *match =
 		xtables_find_match(e->u.user.name, XTF_TRY_LOAD, NULL);
 
 	if (match) {
@@ -1085,7 +1085,8 @@ static int print_match_save(const struct ipt_entry_match *e,
 }
 
 /* print a given ip including mask if neccessary */
-static void print_ip(char *prefix, u_int32_t ip, u_int32_t mask, int invert)
+static void print_ip(const char *prefix, u_int32_t ip,
+		     u_int32_t mask, int invert)
 {
 	u_int32_t bits, hmask = ntohl(mask);
 	int i;
@@ -1118,7 +1119,7 @@ static void print_ip(char *prefix, u_int32_t ip, u_int32_t mask, int invert)
 void print_rule(const struct ipt_entry *e,
 		struct iptc_handle *h, const char *chain, int counters)
 {
-	struct ipt_entry_target *t;
+	const struct ipt_entry_target *t;
 	const char *target_name;
 
 	/* print counters for iptables-save */
@@ -1168,7 +1169,7 @@ void print_rule(const struct ipt_entry *e,
 	/* Print targinfo part */
 	t = ipt_get_target((struct ipt_entry *)e);
 	if (t->u.user.name[0]) {
-		struct xtables_target *target =
+		const struct xtables_target *target =
 			xtables_find_target(t->u.user.name, XTF_TRY_LOAD);
 
 		if (!target) {
-- 
1.7.1

