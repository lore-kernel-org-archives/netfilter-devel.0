From: Harald Welte <laforge@netfilter.org>
Subject: [PATCH 2.6] remove ipt_unclean match from 2.6.x
Date: Sat, 23 Aug 2003 23:19:26 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20030823211926.GF6750@sunbeam.de.gnumonks.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="IvGM3kKqwtniy32b"
Cc: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: David Miller <davem@redhat.com>
Content-Disposition: inline
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


--IvGM3kKqwtniy32b
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Dave!

The following (trivial) patch removes the unclean match from the
2.6.0-test4 kernel. =20

We have decided to remove the unclean match, since it is considered
a potentially dangerous function of the current iptables code.

The match is used by lots of users who don't really undestand what kind
of danger they are imposing on the future-compatibility of their
networks.  (just think of the ECN issue resulting from this kind of
filtering)

We'd rather keep it in patch-o-matic, where lots of other modules that
are only useful in experimental scenarios are kept.

Now that we don't have to keep it for compatibility reasons, we'd like
to remove it before 2.6.0 final is released.

Please apply, thanks.


diff -Nru linux-2.6.0-test4-queue/net/ipv4/netfilter/Kconfig linux-2.6.0-te=
st4-unclean/net/ipv4/netfilter/Kconfig
--- linux-2.6.0-test4-queue/net/ipv4/netfilter/Kconfig	2003-08-23 01:58:50.=
000000000 +0200
+++ linux-2.6.0-test4-unclean/net/ipv4/netfilter/Kconfig	2003-08-23 23:19:0=
6.000000000 +0200
@@ -271,16 +271,6 @@
 	  If you want to compile it as a module, say M here and read
 	  Documentation/modules.txt.  If unsure, say `N'.
=20
-config IP_NF_MATCH_UNCLEAN
-	tristate "Unclean match support (EXPERIMENTAL)"
-	depends on EXPERIMENTAL && IP_NF_IPTABLES
-	help
-	  Unclean packet matching matches any strange or invalid packets, by
-	  looking at a series of fields in the IP, TCP, UDP and ICMP headers.
-
-	  If you want to compile it as a module, say M here and read
-	  <file:Documentation/modules.txt>.  If unsure, say `N'.
-
 config IP_NF_MATCH_OWNER
 	tristate "Owner match support (EXPERIMENTAL)"
 	depends on EXPERIMENTAL && IP_NF_IPTABLES
diff -Nru linux-2.6.0-test4-queue/net/ipv4/netfilter/Makefile linux-2.6.0-t=
est4-unclean/net/ipv4/netfilter/Makefile
--- linux-2.6.0-test4-queue/net/ipv4/netfilter/Makefile	2003-08-23 01:53:09=
=2E000000000 +0200
+++ linux-2.6.0-test4-unclean/net/ipv4/netfilter/Makefile	2003-08-23 23:18:=
50.000000000 +0200
@@ -61,7 +61,6 @@
 obj-$(CONFIG_IP_NF_MATCH_TTL) +=3D ipt_ttl.o
 obj-$(CONFIG_IP_NF_MATCH_STATE) +=3D ipt_state.o
 obj-$(CONFIG_IP_NF_MATCH_CONNTRACK) +=3D ipt_conntrack.o
-obj-$(CONFIG_IP_NF_MATCH_UNCLEAN) +=3D ipt_unclean.o
 obj-$(CONFIG_IP_NF_MATCH_TCPMSS) +=3D ipt_tcpmss.o
=20
 obj-$(CONFIG_IP_NF_MATCH_PHYSDEV) +=3D ipt_physdev.o
