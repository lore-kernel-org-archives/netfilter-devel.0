From: Patrick McHardy <kaber@trash.net>
Subject: [NETFILTER 00/20]: Netfilter Update part II
Date: Sat,  2 Dec 2006 15:49:36 +0100 (MET)
Message-ID: <20061202145241.1381.88698.sendpatchset@localhost.localdomain>
Cc: netfilter-devel@lists.netfilter.org, Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: davem@davemloft.net
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

Hi Dave,

following is part two of my netfilter update for 2.6.20, containing
NAT support for nf_conntrack and ports of all conntrack/NAT helpers.
With these patches nf_conntrack is finally a full replacement for
ip_conntrack, which is now scheduled for removal in 2.6.22 after some
stabilization of the new code.

You can also pull these patches from
http://people.netfilter.org/~kaber/nf-2.6.20-nat.git

Please apply, thanks.


 Documentation/feature-removal-schedule.txt                    |    9 
 include/linux/inet.h                                          |    4 
 include/linux/netfilter.h                                     |    2 
 include/linux/netfilter/nf_conntrack_amanda.h                 |   10 
 include/linux/netfilter/nf_conntrack_ftp.h                    |   20 
 include/linux/netfilter/nf_conntrack_h323.h                   |   92 
 include/linux/netfilter/nf_conntrack_h323_asn1.h              |   98 
 include/linux/netfilter/nf_conntrack_h323_types.h             |  951 ++++
 include/linux/netfilter/nf_conntrack_irc.h                    |   15 
 include/linux/netfilter/nf_conntrack_pptp.h                   |  321 +
 include/linux/netfilter/nf_conntrack_proto_gre.h              |  112 
 include/linux/netfilter/nf_conntrack_sip.h                    |   41 
 include/linux/netfilter/nf_conntrack_tftp.h                   |   20 
 include/linux/netfilter_ipv4/Kbuild                           |    2 
 include/linux/netfilter_ipv4/ip_conntrack_ftp.h               |   40 
 include/linux/netfilter_ipv4/ip_conntrack_h323.h              |    2 
 include/linux/netfilter_ipv4/ip_conntrack_helper_h323_asn1.h  |   98 
 include/linux/netfilter_ipv4/ip_conntrack_helper_h323_types.h |  939 ----
 include/net/netfilter/ipv4/nf_conntrack_ipv4.h                |   22 
 include/net/netfilter/nf_conntrack.h                          |   38 
 include/net/netfilter/nf_conntrack_expect.h                   |   10 
 include/net/netfilter/nf_conntrack_helper.h                   |    2 
 include/net/netfilter/nf_conntrack_tuple.h                    |   34 
 include/net/netfilter/nf_nat.h                                |   77 
 include/net/netfilter/nf_nat_core.h                           |   27 
 include/net/netfilter/nf_nat_helper.h                         |   32 
 include/net/netfilter/nf_nat_protocol.h                       |   70 
 include/net/netfilter/nf_nat_rule.h                           |   35 
 net/core/utils.c                                              |   10 
 net/ipv4/netfilter/Kconfig                                    |  123 
 net/ipv4/netfilter/Makefile                                   |   24 
 net/ipv4/netfilter/ip_conntrack_helper_h323_asn1.c            |  874 ----
 net/ipv4/netfilter/ip_conntrack_helper_h323_types.c           | 1926 ---------
 net/ipv4/netfilter/ip_nat_proto_icmp.c                        |    4 
 net/ipv4/netfilter/ip_nat_standalone.c                        |    6 
 net/ipv4/netfilter/ipt_MASQUERADE.c                           |   29 
 net/ipv4/netfilter/ipt_NETMAP.c                               |    4 
 net/ipv4/netfilter/ipt_REDIRECT.c                             |    6 
 net/ipv4/netfilter/ipt_SAME.c                                 |   12 
 net/ipv4/netfilter/nf_conntrack_l3proto_ipv4.c                |   23 
 net/ipv4/netfilter/nf_conntrack_proto_icmp.c                  |    5 
 net/ipv4/netfilter/nf_nat_amanda.c                            |   78 
 net/ipv4/netfilter/nf_nat_core.c                              |  647 +++
 net/ipv4/netfilter/nf_nat_ftp.c                               |  179 
 net/ipv4/netfilter/nf_nat_h323.c                              |  596 +++
 net/ipv4/netfilter/nf_nat_helper.c                            |  433 ++
 net/ipv4/netfilter/nf_nat_irc.c                               |  101 
 net/ipv4/netfilter/nf_nat_pptp.c                              |  315 +
 net/ipv4/netfilter/nf_nat_proto_gre.c                         |  179 
 net/ipv4/netfilter/nf_nat_proto_icmp.c                        |   86 
 net/ipv4/netfilter/nf_nat_proto_tcp.c                         |  148 
 net/ipv4/netfilter/nf_nat_proto_udp.c                         |  138 
 net/ipv4/netfilter/nf_nat_proto_unknown.c                     |   54 
 net/ipv4/netfilter/nf_nat_rule.c                              |  343 +
 net/ipv4/netfilter/nf_nat_sip.c                               |  283 +
 net/ipv4/netfilter/nf_nat_snmp_basic.c                        | 1332 ++++++
 net/ipv4/netfilter/nf_nat_standalone.c                        |  406 ++
 net/ipv4/netfilter/nf_nat_tftp.c                              |   52 
 net/ipv6/netfilter/Kconfig                                    |    2 
 net/ipv6/netfilter/nf_conntrack_proto_icmpv6.c                |    2 
 net/ipv6/netfilter/nf_conntrack_reasm.c                       |   26 
 net/netfilter/Kconfig                                         |  170 
 net/netfilter/Makefile                                        |   10 
 net/netfilter/nf_conntrack_amanda.c                           |  237 +
 net/netfilter/nf_conntrack_core.c                             |   84 
 net/netfilter/nf_conntrack_ecache.c                           |    6 
 net/netfilter/nf_conntrack_expect.c                           |   78 
 net/netfilter/nf_conntrack_ftp.c                              |   32 
 net/netfilter/nf_conntrack_h323_asn1.c                        |  874 ++++
 net/netfilter/nf_conntrack_h323_main.c                        | 1856 +++++++++
 net/netfilter/nf_conntrack_h323_types.c                       | 1927 ++++++++++
 net/netfilter/nf_conntrack_helper.c                           |   17 
 net/netfilter/nf_conntrack_irc.c                              |  281 +
 net/netfilter/nf_conntrack_netbios_ns.c                       |  125 
 net/netfilter/nf_conntrack_netlink.c                          |   85 
 net/netfilter/nf_conntrack_pptp.c                             |  607 +++
 net/netfilter/nf_conntrack_proto.c                            |   12 
 net/netfilter/nf_conntrack_proto_gre.c                        |  305 +
 net/netfilter/nf_conntrack_proto_sctp.c                       |    3 
 net/netfilter/nf_conntrack_proto_tcp.c                        |   17 
 net/netfilter/nf_conntrack_proto_udp.c                        |    5 
 net/netfilter/nf_conntrack_sip.c                              |  530 ++
 net/netfilter/nf_conntrack_standalone.c                       |   79 
 net/netfilter/nf_conntrack_tftp.c                             |  159 
 84 files changed, 14937 insertions(+), 4131 deletions(-)

