From: Yasuyuki KOZAKAI <yasuyuki.kozakai@toshiba.co.jp>
Subject: [PATCH 17/43] Use unified API in multiport match
Date: Fri, 20 Jul 2007 20:11:38 +0900 (JST)
Message-ID: <200707201111.l6KBBdAe025698@toshiba.co.jp>
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
 extensions/libipt_multiport.c          |   96 ++++++++++++++++---------------
 include/linux/netfilter/xt_multiport.h |   30 ++++++++++
 2 files changed, 80 insertions(+), 46 deletions(-)
 create mode 100644 include/linux/netfilter/xt_multiport.h

diff --git a/extensions/libipt_multiport.c b/extensions/libipt_multiport.c
index 6de25c3..b6d2dff 100644
--- a/extensions/libipt_multiport.c
+++ b/extensions/libipt_multiport.c
@@ -4,9 +4,11 @@
 #include <string.h>
 #include <stdlib.h>
 #include <getopt.h>
-#include <iptables.h>
+
+#include <xtables.h>
+#include <libiptc/libiptc.h>
 /* To ensure that iptables compiles with an old kernel */
-#include "../include/linux/netfilter_ipv4/ipt_multiport.h"
+#include "../include/linux/netfilter/xt_multiport.h"
 
 /* Function which prints out usage message. */
 static void
@@ -79,7 +81,7 @@ parse_multi_ports(const char *portstring, u_int16_t *ports, const char *proto)
 	buffer = strdup(portstring);
 	if (!buffer) exit_error(OTHER_PROBLEM, "strdup failed");
 
