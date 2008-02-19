From: "Tseng, Kuo-Lang" <kuo-lang.tseng-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH 1/2] Add IPv6 support
Date: Mon, 18 Feb 2008 17:50:26 -0800
Message-ID: <3F25FE8C477E9E4FB3D42C2FF937C08A8D090B@orsmsx423.amr.corp.intel.com>
References: <20080211220753.796791654@endian.com>
	<1202846691.2901.16.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: Bart De Schuymer <bdschuym-LPO8gxj9N8aZIoH1IeqzKA@public.gmane.org>,
	netfilter-devel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: <ebtables-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
Return-path: <ebtables-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
Content-class: urn:content-classes:message
In-Reply-To: <1202846691.2901.16.camel-bi+AKbBUZKY6gyzm1THtWbp2dZbC/Bob@public.gmane.org>
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/ebtables-devel>,
	<mailto:ebtables-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=ebtables-devel>
List-Post: <mailto:ebtables-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
List-Help: <mailto:ebtables-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/ebtables-devel>,
	<mailto:ebtables-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=subscribe>
Sender: ebtables-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
Errors-To: ebtables-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
List-Id: netfilter-devel.vger.kernel.org

This is the userspace ebtables patch that implements IPv6 header field
checking and parsing. 

Signed-off-by: Kuo-lang Tseng <kuo-lang.tseng-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>




diff -urNp ebtables-v2.0.8-2.orig/ebtables.8
ebtables-v2.0.8-2.ipv6/ebtables.8
--- ebtables-v2.0.8-2.orig/ebtables.8	2007-09-21 10:27:20.000000000
-0700
+++ ebtables-v2.0.8-2.ipv6/ebtables.8	2008-02-18 15:40:31.000000000
-0800
@@ -652,6 +652,54 @@ If
 The flag
 .B --ip-dport
 is an alias for this option.
+.SS ipv6
+Specify IPv6 fields. The protocol must be specified as
+.IR IPv6 .
+.TP
+.BR "--ip6-source " "[!] \fIaddress\fP[/\fImask\fP]"
+The source IPv6 address.
+The flag
+.B --ip6-src
+is an alias for this option.
+.TP
+.BR "--ip6-destination " "[!] \fIaddress\fP[/\fImask\fP]"
+The destination IPv6 address.
+The flag
+.B --ip6-dst
+is an alias for this option.
+.TP
+.BR "--ip6-tclass " "[!] \fItclass\fP"
+The IPv6 traffic class, in hexadecimal numbers.
+.TP
+.BR "--ip6-protocol " "[!] \fIprotocol\fP"
+The IP protocol.
+The flag
+.B --ip6-proto
+is an alias for this option.
+.TP
+.BR "--ip6-source-port " "[!] \fIport1\fP[:\fIport2\fP]"
+The source port or port range for the IPv6 protocols 6 (TCP), 17
+(UDP), 33 (DCCP) or 132 (SCTP). The
+.B --ip6-protocol
+option must be specified as
+.IR TCP ", " UDP ", " DCCP " or " SCTP .
+If
+.IR port1 " is omitted, " 0:port2 " is used; if " port2 " is omitted
but a colon is specified, " port1:65535 " is used."
+The flag
+.B --ip6-sport
+is an alias for this option.
+.TP
+.BR "--ip6-destination-port " "[!] \fIport1\fP[:\fIport2\fP]"
+The destination port or port range for IPv6 protocols 6 (TCP), 17
+(UDP), 33 (DCCP) or 132 (SCTP). The
+.B --ip6-protocol
+option must be specified as
+.IR TCP ", " UDP ", " DCCP " or " SCTP .
+If
+.IR port1 " is omitted, " 0:port2 " is used; if " port2 " is omitted
but a colon is specified, " port1:65535 " is used."
+The flag
+.B --ip6-dport
+is an alias for this option.
 .SS limit
 This module matches at a limited rate using a token bucket filter.
 A rule using this extension will match until this limit is reached.
@@ -800,6 +848,11 @@ to be printed at the beginning of the li
 Will log the ip information when a frame made by the ip protocol
matches 
 the rule. The default is no ip information logging.
 .TP
