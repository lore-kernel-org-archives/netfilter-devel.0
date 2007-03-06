From: Patrick McHardy <kaber@trash.net>
Subject: [NETFILTER 00/03]: Netfilter fixes
Date: Tue,  6 Mar 2007 08:44:01 +0100 (MET)
Message-ID: <20070306074400.24479.43171.sendpatchset@localhost.localdomain>
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

following are three more patches for some nasty netfilter bugs, fixing incorrect
conntrack classification of IPv6 fragments, a crash in nfnetlink_log with briding
and a missing terminating zero-byte in the nfnetlink_log prefix message.

Please apply, thanks.


 net/ipv6/netfilter/nf_conntrack_l3proto_ipv6.c |    1 +
 net/netfilter/nfnetlink_log.c                  |    4 ++--
 2 files changed, 3 insertions(+), 2 deletions(-)

Patrick McHardy:
      [NETFILTER]: nf_conntrack: fix incorrect classification of IPv6 fragments as ESTABLISHED
      [NETFILTER]: nfnetlink_log: zero-terminate prefix
      [NETFILTER]: nfnetlink_log: fix crash on bridged packet
