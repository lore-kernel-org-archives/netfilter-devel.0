From: Pablo Neira <pablo@eurodev.net>
Subject: [PATCH] convert mport to multiport
Date: Mon, 27 Sep 2004 00:55:36 +0200
Sender: netfilter-devel-bounces@lists.netfilter.org
Message-ID: <415748E8.60000@eurodev.net>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="------------090402050205040708080300"
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>,
	Patrick McHardy <kaber@trash.net>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: </pipermail/netfilter-devel>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
Errors-To: netfilter-devel-bounces@lists.netfilter.org
List-Id: netfilter-devel.vger.kernel.org

This is a multi-part message in MIME format.
--------------090402050205040708080300
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

Hi Patrick,

Attached a patch that puts mport and multiport together. It applies to 
latest bk snapshot.

I've also added some clean ups like the use of  a count var inside the 
ipt_multiport instead of using 65535 and the pflag set to mark the end 
of the array of ports. I've tested and it works fine for me.

Also attached the patch for iptables and man page. If missing something, 
please let me know.

regards,
Pablo

--------------090402050205040708080300
Content-Type: text/x-patch;
 name="mport2multiport-pablo.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="mport2multiport-pablo.patch"

===== net/ipv4/netfilter/ipt_multiport.c 1.8 vs edited =====
--- 1.8/net/ipv4/netfilter/ipt_multiport.c	Thu Aug 19 02:14:53 2004
+++ edited/net/ipv4/netfilter/ipt_multiport.c	Sun Sep 26 00:22:25 2004
@@ -29,18 +29,38 @@
 
 /* Returns 1 if the port is matched by the test, 0 otherwise. */
 static inline int
-ports_match(const u_int16_t *portlist, enum ipt_multiport_flags flags,
-	    u_int8_t count, u_int16_t src, u_int16_t dst)
+ports_match(const struct ipt_multiport *minfo, u_int16_t src, u_int16_t dst)
 {
-	unsigned int i;
-	for (i=0; i<count; i++) {
-		if (flags != IPT_MULTIPORT_DESTINATION
-		    && portlist[i] == src)
-			return 1;
-
-		if (flags != IPT_MULTIPORT_SOURCE
-		    && portlist[i] == dst)
-			return 1;
+	unsigned int i, m;
+	u_int16_t pflags = minfo->pflags;
+	u_int8_t count = minfo->count;
+	u_int16_t s, e;
+
+	for (i=0, m=1; i < count; i++, m<<=1) {
+		s = minfo->ports[i];
+
+		if (pflags & m) {
+			/* range port matching */
+			e = minfo->ports[++i];
+			m <<= 1;
+			duprintf("src or dst matches with %d-%d?\n", s, e);
+
+			if (minfo->flags & IPT_MULTIPORT_SOURCE
+			    && src >= s && src <= e)
+				return 1;
+			if (minfo->flags & IPT_MULTIPORT_DESTINATION
+			    && dst >= s && dst <= e)
+				return 1;
+		} else {
+			/* exact port matching */
+			duprintf("src or dst matches with %d?\n", s);
+			if (minfo->flags & IPT_MULTIPORT_SOURCE
+			    && src == s)
+				return 1;
+			if (minfo->flags & IPT_MULTIPORT_DESTINATION
+			    && dst == s)
+				return 1;
+		}
 	}
 
 	return 0;
@@ -69,15 +89,11 @@
 		/* We've been asked to examine this packet, and we
 		 * can't.  Hence, no choice but to drop.
 		 */
-		duprintf("ipt_multiport:"
-			 " Dropping evil offset=0 tinygram.\n");
+		duprintf("ipt_multiport: Dropping evil offset=0 tinygram.\n");
 		*hotdrop = 1;
 		return 0;
 	}
-
-	return ports_match(multiinfo->ports,
-			   multiinfo->flags, multiinfo->count,
-			   ntohs(pptr[0]), ntohs(pptr[1]));
+	return ports_match(multiinfo, ntohs(pptr[0]), ntohs(pptr[1]));
 }
 
 /* Called when user tries to insert an entry of this type. */