+.B --log-ip6 
+.br
+Will log the ipv6 information when a frame made by the ipv6 protocol
matches 
+the rule. The default is no ipv6 information logging.
+.TP
 .B --log-arp
 .br
 Will log the (r)arp information when a frame made by the (r)arp
protocols
diff -urNp ebtables-v2.0.8-2.orig/extensions/ebt_ip6.c
ebtables-v2.0.8-2.ipv6/extensions/ebt_ip6.c
--- ebtables-v2.0.8-2.orig/extensions/ebt_ip6.c	1969-12-31
16:00:00.000000000 -0800
+++ ebtables-v2.0.8-2.ipv6/extensions/ebt_ip6.c	2008-02-18
15:24:21.000000000 -0800
@@ -0,0 +1,339 @@
+/* ebt_ip6
+ * 
+ * Authors:
+ * Kuo-Lang Tseng <kuo-lang.tseng-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
+ * Manohar Castelino <manohar.castelino-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
+ *
+ * Summary:
+ * This is just a modification of the IPv4 code written by 
+ * Bart De Schuymer <bdschuym-LPO8gxj9N8aZIoH1IeqzKA@public.gmane.org>
+ * with the changes required to support IPv6
+ *
+ */
+
+#include <stdio.h>
+#include <stdlib.h>
+#include <string.h>
+#include <getopt.h>
+#include <netdb.h>
+#include "../include/ebtables_u.h"
+#include <linux/netfilter_bridge/ebt_ip6.h>
+
+
+
+#define IP_SOURCE '1'
+#define IP_DEST   '2'
+#define IP_TCLASS '3'
+#define IP_PROTO  '4'
+#define IP_SPORT  '5'
+#define IP_DPORT  '6'
+
+static struct option opts[] =
+{
+	{ "ip6-source"           , required_argument, 0, IP_SOURCE },
+	{ "ip6-src"              , required_argument, 0, IP_SOURCE },
+	{ "ip6-destination"      , required_argument, 0, IP_DEST   },
+	{ "ip6-dst"              , required_argument, 0, IP_DEST   },
+	{ "ip6-traffic-class"    , required_argument, 0, IP_TCLASS },
+	{ "ip6-tclass"           , required_argument, 0, IP_TCLASS },
+	{ "ip6-protocol"         , required_argument, 0, IP_PROTO  },
+	{ "ip6-proto"            , required_argument, 0, IP_PROTO  },
+	{ "ip6-source-port"      , required_argument, 0, IP_SPORT  },
+	{ "ip6-sport"            , required_argument, 0, IP_SPORT  },
+	{ "ip6-destination-port" , required_argument, 0, IP_DPORT  },
+	{ "ip6-dport"            , required_argument, 0, IP_DPORT  },
+	{ 0 }
+};
+
+/* transform a protocol and service name into a port number */
+static uint16_t parse_port(const char *protocol, const char *name)
+{
+	struct servent *service;
+	char *end;
+	int port;
+
+	port = strtol(name, &end, 10);
+	if (*end != '\0') {
+		if (protocol && 
+		    (service = getservbyname(name, protocol)) != NULL)
+			return ntohs(service->s_port);
+	}
+	else if (port >= 0 || port <= 0xFFFF) {
+		return port;
+	}
+	ebt_print_error("Problem with specified %s port '%s'", 
+			protocol?protocol:"", name);
+	return 0;
+}
+
+static void
+parse_port_range(const char *protocol, const char *portstring, uint16_t
*ports)
+{
+	char *buffer;
+	char *cp;
+	
+	buffer = strdup(portstring);
+	if ((cp = strchr(buffer, ':')) == NULL)
+		ports[0] = ports[1] = parse_port(protocol, buffer);
+	else {
+		*cp = '\0';
+		cp++;
+		ports[0] = buffer[0] ? parse_port(protocol, buffer) : 0;
+		if (ebt_errormsg[0] != '\0')
+			return;
+		ports[1] = cp[0] ? parse_port(protocol, cp) : 0xFFFF;
+		if (ebt_errormsg[0] != '\0')
+			return;
+		
+		if (ports[0] > ports[1])
+			ebt_print_error("Invalid portrange (min >
max)");
+	}
+	free(buffer);
+}
+
+static void print_port_range(uint16_t *ports)
+{
+	if (ports[0] == ports[1])
+		printf("%d ", ports[0]);
+	else
+		printf("%d:%d ", ports[0], ports[1]);
+}
+
+static void print_help()
+{
+	printf(
+"ip6 options:\n"
+"--ip6-src    [!] address[/mask]: ipv6 source specification\n"
+"--ip6-dst    [!] address[/mask]: ipv6 destination specification\n"
+"--ip6-tclass [!] tclass        : ipv6 traffic class specification\n"
+"--ip6-proto  [!] protocol      : ipv6 protocol specification\n"
+"--ip6-sport  [!] port[:port]   : tcp/udp source port or port range\n"
+"--ip6-dport  [!] port[:port]   : tcp/udp destination port or port
range\n");
+}
+
+static void init(struct ebt_entry_match *match)
+{
+	struct ebt_ip6_info *ipinfo = (struct ebt_ip6_info
*)match->data;
+
+	ipinfo->invflags = 0;
+	ipinfo->bitmask = 0;
+}
+
+#define OPT_SOURCE 0x01
+#define OPT_DEST   0x02
+#define OPT_TCLASS 0x04
+#define OPT_PROTO  0x08
+#define OPT_SPORT  0x10
+#define OPT_DPORT  0x20
+static int parse(int c, char **argv, int argc, const struct ebt_u_entry
*entry,
+   unsigned int *flags, struct ebt_entry_match **match)
+{
+	struct ebt_ip6_info *ipinfo = (struct ebt_ip6_info
*)(*match)->data;
+	char *end;
+	long int i;
+
+	switch (c) {
+	case IP_SOURCE:
+		ebt_check_option2(flags, OPT_SOURCE);
+		ipinfo->bitmask |= EBT_IP6_SOURCE;
+		if (ebt_check_inverse2(optarg)) {
+		    ipinfo->invflags |= EBT_IP6_SOURCE;
+		}
+		ebt_parse_ip6_address(optarg, &ipinfo->saddr,
&ipinfo->smsk);
+		break;
+
+	case IP_DEST:
+		ebt_check_option2(flags, OPT_DEST);
+		ipinfo->bitmask |= EBT_IP6_DEST;
+		if (ebt_check_inverse2(optarg)) {
+			ipinfo->invflags |= EBT_IP6_DEST;
+		}
+		ebt_parse_ip6_address(optarg, &ipinfo->daddr,
&ipinfo->dmsk);
+		break;
+
+	case IP_SPORT:
+	case IP_DPORT:
+		if (c == IP_SPORT) {
+			ebt_check_option2(flags, OPT_SPORT);
+			ipinfo->bitmask |= EBT_IP6_SPORT;
+			if (ebt_check_inverse2(optarg))
+				ipinfo->invflags |= EBT_IP6_SPORT;
+		} else {
+			ebt_check_option2(flags, OPT_DPORT);
+			ipinfo->bitmask |= EBT_IP6_DPORT;
+			if (ebt_check_inverse2(optarg))
+				ipinfo->invflags |= EBT_IP6_DPORT;
+		}
+		if (c == IP_SPORT)
+			parse_port_range(NULL, optarg, ipinfo->sport);
+		else
+			parse_port_range(NULL, optarg, ipinfo->dport);
+		break;
+
+	case IP_TCLASS:
+		ebt_check_option2(flags, OPT_TCLASS);
+		if (ebt_check_inverse2(optarg))
+			ipinfo->invflags |= EBT_IP6_TCLASS;
+		i = strtol(optarg, &end, 16);
+		if (i < 0 || i > 255 || *end != '\0')
+			ebt_print_error2("Problem with specified IPv6
traffic class");
+		ipinfo->tclass = i;
+		ipinfo->bitmask |= EBT_IP6_TCLASS;
+		break;
+
+	case IP_PROTO:
+		ebt_check_option2(flags, OPT_PROTO);
+		if (ebt_check_inverse2(optarg))
+			ipinfo->invflags |= EBT_IP6_PROTO;
+		i = strtoul(optarg, &end, 10);
+		if (*end != '\0') {
+			struct protoent *pe;
+
+			pe = getprotobyname(optarg);
+			if (pe == NULL)
+				ebt_print_error("Unknown specified IP
protocol - %s", argv[optind - 1]);
+			ipinfo->protocol = pe->p_proto;
+		} else {
+			ipinfo->protocol = (unsigned char) i;
+		}
+		ipinfo->bitmask |= EBT_IP6_PROTO;
+		break;
+	default:
+		return 0;
+	}
+	return 1;
+}
+
+static void final_check(const struct ebt_u_entry *entry,
+   const struct ebt_entry_match *match, const char *name,
+   unsigned int hookmask, unsigned int time)
+{
+	struct ebt_ip6_info *ipinfo = (struct ebt_ip6_info
*)match->data;
+
+	if (entry->ethproto != ETH_P_IPV6 || entry->invflags &
EBT_IPROTO) {
+		ebt_print_error("For IPv6 filtering the protocol must be
"
+		            "specified as IPv6");
+	} else if (ipinfo->bitmask & (EBT_IP6_SPORT|EBT_IP6_DPORT) &&
+		(!(ipinfo->bitmask & EBT_IP6_PROTO) ||
+		ipinfo->invflags & EBT_IP6_PROTO ||
+		(ipinfo->protocol!=IPPROTO_TCP &&
+		 ipinfo->protocol!=IPPROTO_UDP &&
+		 ipinfo->protocol!=IPPROTO_SCTP &&
+		 ipinfo->protocol!=IPPROTO_DCCP)))
+		ebt_print_error("For port filtering the IP protocol must
be "
+				"either 6 (tcp), 17 (udp), 33 (dccp) or
"
+				"132 (sctp)");
+}
+
+static void print(const struct ebt_u_entry *entry,
+   const struct ebt_entry_match *match)
+{
+	struct ebt_ip6_info *ipinfo = (struct ebt_ip6_info
*)match->data;
+
+	if (ipinfo->bitmask & EBT_IP6_SOURCE) {
+		printf("--ip6-src ");
+		if (ipinfo->invflags & EBT_IP6_SOURCE)
+			printf("! ");
+		printf("%s", ebt_ip6_to_numeric(&ipinfo->saddr));
+		printf("/%s ", ebt_ip6_to_numeric(&ipinfo->smsk));
+	}
+	if (ipinfo->bitmask & EBT_IP6_DEST) {
+		printf("--ip6-dst ");
+		if (ipinfo->invflags & EBT_IP6_DEST)
+			printf("! ");
+		printf("%s", ebt_ip6_to_numeric(&ipinfo->daddr));
+		printf("/%s ", ebt_ip6_to_numeric(&ipinfo->dmsk));
+	}
+	if (ipinfo->bitmask & EBT_IP6_TCLASS) {
+		printf("--ip6-tclass ");
+		if (ipinfo->invflags & EBT_IP6_TCLASS)
+			printf("! ");
+		printf("0x%02X ", ipinfo->tclass);
+	}
+	if (ipinfo->bitmask & EBT_IP6_PROTO) {
+		struct protoent *pe;
+
+		printf("--ip6-proto ");
+		if (ipinfo->invflags & EBT_IP6_PROTO)
+			printf("! ");
+		pe = getprotobynumber(ipinfo->protocol);
+		if (pe == NULL) {
+			printf("%d ", ipinfo->protocol);
+		} else {
+			printf("%s ", pe->p_name);
+		}
+	}
+	if (ipinfo->bitmask & EBT_IP6_SPORT) {
+		printf("--ip6-sport ");
+		if (ipinfo->invflags & EBT_IP6_SPORT)
+			printf("! ");
+		print_port_range(ipinfo->sport);
+	}
+	if (ipinfo->bitmask & EBT_IP6_DPORT) {
+		printf("--ip6-dport ");
+		if (ipinfo->invflags & EBT_IP6_DPORT)
+			printf("! ");
+		print_port_range(ipinfo->dport);
+	}
+}
+
+static int compare(const struct ebt_entry_match *m1,
+   const struct ebt_entry_match *m2)
+{
+	struct ebt_ip6_info *ipinfo1 = (struct ebt_ip6_info *)m1->data;
+	struct ebt_ip6_info *ipinfo2 = (struct ebt_ip6_info *)m2->data;
+
+	if (ipinfo1->bitmask != ipinfo2->bitmask)
+		return 0;
+	if (ipinfo1->invflags != ipinfo2->invflags)
+		return 0;
+	if (ipinfo1->bitmask & EBT_IP6_SOURCE) {
+		if (!IN6_ARE_ADDR_EQUAL(&ipinfo1->saddr,
&ipinfo2->saddr))
+			return 0;
+		if (!IN6_ARE_ADDR_EQUAL(&ipinfo1->smsk, &ipinfo2->smsk))
+			return 0;
+	}
+	if (ipinfo1->bitmask & EBT_IP6_DEST) {
+		if (!IN6_ARE_ADDR_EQUAL(&ipinfo1->daddr,
&ipinfo2->daddr))
+			return 0;
+		if (!IN6_ARE_ADDR_EQUAL(&ipinfo1->dmsk, &ipinfo2->dmsk))
+			return 0;
+	}
+	if (ipinfo1->bitmask & EBT_IP6_TCLASS) {
+		if (ipinfo1->tclass != ipinfo2->tclass)
+			return 0;
+	}
+	if (ipinfo1->bitmask & EBT_IP6_PROTO) {
+		if (ipinfo1->protocol != ipinfo2->protocol)
+			return 0;
+	}
+	if (ipinfo1->bitmask & EBT_IP6_SPORT) {
+		if (ipinfo1->sport[0] != ipinfo2->sport[0] ||
+		   ipinfo1->sport[1] != ipinfo2->sport[1])
+			return 0;
+	}
+	if (ipinfo1->bitmask & EBT_IP6_DPORT) {
+		if (ipinfo1->dport[0] != ipinfo2->dport[0] ||
+		   ipinfo1->dport[1] != ipinfo2->dport[1])
+			return 0;
+	}
+	return 1;
+}
+
+static struct ebt_u_match ip6_match =
+{
+	.name		= EBT_IP6_MATCH,
+	.size		= sizeof(struct ebt_ip6_info),
+	.help		= print_help,
+	.init		= init,
+	.parse		= parse,
+	.final_check	= final_check,
+	.print		= print,
+	.compare	= compare,
+	.extra_ops	= opts,
+};
+
+void _init(void)
+{
+	ebt_register_match(&ip6_match);
+}
diff -urNp ebtables-v2.0.8-2.orig/extensions/ebt_log.c
ebtables-v2.0.8-2.ipv6/extensions/ebt_log.c
--- ebtables-v2.0.8-2.orig/extensions/ebt_log.c	2007-09-21
10:27:20.000000000 -0700
+++ ebtables-v2.0.8-2.ipv6/extensions/ebt_log.c	2008-01-30
17:22:56.000000000 -0800
@@ -60,6 +60,7 @@ static int name_to_loglevel(char* arg)
 #define LOG_ARP    '3'
 #define LOG_IP     '4'
 #define LOG_LOG    '5'
+#define LOG_IP6    '6'
 static struct option opts[] =
 {
 	{ "log-prefix", required_argument, 0, LOG_PREFIX },
@@ -67,6 +68,7 @@ static struct option opts[] =
 	{ "log-arp"   , no_argument      , 0, LOG_ARP    },
 	{ "log-ip"    , no_argument      , 0, LOG_IP     },
 	{ "log"       , no_argument      , 0, LOG_LOG    },
+	{ "log-ip6"   , no_argument      , 0, LOG_IP6    },
 	{ 0 }
 };
 
@@ -81,6 +83,7 @@ static void print_help()
 "--log-prefix prefix : max. %d chars.\n"
 "--log-ip            : put ip info. in the log for ip packets\n"
 "--log-arp           : put (r)arp info. in the log for (r)arp
packets\n"
+"--log-ip6           : put ip6 info. in the log for ip6 packets\n"
 	, EBT_LOG_PREFIX_SIZE - 1);
 	printf("levels:\n");
 	for (i = 0; i < 8; i++)
@@ -102,6 +105,7 @@ static void init(struct ebt_entry_watche
 #define OPT_ARP    0x04
 #define OPT_IP     0x08
 #define OPT_LOG    0x10
+#define OPT_IP6    0x20
 static int parse(int c, char **argv, int argc, const struct ebt_u_entry
*entry,
    unsigned int *flags, struct ebt_entry_watcher **watcher)
 {
@@ -151,6 +155,13 @@ static int parse(int c, char **argv, int
 		if (ebt_check_inverse(optarg))
 			ebt_print_error2("Unexpected `!' after --log");
 		break;
+
+	case LOG_IP6:
+		ebt_check_option2(flags, OPT_IP6);
+		if (ebt_check_inverse(optarg))
+			ebt_print_error2("Unexpected `!' after
--log-ip6");
+		loginfo->bitmask |= EBT_LOG_IP6;
+		break;
 	default:
 		return 0;
 	}
@@ -175,6 +186,8 @@ static void print(const struct ebt_u_ent
 		printf(" --log-ip");
 	if (loginfo->bitmask & EBT_LOG_ARP)
 		printf(" --log-arp");
+	if (loginfo->bitmask & EBT_LOG_IP6)
+		printf(" --log-ip6");
 	printf(" ");
 }
 
diff -urNp ebtables-v2.0.8-2.orig/extensions/Makefile
ebtables-v2.0.8-2.ipv6/extensions/Makefile
--- ebtables-v2.0.8-2.orig/extensions/Makefile	2007-09-21
10:27:20.000000000 -0700
+++ ebtables-v2.0.8-2.ipv6/extensions/Makefile	2008-01-11
19:41:47.000000000 -0800
@@ -1,6 +1,6 @@
 #! /usr/bin/make
 
-EXT_FUNC+=802_3 nat arp arpreply ip standard log redirect vlan mark_m
mark \
+EXT_FUNC+=802_3 nat arp arpreply ip ip6 standard log redirect vlan
mark_m mark \
           pkttype stp among limit ulog
 EXT_TABLES+=filter nat broute
 EXT_OBJS+=$(foreach T,$(EXT_FUNC), extensions/ebt_$(T).o)
diff -urNp ebtables-v2.0.8-2.orig/include/ebtables_u.h
ebtables-v2.0.8-2.ipv6/include/ebtables_u.h
--- ebtables-v2.0.8-2.orig/include/ebtables_u.h	2007-09-21
10:27:20.000000000 -0700
+++ ebtables-v2.0.8-2.ipv6/include/ebtables_u.h	2008-02-15
11:43:06.000000000 -0800
@@ -297,6 +297,10 @@ void ebt_print_mac_and_mask(const unsign
 int ebt_get_mac_and_mask(const char *from, unsigned char *to, unsigned
char *mask);
 void ebt_parse_ip_address(char *address, uint32_t *addr, uint32_t
*msk);
 char *ebt_mask_to_dotted(uint32_t mask);
+void ebt_parse_ip6_address(char *address, struct in6_addr *addr, 
+						   struct in6_addr
*msk);
+char *ebt_ip6_to_numeric(const struct in6_addr *addrp);
+
 
 int do_command(int argc, char *argv[], int exec_style,
                struct ebt_u_replace *replace_);
diff -urNp ebtables-v2.0.8-2.orig/useful_functions.c
ebtables-v2.0.8-2.ipv6/useful_functions.c
--- ebtables-v2.0.8-2.orig/useful_functions.c	2007-09-21
10:27:20.000000000 -0700
+++ ebtables-v2.0.8-2.ipv6/useful_functions.c	2008-02-18
15:20:52.000000000 -0800
@@ -29,6 +29,10 @@
 #include <string.h>
 #include <stdlib.h>
 #include <getopt.h>
+#include <errno.h>
+#include <sys/types.h>
+#include <sys/socket.h>
+#include <arpa/inet.h>
 
 const unsigned char mac_type_unicast[ETH_ALEN] =   {0,0,0,0,0,0};
 const unsigned char msk_type_unicast[ETH_ALEN] =   {1,0,0,0,0,0};
@@ -244,6 +248,7 @@ void ebt_parse_ip_address(char *address,
 	*addr = *addr & *msk;
 }
 
+
 /* Transform the ip mask into a string ready for output. */
 char *ebt_mask_to_dotted(uint32_t mask)
 {
@@ -276,3 +281,134 @@ char *ebt_mask_to_dotted(uint32_t mask)
 
 	return buf;
 }
+
+/* Most of the following code is derived from iptables */
+static void
+in6addrcpy(struct in6_addr *dst, struct in6_addr *src)
+{
+    memcpy(dst, src, sizeof(struct in6_addr));
+}
+
+int string_to_number_ll(const char *s, unsigned long long min,
+            unsigned long long max, unsigned long long *ret)
+{
+    unsigned long long number;
+    char *end;
+
+    /* Handle hex, octal, etc. */
+    errno = 0;
+    number = strtoull(s, &end, 0);
+    if (*end == '\0' && end != s) {
+        /* we parsed a number, let's see if we want this */
+        if (errno != ERANGE && min <= number && (!max || number <=
max)) {
+            *ret = number;
+            return 0;
+        }
+    }
+    return -1;
+}
+
+int string_to_number_l(const char *s, unsigned long min, unsigned long
max,
+               unsigned long *ret)
+{
+    int result;
+    unsigned long long number;
+
+    result = string_to_number_ll(s, min, max, &number);
+    *ret = (unsigned long)number;
+
+    return result;
+}
+
+int string_to_number(const char *s, unsigned int min, unsigned int max,
+        unsigned int *ret)
+{
+    int result;
+    unsigned long number;
+
+    result = string_to_number_l(s, min, max, &number);
+    *ret = (unsigned int)number;
+
+    return result;
+}
+
+static struct in6_addr *
+numeric_to_addr(const char *num)
+{
+    static struct in6_addr ap;
+    int err;
+    if ((err=inet_pton(AF_INET6, num, &ap)) == 1)
+        return &ap;
+    return (struct in6_addr *)NULL;
+}
+
+static struct in6_addr *
+parse_ip6_mask(char *mask)
+{
+    static struct in6_addr maskaddr;
+    struct in6_addr *addrp;
+    unsigned int bits;
+
+    if (mask == NULL) {
+        /* no mask at all defaults to 128 bits */
+        memset(&maskaddr, 0xff, sizeof maskaddr);
+        return &maskaddr;
+    }
+    if ((addrp = numeric_to_addr(mask)) != NULL)
+        return addrp;
+    if (string_to_number(mask, 0, 128, &bits) == -1)
+		ebt_print_error("Invalid IPv6 Mask '%s' specified",
mask);
+    if (bits != 0) {
+        char *p = (char *)&maskaddr;
+        memset(p, 0xff, bits / 8);
+        memset(p + (bits / 8) + 1, 0, (128 - bits) / 8);
+        p[bits / 8] = 0xff << (8 - (bits & 7));
+        return &maskaddr;
+    }
+
+    memset(&maskaddr, 0, sizeof maskaddr);
+    return &maskaddr;
+}
+
+/* Set the ipv6 mask and address. Callers should check ebt_errormsg[0].
+ * The string pointed to by address can be altered. */
+void ebt_parse_ip6_address(char *address, struct in6_addr *addr, 
+						   struct in6_addr *msk)
+{
+    struct in6_addr *tmp_addr;
+    char buf[256];
+    char *p;
+    int i;
+    int err;
+
+    strncpy(buf, address, sizeof(buf) - 1);
+	/* first the mask */
+    buf[sizeof(buf) - 1] = '\0';
+    if ((p = strrchr(buf, '/')) != NULL) {
+        *p = '\0';
+        tmp_addr = parse_ip6_mask(p + 1);
+    } else
+        tmp_addr = parse_ip6_mask(NULL);
+    in6addrcpy(msk, tmp_addr);
+
+    /* if a null mask is given, the name is ignored, like in "any/0" */
+    if (!memcmp(msk, &in6addr_any, sizeof(in6addr_any)))
+        strcpy(buf, "::");
+
+    if ((err=inet_pton(AF_INET6, buf, addr)) < 1) {
+		ebt_print_error("Invalid IPv6 Address '%s' specified",
buf);
+		return;
+	}
+
+ 	for (i = 0; i < 4; i++)
+    	addr->in6_u.u6_addr32[i] &= msk->in6_u.u6_addr32[i];
+}
+
+/* Transform the ip6 addr into a string ready for output. */
+char *ebt_ip6_to_numeric(const struct in6_addr *addrp)
+{
+    /* 0000:0000:0000:0000:0000:000.000.000.000
+     * 0000:0000:0000:0000:0000:0000:0000:0000 */
+    static char buf[50+1];
+    return (char *)inet_ntop(AF_INET6, addrp, buf, sizeof(buf));
+}

-------------------------------------------------------------------------
This SF.net email is sponsored by: Microsoft
Defy all challenges. Microsoft(R) Visual Studio 2008.
http://clk.atdmt.com/MRT/go/vse0120000070mrt/direct/01/
