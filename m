From: Pablo Neira <pablo@eurodev.net>
Subject: Re: [PATCH] convert mport to multiport
Date: Mon, 27 Sep 2004 03:29:46 +0200
Sender: netfilter-devel-bounces@lists.netfilter.org
Message-ID: <41576D0A.9080103@eurodev.net>
References: <415748E8.60000@eurodev.net>
	<41574F5E.1020409@eurodev.net>	<41575282.4030006@trash.net>
	<415755BC.8000706@eurodev.net>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="------------080809010409040802060309"
Cc: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>,
	Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Pablo Neira <pablo@eurodev.net>
In-Reply-To: <415755BC.8000706@eurodev.net>
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
--------------080809010409040802060309
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit

Hi Patrick,

Pablo Neira wrote:

> In that case, I have the patches without that change here, I'll test 
> them and then I'll resend them to you again.


Attached the new patches, they respect userspace compatibility. I tested 
them and they work for me.

- Iptables patch is mport version (by Andreas Feber) with some broken 
indentation fixed and a var renamed.
- Kernel patch is mport with flags defined in a different way.

regards,
Pablo

--------------080809010409040802060309
Content-Type: text/x-patch;
 name="mport2multiport.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="mport2multiport.patch"

===== include/linux/netfilter_ipv4/ipt_multiport.h 1.1 vs edited =====
--- 1.1/include/linux/netfilter_ipv4/ipt_multiport.h	Tue Feb  5 18:39:43 2002
+++ edited/include/linux/netfilter_ipv4/ipt_multiport.h	Mon Sep 27 03:11:13 2004
@@ -4,18 +4,28 @@
 
 enum ipt_multiport_flags
 {
-	IPT_MULTIPORT_SOURCE,
-	IPT_MULTIPORT_DESTINATION,
-	IPT_MULTIPORT_EITHER
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
 };
 #endif /*_IPT_MULTIPORT_H*/
===== net/ipv4/netfilter/ipt_multiport.c 1.8 vs edited =====
--- 1.8/net/ipv4/netfilter/ipt_multiport.c	Thu Aug 19 02:14:53 2004
+++ edited/net/ipv4/netfilter/ipt_multiport.c	Mon Sep 27 02:54:46 2004
@@ -29,17 +29,31 @@
 
 /* Returns 1 if the port is matched by the test, 0 otherwise. */
 static inline int
-ports_match(const u_int16_t *portlist, enum ipt_multiport_flags flags,
-	    u_int8_t count, u_int16_t src, u_int16_t dst)
+ports_match(const struct ipt_multiport *minfo, u_int16_t src, u_int16_t dst)
 {
 	unsigned int i;
-	for (i=0; i<count; i++) {
-		if (flags != IPT_MULTIPORT_DESTINATION
-		    && portlist[i] == src)
+	unsigned int m;
+	u_int16_t pflags = minfo->pflags;
+	for (i=0, m=1; i<IPT_MULTI_PORTS; i++, m<<=1) {
+		u_int16_t s, e;
+
+		if ((pflags & m) && minfo->ports[i] == 65535)
+			return 0;
+
+		s = minfo->ports[i];
+
+		if (pflags & m) {
+			e = minfo->ports[++i];
+			m <<= 1;
+		} else
+			e = s;
+
+		if (minfo->flags & IPT_MULTIPORT_SOURCE
+		    && src >= s && src <= e)
 			return 1;
 
-		if (flags != IPT_MULTIPORT_SOURCE
-		    && portlist[i] == dst)
+		if (minfo->flags & IPT_MULTIPORT_DESTINATION
+		    && dst >= s && dst <= e)
 			return 1;
 	}
 
@@ -69,15 +83,12 @@
 		/* We've been asked to examine this packet, and we
 		 * can't.  Hence, no choice but to drop.
 		 */
-		duprintf("ipt_multiport:"
-			 " Dropping evil offset=0 tinygram.\n");
+		duprintf("ipt_multiport: Dropping evil offset=0 tinygram.\n");
 		*hotdrop = 1;
 		return 0;
 	}
 
-	return ports_match(multiinfo->ports,
-			   multiinfo->flags, multiinfo->count,
-			   ntohs(pptr[0]), ntohs(pptr[1]));
+	return ports_match(multiinfo, ntohs(pptr[0]), ntohs(pptr[1]));
 }
 
 /* Called when user tries to insert an entry of this type. */
