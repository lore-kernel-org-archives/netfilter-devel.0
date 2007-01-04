From: Patrick McHardy <kaber@trash.net>
Subject: [NETFILTER 00/05]: Netfilter fixes
Date: Thu,  4 Jan 2007 19:38:20 +0100 (MET)
Message-ID: <20070104183820.18369.3658.sendpatchset@localhost.localdomain>
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

following are a few important netfilter fixes for 2.6.20, fixing a
REJECT target regression in 2.6.19, a nf_nat crash and an ebtables
crash. Also included are two patches to use the correct type for
iptables compat offsets and remove the EXPERIMENTAL mark from
nf_conntrack.

Please apply, thanks.


 net/bridge/netfilter/ebtables.c     |    3 ++-
 net/ipv4/netfilter.c                |    7 +++++--
 net/ipv4/netfilter/Kconfig          |    4 ++--
 net/ipv4/netfilter/ip_tables.c      |   10 +++++-----
 net/ipv4/netfilter/ipt_MASQUERADE.c |    5 ++++-
 net/netfilter/Kconfig               |   25 ++++++++++++-------------
 6 files changed, 30 insertions(+), 24 deletions(-)

Chuck Ebbert:
      [NETFILTER]: ebtables: don't compute gap before checking struct type

Dmitry Mishin:
      [NETFILTER]: compat offsets size change

Martin Josefsson:
      [NETFILTER]: nf_nat: fix MASQUERADE crash on device down

Patrick McHardy:
      [NETFILTER]: Fix routing of REJECT target generated packets in output chain
      [NETFILTER]: New connection tracking is not EXPERIMENTAL anymore
