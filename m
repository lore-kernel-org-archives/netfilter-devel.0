From: Pablo Neira <pablo@eurodev.net>
Subject: [PATCH] kill NFC_* stuff in iptables [was Re: iptables compile
 error: NFC_IP_TOS undeclared]
Date: Fri, 11 Feb 2005 00:16:06 +0100
Message-ID: <420BEB36.7080209@eurodev.net>
References: <Pine.GSO.4.33.0502101758010.19216-100000@indigo>	<420B8623.9050308@niksula.hut.fi>
	<420B9ED0.1020303@trash.net>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="------------030402020100080704030000"
Cc: netfilter-devel@lists.netfilter.org
To: Patrick McHardy <kaber@trash.net>
In-Reply-To: <420B9ED0.1020303@trash.net>
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
--------------030402020100080704030000
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

Hi Patrick,

Patrick McHardy wrote:

> Jonas Berlin wrote:
>
>> Alexander Piavka wrote:
>>
>>>
>>> actually there is no match from  NFC_IP_TOS in the whole
>>> /usr/src/linux-2.6.10-ct_sync-rc1/include subtree
>>>  
>>>
>> Ok, I'm not that familiar with different kernel versions, but my 
>> 2.6.10 at least has that one. Could it be that the ct_sync patch 
>> takes it away? Do you have ct_sync as a patch or did you get the 
>> kernel pre-patched?
>
>
> Yes, it reuses the bits to record state changes. The nfcache bits
> don't affect any functionality, just define it to anything you want
> or remove it.


I've renamed all NFC_* stuff != NFC_UNKNOWN to NFC_UNKNOWN. So people 
using ct_sync won't complain about this again. I see this as a first 
step to remove the old behaviour of nfcache. Please, see the patch attached.

--
Pablo

--------------030402020100080704030000
Content-Type: text/x-patch;
 name="kill-NFC.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="kill-NFC.patch"

Index: iptables.c
===================================================================
--- iptables.c	(revision 3656)
+++ iptables.c	(working copy)
@@ -1987,7 +1987,7 @@
 			    && (fw.ip.invflags & IPT_INV_PROTO))
 				exit_error(PARAMETER_PROBLEM,
 					   "rule would never match protocol");
-			fw.nfcache |= NFC_IP_PROTO;
+			fw.nfcache |= NFC_UNKNOWN;
 			break;
 
 		case 's':
@@ -1995,7 +1995,7 @@
 			set_option(&options, OPT_SOURCE, &fw.ip.invflags,
 				   invert);
 			shostnetworkmask = argv[optind-1];
-			fw.nfcache |= NFC_IP_SRC;
+			fw.nfcache |= NFC_UNKNOWN;
 			break;
 
 		case 'd':
@@ -2003,7 +2003,7 @@
 			set_option(&options, OPT_DESTINATION, &fw.ip.invflags,
 				   invert);
 			dhostnetworkmask = argv[optind-1];
-			fw.nfcache |= NFC_IP_DST;
+			fw.nfcache |= NFC_UNKNOWN;
 			break;
 
 		case 'j':
@@ -2037,7 +2037,7 @@
 			parse_interface(argv[optind-1],
 					fw.ip.iniface,
 					fw.ip.iniface_mask);
-			fw.nfcache |= NFC_IP_IF_IN;
+			fw.nfcache |= NFC_UNKNOWN;
 			break;
 
 		case 'o':
@@ -2047,14 +2047,14 @@
 			parse_interface(argv[optind-1],
 					fw.ip.outiface,
 					fw.ip.outiface_mask);
-			fw.nfcache |= NFC_IP_IF_OUT;
+			fw.nfcache |= NFC_UNKNOWN;
 			break;
 
 		case 'f':
 			set_option(&options, OPT_FRAGMENT, &fw.ip.invflags,
 				   invert);
 			fw.ip.flags |= IPT_F_FRAG;
-			fw.nfcache |= NFC_IP_FRAG;
+			fw.nfcache |= NFC_UNKNOWN; 
 			break;
 
 		case 'v':
Index: libiptc/libip4tc.c
===================================================================
--- libiptc/libip4tc.c	(revision 3656)
+++ libiptc/libip4tc.c	(working copy)
@@ -149,17 +149,6 @@
 	printf("Cache: %08X ", e->nfcache);
 	if (e->nfcache & NFC_ALTERED) printf("ALTERED ");
 	if (e->nfcache & NFC_UNKNOWN) printf("UNKNOWN ");