diff -Nru linux-2.6.0-test4-queue/net/ipv4/netfilter/ipt_unclean.c linux-2.=
6.0-test4-unclean/net/ipv4/netfilter/ipt_unclean.c
--- linux-2.6.0-test4-queue/net/ipv4/netfilter/ipt_unclean.c	2003-08-23 01:=
57:09.000000000 +0200
+++ linux-2.6.0-test4-unclean/net/ipv4/netfilter/ipt_unclean.c	1970-01-01 0=
1:00:00.000000000 +0100
@@ -1,610 +0,0 @@
-/* Kernel module to match suspect packets. */
-#include <linux/module.h>
-#include <linux/skbuff.h>
-#include <linux/ip.h>
-#include <linux/udp.h>
-#include <linux/tcp.h>
-#include <linux/icmp.h>
-#include <net/checksum.h>
-
-#include <linux/netfilter_ipv4/ip_tables.h>
-
-#define limpk(format, args...)						 \
-do {									 \
-	if (net_ratelimit())						 \
-		printk("ipt_unclean: %s" format,			 \
-		       embedded ? "(embedded packet) " : "" , ## args);  \
-} while(0)
-
-enum icmp_error_status
-{
-	ICMP_MAY_BE_ERROR,
-	ICMP_IS_ERROR,
-	ICMP_NOT_ERROR
-};
-
-struct icmp_info
-{
-	size_t min_len, max_len;
-	enum icmp_error_status err;
-	u_int8_t min_code, max_code;
-};
-
-static int
-check_ip(const struct sk_buff *skb, unsigned int offset);
-
-/* ICMP-specific checks. */
-static int
-check_icmp(const struct sk_buff *skb,
-	   unsigned int offset,
-	   unsigned int fragoff,
-	   int more_frags,
-	   int embedded)
-{
-	struct icmphdr icmph;
-	static struct icmp_info info[]
-		=3D { [ICMP_ECHOREPLY]
-		    =3D { 8, 65536, ICMP_NOT_ERROR, 0, 0 },
-		    [ICMP_DEST_UNREACH]
-		    =3D { 8 + 28, 65536, ICMP_IS_ERROR, 0, 15 },
-		    [ICMP_SOURCE_QUENCH]
-		    =3D { 8 + 28, 65536, ICMP_IS_ERROR, 0, 0 },
-		    [ICMP_REDIRECT]
-		    =3D { 8 + 28, 65536, ICMP_IS_ERROR, 0, 3 },
-		    [ICMP_ECHO]
-		    =3D { 8, 65536, ICMP_NOT_ERROR, 0, 0  },
-		    /* Router advertisement. */
-		    [9]
-		    =3D { 8, 8 + 255 * 8, ICMP_NOT_ERROR, 0, 0 },
-		    /* Router solicitation. */
-		    [10]
-		    =3D { 8, 8, ICMP_NOT_ERROR, 0, 0 },
-		    [ICMP_TIME_EXCEEDED]
-		    =3D { 8 + 28, 65536, ICMP_IS_ERROR, 0, 1  },
-		    [ICMP_PARAMETERPROB]
-		    =3D { 8 + 28, 65536, ICMP_IS_ERROR, 0, 1 },
-		    [ICMP_TIMESTAMP]
-		    =3D { 20, 20, ICMP_NOT_ERROR, 0, 0 },
-		    [ICMP_TIMESTAMPREPLY]
-		    =3D { 20, 20, ICMP_NOT_ERROR, 0, 0 },
-		    [ICMP_INFO_REQUEST]
-		    =3D { 8, 65536, ICMP_NOT_ERROR, 0, 0 },
-		    [ICMP_INFO_REPLY]
-		    =3D { 8, 65536, ICMP_NOT_ERROR, 0, 0 },
-		    [ICMP_ADDRESS]
-		    =3D { 12, 12, ICMP_NOT_ERROR, 0, 0 },
-		    [ICMP_ADDRESSREPLY]
-		    =3D { 12, 12, ICMP_NOT_ERROR, 0, 0 } };
-
-	/* Can't do anything if it's a fragment. */
-	if (fragoff)
-		return 1;
-
-	/* CHECK: Must have whole header.. */
-	if (skb_copy_bits(skb, offset, &icmph, sizeof(icmph)) < 0) {
-		limpk("ICMP len=3D%u too short\n", skb->len - offset);
-		return 0;
-	}
-
-	/* If not embedded in an ICMP error already. */
-	if (!embedded) {
-		/* CHECK: Truncated ICMP (even if first fragment). */
-		if (icmph.type < sizeof(info)/sizeof(struct icmp_info)
-		    && info[icmph.type].min_len !=3D 0
-		    && skb->len - offset < info[icmph.type].min_len) {
-			limpk("ICMP type %u len %u too short\n",
-			      icmph.type, skb->len - offset);
-			return 0;
-		}
-
-		/* CHECK: Check within known error ICMPs. */
-		if (icmph.type < sizeof(info)/sizeof(struct icmp_info)
-		    && info[icmph.type].err =3D=3D ICMP_IS_ERROR) {
-			/* Max IP header size =3D 60 */
-			char inner[60 + 8];
-			struct iphdr *inner_ip =3D (struct iphdr *)inner;
-
-			/* CHECK: Embedded packet must be at least
-			   length of iph + 8 bytes. */
-			if (skb_copy_bits(skb, offset + sizeof(icmph),
-					  inner, sizeof(struct iphdr)+8) < 0) {
-				limpk("ICMP error internal way too short\n");
-				return 0;
-			}
-
-			/* iphhdr may actually be longer: still need 8
-                           actual protocol bytes. */
-			if (offset + sizeof(icmph) + inner_ip->ihl*4 + 8
-			    > skb->len) {
-				limpk("ICMP error internal too short\n");
-				return 0;
-			}
-			if (!check_ip(skb, offset + sizeof(icmph)))
-				return 0;
-		}
-	} else {
-		/* CHECK: Can't embed ICMP unless known non-error. */
-		if (icmph.type >=3D sizeof(info)/sizeof(struct icmp_info)
-		    || info[icmph.type].err !=3D ICMP_NOT_ERROR) {
-			limpk("ICMP type %u not embeddable\n",
-			      icmph.type);
-			return 0;
-		}
-	}
-
-	/* CHECK: Invalid ICMP codes. */
-	if (icmph.type < sizeof(info)/sizeof(struct icmp_info)
-	    && (icmph.code < info[icmph.type].min_code
-		|| icmph.code > info[icmph.type].max_code)) {
-		limpk("ICMP type=3D%u code=3D%u\n",
-		      icmph.type, icmph.code);
-		return 0;
-	}
-
-	/* CHECK: Above maximum length. */
-	if (icmph.type < sizeof(info)/sizeof(struct icmp_info)
-	    && info[icmph.type].max_len !=3D 0
-	    && skb->len - offset > info[icmph.type].max_len) {
-		limpk("ICMP type=3D%u too long: %u bytes\n",
-		      icmph.type, skb->len - offset);
-		return 0;
-	}
-
-	switch (icmph.type) {
-	case ICMP_PARAMETERPROB: {
-		/* CHECK: Problem param must be within error packet's
-		 * IP header. */
-		u_int32_t arg =3D ntohl(icmph.un.gateway);
-
-		if (icmph.code =3D=3D 0) {
-			/* We've already made sure it's long enough. */
-			struct iphdr iph;
-			skb_copy_bits(skb, offset + sizeof(icmph), &iph,
-				      sizeof(iph));
-			/* Code 0 means that upper 8 bits is pointer
-                           to problem. */
-			if ((arg >> 24) >=3D iph.ihl*4) {
-				limpk("ICMP PARAMETERPROB ptr =3D %u\n",
-				      ntohl(icmph.un.gateway) >> 24);
-				return 0;
-			}
-			arg &=3D 0x00FFFFFF;
-		}
-
-		/* CHECK: Rest must be zero. */
-		if (arg) {
-			limpk("ICMP PARAMETERPROB nonzero arg =3D %u\n",
-			      arg);
-			return 0;
-		}
-		break;
-	}
-
-	case ICMP_TIME_EXCEEDED:
-	case ICMP_SOURCE_QUENCH:
-		/* CHECK: Unused must be zero. */
-		if (icmph.un.gateway !=3D 0) {
-			limpk("ICMP type=3D%u unused =3D %u\n",
-			      icmph.type, ntohl(icmph.un.gateway));
-			return 0;
-		}
-		break;
-	}
-
-	return 1;
-}
-
-/* UDP-specific checks. */
-static int
-check_udp(const struct sk_buff *skb,
-	  unsigned int offset,
-	  unsigned int fragoff,
-	  int more_frags,
-	  int embedded)
-{
-	struct udphdr udph;
-
-	/* Can't do anything if it's a fragment. */
-	if (fragoff)
-		return 1;
-
-	/* CHECK: Must cover UDP header. */
-	if (skb_copy_bits(skb, offset, &udph, sizeof(udph)) < 0) {
-		limpk("UDP len=3D%u too short\n", skb->len - offset);
-		return 0;
-	}
-
-	/* CHECK: Destination port can't be zero. */
-	if (!udph.dest) {
-		limpk("UDP zero destination port\n");
-		return 0;
-	}
-
-	if (!more_frags) {
-		if (!embedded) {
-			/* CHECK: UDP length must match. */
-			if (ntohs(udph.len) !=3D skb->len - offset) {
-				limpk("UDP len too short %u vs %u\n",
-				      ntohs(udph.len), skb->len - offset);
-				return 0;
-			}
-		} else {
-			/* CHECK: UDP length be >=3D this truncated pkt. */
-			if (ntohs(udph.len) < skb->len - offset) {
-				limpk("UDP len too long %u vs %u\n",
-				      ntohs(udph.len), skb->len - offset);
-				return 0;
-			}
-		}
-	} else {
-		/* CHECK: UDP length must be > this frag's length. */
-		if (ntohs(udph.len) <=3D skb->len - offset) {
-			limpk("UDP fragment len too short %u vs %u\n",
-			      ntohs(udph.len), skb->len - offset);
-			return 0;
-		}
-	}
-
-	return 1;
-}
-
-/* TCP-specific checks. */
-static int
-check_tcp(const struct sk_buff *skb,
-	  unsigned int offset,
-	  unsigned int fragoff,
-	  int more_frags,
-	  int embedded)
-{
-	struct tcphdr tcph;=20
-	unsigned char opt[15 * 4 - sizeof(struct tcphdr)];
-	u32 tcpflags;
-	int end_of_options =3D 0;
-	unsigned int i, optlen;
-
-	/* CHECK: Can't have offset=3D1: used to override TCP syn-checks. */
-	/* In fact, this is caught below (offset < 516). */
-
-	/* Can't do anything if it's a fragment. */
-	if (fragoff)
-		return 1;
-
-	/* CHECK: Smaller than minimal TCP hdr. */
-	if (skb_copy_bits(skb, offset, &tcph, sizeof(tcph)) < 0) {
-		u16 ports[2];
-
-		if (!embedded) {
-			limpk("Packet length %u < TCP header.\n",
-			      skb->len - offset);
-			return 0;
-		}
-
-		/* Must have ports available (datalen >=3D 8), from
-                   check_icmp which set embedded =3D 1 */
-		/* CHECK: TCP ports inside ICMP error */
-		skb_copy_bits(skb, offset, ports, sizeof(ports));
-		if (!ports[0] || !ports[1]) {
-			limpk("Zero TCP ports %u/%u.\n",
-			      htons(ports[0]), htons(ports[1]));
-			return 0;
-		}
-		return 1;
-	}
-
-	/* CHECK: TCP header claims tiny size. */
-	if (tcph.doff * 4 < sizeof(tcph)) {
-		limpk("TCP header claims tiny size %u\n", tcph.doff * 4);
-		return 0;
-	}
-
-	/* CHECK: Packet smaller than actual TCP hdr. */
-	optlen =3D tcph.doff*4 - sizeof(tcph);
-	if (skb_copy_bits(skb, offset + sizeof(tcph), opt, optlen) < 0) {
-		if (!embedded) {
-			limpk("Packet length %u < actual TCP header.\n",
-			      skb->len - offset);
-			return 0;
-		} else
-			return 1;
-	}
-
-	/* CHECK: TCP ports non-zero */
-	if (!tcph.source || !tcph.dest) {
-		limpk("Zero TCP ports %u/%u.\n",
-		      htons(tcph.source), htons(tcph.dest));
-		return 0;
-	}
-
-	tcpflags =3D tcp_flag_word(&tcph);
-
-	/* CHECK: TCP reserved bits zero. */
-	if (tcpflags & TCP_RESERVED_BITS) {
-		limpk("TCP reserved bits not zero\n");
-		return 0;
-	}
-
-	tcpflags &=3D ~(TCP_DATA_OFFSET | TCP_FLAG_CWR | TCP_FLAG_ECE
-		      | __constant_htonl(0x0000FFFF));
-
-	/* CHECK: TCP flags. */
-	if (tcpflags !=3D TCP_FLAG_SYN
-	    && tcpflags !=3D (TCP_FLAG_SYN|TCP_FLAG_ACK)
-	    && tcpflags !=3D TCP_FLAG_RST
-	    && tcpflags !=3D (TCP_FLAG_RST|TCP_FLAG_ACK)
-	    && tcpflags !=3D (TCP_FLAG_RST|TCP_FLAG_ACK|TCP_FLAG_PSH)
-	    && tcpflags !=3D (TCP_FLAG_FIN|TCP_FLAG_ACK)
-	    && tcpflags !=3D TCP_FLAG_ACK
-	    && tcpflags !=3D (TCP_FLAG_ACK|TCP_FLAG_PSH)
-	    && tcpflags !=3D (TCP_FLAG_ACK|TCP_FLAG_URG)
-	    && tcpflags !=3D (TCP_FLAG_ACK|TCP_FLAG_URG|TCP_FLAG_PSH)
-	    && tcpflags !=3D (TCP_FLAG_FIN|TCP_FLAG_ACK|TCP_FLAG_PSH)
-	    && tcpflags !=3D (TCP_FLAG_FIN|TCP_FLAG_ACK|TCP_FLAG_URG)
-	    && tcpflags !=3D (TCP_FLAG_FIN|TCP_FLAG_ACK|TCP_FLAG_URG
-			    |TCP_FLAG_PSH)) {
-		limpk("TCP flags bad: 0x%04X\n", ntohl(tcpflags) >> 16);
-		return 0;
-	}
-
-	for (i =3D 0; i < optlen; ) {
-		switch (opt[i]) {
-		case 0:
-			end_of_options =3D 1;
-			i++;
-			break;
-		case 1:
-			i++;
-			break;
-		default:
-			/* CHECK: options after EOO. */
-			if (end_of_options) {
-				limpk("TCP option %u after end\n",
-				      opt[i]);
-				return 0;
-			}
-			/* CHECK: options at tail. */
-			else if (i+1 >=3D optlen) {
-				limpk("TCP option %u at tail\n",
-				      opt[i]);
-				return 0;
-			}
-			/* CHECK: zero-length options. */
-			else if (opt[i+1] =3D=3D 0) {
-				limpk("TCP option %u 0 len\n",
-				      opt[i]);
-				return 0;
-			}
-			/* CHECK: oversize options. */
-			else if (i + opt[i+1] > optlen) {
-				limpk("TCP option %u at %u too long\n",
-				      (unsigned int) opt[i], i);
-				return 0;
-			}
-			/* Move to next option */
-			i +=3D opt[i+1];
-		}
-	}
-
-	return 1;
-}
-
-/* Returns 1 if ok */
-/* Standard IP checks. */
-static int
-check_ip(const struct sk_buff *skb, unsigned int offset)
-{
-	int end_of_options =3D 0;
-	unsigned int datalen, optlen;
-	unsigned int i;
-	unsigned int fragoff;
-	struct iphdr iph;
-	unsigned char opt[15 * 4 - sizeof(struct iphdr)];
-	int embedded =3D offset;
-
-	/* Should only happen for local outgoing raw-socket packets. */
-	/* CHECK: length >=3D ip header. */
-	if (skb_copy_bits(skb, offset, &iph, sizeof(iph)) < 0) {
-		limpk("Packet length %u < IP header.\n", skb->len - offset);
-		return 0;
-	}
-	if (iph.ihl * 4 < sizeof(iph)) {
-		limpk("IP len %u < minimum IP header.\n", iph.ihl*4);
-		return 0;
-	}
-
-	optlen =3D iph.ihl * 4 - sizeof(iph);
-	if (skb_copy_bits(skb, offset+sizeof(struct iphdr), opt, optlen)<0) {
-		limpk("Packet length %u < IP header %u.\n",
-		      skb->len - offset, iph.ihl * 4);
-		return 0;
-	}
-
-	fragoff =3D (ntohs(iph.frag_off) & IP_OFFSET);
-	datalen =3D skb->len - (offset + sizeof(struct iphdr) + optlen);
-
-	/* CHECK: Embedded fragment. */
-	if (offset && fragoff) {
-		limpk("Embedded fragment.\n");
-		return 0;
-	}
-
-	for (i =3D 0; i < optlen; ) {
-		switch (opt[i]) {
-		case 0:
-			end_of_options =3D 1;
-			i++;
-			break;
-		case 1:
-			i++;
-			break;
-		default:
-			/* CHECK: options after EOO. */
-			if (end_of_options) {
-				limpk("IP option %u after end\n",
-				      opt[i]);
-				return 0;
-			}
-			/* CHECK: options at tail. */
-			else if (i+1 >=3D optlen) {
-				limpk("IP option %u at tail\n",
-				      opt[i]);
-				return 0;
-			}
-			/* CHECK: zero-length or one-length options. */
-			else if (opt[i+1] < 2) {
-				limpk("IP option %u %u len\n",
-				      opt[i], opt[i+1]);
-				return 0;
-			}
-			/* CHECK: oversize options. */
-			else if (i + opt[i+1] > optlen) {
-				limpk("IP option %u at %u too long\n",
-				      opt[i], i);
-				return 0;
-			}
-			/* Move to next option */
-			i +=3D opt[i+1];
-		}
-	}
-
-	/* Fragment checks. */
-
-	/* CHECK: More fragments, but doesn't fill 8-byte boundary. */
-	if ((ntohs(iph.frag_off) & IP_MF)
-	    && (ntohs(iph.tot_len) % 8) !=3D 0) {
-		limpk("Truncated fragment %u long.\n", ntohs(iph.tot_len));
-		return 0;
-	}
-
-	/* CHECK: Oversize fragment a-la Ping of Death. */
-	if (fragoff * 8 + datalen > 65535) {
-		limpk("Oversize fragment to %u.\n", fragoff * 8);
-		return 0;
-	}
-
-	/* CHECK: DF set and fragoff or MF set. */
-	if ((ntohs(iph.frag_off) & IP_DF)
-	    && (fragoff || (ntohs(iph.frag_off) & IP_MF))) {
-		limpk("DF set and offset=3D%u, MF=3D%u.\n",
-		      fragoff, ntohs(iph.frag_off) & IP_MF);
-		return 0;
-	}
-
-	/* CHECK: Zero-sized fragments. */
-	if ((fragoff || (ntohs(iph.frag_off) & IP_MF))
-	    && datalen =3D=3D 0) {
-		limpk("Zero size fragment offset=3D%u\n", fragoff);
-		return 0;
-	}
-
-	/* Note: we can have even middle fragments smaller than this:
-	   consider a large packet passing through a 600MTU then
-	   576MTU link: this gives a fragment of 24 data bytes.  But
-	   everyone packs fragments largest first, hence a fragment
-	   can't START before 576 - MAX_IP_HEADER_LEN. */
-
-	/* Used to be min-size 576: I recall Alan Cox saying ax25 goes
-	   down to 128 (576 taken from RFC 791: All hosts must be
-	   prepared to accept datagrams of up to 576 octets).  Use 128
-	   here. */
-#define MIN_LIKELY_MTU 128
-	/* CHECK: Min size of first frag =3D 128. */
-	if ((ntohs(iph.frag_off) & IP_MF)
-	    && fragoff =3D=3D 0
-	    && ntohs(iph.tot_len) < MIN_LIKELY_MTU) {
-		limpk("First fragment size %u < %u\n", ntohs(iph.tot_len),
-		      MIN_LIKELY_MTU);
-		return 0;
-	}
-
-	/* CHECK: Min offset of frag =3D 128 - IP hdr len. */
-	if (fragoff && fragoff * 8 < MIN_LIKELY_MTU - iph.ihl * 4) {
-		limpk("Fragment starts at %u < %u\n", fragoff * 8,
-		      MIN_LIKELY_MTU - iph.ihl * 4);
-		return 0;
-	}
-
-	/* CHECK: Protocol specification non-zero. */
-	if (iph.protocol =3D=3D 0) {
-		limpk("Zero protocol\n");
-		return 0;
-	}
-
-	/* FIXME: This is already checked for in "Oversize fragment"
-           above --RR */
-	/* CHECK: Do not use what is unused.
-	 * First bit of fragmentation flags should be unused.
-	 * May be used by OS fingerprinting tools.
-	 * 04 Jun 2002, Maciej Soltysiak, solt@dns.toxicfilms.tv
-	 */
-	if (ntohs(iph.frag_off)>>15) {
-		limpk("IP unused bit set\n");
-		return 0;
-	}
-
-	/* Per-protocol checks. */
-	switch (iph.protocol) {
-	case IPPROTO_ICMP:
-		return check_icmp(skb, offset + iph.ihl*4, fragoff,
-				  (ntohs(iph.frag_off) & IP_MF),
-				  embedded);
-
-	case IPPROTO_UDP:
-		return check_udp(skb, offset + iph.ihl*4, fragoff,
-				 (ntohs(iph.frag_off) & IP_MF),
-				 embedded);
-
-	case IPPROTO_TCP:
-		return check_tcp(skb, offset + iph.ihl*4, fragoff,
-				 (ntohs(iph.frag_off) & IP_MF),
-				 embedded);
-	default:
-		/* Ignorance is bliss. */
-		return 1;
-	}
-}
-
-static int
-match(const struct sk_buff *skb,
-      const struct net_device *in,
-      const struct net_device *out,
-      const void *matchinfo,
-      int offset,
-      int *hotdrop)
-{
-	return !check_ip(skb, 0);
-}
-
-/* Called when user tries to insert an entry of this type. */
-static int
-checkentry(const char *tablename,
-	   const struct ipt_ip *ip,
-	   void *matchinfo,
-	   unsigned int matchsize,
-	   unsigned int hook_mask)
-{
-	if (matchsize !=3D IPT_ALIGN(0))
-		return 0;
-
-	return 1;
-}
-
-static struct ipt_match unclean_match =3D {
-	.name		=3D "unclean",
-	.match		=3D &match,
-	.checkentry	=3D &checkentry,
-	.me		=3D THIS_MODULE,
-};
-
-static int __init init(void)
-{
-	return ipt_register_match(&unclean_match);
-}
-
-static void __exit fini(void)
-{
-	ipt_unregister_match(&unclean_match);
-}
-
-module_init(init);
-module_exit(fini);
-MODULE_LICENSE("GPL");
--=20
- Harald Welte <laforge@netfilter.org>             http://www.netfilter.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
  "Fragmentation is like classful addressing -- an interesting early
   architectural error that shows how much experimentation was going
   on while IP was being designed."                    -- Paul Vixie

--IvGM3kKqwtniy32b
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.2 (GNU/Linux)

iD8DBQE/R9peXaXGVTD0i/8RAkxcAKCBlMIaouKQy4pMhpqTVUB5M+w46QCfbTXt
8NA/PTtROR1lj1CXpW+VeAA=
=vYQa
-----END PGP SIGNATURE-----

--IvGM3kKqwtniy32b--