@@ -89,9 +105,6 @@
 	   unsigned int hook_mask)
 {
 	const struct ipt_multiport *multiinfo = matchinfo;
-
-	if (matchsize != IPT_ALIGN(sizeof(struct ipt_multiport)))
-		return 0;
 
 	/* Must specify proto == TCP/UDP, no unknown flags or bad count */
 	return (ip->proto == IPPROTO_TCP || ip->proto == IPPROTO_UDP)
===== include/linux/netfilter_ipv4/ipt_multiport.h 1.1 vs edited =====
--- 1.1/include/linux/netfilter_ipv4/ipt_multiport.h	Tue Feb  5 18:39:43 2002
+++ edited/include/linux/netfilter_ipv4/ipt_multiport.h	Sun Sep 26 00:23:48 2004
@@ -2,20 +2,30 @@
 #define _IPT_MULTIPORT_H
 #include <linux/netfilter_ipv4/ip_tables.h>
 
-enum ipt_multiport_flags
-{
-	IPT_MULTIPORT_SOURCE,
-	IPT_MULTIPORT_DESTINATION,
-	IPT_MULTIPORT_EITHER
+enum ipt_multiport_flags {
+	IPT_MULTIPORT_SOURCE_BIT = 0,
+	IPT_MULTIPORT_SOURCE = (1 << IPT_MULTIPORT_SOURCE_BIT),
+	
+	IPT_MULTIPORT_DESTINATION_BIT = 1,
+	IPT_MULTIPORT_DESTINATION = (1 << IPT_MULTIPORT_DESTINATION_BIT),
+
+	IPT_MULTIPORT_EITHER = IPT_MULTIPORT_SOURCE|IPT_MULTIPORT_DESTINATION,
 };
 
 #define IPT_MULTI_PORTS	15
 
-/* Must fit inside union ipt_matchinfo: 16 bytes */
+/* Must fit inside union ipt_matchinfo: 32 bytes */
+/* every entry in ports[] except for the last one has one bit in pflags
+ * associated with it. If this bit is set, the port is the first port of
+ * a portrange, with the next entry being the last.
+ * End of list is marked with pflags bit set and port=65535.
+ * If 14 ports are used (last one does not have a pflag), the last port
+ * is repeated to fill the last entry in ports[] */
 struct ipt_multiport
 {
-	u_int8_t flags;				/* Type of comparison */
-	u_int8_t count;				/* Number of ports */
+	u_int8_t flags:2;			/* Type of comparison */
+	u_int16_t pflags:14;			/* Port flags */
 	u_int16_t ports[IPT_MULTI_PORTS];	/* Ports */
+	u_int8_t count;                         /* Number of ports */
 };
 #endif /*_IPT_MULTIPORT_H*/

--------------090402050205040708080300
Content-Type: text/x-patch;
 name="iptables-mport2multiport.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="iptables-mport2multiport.patch"

Index: extensions/libipt_multiport.c
===================================================================
RCS file: /cvspublic/iptables/extensions/libipt_multiport.c,v
retrieving revision 1.8
diff -u -r1.8 libipt_multiport.c
--- extensions/libipt_multiport.c	18 Sep 2004 17:43:36 -0000	1.8
+++ extensions/libipt_multiport.c	26 Sep 2004 22:15:59 -0000
@@ -13,13 +13,13 @@
 {
 	printf(
 "multiport v%s options:\n"
-" --source-ports port[,port,port...]\n"
+" --source-ports port[,port:port,port...]\n"
 " --sports ...\n"
 "				match source port(s)\n"
-" --destination-ports port[,port,port...]\n"
+" --destination-ports port[,port:port,port...]\n"
 " --dports ...\n"
 "				match destination port(s)\n"
-" --ports port[,port,port]\n"
+" --ports port[,port:port,port]\n"
 "				match both source and destination port(s)\n",
 IPTABLES_VERSION);
 }
@@ -57,24 +57,42 @@
 		   "invalid port/service `%s' specified", port);
 }
 