Patrick McHardy:
      [NET]: Accept wildcard delimiters in in[46]_pton
      [NETFILTER]: nf_conntrack: fix NF_CONNTRACK_PROC_COMPAT dependency
      [NETFILTER]: nf_conntrack: fix helper structure alignment
      [NETFILTER]: nf_conntrack: endian annotations
      [NETFILTER]: nf_conntrack: automatic helper assignment for expectations
      [NETFILTER]: Kconfig: improve conntrack selection
      [NETFILTER]: nf_conntrack: add module aliases to IPv4 conntrack names
      [NETFILTER]: Add NAT support for nf_conntrack
      [NETFILTER]: nf_nat: add FTP NAT helper port
      [NETFILTER]: nf_conntrack: add helper function for expectation initialization
      [NETFILTER]: nf_conntrack/nf_nat: add amanda helper port
      [NETFILTER]: nf_conntrack/nf_nat: add H.323 helper port
      [NETFILTER]: nf_conntrack/nf_nat: add IRC helper port
      [NETFILTER]: nf_conntrack: add NetBIOS name service helper port
      [NETFILTER]: nf_conntrack/nf_nat: add PPTP helper port
      [NETFILTER]: nf_conntrack/nf_nat: add SIP helper port
      [NETFILTER]: nf_conntrack/nf_nat: add TFTP helper port
      [NETFILTER]: nf_nat: add SNMP NAT helper port
      [NETFILTER]: Mark old IPv4-only connection tracking scheduled for removal
      [NETFILTER]: nf_conntrack: EXPORT_SYMBOL cleanup
