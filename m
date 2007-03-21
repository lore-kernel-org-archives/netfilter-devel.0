From: Patrick McHardy <kaber@trash.net>
Subject: [NETFILTER 00/02]: Netfilter fixes for 2.6.21
Date: Wed, 21 Mar 2007 06:21:44 +0100 (MET)
Message-ID: <20070321052119.6534.84898.sendpatchset@localhost.localdomain>
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

these two patches add a missing Kconfig dependency on NAT for nf_conntrack_netlink
and fix a problem with ping -I to a destination without a route in combination with
CONFIG_XFRM.

Please apply, thanks.


 net/ipv4/netfilter/ip_nat_standalone.c |   15 +++++++++------
 net/ipv4/netfilter/nf_nat_standalone.c |   14 ++++++++------
 net/netfilter/Kconfig                  |    1 +
 3 files changed, 18 insertions(+), 12 deletions(-)

Patrick McHardy:
      [NETFILTER]: nf_conntrack_netlink: add missing dependency on NF_NAT
      [NETFILTER]: nat: avoid rerouting packets if only XFRM policy key changed