-	if (e->nfcache & NFC_IP_SRC) printf("IP_SRC ");
-	if (e->nfcache & NFC_IP_DST) printf("IP_DST ");
-	if (e->nfcache & NFC_IP_IF_IN) printf("IP_IF_IN ");
-	if (e->nfcache & NFC_IP_IF_OUT) printf("IP_IF_OUT ");
-	if (e->nfcache & NFC_IP_TOS) printf("IP_TOS ");
-	if (e->nfcache & NFC_IP_PROTO) printf("IP_PROTO ");
-	if (e->nfcache & NFC_IP_OPTIONS) printf("IP_OPTIONS ");
-	if (e->nfcache & NFC_IP_TCPFLAGS) printf("IP_TCPFLAGS ");
-	if (e->nfcache & NFC_IP_SRC_PT) printf("IP_SRC_PT ");
-	if (e->nfcache & NFC_IP_DST_PT) printf("IP_DST_PT ");
-	if (e->nfcache & NFC_IP_PROTO_UNKNOWN) printf("IP_PROTO_UNKNOWN ");
 	printf("\n");
 
 	IPT_MATCH_ITERATE(e, print_match);
Index: libiptc/libip6tc.c
===================================================================
--- libiptc/libip6tc.c	(revision 3656)
+++ libiptc/libip6tc.c	(working copy)
@@ -180,17 +180,6 @@
 	printf("Cache: %08X ", e->nfcache);
 	if (e->nfcache & NFC_ALTERED) printf("ALTERED ");
 	if (e->nfcache & NFC_UNKNOWN) printf("UNKNOWN ");
-	if (e->nfcache & NFC_IP6_SRC) printf("IP6_SRC ");
-	if (e->nfcache & NFC_IP6_DST) printf("IP6_DST ");
-	if (e->nfcache & NFC_IP6_IF_IN) printf("IP6_IF_IN ");
-	if (e->nfcache & NFC_IP6_IF_OUT) printf("IP6_IF_OUT ");
-	if (e->nfcache & NFC_IP6_TOS) printf("IP6_TOS ");
-	if (e->nfcache & NFC_IP6_PROTO) printf("IP6_PROTO ");
-	if (e->nfcache & NFC_IP6_OPTIONS) printf("IP6_OPTIONS ");
-	if (e->nfcache & NFC_IP6_TCPFLAGS) printf("IP6_TCPFLAGS ");
-	if (e->nfcache & NFC_IP6_SRC_PT) printf("IP6_SRC_PT ");
-	if (e->nfcache & NFC_IP6_DST_PT) printf("IP6_DST_PT ");
-	if (e->nfcache & NFC_IP6_PROTO_UNKNOWN) printf("IP6_PROTO_UNKNOWN ");
 	printf("\n");
 	
 	IP6T_MATCH_ITERATE(e, print_match);
Index: extensions/libip6t_multiport.c
===================================================================
--- extensions/libip6t_multiport.c	(revision 3656)
+++ extensions/libip6t_multiport.c	(working copy)
@@ -117,7 +117,7 @@
 		multiinfo->count = parse_multi_ports(argv[optind-1],
 						     multiinfo->ports, proto);
 		multiinfo->flags = IP6T_MULTIPORT_SOURCE;
-		*nfcache |= NFC_IP6_SRC_PT;
+		*nfcache |= NFC_UNKNOWN;
 		break;
 
 	case '2':
@@ -126,7 +126,7 @@
 		multiinfo->count = parse_multi_ports(argv[optind-1],
 						     multiinfo->ports, proto);
 		multiinfo->flags = IP6T_MULTIPORT_DESTINATION;
-		*nfcache |= NFC_IP6_DST_PT;
+		*nfcache |= NFC_UNKNOWN;
 		break;
 
 	case '3':
@@ -135,7 +135,7 @@
 		multiinfo->count = parse_multi_ports(argv[optind-1],
 						     multiinfo->ports, proto);
 		multiinfo->flags = IP6T_MULTIPORT_EITHER;
-		*nfcache |= NFC_IP6_SRC_PT | NFC_IP6_DST_PT;
+		*nfcache |= NFC_UNKNOWN;
 		break;
 
 	default:
