From: Henrik Nordstrom <hno@marasystems.com>
Subject: conntrack match issues
Date: Mon, 1 Jul 2002 15:35:19 +0200
Sender: netfilter-devel-admin@lists.samba.org
Message-ID: <200207011535.19412.hno@marasystems.com>
Mime-Version: 1.0
Content-Type: Multipart/Mixed;
  boundary="------------Boundary-00=_VEOKKKNE66259RHDPX99"
Return-path: <netfilter-devel-admin@lists.samba.org>
To: Marc Boucher <marc+nf@mbsi.ca>,
	netfilter-devel <netfilter-devel@lists.samba.org>
Errors-To: netfilter-devel-admin@lists.samba.org
List-Help: <mailto:netfilter-devel-request@lists.samba.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.samba.org>
List-Subscribe: <http://lists.samba.org/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.samba.org?subject=subscribe>
List-Unsubscribe: <http://lists.samba.org/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.samba.org?subject=unsubscribe>
List-Archive: <http://lists.samba.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


--------------Boundary-00=_VEOKKKNE66259RHDPX99
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8bit

I have some small issues with the conntrack match in it's current incarnation

a) Very hard to extend with new features as there is no extra flag bits

b) Missing the ability to match conntrack ports.

c) Some errors in iptables-save output


Attached to this message is an extension patch to the conntrack match to

a) Be able to match conntrack source/destination ports.

b) The flags words extended to 32 bits to make room for the new options and 
leave some allowing for future extensions such as the ability to match 
original ICMP, new conntrack state bits, master connection etc without having 
to totally break binary compability.

c) Corrected iptables-save output

Attached is an incremental diff to the current CVS version.

Note: Due to the extension and addition of new fields in the match structure 
it is not binary compatible with the current "pending" version.

Regards
Henrik Norström
MARA Systems AB
--------------Boundary-00=_VEOKKKNE66259RHDPX99
Content-Type: text/x-diff;
  charset="us-ascii";
  name="conntrack_match_ports.diff"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment; filename="conntrack_match_ports.diff"

? extensions/.BALANCE-test
? extensions/.CONFIRMED-test
? extensions/.CONNMARK-test
? extensions/.FTOS-test
? extensions/.IPV4OPTSSTRIP-test
? extensions/.NETLINK.test
? extensions/.NETMAP-test
? extensions/.REJECT-test6
? extensions/.ROUTE-test
? extensions/.ah-test6
? extensions/.confirmed-test
? extensions/.connmark-test
? extensions/.conntrack2-test
? extensions/.esp-test6
? extensions/.frag-test6
? extensions/.helper-test
? extensions/.ipv4options-test
? extensions/.ipv6header-test6
? extensions/.mport-test
? extensions/.nth-test
? extensions/.opts-test6
? extensions/.pool-test
? extensions/.psd-test
? extensions/.quota-test
? extensions/.random-test
? extensions/.realm-test
? extensions/.recent-test
? extensions/.record-rpc-test
? extensions/.rt-test6
? extensions/.string-test
? extensions/.time-test
? patch-o-matic/pending/.conntrack.patch.swp
Index: extensions/libipt_conntrack.c
===================================================================
RCS file: /cvspublic/netfilter/userspace/extensions/libipt_conntrack.c,v
retrieving revision 1.4
diff -u -r1.4 libipt_conntrack.c
--- extensions/libipt_conntrack.c	29 May 2002 13:08:16 -0000	1.4
+++ extensions/libipt_conntrack.c	1 Jul 2002 13:32:29 -0000
@@ -30,6 +30,14 @@
 "				Reply source specification\n"
 "     --ctrepldst  [!] address[/mask]\n"
 "				Reply destination specification\n"
+"     --ctorigsrcport [!] port[:port]\n"
+"				Original source port specification\n"
+"     --ctorigdstport [!] port[:port]\n"
+"				Original destination port specification\n"
+"     --ctreplsrcport [!] port[:port]\n"
+"				Reply source port specification\n"
+"     --ctrepldstport [!] port[:port]\n"
+"				Reply destination port specification\n"
 " [!] --ctstatus [NONE|EXPECTED|SEEN_REPLY|ASSURED][,...]\n"
 "				Status(es) to match\n"
 " [!] --ctexpire time[:time]	Match remaining lifetime in seconds against\n"
