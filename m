From: Patrick McHardy <kaber@trash.net>
Subject: [NETFILTER 00/06]: Netfilter update
Date: Fri, 13 Apr 2007 05:00:08 +0200 (MEST)
Message-ID: <20070413025923.29875.68909.sendpatchset@localhost.localdomain>
Cc: netfilter-devel@lists.netfilter.org, Patrick McHardy <kaber@trash.net>
To: davem@davemloft.net
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
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

following are a few netfilter patches for 2.6.22, adding support for filtering
encapsulated PPPoE and gratuitous ARP packets in bridge netfilter, compat
support for ipt_ULOG (as mentioned in the other thread, 32 bit userspace can
already deal with log messages sent by a 64 bit kernel, but the kernel
currently does not support adding new rules from a 32 bit iptables binary),
some misc netfilter logging cleanup and support for using HW checksumming
for forwarded packets mangled by NAT helpers.

Please apply, thanks.



 Documentation/networking/ip-sysctl.txt   |    7 ++
 include/linux/if_pppox.h                 |    3 +
 include/linux/netfilter_bridge.h         |   11 +++-
 include/linux/netfilter_bridge/ebt_arp.h |    4 +
 include/linux/sysctl.h                   |    1 
 net/bridge/br_netfilter.c                |   77 +++++++++++++++++++++++++++++--
 net/bridge/netfilter/ebt_arp.c           |   48 ++++++++-----------
 net/bridge/netfilter/ebt_log.c           |   12 +---
 net/ipv4/netfilter/ipt_LOG.c             |   12 +---
 net/ipv4/netfilter/ipt_ULOG.c            |   40 ++++++++++++++++
 net/ipv4/netfilter/nf_nat_helper.c       |   49 ++++++++++++++-----
 net/ipv6/netfilter/ip6t_LOG.c            |   12 +---
 net/netfilter/nfnetlink_log.c            |    5 --
 13 files changed, 206 insertions(+), 75 deletions(-)

Bart De Schuymer (1):
      [NETFILTER]: ebt_arp: add gratuitous arp filtering

Michael Milner (1):
      [NETFILTER]: bridge-nf: filter bridged IPv4/IPv6 encapsulated in pppoe traffic

Patrick McHardy (4):
      [NETFILTER]: nf_nat: use HW checksumming when possible
      [NETFILTER]: {eb,ip6,ip}t_LOG: remove remains of LOG target overloading
      [NETFILTER]: nfnetlink_log: remove fallback to group 0
      [NETFILTER]: ipt_ULOG: add compat conversion functions
