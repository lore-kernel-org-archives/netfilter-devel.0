From: Patrick McHardy <kaber@trash.net>
Subject: [NETFILTER 00/03]: -stable fixes
Date: Mon,  4 Dec 2006 12:22:06 +0100 (MET)
Message-ID: <20061204112515.14395.20257.sendpatchset@localhost.localdomain>
Cc: netfilter-devel@lists.netfilter.org, Patrick McHardy <kaber@trash.net>,
	davem@davemloft.net
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: stable@kernel.org
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

These three patches fix two critical ruleset validation bugs in iptables
as well as martian handling in the bridge netfilter code. The first two
patches are already queued for stable-2.6.18. but unfortunately didn't
make 2.6.19 in time.

Please apply to stable-2.6.19. Thanks.


 net/bridge/br_netfilter.c       |   36 +++++++--
 net/ipv4/netfilter/arp_tables.c |   48 ++++++-------
 net/ipv4/netfilter/ip_tables.c  |  146 ++++++++++++++++++++--------------------
 net/ipv6/netfilter/ip6_tables.c |   59 ++++++----------
 4 files changed, 151 insertions(+), 138 deletions(-)

Bart De Schuymer:
      [NETFILTER]: bridge netfilter: deal with martians correctly

Dmitry Mishin:
      [NETFILTER]: Fix {ip,ip6,arp}_tables hook validation
      [NETFILTER]: Fix iptables compat hook validation
