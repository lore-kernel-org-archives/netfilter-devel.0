From: Nick Pasich <NewsLetters@NickAndBarb.net>
Subject: geoip won't compile on 2.6.22
Date: Tue, 10 Jul 2007 19:23:11 -0700
Message-ID: <20070711022311.GA31144@69.17.112.251>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@lists.netfilter.org
To: Samuel Jean <jix@bugmachine.ca>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
Content-Disposition: inline
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

Samuel,

Geoip has problems when compiling for Linux Kernel 2.6.22

Geoip is a great module....

     Thanks,

     Nick Pasich

*************************************************************************
*************************************************************************


  CC      net/ipv4/netfilter.o
  LD      net/ipv4/netfilter/built-in.o
  CC [M]  net/ipv4/netfilter/nf_nat_rule.o
  CC [M]  net/ipv4/netfilter/nf_nat_standalone.o
  CC [M]  net/ipv4/netfilter/nf_conntrack_l3proto_ipv4.o
  CC [M]  net/ipv4/netfilter/nf_conntrack_proto_icmp.o
  CC [M]  net/ipv4/netfilter/nf_conntrack_l3proto_ipv4_compat.o
  CC [M]  net/ipv4/netfilter/nf_nat_core.o
  CC [M]  net/ipv4/netfilter/nf_nat_helper.o
  CC [M]  net/ipv4/netfilter/nf_nat_proto_unknown.o
  CC [M]  net/ipv4/netfilter/nf_nat_proto_tcp.o
  CC [M]  net/ipv4/netfilter/nf_nat_proto_udp.o
  CC [M]  net/ipv4/netfilter/nf_nat_proto_icmp.o
  LD [M]  net/ipv4/netfilter/nf_conntrack_ipv4.o
  LD [M]  net/ipv4/netfilter/nf_nat.o
  CC [M]  net/ipv4/netfilter/nf_nat_ftp.o
  CC [M]  net/ipv4/netfilter/nf_nat_snmp_basic.o
  CC [M]  net/ipv4/netfilter/nf_nat_tftp.o
  CC [M]  net/ipv4/netfilter/ip_tables.o
  CC [M]  net/ipv4/netfilter/iptable_filter.o
  CC [M]  net/ipv4/netfilter/iptable_mangle.o
  LD [M]  net/ipv4/netfilter/iptable_nat.o
  CC [M]  net/ipv4/netfilter/iptable_raw.o
  CC [M]  net/ipv4/netfilter/ipt_iprange.o
  CC [M]  net/ipv4/netfilter/ipt_owner.o
  CC [M]  net/ipv4/netfilter/ipt_tos.o
  CC [M]  net/ipv4/netfilter/ipt_recent.o
  CC [M]  net/ipv4/netfilter/ipt_geoip.o
net/ipv4/netfilter/ipt_geoip.c: In function `match':
net/ipv4/netfilter/ipt_geoip.c:113: error: structure has no member named `nh'
net/ipv4/netfilter/ipt_geoip.c: In function `init':
net/ipv4/netfilter/ipt_geoip.c:291: warning: implicit declaration of function `ipt_register_match'
net/ipv4/netfilter/ipt_geoip.c: In function `fini':
net/ipv4/netfilter/ipt_geoip.c:296: warning: implicit declaration of function `ipt_unregister_match'
make[3]: *** [net/ipv4/netfilter/ipt_geoip.o] Error 1
make[2]: *** [net/ipv4/netfilter] Error 2
make[1]: *** [net/ipv4] Error 2
make: *** [net] Error 2

*************************************************************************
*************************************************************************
