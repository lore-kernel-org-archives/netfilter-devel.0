From: Patrick McHardy <kaber@trash.net>
Subject: [NETFITER 00/03]: Netfilter fixes/cleanup
Date: Tue, 24 Jul 2007 17:54:12 +0200 (MEST)
Message-ID: <20070724155342.18487.35001.sendpatchset@localhost.localdomain>
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

These patches fix a log target regression in 2.6.22, causing failures to
load ipt_LOG/ ipt_ULOG when the other one is already loaded and clean
up a couple of duplicate includes. I'll send the regression fix to -stable
once its upstream.

Please apply, thanks.


 net/bridge/netfilter/ebt_log.c             |    7 ++-----
 net/bridge/netfilter/ebt_ulog.c            |    9 ++-------
 net/ipv4/netfilter/ipt_LOG.c               |    6 ++----
 net/ipv6/netfilter/ip6t_LOG.c              |    6 ++----
 net/netfilter/nf_conntrack_proto_tcp.c     |    1 -
 net/netfilter/nf_conntrack_proto_udp.c     |    1 -
 net/netfilter/nf_conntrack_proto_udplite.c |    1 -
 net/netfilter/xt_physdev.c                 |    1 -
 8 files changed, 8 insertions(+), 24 deletions(-)

Jesper Juhl (2):
      [NETFILTER]: Clean up duplicate includes in net/bridge/
      [NETFILTER]: Clean up duplicate includes in net/netfilter/

Patrick McHardy (1):
      [NETFILTER]: Fix logging regression