Index: extensions/libipt_multiport.c
===================================================================
--- extensions/libipt_multiport.c	(revision 3656)
+++ extensions/libipt_multiport.c	(working copy)
@@ -179,7 +179,7 @@
 		multiinfo->count = parse_multi_ports(argv[optind-1],
 						     multiinfo->ports, proto);
 		multiinfo->flags = IPT_MULTIPORT_SOURCE;
-		*nfcache |= NFC_IP_SRC_PT;
+		*nfcache |= NFC_UNKNOWN;
 		break;
 
 	case '2':
@@ -188,7 +188,7 @@
 		multiinfo->count = parse_multi_ports(argv[optind-1],
 						     multiinfo->ports, proto);
 		multiinfo->flags = IPT_MULTIPORT_DESTINATION;
-		*nfcache |= NFC_IP_DST_PT;
+		*nfcache |= NFC_UNKNOWN;
 		break;
 
 	case '3':
@@ -197,7 +197,7 @@
 		multiinfo->count = parse_multi_ports(argv[optind-1],
 						     multiinfo->ports, proto);
 		multiinfo->flags = IPT_MULTIPORT_EITHER;
-		*nfcache |= NFC_IP_SRC_PT | NFC_IP_DST_PT;
+		*nfcache |= NFC_UNKNOWN;
 		break;
 
 	default:
@@ -231,7 +231,7 @@
 		proto = check_proto(entry);
 		parse_multi_ports_v1(argv[optind-1], multiinfo, proto);
 		multiinfo->flags = IPT_MULTIPORT_SOURCE;
-		*nfcache |= NFC_IP_SRC_PT;
+		*nfcache |= NFC_UNKNOWN;
 		break;
 
 	case '2':
@@ -239,7 +239,7 @@
 		proto = check_proto(entry);
 		parse_multi_ports_v1(argv[optind-1], multiinfo, proto);
 		multiinfo->flags = IPT_MULTIPORT_DESTINATION;
-		*nfcache |= NFC_IP_DST_PT;
+		*nfcache |= NFC_UNKNOWN;
 		break;
 
 	case '3':
@@ -247,7 +247,7 @@
 		proto = check_proto(entry);
 		parse_multi_ports_v1(argv[optind-1], multiinfo, proto);
 		multiinfo->flags = IPT_MULTIPORT_EITHER;
-		*nfcache |= NFC_IP_SRC_PT | NFC_IP_DST_PT;
+		*nfcache |= NFC_UNKNOWN;
 		break;
 
 	default:
Index: extensions/libipt_tos.c
===================================================================
--- extensions/libipt_tos.c	(revision 3656)
+++ extensions/libipt_tos.c	(working copy)
@@ -51,7 +51,7 @@
 static void
 init(struct ipt_entry_match *m, unsigned int *nfcache)
 {
-	*nfcache |= NFC_IP_TOS;
+	*nfcache |= NFC_UNKNOWN;
 }
 
 static void
Index: extensions/libipt_TCPLAG.c
===================================================================
--- extensions/libipt_TCPLAG.c	(revision 3656)
+++ extensions/libipt_TCPLAG.c	(working copy)
@@ -70,18 +70,6 @@
  * our own private data structure (which is at t->data).
  * Probably we could fiddle with t->tflags too but there is
  * no great advantage in doing so.