-static unsigned int
-parse_multi_ports(const char *portstring, u_int16_t *ports, const char *proto)
+static void
+parse_multi_ports(const char *portstring, struct ipt_multiport *multiinfo,
+                  const char *proto)
 {
-	char *buffer, *cp, *next;
+	char *buffer, *cp, *next, *range;
 	unsigned int i;
+	u_int16_t m;
 
 	buffer = strdup(portstring);
-	if (!buffer) exit_error(OTHER_PROBLEM, "strdup failed");
+	if (!buffer) exit_error(OTHER_PROBLEM, "strdup failed: OOM");
+
+	multiinfo->pflags = 0;
 
-	for (cp=buffer, i=0; cp && i<IPT_MULTI_PORTS; cp=next,i++)
-	{
+	for (cp=buffer, i=0, m=1; cp && i<IPT_MULTI_PORTS; cp=next,i++,m<<=1) {
 		next=strchr(cp, ',');
 		if (next) *next++='\0';
-		ports[i] = parse_port(cp, proto);
+		range = strchr(cp, ':');
+		if (range) {
+			if (i == IPT_MULTI_PORTS-1)
+				exit_error(PARAMETER_PROBLEM,
+					   "too many ports specified");
+			*range++ = '\0';
+		}
+		multiinfo->ports[i] = parse_port(cp, proto);
+		if (range) {
+			multiinfo->pflags |= m;
+			multiinfo->ports[++i] = parse_port(range, proto);
+			if (multiinfo->ports[i-1] >= multiinfo->ports[i])
+				exit_error(PARAMETER_PROBLEM,
+					   "invalid portrange specified");
+			m <<= 1;
+                }
 	}
+	multiinfo->count = i;
 	if (cp) exit_error(PARAMETER_PROBLEM, "too many ports specified");
 	free(buffer);
-	return i;
 }
 
 /* Initialize the match. */
@@ -114,8 +132,7 @@
 	case '1':
 		check_inverse(argv[optind-1], &invert, &optind, 0);
 		proto = check_proto(entry);
-		multiinfo->count = parse_multi_ports(argv[optind-1],
-						     multiinfo->ports, proto);
+		parse_multi_ports(argv[optind-1], multiinfo, proto);
 		multiinfo->flags = IPT_MULTIPORT_SOURCE;
 		*nfcache |= NFC_IP_SRC_PT;
 		break;
@@ -123,8 +140,7 @@
 	case '2':
 		check_inverse(argv[optind-1], &invert, &optind, 0);
 		proto = check_proto(entry);
-		multiinfo->count = parse_multi_ports(argv[optind-1],
-						     multiinfo->ports, proto);
+		parse_multi_ports(argv[optind-1], multiinfo, proto);
 		multiinfo->flags = IPT_MULTIPORT_DESTINATION;
 		*nfcache |= NFC_IP_DST_PT;
 		break;
@@ -132,8 +148,7 @@
 	case '3':
 		check_inverse(argv[optind-1], &invert, &optind, 0);
 		proto = check_proto(entry);
-		multiinfo->count = parse_multi_ports(argv[optind-1],
-						     multiinfo->ports, proto);
+		parse_multi_ports(argv[optind-1], multiinfo, proto);
 		multiinfo->flags = IPT_MULTIPORT_EITHER;
 		*nfcache |= NFC_IP_SRC_PT | NFC_IP_DST_PT;
 		break;
@@ -146,6 +161,10 @@
 		exit_error(PARAMETER_PROBLEM,
 			   "multiport does not support invert");
 
+	if (invert)
+		exit_error(PARAMETER_PROBLEM,
+			   "multiport does not support invert");
+
 	if (*flags)
 		exit_error(PARAMETER_PROBLEM,
 			   "multiport can only have one option");
@@ -158,7 +177,7 @@
 final_check(unsigned int flags)
 {
 	if (!flags)
-		exit_error(PARAMETER_PROBLEM, "multiport expection an option");
+		exit_error(PARAMETER_PROBLEM, "multiport expects an option");
 }
 
 static char *
@@ -193,6 +212,7 @@
 	const struct ipt_multiport *multiinfo
 		= (const struct ipt_multiport *)match->data;
 	unsigned int i;
+	u_int16_t pflags = multiinfo->pflags;
 
 	printf("multiport ");
 
@@ -217,6 +237,10 @@
 	for (i=0; i < multiinfo->count; i++) {
 		printf("%s", i ? "," : "");
 		print_port(multiinfo->ports[i], ip->proto, numeric);
+		if (pflags & (1<<i)) {
+			printf(":");
+			print_port(multiinfo->ports[++i], ip->proto, numeric);
+		}
 	}
 	printf(" ");
 }
@@ -227,6 +251,7 @@
 	const struct ipt_multiport *multiinfo
 		= (const struct ipt_multiport *)match->data;
 	unsigned int i;
+	u_int16_t pflags = multiinfo->pflags;
 
 	switch (multiinfo->flags) {
 	case IPT_MULTIPORT_SOURCE:
@@ -245,6 +270,10 @@
 	for (i=0; i < multiinfo->count; i++) {
 		printf("%s", i ? "," : "");
 		print_port(multiinfo->ports[i], ip->proto, 1);
+                if (pflags & (1<<i)) {
+                        printf(":");
+                        print_port(multiinfo->ports[++i], ip->proto, 1);
+                }
 	}
 	printf(" ");
 }