@@ -48,6 +56,10 @@
 	{ "ctrepldst", 1, 0, '6' },
 	{ "ctstatus", 1, 0, '7' },
 	{ "ctexpire", 1, 0, '8' },
+	{ "ctorigsrcport", 1, 0, '9' },
+	{ "ctorigdstport", 1, 0, 'a' },
+	{ "ctreplsrcport", 1, 0, 'b' },
+	{ "ctrepldstport", 1, 0, 'c' },
 	{0}
 };
 
@@ -163,6 +175,54 @@
 	
 }
 
+
+static int
+service_to_port(const char *name)
+{
+	struct servent *service;
+
+	if ((service = getservbyname(name, "tcp")) != NULL)
+		return ntohs((unsigned short) service->s_port);
+
+	if ((service = getservbyname(name, "udp")) != NULL)
+		return ntohs((unsigned short) service->s_port);
+
+	return -1;
+}
+
+static u_int16_t
+parse_port(const char *port)
+{
+	unsigned int portnum;
+
+	if (string_to_number(port, 0, 65535, &portnum) != -1 ||
+	    (portnum = service_to_port(port)) != -1)
+		return (u_int16_t)portnum;
+
+	exit_error(PARAMETER_PROBLEM,
+		   "invalid port/service `%s' specified", port);
+}
+
+static void
+parse_ports(const char *portstring, u_int16_t *ports)
+{
+	char *buffer;
+	char *cp;
+
+	buffer = strdup(portstring);
+	if ((cp = strchr(buffer, ':')) == NULL)
+		ports[0] = ports[1] = parse_port(buffer);
+	else {
+		*cp = '\0';
+		cp++;
+
+		ports[0] = buffer[0] ? parse_port(buffer) : 0;
+		ports[1] = cp[0] ? parse_port(cp) : 0xFFFF;
+	}
+	free(buffer);
+}
+
+
 /* Function which parses command options; returns true if it
    ate an option */
 static int
@@ -309,6 +369,46 @@
 		sinfo->flags |= IPT_CONNTRACK_EXPIRES;
 		break;
 
+	case '9':
+		check_inverse(optarg, &invert, &optind, 0);
+
+		parse_ports(argv[optind-1], sinfo->srcports[IP_CT_DIR_ORIGINAL]);
+		if (invert) {
+			sinfo->invflags |= IPT_CONNTRACK_ORIGSRCPORT;
+		}
+		sinfo->flags |= IPT_CONNTRACK_ORIGSRCPORT;
+		break;
+
+	case 'a':
+		check_inverse(optarg, &invert, &optind, 0);
+
+		parse_ports(argv[optind-1], sinfo->dstports[IP_CT_DIR_ORIGINAL]);
+		if (invert) {
+			sinfo->invflags |= IPT_CONNTRACK_ORIGDSTPORT;
+		}
+		sinfo->flags |= IPT_CONNTRACK_ORIGDSTPORT;
+		break;
+
+	case 'b':
+		check_inverse(optarg, &invert, &optind, 0);
+
+		parse_ports(argv[optind-1], sinfo->srcports[IP_CT_DIR_REPLY]);
+		if (invert) {
+			sinfo->invflags |= IPT_CONNTRACK_REPLSRCPORT;
+		}
+		sinfo->flags |= IPT_CONNTRACK_REPLSRCPORT;
+		break;
+
+	case 'c':
+		check_inverse(optarg, &invert, &optind, 0);
+
+		parse_ports(argv[optind-1], sinfo->dstports[IP_CT_DIR_REPLY]);
+		if (invert) {
+			sinfo->invflags |= IPT_CONNTRACK_REPLDSTPORT;
+		}
+		sinfo->flags |= IPT_CONNTRACK_REPLDSTPORT;
+		break;
+
 	default:
 		return 0;
 	}
@@ -386,7 +486,7 @@
 	char buf[BUFSIZ];
 
         if (inv)
-               	fputc('!', stdout);
+               	printf("! ");
 
 	if (mask->s_addr == 0L && !numeric)
 		printf("%s ", "anywhere");
