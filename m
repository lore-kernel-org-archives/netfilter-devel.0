From: Patrick McHardy <kaber@trash.net>
Subject: [00/06]: Netfilter fixes for 2.6.16
Date: Sat, 25 Feb 2006 14:17:30 +0100 (MET)
Message-ID: <20060225131547.7400.12127.sendpatchset@localhost.localdomain>
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

following are a couple fixes for 2.6.16. mostly concerning nf_queue.
Please apply.


 include/linux/netfilter_bridge/ebt_log.h |    1 
 include/linux/netfilter_ipv4/ipt_LOG.h   |    3 +
 include/linux/netfilter_ipv6/ip6t_LOG.h  |    3 +
 net/bridge/netfilter/ebt_log.c           |    7 +++
 net/ipv4/netfilter/ipt_LOG.c             |    7 +++
 net/ipv6/netfilter/ip6t_LOG.c            |    7 +++
 net/netfilter/nf_queue.c                 |   58 ++++++++++++++-----------------
 7 files changed, 51 insertions(+), 35 deletions(-)

Patrick McHardy:
      [NETFILTER]: nf_queue: don't copy registered rerouter data
      [NETFILTER]: nf_queue: check if rerouter is present before using it
      [NETFILTER]: nf_queue: fix rerouting after packet mangling
      [NETFILTER]: nf_queue: remove unnecessary check for outfn
      [NETFILTER]: nf_queue: fix end-of-list check
      [NETFILTER]: Restore {ipt,ip6t,ebt}_LOG compatibility
