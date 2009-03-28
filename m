From: "Gabor Z. Papp" <gzp@papp.hu>
Subject: Re: [ANNOUNCE]: Release of iptables-1.4.3.1
Date: Sat, 28 Mar 2009 15:17:09 +0100
Message-ID: <x67i293f6i@gzp>
References: <49C8DB3B.909@netfilter.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter@vger.kernel.org,
	Netfilter Development Mailinglist
	<netfilter-devel@vger.kernel.org>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from odpn1.odpn.net ([212.40.96.53]:48275 "EHLO odpn1.odpn.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754097AbZC1OpN (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 28 Mar 2009 10:45:13 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hello,

trying to compile 1.4.3.1 on Linux 2.4.37:

make  all-recursive
make[1]: Entering directory `/home/gzp/src/iptables-1.4.3.1'
Making all in extensions
make[2]: Entering directory `/home/gzp/src/iptables-1.4.3.1/extensions'
  GEN      initext4.c
  CC       initext4.o
  CC       libxt_CLASSIFY.o
  CC       libxt_CONNMARK.o
  CC       libxt_CONNSECMARK.o
  CC       libxt_DSCP.o
  CC       libxt_MARK.o
  CC       libxt_NFLOG.o
  CC       libxt_NFQUEUE.o
  CC       libxt_NOTRACK.o
  CC       libxt_RATEEST.o
  CC       libxt_SECMARK.o
  CC       libxt_TCPMSS.o
  CC       libxt_TCPOPTSTRIP.o
  CC       libxt_TOS.o
  CC       libxt_TPROXY.o
  CC       libxt_TRACE.o
  CC       libxt_comment.o
  CC       libxt_connbytes.o
  CC       libxt_connlimit.o
  CC       libxt_connmark.o
  CC       libxt_conntrack.o
  CC       libxt_dscp.o
  CC       libxt_esp.o
  CC       libxt_hashlimit.o
  CC       libxt_helper.o
  CC       libxt_iprange.o
  CC       libxt_length.o
  CC       libxt_limit.o
  CC       libxt_mac.o
  CC       libxt_mark.o
  CC       libxt_multiport.o
  CC       libxt_owner.o
  CC       libxt_physdev.o
  CC       libxt_pkttype.o
  CC       libxt_quota.o
  CC       libxt_rateest.o
  CC       libxt_recent.o
  CC       libxt_sctp.o
  CC       libxt_socket.o
  CC       libxt_standard.o
  CC       libxt_state.o
  CC       libxt_statistic.o
  CC       libxt_string.o
  CC       libxt_tcp.o
  CC       libxt_tcpmss.o
  CC       libxt_time.o
  CC       libxt_tos.o
  CC       libxt_u32.o
  CC       libxt_udp.o
  CC       libipt_CLUSTERIP.o
  CC       libipt_DNAT.o
  CC       libipt_ECN.o
  CC       libipt_LOG.o
  CC       libipt_MASQUERADE.o
  CC       libipt_MIRROR.o
  CC       libipt_NETMAP.o
  CC       libipt_REDIRECT.o
  CC       libipt_REJECT.o
  CC       libipt_SAME.o
  CC       libipt_SET.o
  CC       libipt_SNAT.o
  CC       libipt_TTL.o
  CC       libipt_ULOG.o
  CC       libipt_addrtype.o
  CC       libipt_ah.o
  CC       libipt_ecn.o
  CC       libipt_icmp.o
  CC       libipt_policy.o
  CC       libipt_realm.o
  CC       libipt_set.o
  CC       libipt_ttl.o
  CC       libipt_unclean.o
  AR       libext4.a
  GEN      initext6.c
  CC       initext6.o
  CC       libip6t_HL.o
  CC       libip6t_LOG.o
  CC       libip6t_REJECT.o
  CC       libip6t_ah.o
  CC       libip6t_dst.o
  CC       libip6t_eui64.o
  CC       libip6t_frag.o
  CC       libip6t_hbh.o
  CC       libip6t_hl.o
  CC       libip6t_icmp6.o
  CC       libip6t_ipv6header.o
  CC       libip6t_mh.o
  CC       libip6t_policy.o
  CC       libip6t_rt.o
  AR       libext6.a
  GEN      matches4.man
  GEN      matches6.man
  GEN      targets4.man
  GEN      targets6.man
make[2]: Leaving directory `/home/gzp/src/iptables-1.4.3.1/extensions'
Making all in include
make[2]: Entering directory `/home/gzp/src/iptables-1.4.3.1/include'
make[2]: Nothing to be done for `all'.
make[2]: Leaving directory `/home/gzp/src/iptables-1.4.3.1/include'
Making all in libipq
make[2]: Entering directory `/home/gzp/src/iptables-1.4.3.1/libipq'
gcc -DHAVE_CONFIG_H -I. -I..    -D_LARGEFILE_SOURCE=1 -D_LARGE_FILES -D_FILE_OFFSET_BITS=64 	-D_REENTRANT -Wall -Waggregate-return -Wmissing-declarations 	-Wmissing-prototypes -Wredundant-decls -Wshadow -Wstrict-prototypes 	-Winline -pipe 	-DXTABLES_LIBDIR=\"/pkg/lib/xtables\" -DXTABLES_INTERNAL -I../include -I../include -g -O2 -MT libipq.o -MD -MP -MF .deps/libipq.Tpo -c -o libipq.o libipq.c
In file included from libipq.c:36:
../include/linux/netfilter.h:51: error: expected specifier-qualifier-list before '__be32'
make[2]: *** [libipq.o] Error 1
make[2]: Leaving directory `/home/gzp/src/iptables-1.4.3.1/libipq'
make[1]: *** [all-recursive] Error 1
make[1]: Leaving directory `/home/gzp/src/iptables-1.4.3.1'
make: *** [all] Error 2