@@ -409,7 +509,7 @@
 	if(sinfo->flags & IPT_CONNTRACK_STATE) {
 		printf("%sctstate ", optpfx);
         	if (sinfo->invflags & IPT_CONNTRACK_STATE)
-                	fputc('!', stdout);
+			printf("! ");
 		print_state(sinfo->statemask);
 	}
 
@@ -434,7 +534,7 @@
 	}
 
 	if(sinfo->flags & IPT_CONNTRACK_REPLSRC) {
-		printf("%sctorigsrc ", optpfx);
+		printf("%sctreplsrc ", optpfx);
 
 		print_addr(
 		    (struct in_addr *)&sinfo->tuple[IP_CT_DIR_REPLY].src.ip,
@@ -444,7 +544,7 @@
 	}
 
 	if(sinfo->flags & IPT_CONNTRACK_REPLDST) {
-		printf("%sctorigdst ", optpfx);
+		printf("%sctrepldst ", optpfx);
 
 		print_addr(
 		    (struct in_addr *)&sinfo->tuple[IP_CT_DIR_REPLY].dst.ip,
@@ -453,18 +553,45 @@
 		    numeric);
 	}
 
+	if(sinfo->flags & IPT_CONNTRACK_ORIGSRCPORT) {
+		printf("%sctorigsrcport ", optpfx);
+        	if (sinfo->invflags & IPT_CONNTRACK_ORIGSRCPORT)
+			printf("! ");
+		printf("%u:%u ", (unsigned)sinfo->srcports[IP_CT_DIR_ORIGINAL][0], (unsigned)sinfo->srcports[IP_CT_DIR_ORIGINAL][1]);
+	}
+
+	if(sinfo->flags & IPT_CONNTRACK_ORIGDSTPORT) {
+		printf("%sctorigdstport ", optpfx);
+        	if (sinfo->invflags & IPT_CONNTRACK_ORIGDSTPORT)
+			printf("! ");
+		printf("%u:%u ", (unsigned)sinfo->dstports[IP_CT_DIR_ORIGINAL][0], (unsigned)sinfo->dstports[IP_CT_DIR_ORIGINAL][1]);
+	}
+
+	if(sinfo->flags & IPT_CONNTRACK_REPLSRCPORT) {
+		printf("%sctreplsrcport ", optpfx);
+        	if (sinfo->invflags & IPT_CONNTRACK_REPLSRCPORT)
+			printf("! ");
+		printf("%u:%u ", (unsigned)sinfo->srcports[IP_CT_DIR_REPLY][0], (unsigned)sinfo->srcports[IP_CT_DIR_REPLY][1]);
+	}
+
+	if(sinfo->flags & IPT_CONNTRACK_REPLDSTPORT) {
+		printf("%sctrepldstport ", optpfx);
+        	if (sinfo->invflags & IPT_CONNTRACK_REPLDSTPORT)
+			printf("! ");
+		printf("%u:%u ", (unsigned)sinfo->dstports[IP_CT_DIR_REPLY][0], (unsigned)sinfo->dstports[IP_CT_DIR_REPLY][1]);
+	}
+
 	if(sinfo->flags & IPT_CONNTRACK_STATUS) {
 		printf("%sctstatus ", optpfx);
         	if (sinfo->invflags & IPT_CONNTRACK_STATE)
-                	fputc('!', stdout);
+			printf("! ");
 		print_status(sinfo->statusmask);
 	}
 
 	if(sinfo->flags & IPT_CONNTRACK_EXPIRES) {
 		printf("%sctexpire ", optpfx);
         	if (sinfo->invflags & IPT_CONNTRACK_EXPIRES)
-                	fputc('!', stdout);
-
+			printf("! ");
         	if (sinfo->expires_max == sinfo->expires_min)
                 	printf("%lu ", sinfo->expires_min);
         	else
Index: patch-o-matic/pending/conntrack.patch
===================================================================
RCS file: /cvspublic/netfilter/userspace/patch-o-matic/pending/conntrack.patch,v
retrieving revision 1.1
diff -u -r1.1 conntrack.patch
--- patch-o-matic/pending/conntrack.patch	19 Jan 2002 12:29:21 -0000	1.1
+++ patch-o-matic/pending/conntrack.patch	1 Jul 2002 13:32:29 -0000
@@ -1,7 +1,7 @@
 diff -urN linux-2.4.18-pre4/include/linux/netfilter_ipv4/ipt_conntrack.h linux-2.4.18-pre4-mb/include/linux/netfilter_ipv4/ipt_conntrack.h
 --- linux-2.4.18-pre4/include/linux/netfilter_ipv4/ipt_conntrack.h	Thu Jan  1 01:00:00 1970
 +++ linux-2.4.18-pre4-mb/include/linux/netfilter_ipv4/ipt_conntrack.h	Sat Jan 19 12:21:55 2002
-@@ -0,0 +1,38 @@
+@@ -0,0 +1,46 @@
 +/* Header file for kernel module to match connection tracking information.
 + * GPL (C) 2001  Marc Boucher (marc@mbsi.ca).
 + */
@@ -16,14 +16,18 @@
 +#define IPT_CONNTRACK_STATE_DNAT (1 << (IP_CT_NUMBER + 2))
 +
 +/* flags, invflags: */
-+#define IPT_CONNTRACK_STATE	0x01
-+#define IPT_CONNTRACK_PROTO	0x02
-+#define IPT_CONNTRACK_ORIGSRC	0x04
-+#define IPT_CONNTRACK_ORIGDST	0x08
-+#define IPT_CONNTRACK_REPLSRC	0x10
-+#define IPT_CONNTRACK_REPLDST	0x20
-+#define IPT_CONNTRACK_STATUS	0x40
-+#define IPT_CONNTRACK_EXPIRES	0x80
++#define IPT_CONNTRACK_STATE		0x00000001
++#define IPT_CONNTRACK_PROTO		0x00000002
++#define IPT_CONNTRACK_ORIGSRC		0x00000004
++#define IPT_CONNTRACK_ORIGDST		0x00000008
++#define IPT_CONNTRACK_REPLSRC		0x00000010
++#define IPT_CONNTRACK_REPLDST		0x00000020
++#define IPT_CONNTRACK_STATUS		0x00000040
++#define IPT_CONNTRACK_EXPIRES		0x00000080
++#define IPT_CONNTRACK_ORIGSRCPORT	0x00000100
++#define IPT_CONNTRACK_ORIGDSTPORT	0x00000200
++#define IPT_CONNTRACK_REPLSRCPORT	0x00000400
++#define IPT_CONNTRACK_REPLDSTPORT	0x00000800
 +
 +struct ipt_conntrack_info
 +{
@@ -34,16 +38,20 @@
 +
 +	unsigned long expires_min, expires_max;
 +
++	/* The port fields in the tuple is not used */
++	u_int16_t srcports[IP_CT_DIR_MAX][2];
++	u_int16_t dstports[IP_CT_DIR_MAX][2];
++
 +	/* Flags word */
-+	u_int8_t flags;
++	u_int32_t flags;
 +	/* Inverse flags */
-+	u_int8_t invflags;
++	u_int32_t invflags;
 +};
 +#endif /*_IPT_CONNTRACK_H*/
 diff -urN linux-2.4.18-pre4/net/ipv4/netfilter/ipt_conntrack.c linux-2.4.18-pre4-mb/net/ipv4/netfilter/ipt_conntrack.c
 --- linux-2.4.18-pre4/net/ipv4/netfilter/ipt_conntrack.c	Thu Jan  1 01:00:00 1970
 +++ linux-2.4.18-pre4-mb/net/ipv4/netfilter/ipt_conntrack.c	Sat Jan 19 12:21:55 2002
-@@ -0,0 +1,123 @@
+@@ -0,0 +1,154 @@
 +/* Kernel module to match connection tracking information.
 + * Superset of Rusty's minimalistic state match.
 + * GPL (C) 2001  Marc Boucher (marc@mbsi.ca).
@@ -54,6 +62,17 @@
 +#include <linux/netfilter_ipv4/ip_tables.h>
 +#include <linux/netfilter_ipv4/ipt_conntrack.h>
 +
++/* Returns 1 if the port is matched by the range, 0 otherwise */
++static inline int
++port_match(u_int16_t min, u_int16_t max, u_int16_t port)
++{
++	int ret;
++
++	ret = port >= min && port <= max;
++	return ret;
++}
++
++
 +static int
 +match(const struct sk_buff *skb,
 +      const struct net_device *in,
@@ -111,6 +130,26 @@
 +
 +	if(sinfo->flags & IPT_CONNTRACK_REPLDST) {
 +		if (!ct || FWINV((ct->tuplehash[IP_CT_DIR_REPLY].tuple.dst.ip&sinfo->dipmsk[IP_CT_DIR_REPLY].s_addr) != sinfo->tuple[IP_CT_DIR_REPLY].dst.ip, IPT_CONNTRACK_REPLDST))
++			return 0;
++	}
++
++	if(sinfo->flags & IPT_CONNTRACK_ORIGSRCPORT) {
++		if (!ct || FWINV(!port_match(sinfo->srcports[IP_CT_DIR_ORIGINAL][0], sinfo->srcports[IP_CT_DIR_ORIGINAL][1], ntohs(ct->tuplehash[IP_CT_DIR_ORIGINAL].tuple.src.u.tcp.port)), IPT_CONNTRACK_ORIGSRCPORT))
++			return 0;
++	}
++
++	if(sinfo->flags & IPT_CONNTRACK_ORIGDSTPORT) {
++		if (!ct || FWINV(!port_match(sinfo->dstports[IP_CT_DIR_ORIGINAL][0], sinfo->dstports[IP_CT_DIR_ORIGINAL][1], ntohs(ct->tuplehash[IP_CT_DIR_ORIGINAL].tuple.dst.u.tcp.port)), IPT_CONNTRACK_ORIGDSTPORT))
++			return 0;
++	}
++
++	if(sinfo->flags & IPT_CONNTRACK_REPLSRCPORT) {
++		if (!ct || FWINV(!port_match(sinfo->srcports[IP_CT_DIR_REPLY][0], sinfo->srcports[IP_CT_DIR_REPLY][1], ntohs(ct->tuplehash[IP_CT_DIR_REPLY].tuple.src.u.tcp.port)), IPT_CONNTRACK_REPLSRCPORT))
++			return 0;
++	}
++
++	if(sinfo->flags & IPT_CONNTRACK_REPLDSTPORT) {
++		if (!ct || FWINV(!port_match(sinfo->dstports[IP_CT_DIR_REPLY][0], sinfo->dstports[IP_CT_DIR_REPLY][1], ntohs(ct->tuplehash[IP_CT_DIR_REPLY].tuple.dst.u.tcp.port)), IPT_CONNTRACK_REPLDSTPORT))
 +			return 0;
 +	}
 +
Index: patch-o-matic/pending/conntrack.patch.help
===================================================================
RCS file: /cvspublic/netfilter/userspace/patch-o-matic/pending/conntrack.patch.help,v
retrieving revision 1.1
diff -u -r1.1 conntrack.patch.help
--- patch-o-matic/pending/conntrack.patch.help	19 Jan 2002 12:29:21 -0000	1.1
+++ patch-o-matic/pending/conntrack.patch.help	1 Jul 2002 13:32:29 -0000
@@ -1,4 +1,4 @@
-Author: Marc Boucher <marc+nf@mbsi.ca>
+Author: Marc Boucher <marc+nf@mbsi.ca>, Henrik Nordstrom <hno@marasystems.com>
 Status: Works For Me.
 
 This is a general conntrack match module, a superset of the state match.
@@ -23,6 +23,11 @@
                                 Reply source specification
      --ctrepldst  [!] address[/mask]
                                 Reply destination specification
+     --ctorigsrcport [!] port	Original source port specification
+     --ctorigdstport [!] port	Original destination port specification
+     --ctreplsrcport [!] port	Reply source port specification
+     --ctrepldstport [!] port	Reply destination port specification
+
  [!] --ctstatus [NONE|EXPECTED|SEEN_REPLY|ASSURED][,...]
                                 Status(es) to match
  [!] --ctexpire  time[:time]    Match remaining lifetime in seconds against

--------------Boundary-00=_VEOKKKNE66259RHDPX99--
