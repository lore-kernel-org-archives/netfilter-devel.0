From: Yasuyuki KOZAKAI <yasuyuki.kozakai@toshiba.co.jp>
Subject: [PATCH 18/43] Split ipt_multport into family dependent parts and
 others
Date: Fri, 20 Jul 2007 20:11:50 +0900 (JST)
Message-ID: <200707201111.l6KBBolY002432@toshiba.co.jp>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
To: kaber@trash.net, netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
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



---
 extensions/libipt_multiport.c |  102 +++++++++++++++++++++++++++--------------
 1 files changed, 68 insertions(+), 34 deletions(-)

diff --git a/extensions/libipt_multiport.c b/extensions/libipt_multiport.c
index b6d2dff..a21674d 100644
--- a/extensions/libipt_multiport.c
+++ b/extensions/libipt_multiport.c
@@ -139,18 +139,17 @@ init(struct xt_entry_match *m, unsigned int *nfcache)
 }
 
 static const char *
-check_proto(const void *e)
+check_proto(u_int16_t pnum, u_int8_t invflags)
 {
-	const struct ipt_entry *entry = e;
 	char *proto;
 
-	if (entry->ip.invflags & XT_INV_PROTO)
+	if (invflags & XT_INV_PROTO)
 		exit_error(PARAMETER_PROBLEM,
 			   "multiport only works with TCP, UDP, UDPLITE, SCTP and DCCP");
 
-	if ((proto = proto_to_name(entry->ip.proto)) != NULL)
+	if ((proto = proto_to_name(pnum)) != NULL)
 		return proto;
-	else if (!entry->ip.proto)
+	else if (!pnum)
 		exit_error(PARAMETER_PROBLEM,
 			   "multiport needs `-p tcp', `-p udp', `-p udplite', "
 			   "`-p sctp' or `-p dccp'");
@@ -162,12 +161,10 @@ check_proto(const void *e)
 /* Function which parses command options; returns true if it
    ate an option */
 static int
-parse(int c, char **argv, int invert, unsigned int *flags,
-      const void *e,
-      unsigned int *nfcache,
-      struct xt_entry_match **match)
+__parse(int c, char **argv, int invert, unsigned int *flags,
+	struct xt_entry_match **match,
+	u_int16_t pnum, u_int8_t invflags)
 {
-	const struct ipt_entry *entry = e;
 	const char *proto;
 	struct xt_multiport *multiinfo
 		= (struct xt_multiport *)(*match)->data;
@@ -175,7 +172,7 @@ parse(int c, char **argv, int invert, unsigned int *flags,
 	switch (c) {
 	case '1':
 		check_inverse(argv[optind-1], &invert, &optind, 0);
-		proto = check_proto(entry);
+		proto = check_proto(pnum, invflags);
 		multiinfo->count = parse_multi_ports(argv[optind-1],
 						     multiinfo->ports, proto);
 		multiinfo->flags = XT_MULTIPORT_SOURCE;
@@ -183,7 +180,7 @@ parse(int c, char **argv, int invert, unsigned int *flags,
 
 	case '2':
 		check_inverse(argv[optind-1], &invert, &optind, 0);
-		proto = check_proto(entry);
+		proto = check_proto(pnum, invflags);
 		multiinfo->count = parse_multi_ports(argv[optind-1],
 						     multiinfo->ports, proto);
 		multiinfo->flags = XT_MULTIPORT_DESTINATION;
@@ -191,7 +188,7 @@ parse(int c, char **argv, int invert, unsigned int *flags,
 
 	case '3':
 		check_inverse(argv[optind-1], &invert, &optind, 0);
-		proto = check_proto(entry);
+		proto = check_proto(pnum, invflags);
 		multiinfo->count = parse_multi_ports(argv[optind-1],
 						     multiinfo->ports, proto);
 		multiinfo->flags = XT_MULTIPORT_EITHER;
@@ -213,12 +210,21 @@ parse(int c, char **argv, int invert, unsigned int *flags,
 }
 
 static int
-parse_v1(int c, char **argv, int invert, unsigned int *flags,
+parse(int c, char **argv, int invert, unsigned int *flags,
 	 const void *e,
 	 unsigned int *nfcache,
 	 struct xt_entry_match **match)
 {
 	const struct ipt_entry *entry = e;
+	return __parse(c, argv, invert, flags, match, entry->ip.proto,
+		       entry->ip.invflags);
+}
+
+static int
+__parse_v1(int c, char **argv, int invert, unsigned int *flags,
+	   struct xt_entry_match **match,
+	   u_int16_t pnum, u_int8_t invflags)
+{
 	const char *proto;
 	struct xt_multiport_v1 *multiinfo
 		= (struct xt_multiport_v1 *)(*match)->data;
@@ -226,21 +232,21 @@ parse_v1(int c, char **argv, int invert, unsigned int *flags,
 	switch (c) {
 	case '1':
 		check_inverse(argv[optind-1], &invert, &optind, 0);
-		proto = check_proto(entry);
+		proto = check_proto(pnum, invflags);
 		parse_multi_ports_v1(argv[optind-1], multiinfo, proto);
 		multiinfo->flags = XT_MULTIPORT_SOURCE;
 		break;
 
 	case '2':
 		check_inverse(argv[optind-1], &invert, &optind, 0);
-		proto = check_proto(entry);
+		proto = check_proto(pnum, invflags);
 		parse_multi_ports_v1(argv[optind-1], multiinfo, proto);
 		multiinfo->flags = XT_MULTIPORT_DESTINATION;
 		break;
 
 	case '3':
 		check_inverse(argv[optind-1], &invert, &optind, 0);
-		proto = check_proto(entry);
+		proto = check_proto(pnum, invflags);
 		parse_multi_ports_v1(argv[optind-1], multiinfo, proto);
 		multiinfo->flags = XT_MULTIPORT_EITHER;
 		break;
@@ -259,6 +265,17 @@ parse_v1(int c, char **argv, int invert, unsigned int *flags,
 	return 1;
 }
 
+static int
+parse_v1(int c, char **argv, int invert, unsigned int *flags,
+	 const void *e,
+	 unsigned int *nfcache,
+	 struct xt_entry_match **match)
+{
+	const struct ipt_entry *entry = e;
+	return __parse_v1(c, argv, invert, flags, match, entry->ip.proto,
+			  entry->ip.invflags);
+}
+
 /* Final check; must specify something. */
 static void
 final_check(unsigned int flags)
@@ -291,11 +308,8 @@ print_port(u_int16_t port, u_int8_t protocol, int numeric)
 
 /* Prints out the matchinfo. */
 static void
-print(const void *ip_void,
-      const struct xt_entry_match *match,
-      int numeric)
+__print(const struct xt_entry_match *match, int numeric, u_int16_t proto)
 {
-	const struct ipt_ip *ip = ip_void;
 	const struct xt_multiport *multiinfo
 		= (const struct xt_multiport *)match->data;
 	unsigned int i;
@@ -322,17 +336,21 @@ print(const void *ip_void,
 
 	for (i=0; i < multiinfo->count; i++) {
 		printf("%s", i ? "," : "");
-		print_port(multiinfo->ports[i], ip->proto, numeric);
+		print_port(multiinfo->ports[i], proto, numeric);
 	}
 	printf(" ");
 }
 
 static void
-print_v1(const void *ip_void,
-	 const struct xt_entry_match *match,
-	 int numeric)
+print(const void *ip_void, const struct xt_entry_match *match, int numeric)
 {
 	const struct ipt_ip *ip = ip_void;
+	__print(match, numeric, ip->proto);
+}
+
+static void
+__print_v1(const struct xt_entry_match *match, int numeric, u_int16_t proto)
+{
 	const struct xt_multiport_v1 *multiinfo
 		= (const struct xt_multiport_v1 *)match->data;
 	unsigned int i;
@@ -362,19 +380,25 @@ print_v1(const void *ip_void,
 
 	for (i=0; i < multiinfo->count; i++) {
 		printf("%s", i ? "," : "");
-		print_port(multiinfo->ports[i], ip->proto, numeric);
+		print_port(multiinfo->ports[i], proto, numeric);
 		if (multiinfo->pflags[i]) {
 			printf(":");
-			print_port(multiinfo->ports[++i], ip->proto, numeric);
+			print_port(multiinfo->ports[++i], proto, numeric);
 		}
 	}
 	printf(" ");
 }
 
-/* Saves the union ipt_matchinfo in parsable form to stdout. */
-static void save(const void *ip_void, const struct xt_entry_match *match)
+static void
+print_v1(const void *ip_void, const struct xt_entry_match *match, int numeric)
 {
 	const struct ipt_ip *ip = ip_void;
+	__print_v1(match, numeric, ip->proto);
+}
+
+/* Saves the union ipt_matchinfo in parsable form to stdout. */
+static void __save(const struct xt_entry_match *match, u_int16_t proto)
+{
 	const struct xt_multiport *multiinfo
 		= (const struct xt_multiport *)match->data;
 	unsigned int i;
@@ -395,15 +419,19 @@ static void save(const void *ip_void, const struct xt_entry_match *match)
 
 	for (i=0; i < multiinfo->count; i++) {
 		printf("%s", i ? "," : "");
-		print_port(multiinfo->ports[i], ip->proto, 1);
+		print_port(multiinfo->ports[i], proto, 1);
 	}
 	printf(" ");
 }
 
-static void save_v1(const void *ip_void,
-		    const struct xt_entry_match *match)
+static void save(const void *ip_void, const struct xt_entry_match *match)
 {
 	const struct ipt_ip *ip = ip_void;
+	__save(match, ip->proto);
+}
+
+static void __save_v1(const struct xt_entry_match *match, u_int16_t proto)
+{
 	const struct xt_multiport_v1 *multiinfo
 		= (const struct xt_multiport_v1 *)match->data;
 	unsigned int i;
@@ -427,15 +455,21 @@ static void save_v1(const void *ip_void,
 
 	for (i=0; i < multiinfo->count; i++) {
 		printf("%s", i ? "," : "");
-		print_port(multiinfo->ports[i], ip->proto, 1);
+		print_port(multiinfo->ports[i], proto, 1);
 		if (multiinfo->pflags[i]) {
 			printf(":");
-			print_port(multiinfo->ports[++i], ip->proto, 1);
+			print_port(multiinfo->ports[++i], proto, 1);
 		}
 	}
 	printf(" ");
 }
 
+static void save_v1(const void *ip_void, const struct xt_entry_match *match)
+{
+	const struct ipt_ip *ip = ip_void;
+	__save_v1(match, ip->proto);
+}
+
 static struct xtables_match multiport = { 
 	.next		= NULL,
 	.family		= AF_INET,
-- 
1.5.2.2
