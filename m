From: Patrick McHardy <kaber@trash.net>
Subject: [NETFILTER 00/03]: Netfilter fixes
Date: Mon,  6 Aug 2007 15:29:03 +0200 (MEST)
Message-ID: <20070806132844.17202.50621.sendpatchset@localhost.localdomain>
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

these patches fix a few netfilter bugs: failure to load IPv4 connection tracking
when loading the NAT module, an invalid return code in ctnetlink and a possible
NULL pointer dereference in ipt_recent. I'll pass the NULL pointer fix to
-stable once its upstream.

Please apply, thanks.


 include/net/netfilter/ipv4/nf_conntrack_ipv4.h |    2 ++
 net/ipv4/netfilter/ipt_recent.c                |    7 ++++++-
 net/ipv4/netfilter/nf_conntrack_l3proto_ipv4.c |    6 ++++++
 net/ipv4/netfilter/nf_nat_standalone.c         |    2 +-
 net/netfilter/nf_conntrack_netlink.c           |   17 +++++++++--------
 5 files changed, 24 insertions(+), 10 deletions(-)

Jesper Juhl (1):
      [NETFILTER]: ipt_recent: avoid a possible NULL pointer deref in recent_seq_open()

Pablo Neira Ayuso (1):
      [NETFILTER]: ctnetlink: return EEXIST instead of EINVAL for existing nat'ed conntracks

Patrick McHardy (1):
      [NETFILTER]: nf_nat: add symbolic dependency on IPv4 conntrack