- * 
- * TODO: Find documentation for the above flags which
- *       can be ored into nfcache...
- *
- * NFC_IP6_DST_PT
- * NFC_IP6_PROTO_UNKNOWN
- * NFC_IP6_SRC_PT
- * NFC_IP6_TCPFLAGS
- * NFC_IP_DST_PT
- * NFC_IP_SRC_PT
- * NFC_IP_TOS
- * NFC_UNKNOWN             -- This one seems safest
  */
 static void init( struct ipt_entry_target *t, unsigned int *nfcache )
 {
Index: extensions/libip6t_udp.c
===================================================================
--- extensions/libip6t_udp.c	(revision 3656)
+++ extensions/libip6t_udp.c	(working copy)
@@ -109,7 +109,7 @@
 		if (invert)
 			udpinfo->invflags |= IP6T_UDP_INV_SRCPT;
 		*flags |= UDP_SRC_PORTS;
-		*nfcache |= NFC_IP6_SRC_PT;
+		*nfcache |= NFC_UNKNOWN;
 		break;
 
 	case '2':
@@ -121,7 +121,7 @@
 		if (invert)
 			udpinfo->invflags |= IP6T_UDP_INV_DSTPT;
 		*flags |= UDP_DST_PORTS;
-		*nfcache |= NFC_IP6_DST_PT;
+		*nfcache |= NFC_UNKNOWN;
 		break;
 
 	default:
Index: extensions/libipt_tcpmss.c
===================================================================
--- extensions/libipt_tcpmss.c	(revision 3656)
+++ extensions/libipt_tcpmss.c	(working copy)
@@ -28,7 +28,7 @@
 static void
 init(struct ipt_entry_match *m, unsigned int *nfcache)
 {
-	*nfcache |= NFC_IP_PROTO_UNKNOWN;
+	*nfcache |= NFC_UNKNOWN;
 }
 
 static u_int16_t
Index: extensions/libip6t_tcp.c
===================================================================
--- extensions/libip6t_tcp.c	(revision 3656)
+++ extensions/libip6t_tcp.c	(working copy)
@@ -187,7 +187,7 @@
 		if (invert)
 			tcpinfo->invflags |= IP6T_TCP_INV_SRCPT;
 		*flags |= TCP_SRC_PORTS;
-		*nfcache |= NFC_IP6_SRC_PT;
+		*nfcache |= NFC_UNKNOWN;
 		break;
 
 	case '2':
@@ -199,7 +199,7 @@
 		if (invert)
 			tcpinfo->invflags |= IP6T_TCP_INV_DSTPT;
 		*flags |= TCP_DST_PORTS;
-		*nfcache |= NFC_IP6_DST_PT;
+		*nfcache |= NFC_UNKNOWN;
 		break;
 
 	case '3':
@@ -209,7 +209,7 @@
 				   " allowed");
 		parse_tcp_flags(tcpinfo, "SYN,RST,ACK", "SYN", invert);
 		*flags |= TCP_FLAGS;
-		*nfcache |= NFC_IP6_TCPFLAGS;
+		*nfcache |= NFC_UNKNOWN;
 		break;
 
 	case '4':
@@ -228,7 +228,7 @@
 				invert);
 		optind++;
 		*flags |= TCP_FLAGS;
-		*nfcache |= NFC_IP6_TCPFLAGS;
+		*nfcache |= NFC_UNKNOWN;
 		break;
 
 	case '5':
@@ -240,7 +240,7 @@
 		if (invert)
 			tcpinfo->invflags |= IP6T_TCP_INV_OPTION;
 		*flags |= TCP_OPTION;
-		*nfcache |= NFC_IP6_PROTO_UNKNOWN;
+		*nfcache |= NFC_UNKNOWN;
 		break;
 
 	default:
Index: extensions/libipt_mport.c
===================================================================
--- extensions/libipt_mport.c	(revision 3656)
+++ extensions/libipt_mport.c	(working copy)
@@ -140,7 +140,7 @@
 		proto = check_proto(entry);
 		parse_multi_ports(argv[optind-1], minfo, proto);
 		minfo->flags = IPT_MPORT_SOURCE;
-		*nfcache |= NFC_IP_SRC_PT;
+		*nfcache |= NFC_UNKNOWN;
 		break;
 
 	case '2':
@@ -148,7 +148,7 @@
 		proto = check_proto(entry);
 		parse_multi_ports(argv[optind-1], minfo, proto);
 		minfo->flags = IPT_MPORT_DESTINATION;
-		*nfcache |= NFC_IP_DST_PT;
+		*nfcache |= NFC_UNKNOWN;
 		break;
 
 	case '3':
@@ -156,7 +156,7 @@
 		proto = check_proto(entry);
 		parse_multi_ports(argv[optind-1], minfo, proto);
 		minfo->flags = IPT_MPORT_EITHER;
-		*nfcache |= NFC_IP_SRC_PT | NFC_IP_DST_PT;
+		*nfcache |= NFC_UNKNOWN;
 		break;
 
 	default:
Index: extensions/libipt_sctp.c
===================================================================
--- extensions/libipt_sctp.c	(revision 3656)
+++ extensions/libipt_sctp.c	(working copy)
@@ -293,7 +293,7 @@
 		if (invert)
 			einfo->invflags |= IPT_SCTP_SRC_PORTS;
 		*flags |= IPT_SCTP_SRC_PORTS;
