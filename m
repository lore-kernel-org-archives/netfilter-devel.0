From: Pablo Neira <pablo@eurodev.net>
Subject: Re: [PATCH] convert mport to multiport
Date: Mon, 27 Sep 2004 01:37:14 +0200
Sender: netfilter-devel-bounces@lists.netfilter.org
Message-ID: <415752AA.4010904@eurodev.net>
References: <415748E8.60000@eurodev.net> <20040926232738.GB2201@linuxace.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="------------090106010303040303000303"
Cc: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>,
	Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Phil Oester <kernel@linuxace.com>
In-Reply-To: <20040926232738.GB2201@linuxace.com>
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
--------------090106010303040303000303
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit

Hi Phil,

Phil Oester wrote:

>Minor nit:
>
>@@ -146,6 +161,10 @@
>                exit_error(PARAMETER_PROBLEM,
>                           "multiport does not support invert");
>
>+       if (invert)             
>+               exit_error(PARAMETER_PROBLEM,
>+                          "multiport does not support invert");
>+       
>        if (*flags)
>                exit_error(PARAMETER_PROBLEM,
>                           "multiport can only have one option");
>
>this hunk looks redundant.
>  
>

Hm I think that it got there while updating my cvs working copy. Thanks :-)

Attached a new version, if anything else, please let me know.

regards,
Pablo

--------------090106010303040303000303
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
+++ extensions/libipt_multiport.c	26 Sep 2004 23:35:27 -0000
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
@@ -158,7 +173,7 @@
 final_check(unsigned int flags)
 {
 	if (!flags)
-		exit_error(PARAMETER_PROBLEM, "multiport expection an option");
+		exit_error(PARAMETER_PROBLEM, "multiport expects an option");
 }
 
 static char *
@@ -193,6 +208,7 @@
 	const struct ipt_multiport *multiinfo
 		= (const struct ipt_multiport *)match->data;
 	unsigned int i;
+	u_int16_t pflags = multiinfo->pflags;
 
 	printf("multiport ");
 
@@ -217,6 +233,10 @@
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
@@ -227,6 +247,7 @@
 	const struct ipt_multiport *multiinfo
 		= (const struct ipt_multiport *)match->data;
 	unsigned int i;
+	u_int16_t pflags = multiinfo->pflags;
 
 	switch (multiinfo->flags) {
 	case IPT_MULTIPORT_SOURCE:
@@ -245,6 +266,10 @@
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

--------------090106010303040303000303--