@@ -90,17 +101,13 @@
 {
 	const struct ipt_multiport *multiinfo = matchinfo;
 
-	if (matchsize != IPT_ALIGN(sizeof(struct ipt_multiport)))
-		return 0;
-
 	/* Must specify proto == TCP/UDP, no unknown flags or bad count */
 	return (ip->proto == IPPROTO_TCP || ip->proto == IPPROTO_UDP)
 		&& !(ip->invflags & IPT_INV_PROTO)
 		&& matchsize == IPT_ALIGN(sizeof(struct ipt_multiport))
 		&& (multiinfo->flags == IPT_MULTIPORT_SOURCE
 		    || multiinfo->flags == IPT_MULTIPORT_DESTINATION
-		    || multiinfo->flags == IPT_MULTIPORT_EITHER)
-		&& multiinfo->count <= IPT_MULTI_PORTS;
+		    || multiinfo->flags == IPT_MULTIPORT_EITHER);
 }
 
 static struct ipt_match multiport_match = {

--------------080809010409040802060309
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
+++ extensions/libipt_multiport.c	27 Sep 2004 01:02:37 -0000
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
@@ -57,24 +57,47 @@
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
 	if (!buffer) exit_error(OTHER_PROBLEM, "strdup failed");
 
-	for (cp=buffer, i=0; cp && i<IPT_MULTI_PORTS; cp=next,i++)
-	{
+	multiinfo->pflags = 0;
+
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
+		}
 	}
 	if (cp) exit_error(PARAMETER_PROBLEM, "too many ports specified");
+	if (i == IPT_MULTI_PORTS-1)
+		multiinfo->ports[i] = multiinfo->ports[i-1];
+	else if (i < IPT_MULTI_PORTS-1) {
+		multiinfo->ports[i] = ~0;
+		multiinfo->pflags |= 1<<i;
+	}
 	free(buffer);
-	return i;
 }
 
 /* Initialize the match. */
@@ -114,8 +137,7 @@
 	case '1':
 		check_inverse(argv[optind-1], &invert, &optind, 0);
 		proto = check_proto(entry);
-		multiinfo->count = parse_multi_ports(argv[optind-1],
-						     multiinfo->ports, proto);
+		parse_multi_ports(argv[optind-1], multiinfo, proto);
 		multiinfo->flags = IPT_MULTIPORT_SOURCE;
 		*nfcache |= NFC_IP_SRC_PT;
 		break;
@@ -123,8 +145,7 @@
 	case '2':
 		check_inverse(argv[optind-1], &invert, &optind, 0);
 		proto = check_proto(entry);
-		multiinfo->count = parse_multi_ports(argv[optind-1],
-						     multiinfo->ports, proto);
+		parse_multi_ports(argv[optind-1], multiinfo, proto);
 		multiinfo->flags = IPT_MULTIPORT_DESTINATION;
 		*nfcache |= NFC_IP_DST_PT;
 		break;
@@ -132,8 +153,7 @@
 	case '3':
 		check_inverse(argv[optind-1], &invert, &optind, 0);
 		proto = check_proto(entry);
-		multiinfo->count = parse_multi_ports(argv[optind-1],
-						     multiinfo->ports, proto);
+		parse_multi_ports(argv[optind-1], multiinfo, proto);
 		multiinfo->flags = IPT_MULTIPORT_EITHER;
 		*nfcache |= NFC_IP_SRC_PT | NFC_IP_DST_PT;
 		break;
@@ -158,7 +178,7 @@
 final_check(unsigned int flags)
 {
 	if (!flags)
-		exit_error(PARAMETER_PROBLEM, "multiport expection an option");
+		exit_error(PARAMETER_PROBLEM, "multiport expects an option");
 }
 
 static char *
@@ -193,6 +213,7 @@
 	const struct ipt_multiport *multiinfo
 		= (const struct ipt_multiport *)match->data;
 	unsigned int i;
+	u_int16_t pflags = multiinfo->pflags;
 
 	printf("multiport ");
 
@@ -214,9 +235,19 @@
 		break;
 	}
 
-	for (i=0; i < multiinfo->count; i++) {
+	for (i=0; i < IPT_MULTI_PORTS; i++) {
+		if (pflags & (1<<i)
+		    && multiinfo->ports[i] == 65535)
+			break;
+		if (i == IPT_MULTI_PORTS-1
+		    && multiinfo->ports[i-1] == multiinfo->ports[i])
+			break;
 		printf("%s", i ? "," : "");
 		print_port(multiinfo->ports[i], ip->proto, numeric);
+		if (pflags & (1<<i)) {
+			printf(":");
+			print_port(multiinfo->ports[++i], ip->proto, numeric);
+		}
 	}
 	printf(" ");
 }
@@ -227,6 +258,7 @@
 	const struct ipt_multiport *multiinfo
 		= (const struct ipt_multiport *)match->data;
 	unsigned int i;
+	u_int16_t pflags = multiinfo->pflags;
 
 	switch (multiinfo->flags) {
 	case IPT_MULTIPORT_SOURCE:
@@ -242,9 +274,19 @@
 		break;
 	}
 
-	for (i=0; i < multiinfo->count; i++) {
+	for (i=0; i < IPT_MULTI_PORTS; i++) {
+		if (pflags & (1<<i)
+		    && multiinfo->ports[i] == 65535)
+			break;
+		if (i == IPT_MULTI_PORTS-1
+		    && multiinfo->ports[i-1] == multiinfo->ports[i])
+			break;
 		printf("%s", i ? "," : "");
 		print_port(multiinfo->ports[i], ip->proto, 1);
+		if (pflags & (1<<i)) {
+			printf(":");
+			print_port(multiinfo->ports[++i], ip->proto, 1);
+		}
 	}
 	printf(" ");
 }

--------------080809010409040802060309--