-		*nfcache |= NFC_IP_SRC_PT;
+		*nfcache |= NFC_UNKNOWN;
 		break;
 
 	case '2':
@@ -306,7 +306,7 @@
 		if (invert)
 			einfo->invflags |= IPT_SCTP_DEST_PORTS;
 		*flags |= IPT_SCTP_DEST_PORTS;
-		*nfcache |= NFC_IP_DST_PT;
+		*nfcache |= NFC_UNKNOWN;
 		break;
 
 	case '3':
Index: extensions/libipt_icmp.c
===================================================================
--- extensions/libipt_icmp.c	(revision 3656)
+++ extensions/libipt_icmp.c	(working copy)
@@ -114,7 +114,7 @@
 	{0}
 };
 
-static unsigned int
+static void 
 parse_icmp(const char *icmptype, u_int8_t *type, u_int8_t code[])
 {
 	unsigned int limit = sizeof(icmp_codes)/sizeof(struct icmp_names);
@@ -165,10 +165,6 @@
 			code[1] = 0xFF;
 		}
 	}
-
-	if (code[0] == 0 && code[1] == 0xFF)
-		return NFC_IP_SRC_PT;
-	else return NFC_IP_SRC_PT | NFC_IP_DST_PT;
 }
 
 /* Initialize the match. */
@@ -194,9 +190,9 @@
 	switch (c) {
 	case '1':
 		check_inverse(optarg, &invert, &optind, 0);
-		*nfcache |= parse_icmp(argv[optind-1],
-				       &icmpinfo->type,
-				       icmpinfo->code);
+		*nfcache |= NFC_UNKNOWN;
+		parse_icmp(argv[optind-1], &icmpinfo->type, 
+			   icmpinfo->code);
 		if (invert)
 			icmpinfo->invflags |= IPT_ICMP_INV;
 		break;
Index: extensions/libipt_dscp.c
===================================================================
--- extensions/libipt_dscp.c	(revision 3656)
+++ extensions/libipt_dscp.c	(working copy)
@@ -26,7 +26,7 @@
 
 static void init(struct ipt_entry_match *m, unsigned int *nfcache) 
 {
-	*nfcache |= NFC_IP_TOS;
+	*nfcache |= NFC_UNKNOWN;
 }
 
 static void help(void) 
Index: extensions/libip6t_icmpv6.c
===================================================================
--- extensions/libip6t_icmpv6.c	(revision 3656)
+++ extensions/libip6t_icmpv6.c	(working copy)
@@ -90,7 +90,7 @@
 	{0}
 };
 
-static unsigned int
+static void
 parse_icmpv6(const char *icmpv6type, u_int8_t *type, u_int8_t code[])
 {
 	unsigned int limit = sizeof(icmpv6_codes)/sizeof(struct icmpv6_names);
@@ -141,10 +141,6 @@
 			code[1] = 0xFF;
 		}
 	}
-
-	if (code[0] == 0 && code[1] == 0xFF)
-		return NFC_IP6_SRC_PT;
-	else return NFC_IP6_SRC_PT | NFC_IP6_DST_PT;
 }
 
 /* Initialize the match. */