--------------090402050205040708080300
Content-Type: text/x-patch;
 name="iptables-mport2multiport-man.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="iptables-mport2multiport-man.patch"

Index: extensions/libipt_multiport.man
===================================================================
RCS file: /cvspublic/iptables/extensions/libipt_multiport.man,v
retrieving revision 1.1
diff -u -r1.1 libipt_multiport.man
--- extensions/libipt_multiport.man	22 Jan 2004 15:04:25 -0000	1.1
+++ extensions/libipt_multiport.man	25 Sep 2004 14:50:32 -0000
@@ -4,16 +4,16 @@
 or
 .BR "-p udp" .
 .TP
-.BR "--source-ports " "\fIport\fP[,\fIport\fP[,\fIport\fP...]]"
+.BR "--source-ports " "\fIport\fP[,\fIport:port\fP[,\fIport\fP...]]"
 Match if the source port is one of the given ports.  The flag
 .B --sports
 is a convenient alias for this option.
 .TP
-.BR "--destination-ports " "\fIport\fP[,\fIport\fP[,\fIport\fP...]]"
+.BR "--destination-ports " "\fIport\fP[,\fIport:port\fP[,\fIport\fP...]]"
 Match if the destination port is one of the given ports.  The flag
 .B --dports
 is a convenient alias for this option.
 .TP
-.BR "--ports " "\fIport\fP[,\fIport\fP[,\fIport\fP...]]"
+.BR "--ports " "\fIport\fP[,\fIport:port\fP[,\fIport\fP...]]"
 Match if the both the source and destination ports are equal to each
 other and to one of the given ports.

--------------090402050205040708080300
Content-Type: text/x-patch;
 name="remove-libipt_mport.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="remove-libipt_mport.patch"

