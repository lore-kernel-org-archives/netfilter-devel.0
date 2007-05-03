From: Patrick McHardy <kaber@trash.net>
Subject: [NETFILTER 00/04]: Netfilter update
Date: Thu,  3 May 2007 03:25:56 +0200 (MEST)
Message-ID: <20070503012437.12818.39126.sendpatchset@localhost.localdomain>
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

these patches include Herbert's SIP fix, the GRE memory corruption fix,
a change to the DNAT target to accept the port randomization option
and some small bridge netfilter cleanup.

Please apply, thanks.


 include/linux/netfilter/nf_conntrack_proto_gre.h |   18 ---
 include/linux/netfilter_bridge.h                 |   25 ++--
 net/bridge/br_netfilter.c                        |  138 ++++++-----------------
 net/ipv4/netfilter/nf_nat_proto_gre.c            |   20 +--
 net/ipv4/netfilter/nf_nat_rule.c                 |    4 
 net/ipv4/netfilter/nf_nat_sip.c                  |   26 ++++
 6 files changed, 89 insertions(+), 142 deletions(-)

Herbert Xu (1):
      [NETFILTER]: sip: Fix RTP address NAT

Jorge Boncompte (1):
      [NETFILTER]: nf_nat_proto_gre: do not modify/corrupt GREv0 packets through NAT

Patrick McHardy (2):
      [NETFILTER]: ipt_DNAT: accept port randomization option
      [NETFILTER]: bridge netfilter: consolidate header pushing/pulling code
