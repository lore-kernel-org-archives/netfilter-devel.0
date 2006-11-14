From: Patrick McHardy <kaber@trash.net>
Subject: [NETFILTER 00/04]: Netfilter fixes
Date: Tue, 14 Nov 2006 08:03:26 +0100 (MET)
Message-ID: <20061114070325.13023.10720.sendpatchset@localhost.localdomain>
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

following a few netfilter fixes for 2.6.19, fixing invalid use of skb_trim
in netfilter userspace queueing, conflicting optname values for ip6tables
revision support and another byteorder problem in nfnetlink_log.

Please apply, thanks.


 include/linux/in6.h                       |   12 +++++++++++-
 include/linux/netfilter/x_tables.h        |   16 ----------------
 include/linux/netfilter_arp/arp_tables.h  |   25 +++++++++++++------------
 include/linux/netfilter_ipv4/ip_tables.h  |   27 +++++++++++++++------------
 include/linux/netfilter_ipv6/ip6_tables.h |   27 +++++++++++++++------------
 net/ipv4/netfilter/ip_queue.c             |    7 ++++---
 net/ipv6/netfilter/ip6_queue.c            |    7 ++++---
 net/ipv6/netfilter/ip6_tables.c           |    2 +-
 net/netfilter/nfnetlink_log.c             |    2 +-
 net/netfilter/nfnetlink_queue.c           |    7 ++++---
 10 files changed, 68 insertions(+), 64 deletions(-)

Patrick McHardy:
      [NETFILTER]: nfnetlink_log: fix byteorder of NFULA_SEQ_GLOBAL
      [NETFILTER]: Use pskb_trim in {ip,ip6,nfnetlink}_queue
      [NETFILTER]: ip6_tables: use correct nexthdr value in ipv6_find_hdr()

Yasuyuki Kozakai:
      [NETFILTER]: ip6_tables: fixed conflicted optname for getsockopt