-	for (cp=buffer, i=0; cp && i<IPT_MULTI_PORTS; cp=next,i++)
+	for (cp=buffer, i=0; cp && i<XT_MULTI_PORTS; cp=next,i++)
 	{
 		next=strchr(cp, ',');
 		if (next) *next++='\0';
@@ -92,7 +94,7 @@ parse_multi_ports(const char *portstring, u_int16_t *ports, const char *proto)
 
 static void
 parse_multi_ports_v1(const char *portstring, 
-		     struct ipt_multiport_v1 *multiinfo,
+		     struct xt_multiport_v1 *multiinfo,
 		     const char *proto)
 {
 	char *buffer, *cp, *next, *range;
@@ -102,15 +104,15 @@ parse_multi_ports_v1(const char *portstring,
 	buffer = strdup(portstring);
 	if (!buffer) exit_error(OTHER_PROBLEM, "strdup failed");
 
-	for (i=0; i<IPT_MULTI_PORTS; i++)
+	for (i=0; i<XT_MULTI_PORTS; i++)
 		multiinfo->pflags[i] = 0;
  
-	for (cp=buffer, i=0; cp && i<IPT_MULTI_PORTS; cp=next, i++) {
+	for (cp=buffer, i=0; cp && i<XT_MULTI_PORTS; cp=next, i++) {
 		next=strchr(cp, ',');
  		if (next) *next++='\0';
 		range = strchr(cp, ':');
 		if (range) {
-			if (i == IPT_MULTI_PORTS-1)
+			if (i == XT_MULTI_PORTS-1)
 				exit_error(PARAMETER_PROBLEM,
 					   "too many ports specified");
 			*range++ = '\0';
@@ -142,7 +144,7 @@ check_proto(const void *e)
 	const struct ipt_entry *entry = e;
 	char *proto;
 
-	if (entry->ip.invflags & IPT_INV_PROTO)
+	if (entry->ip.invflags & XT_INV_PROTO)
 		exit_error(PARAMETER_PROBLEM,
 			   "multiport only works with TCP, UDP, UDPLITE, SCTP and DCCP");
 
@@ -167,8 +169,8 @@ parse(int c, char **argv, int invert, unsigned int *flags,
 {
 	const struct ipt_entry *entry = e;
 	const char *proto;
-	struct ipt_multiport *multiinfo
-		= (struct ipt_multiport *)(*match)->data;
+	struct xt_multiport *multiinfo
+		= (struct xt_multiport *)(*match)->data;
 
 	switch (c) {
 	case '1':
@@ -176,7 +178,7 @@ parse(int c, char **argv, int invert, unsigned int *flags,
 		proto = check_proto(entry);
 		multiinfo->count = parse_multi_ports(argv[optind-1],
 						     multiinfo->ports, proto);
-		multiinfo->flags = IPT_MULTIPORT_SOURCE;
+		multiinfo->flags = XT_MULTIPORT_SOURCE;
 		break;
 
 	case '2':
@@ -184,7 +186,7 @@ parse(int c, char **argv, int invert, unsigned int *flags,
 		proto = check_proto(entry);
 		multiinfo->count = parse_multi_ports(argv[optind-1],
 						     multiinfo->ports, proto);
-		multiinfo->flags = IPT_MULTIPORT_DESTINATION;
+		multiinfo->flags = XT_MULTIPORT_DESTINATION;
 		break;
 
 	case '3':
@@ -192,7 +194,7 @@ parse(int c, char **argv, int invert, unsigned int *flags,
 		proto = check_proto(entry);
 		multiinfo->count = parse_multi_ports(argv[optind-1],
 						     multiinfo->ports, proto);
-		multiinfo->flags = IPT_MULTIPORT_EITHER;
+		multiinfo->flags = XT_MULTIPORT_EITHER;
 		break;
 
 	default:
@@ -218,29 +220,29 @@ parse_v1(int c, char **argv, int invert, unsigned int *flags,
 {
 	const struct ipt_entry *entry = e;
 	const char *proto;
-	struct ipt_multiport_v1 *multiinfo
-		= (struct ipt_multiport_v1 *)(*match)->data;
+	struct xt_multiport_v1 *multiinfo
+		= (struct xt_multiport_v1 *)(*match)->data;
 
 	switch (c) {
 	case '1':
 		check_inverse(argv[optind-1], &invert, &optind, 0);
 		proto = check_proto(entry);
 		parse_multi_ports_v1(argv[optind-1], multiinfo, proto);
-		multiinfo->flags = IPT_MULTIPORT_SOURCE;
+		multiinfo->flags = XT_MULTIPORT_SOURCE;
 		break;
 
 	case '2':
 		check_inverse(argv[optind-1], &invert, &optind, 0);
 		proto = check_proto(entry);
 		parse_multi_ports_v1(argv[optind-1], multiinfo, proto);
-		multiinfo->flags = IPT_MULTIPORT_DESTINATION;
+		multiinfo->flags = XT_MULTIPORT_DESTINATION;
 		break;
 
 	case '3':
 		check_inverse(argv[optind-1], &invert, &optind, 0);
 		proto = check_proto(entry);
 		parse_multi_ports_v1(argv[optind-1], multiinfo, proto);
-		multiinfo->flags = IPT_MULTIPORT_EITHER;
+		multiinfo->flags = XT_MULTIPORT_EITHER;
 		break;
 
 	default:
@@ -294,22 +296,22 @@ print(const void *ip_void,
       int numeric)
 {
 	const struct ipt_ip *ip = ip_void;
-	const struct ipt_multiport *multiinfo
-		= (const struct ipt_multiport *)match->data;
+	const struct xt_multiport *multiinfo
+		= (const struct xt_multiport *)match->data;
 	unsigned int i;
 
 	printf("multiport ");
 
 	switch (multiinfo->flags) {
-	case IPT_MULTIPORT_SOURCE:
+	case XT_MULTIPORT_SOURCE:
 		printf("sports ");
 		break;
 
-	case IPT_MULTIPORT_DESTINATION:
+	case XT_MULTIPORT_DESTINATION:
 		printf("dports ");
 		break;
 
-	case IPT_MULTIPORT_EITHER:
+	case XT_MULTIPORT_EITHER:
 		printf("ports ");
 		break;
 
@@ -331,22 +333,22 @@ print_v1(const void *ip_void,
 	 int numeric)
 {
 	const struct ipt_ip *ip = ip_void;
-	const struct ipt_multiport_v1 *multiinfo
-		= (const struct ipt_multiport_v1 *)match->data;
+	const struct xt_multiport_v1 *multiinfo
+		= (const struct xt_multiport_v1 *)match->data;
 	unsigned int i;
 
 	printf("multiport ");
 
 	switch (multiinfo->flags) {
-	case IPT_MULTIPORT_SOURCE:
+	case XT_MULTIPORT_SOURCE:
 		printf("sports ");
 		break;
 
-	case IPT_MULTIPORT_DESTINATION:
+	case XT_MULTIPORT_DESTINATION:
 		printf("dports ");
 		break;
 
-	case IPT_MULTIPORT_EITHER:
+	case XT_MULTIPORT_EITHER:
 		printf("ports ");
 		break;
 
@@ -373,20 +375,20 @@ print_v1(const void *ip_void,
 static void save(const void *ip_void, const struct xt_entry_match *match)
 {
 	const struct ipt_ip *ip = ip_void;
-	const struct ipt_multiport *multiinfo
-		= (const struct ipt_multiport *)match->data;
+	const struct xt_multiport *multiinfo
+		= (const struct xt_multiport *)match->data;
 	unsigned int i;
 
 	switch (multiinfo->flags) {
-	case IPT_MULTIPORT_SOURCE:
+	case XT_MULTIPORT_SOURCE:
 		printf("--sports ");
 		break;
 
-	case IPT_MULTIPORT_DESTINATION:
+	case XT_MULTIPORT_DESTINATION:
 		printf("--dports ");
 		break;
 
-	case IPT_MULTIPORT_EITHER:
+	case XT_MULTIPORT_EITHER:
 		printf("--ports ");
 		break;
 	}
@@ -402,20 +404,20 @@ static void save_v1(const void *ip_void,
 		    const struct xt_entry_match *match)
 {
 	const struct ipt_ip *ip = ip_void;
-	const struct ipt_multiport_v1 *multiinfo
-		= (const struct ipt_multiport_v1 *)match->data;
+	const struct xt_multiport_v1 *multiinfo
+		= (const struct xt_multiport_v1 *)match->data;
 	unsigned int i;
 
 	switch (multiinfo->flags) {
-	case IPT_MULTIPORT_SOURCE:
+	case XT_MULTIPORT_SOURCE:
 		printf("--sports ");
 		break;
 
-	case IPT_MULTIPORT_DESTINATION:
+	case XT_MULTIPORT_DESTINATION:
 		printf("--dports ");
 		break;
 
-	case IPT_MULTIPORT_EITHER:
+	case XT_MULTIPORT_EITHER:
 		printf("--ports ");
 		break;
 	}
@@ -434,13 +436,14 @@ static void save_v1(const void *ip_void,
 	printf(" ");
 }
 
-static struct iptables_match multiport = { 
+static struct xtables_match multiport = { 
 	.next		= NULL,
+	.family		= AF_INET,
 	.name		= "multiport",
 	.revision	= 0,
 	.version	= IPTABLES_VERSION,
-	.size		= IPT_ALIGN(sizeof(struct ipt_multiport)),
-	.userspacesize	= IPT_ALIGN(sizeof(struct ipt_multiport)),
+	.size		= XT_ALIGN(sizeof(struct xt_multiport)),
+	.userspacesize	= XT_ALIGN(sizeof(struct xt_multiport)),
 	.help		= &help,
 	.init		= &init,
 	.parse		= &parse,
@@ -450,13 +453,14 @@ static struct iptables_match multiport = {
 	.extra_opts	= opts
 };
 
-static struct iptables_match multiport_v1 = { 
+static struct xtables_match multiport_v1 = { 
 	.next		= NULL,
+	.family		= AF_INET,
 	.name		= "multiport",
 	.version	= IPTABLES_VERSION,
 	.revision	= 1,
-	.size		= IPT_ALIGN(sizeof(struct ipt_multiport_v1)),
-	.userspacesize	= IPT_ALIGN(sizeof(struct ipt_multiport_v1)),
+	.size		= XT_ALIGN(sizeof(struct xt_multiport_v1)),
+	.userspacesize	= XT_ALIGN(sizeof(struct xt_multiport_v1)),
 	.help		= &help_v1,
 	.init		= &init,
 	.parse		= &parse_v1,
@@ -469,6 +473,6 @@ static struct iptables_match multiport_v1 = {
 void
 _init(void)
 {
-	register_match(&multiport);
-	register_match(&multiport_v1);
+	xtables_register_match(&multiport);
+	xtables_register_match(&multiport_v1);
 }
diff --git a/include/linux/netfilter/xt_multiport.h b/include/linux/netfilter/xt_multiport.h
new file mode 100644
index 0000000..d49ee41
--- /dev/null
+++ b/include/linux/netfilter/xt_multiport.h
@@ -0,0 +1,30 @@
+#ifndef _XT_MULTIPORT_H
+#define _XT_MULTIPORT_H
+
+enum xt_multiport_flags
+{
+	XT_MULTIPORT_SOURCE,
+	XT_MULTIPORT_DESTINATION,
+	XT_MULTIPORT_EITHER
+};
+
+#define XT_MULTI_PORTS	15
+
+/* Must fit inside union xt_matchinfo: 16 bytes */
+struct xt_multiport
+{
+	u_int8_t flags;				/* Type of comparison */
+	u_int8_t count;				/* Number of ports */
+	u_int16_t ports[XT_MULTI_PORTS];	/* Ports */
+};
+
+struct xt_multiport_v1
+{
+	u_int8_t flags;				/* Type of comparison */
+	u_int8_t count;				/* Number of ports */
+	u_int16_t ports[XT_MULTI_PORTS];	/* Ports */
+	u_int8_t pflags[XT_MULTI_PORTS];	/* Port flags */
+	u_int8_t invert;			/* Invert flag */
+};
+
+#endif /*_XT_MULTIPORT_H*/
-- 
1.5.2.2
