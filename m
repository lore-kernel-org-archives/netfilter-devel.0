From: Patrick McHardy <kaber@trash.net>
Subject: [NETFILTER 00/03]: Netfilter fixes
Date: Thu, 25 Jan 2007 01:21:56 +0100 (MET)
Message-ID: <20070125002156.1883.33845.sendpatchset@localhost.localdomain>
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

following are three netfilter fixes for 2.6.20, fixing a problem with ICMP
translation in the new nf_nat code and two bugs in the new PPTP helper port
breaking NAT of PPTP connections.

Please apply, thanks.


 net/ipv4/netfilter/Makefile       |   20 ++++++++++----------
 net/ipv4/netfilter/nf_nat_pptp.c  |    4 ++--
 net/netfilter/nf_conntrack_pptp.c |    2 +-
 3 files changed, 13 insertions(+), 13 deletions(-)

Patrick McHardy:
      [NETFILTER]: nf_nat: fix ICMP translation with statically linked conntrack
      [NETFILTER]: nf_nat_pptp: fix expectation removal
      [NETFILTER]: nf_conntrack_pptp: fix NAT setup of expected GRE connections