Index: extensions/libipt_mport.c
===================================================================
RCS file: /cvspublic/iptables/extensions/libipt_mport.c,v
retrieving revision 1.7
diff -u -r1.7 libipt_mport.c
--- extensions/libipt_mport.c	18 Sep 2004 17:43:36 -0000	1.7
+++ extensions/libipt_mport.c	26 Sep 2004 22:57:42 -0000
@@ -1,314 +0,0 @@
-/* Shared library add-on to iptables to add multiple TCP port support. */
-#include <stdio.h>
-#include <netdb.h>
-#include <string.h>
-#include <stdlib.h>
-#include <getopt.h>
-#include <iptables.h>
-#include <linux/netfilter_ipv4/ipt_mport.h>
-
-/* Function which prints out usage message. */
-static void
-help(void)
-{
-	printf(
-"mport v%s options:\n"
-" --source-ports port[,port:port,port...]\n"
-" --sports ...\n"
-"				match source port(s)\n"
-" --destination-ports port[,port:port,port...]\n"
-" --dports ...\n"
-"				match destination port(s)\n"
-" --ports port[,port:port,port]\n"
-"				match both source and destination port(s)\n",
-IPTABLES_VERSION);
-}
-
-static struct option opts[] = {
-	{ "source-ports", 1, 0, '1' },
-	{ "sports", 1, 0, '1' }, /* synonym */
-	{ "destination-ports", 1, 0, '2' },
-	{ "dports", 1, 0, '2' }, /* synonym */
-	{ "ports", 1, 0, '3' },
-	{0}
-};
-
-static int
-service_to_port(const char *name, const char *proto)
-{
-	struct servent *service;
-
-	if ((service = getservbyname(name, proto)) != NULL)
-		return ntohs((unsigned short) service->s_port);
-
-		return -1;
-}
-
-static u_int16_t
-parse_port(const char *port, const char *proto)
-{
-	unsigned int portnum;
-
-	if (string_to_number(port, 0, 65535, &portnum) != -1 ||
-	    (portnum = service_to_port(port, proto)) != -1)
-		return (u_int16_t)portnum;
-
-	exit_error(PARAMETER_PROBLEM,
-		   "invalid port/service `%s' specified", port);
-}
-
-static void
-parse_multi_ports(const char *portstring, struct ipt_mport *minfo,
-                  const char *proto)
-{
-	char *buffer, *cp, *next, *range;
-	unsigned int i;
-        u_int16_t m;
-
-	buffer = strdup(portstring);
-	if (!buffer) exit_error(OTHER_PROBLEM, "strdup failed");
-
-        minfo->pflags = 0;
-
-	for (cp=buffer, i=0, m=1; cp && i<IPT_MULTI_PORTS; cp=next,i++,m<<=1)
-	{
-		next=strchr(cp, ',');
-		if (next) *next++='\0';
-                range = strchr(cp, ':');
-                if (range) {
-                        if (i == IPT_MULTI_PORTS-1)
-                                exit_error(PARAMETER_PROBLEM,
-                                           "too many ports specified");
-                        *range++ = '\0';
-                }
-		minfo->ports[i] = parse_port(cp, proto);
-                if (range) {
-                        minfo->pflags |= m;
-                        minfo->ports[++i] = parse_port(range, proto);
-                        if (minfo->ports[i-1] >= minfo->ports[i])
-                                exit_error(PARAMETER_PROBLEM,
-                                           "invalid portrange specified");
-                        m <<= 1;
-                }
-	}
-	if (cp) exit_error(PARAMETER_PROBLEM, "too many ports specified");
-        if (i == IPT_MULTI_PORTS-1)
-                minfo->ports[i] = minfo->ports[i-1];
-        else if (i < IPT_MULTI_PORTS-1) {
-                minfo->ports[i] = ~0;
-                minfo->pflags |= 1<<i;
-        }
-	free(buffer);
-}
-
-/* Initialize the match. */
-static void
-init(struct ipt_entry_match *m, unsigned int *nfcache)
-{
-}
-
-static const char *
-check_proto(const struct ipt_entry *entry)
-{
-	if (entry->ip.proto == IPPROTO_TCP)
-		return "tcp";
-	else if (entry->ip.proto == IPPROTO_UDP)
-		return "udp";
-	else if (!entry->ip.proto)
-		exit_error(PARAMETER_PROBLEM,
-			   "multiport needs `-p tcp' or `-p udp'");
-	else
-		exit_error(PARAMETER_PROBLEM,
-			   "multiport only works with TCP or UDP");
-}
-
-/* Function which parses command options; returns true if it
-   ate an option */
-static int
-parse(int c, char **argv, int invert, unsigned int *flags,
-      const struct ipt_entry *entry,
-      unsigned int *nfcache,
-      struct ipt_entry_match **match)
-{
-	const char *proto;
-	struct ipt_mport *minfo
-		= (struct ipt_mport *)(*match)->data;
-
-	switch (c) {
-	case '1':
-		check_inverse(argv[optind-1], &invert, &optind, 0);
-		proto = check_proto(entry);
-		parse_multi_ports(argv[optind-1], minfo, proto);
-		minfo->flags = IPT_MPORT_SOURCE;
-		*nfcache |= NFC_IP_SRC_PT;
-		break;
-
-	case '2':
-		check_inverse(argv[optind-1], &invert, &optind, 0);
-		proto = check_proto(entry);
-		parse_multi_ports(argv[optind-1], minfo, proto);
-		minfo->flags = IPT_MPORT_DESTINATION;
-		*nfcache |= NFC_IP_DST_PT;
-		break;
-
-	case '3':
-		check_inverse(argv[optind-1], &invert, &optind, 0);
-		proto = check_proto(entry);
-		parse_multi_ports(argv[optind-1], minfo, proto);
-		minfo->flags = IPT_MPORT_EITHER;
-		*nfcache |= NFC_IP_SRC_PT | NFC_IP_DST_PT;
-		break;
-
-	default:
-		return 0;
-	}
-
-	if (invert)
-		exit_error(PARAMETER_PROBLEM,
-			   "multiport does not support invert");
-
-	if (*flags)
-		exit_error(PARAMETER_PROBLEM,
-			   "multiport can only have one option");
-	*flags = 1;
-	return 1;
-}
-
-/* Final check; must specify something. */
-static void
-final_check(unsigned int flags)
-{
-	if (!flags)
-		exit_error(PARAMETER_PROBLEM, "mport expects an option");
-}
-
-static char *
-port_to_service(int port, u_int8_t proto)
-{
-	struct servent *service;
-
-	if ((service = getservbyport(htons(port),
-				     proto == IPPROTO_TCP ? "tcp" : "udp")))
-		return service->s_name;
-
-	return NULL;
-}
-
-static void
-print_port(u_int16_t port, u_int8_t protocol, int numeric)
-{
-	char *service;
-
-	if (numeric || (service = port_to_service(port, protocol)) == NULL)
-		printf("%u", port);
-	else
-		printf("%s", service);
-}
-
-/* Prints out the matchinfo. */
-static void
-print(const struct ipt_ip *ip,
-      const struct ipt_entry_match *match,
-      int numeric)
-{
-	const struct ipt_mport *minfo
-		= (const struct ipt_mport *)match->data;
-	unsigned int i;
-        u_int16_t pflags = minfo->pflags;
-
-	printf("mport ");
-
-	switch (minfo->flags) {
-	case IPT_MPORT_SOURCE:
-		printf("sports ");
-		break;
-
-	case IPT_MPORT_DESTINATION:
-		printf("dports ");
-		break;
-
-	case IPT_MPORT_EITHER:
-		printf("ports ");
-		break;
-
-	default:
-		printf("ERROR ");
-		break;
-	}
-
-	for (i=0; i < IPT_MULTI_PORTS; i++) {
-                if (pflags & (1<<i)
-                    && minfo->ports[i] == 65535)
-                        break;
-                if (i == IPT_MULTI_PORTS-1
-                    && minfo->ports[i-1] == minfo->ports[i])
-                        break;
-		printf("%s", i ? "," : "");
-		print_port(minfo->ports[i], ip->proto, numeric);
-                if (pflags & (1<<i)) {
-                        printf(":");
-                        print_port(minfo->ports[++i], ip->proto, numeric);
-                }
-	}
-	printf(" ");
-}
-
-/* Saves the union ipt_matchinfo in parsable form to stdout. */
-static void save(const struct ipt_ip *ip, const struct ipt_entry_match *match)
-{
-	const struct ipt_mport *minfo
-		= (const struct ipt_mport *)match->data;
-	unsigned int i;
-        u_int16_t pflags = minfo->pflags;
-
-	switch (minfo->flags) {
-	case IPT_MPORT_SOURCE:
-		printf("--sports ");
-		break;
-
-	case IPT_MPORT_DESTINATION:
-		printf("--dports ");
-		break;
-
-	case IPT_MPORT_EITHER:
-		printf("--ports ");
-		break;
-	}
-
-	for (i=0; i < IPT_MULTI_PORTS; i++) {
-                if (pflags & (1<<i)
-                    && minfo->ports[i] == 65535)
-                        break;
-                if (i == IPT_MULTI_PORTS-1
-                    && minfo->ports[i-1] == minfo->ports[i])
-                        break;
-		printf("%s", i ? "," : "");
-		print_port(minfo->ports[i], ip->proto, 1);
-                if (pflags & (1<<i)) {
-                        printf(":");
-                        print_port(minfo->ports[++i], ip->proto, 1);
-                }
-	}
-	printf(" ");
-}
-
-struct iptables_match mport
-= { NULL,
-    "mport",
-    IPTABLES_VERSION,
-    IPT_ALIGN(sizeof(struct ipt_mport)),
-    IPT_ALIGN(sizeof(struct ipt_mport)),
-    &help,
-    &init,
-    &parse,
-    &final_check,
-    &print,
-    &save,
-    opts
-};
-
-void
-_init(void)
-{
-	register_match(&mport);
-}
Index: extensions/libipt_mport.man
===================================================================
RCS file: /cvspublic/iptables/extensions/libipt_mport.man,v
retrieving revision 1.1
diff -u -r1.1 libipt_mport.man
--- extensions/libipt_mport.man	22 Jan 2004 15:04:25 -0000	1.1
+++ extensions/libipt_mport.man	26 Sep 2004 22:57:42 -0000
@@ -1,19 +0,0 @@
-This module matches a set of source or destination ports.  Up to 15
-ports can be specified.  It can only be used in conjunction with
-.B "-p tcp"
-or
-.BR "-p udp" .
-.TP
-.BR "--source-ports " "\fIport\fP[,\fIport\fP[,\fIport\fP...]]"
-Match if the source port is one of the given ports.  The flag
-.B --sports
-is a convenient alias for this option.
-.TP
-.BR "--destination-ports " "\fIport\fP[,\fIport\fP[,\fIport\fP...]]"
-Match if the destination port is one of the given ports.  The flag
-.B --dports
-is a convenient alias for this option.
-.TP
-.BR "--ports " "\fIport\fP[,\fIport\fP[,\fIport\fP...]]"
-Match if the both the source and destination ports are equal to each
-other and to one of the given ports.

--------------090402050205040708080300--