@@ -169,9 +165,9 @@
 	switch (c) {
 	case '1':
 		check_inverse(optarg, &invert, &optind, 0);
-		*nfcache |= parse_icmpv6(argv[optind-1],
-				       &icmpv6info->type,
-				       icmpv6info->code);
+		*nfcache |= NFC_UNKNOWN;
+		parse_icmpv6(argv[optind-1], &icmpv6info->type, 
+			     icmpv6info->code);
 		if (invert)
 			icmpv6info->invflags |= IP6T_ICMP_INV;
 		break;
Index: extensions/libipt_udp.c
===================================================================
--- extensions/libipt_udp.c	(revision 3656)
+++ extensions/libipt_udp.c	(working copy)
@@ -109,7 +109,7 @@
 		if (invert)
 			udpinfo->invflags |= IPT_UDP_INV_SRCPT;
 		*flags |= UDP_SRC_PORTS;
-		*nfcache |= NFC_IP_SRC_PT;
+		*nfcache |= NFC_UNKNOWN;
 		break;
 
 	case '2':
@@ -121,7 +121,7 @@
 		if (invert)
 			udpinfo->invflags |= IPT_UDP_INV_DSTPT;
 		*flags |= UDP_DST_PORTS;
-		*nfcache |= NFC_IP_DST_PT;
+		*nfcache |= NFC_UNKNOWN;
 		break;
 
 	default:
Index: extensions/libipt_ecn.c
===================================================================
--- extensions/libipt_ecn.c	(revision 3656)
+++ extensions/libipt_ecn.c	(working copy)
@@ -18,7 +18,7 @@
 
 static void init(struct ipt_entry_match *m, unsigned int *nfcache) 
 {
-	*nfcache |= NFC_IP_TOS;
+	*nfcache |= NFC_UNKNOWN;
 }
 
 static void help(void) 
Index: extensions/libipt_tcp.c
===================================================================
--- extensions/libipt_tcp.c	(revision 3656)
+++ extensions/libipt_tcp.c	(working copy)
@@ -187,7 +187,7 @@
 		if (invert)
 			tcpinfo->invflags |= IPT_TCP_INV_SRCPT;
 		*flags |= TCP_SRC_PORTS;
-		*nfcache |= NFC_IP_SRC_PT;
+		*nfcache |= NFC_UNKNOWN;
 		break;
 
 	case '2':
@@ -199,7 +199,7 @@
 		if (invert)
 			tcpinfo->invflags |= IPT_TCP_INV_DSTPT;
 		*flags |= TCP_DST_PORTS;
-		*nfcache |= NFC_IP_DST_PT;
+		*nfcache |= NFC_UNKNOWN;
 		break;
 
 	case '3':
@@ -209,7 +209,7 @@
 				   " allowed");
 		parse_tcp_flags(tcpinfo, "SYN,RST,ACK", "SYN", invert);
 		*flags |= TCP_FLAGS;
-		*nfcache |= NFC_IP_TCPFLAGS;
+		*nfcache |= NFC_UNKNOWN;
 		break;
 
 	case '4':
@@ -228,7 +228,7 @@
 				invert);
 		optind++;
 		*flags |= TCP_FLAGS;
-		*nfcache |= NFC_IP_TCPFLAGS;
+		*nfcache |= NFC_UNKNOWN;
 		break;
 
 	case '5':
@@ -240,7 +240,7 @@
 		if (invert)
 			tcpinfo->invflags |= IPT_TCP_INV_OPTION;
 		*flags |= TCP_OPTION;
-		*nfcache |= NFC_IP_PROTO_UNKNOWN;
+		*nfcache |= NFC_UNKNOWN;
 		break;
 
 	default:
Index: ip6tables.c
===================================================================
--- ip6tables.c	(revision 3656)
+++ ip6tables.c	(working copy)
@@ -1887,7 +1887,7 @@
 			    && (fw.ipv6.invflags & IP6T_INV_PROTO))
 				exit_error(PARAMETER_PROBLEM,
 					   "rule would never match protocol");
-			fw.nfcache |= NFC_IP6_PROTO;
+			fw.nfcache |= NFC_UNKNOWN;
 			break;
 
 		case 's':
@@ -1895,7 +1895,7 @@
 			set_option(&options, OPT_SOURCE, &fw.ipv6.invflags,
 				   invert);
 			shostnetworkmask = argv[optind-1];
-			fw.nfcache |= NFC_IP6_SRC;
+			fw.nfcache |= NFC_UNKNOWN;
 			break;
 
 		case 'd':
@@ -1903,7 +1903,7 @@
 			set_option(&options, OPT_DESTINATION, &fw.ipv6.invflags,
 				   invert);
 			dhostnetworkmask = argv[optind-1];
-			fw.nfcache |= NFC_IP6_DST;
+			fw.nfcache |= NFC_UNKNOWN;
 			break;
 
 		case 'j':
@@ -1935,7 +1935,7 @@
 			parse_interface(argv[optind-1],
 					fw.ipv6.iniface,
 					fw.ipv6.iniface_mask);
-			fw.nfcache |= NFC_IP6_IF_IN;
+			fw.nfcache |= NFC_UNKNOWN;
 			break;
 
 		case 'o':
@@ -1945,7 +1945,7 @@
 			parse_interface(argv[optind-1],
 					fw.ipv6.outiface,
 					fw.ipv6.outiface_mask);
-			fw.nfcache |= NFC_IP6_IF_OUT;
+			fw.nfcache |= NFC_UNKNOWN;
 			break;
 
 		case 'v':

--------------030402020100080704030000--
