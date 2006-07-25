From: Patrick McHardy <kaber@trash.net>
Subject: [NETFILTER 00/06]: Netfilter fixes
Date: Tue, 25 Jul 2006 05:26:54 +0200 (MEST)
Message-ID: <20060725032653.25063.8139.sendpatchset@localhost.localdomain>
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

following are a few small netfilter fixes and a patch to finally
add the bridge netfilter deferred hooks to feature-removal-schedule
and disable them by default, which classifies as a huge bugfix in
my opinion :)

Please apply, thanks.


 Documentation/feature-removal-schedule.txt   |   16 ++++++++++++++++
 include/linux/netfilter_bridge.h             |    2 ++
 net/bridge/br_netfilter.c                    |    5 +++++
 net/ipv4/netfilter/ip_conntrack_standalone.c |    4 ++--
 net/ipv4/netfilter/ip_nat_snmp_basic.c       |    4 ++--
 net/netfilter/Kconfig                        |    4 ++--
 net/netfilter/nf_conntrack_standalone.c      |    4 ++--
 net/netfilter/nf_queue.c                     |    9 ++++-----
 net/netfilter/xt_physdev.c                   |   15 +++++++++++++++
 net/netfilter/xt_pkttype.c                   |   12 +++++++++++-
 10 files changed, 61 insertions(+), 14 deletions(-)

Adrian Bunk:
      [NETFILTER]: conntrack: fix SYSCTL=n compile

Patrick McHardy:
      [NETFILTER]: nf_queue: handle NF_STOP and unknown verdicts in nf_reinject
      [NETFILTER]: SNMP NAT: fix byteorder confusion
      [NETFILTER]: bridge netfilter: add deferred output hooks to feature-removal-schedule
      [NETFILTER]: Demote xt_sctp to EXPERIMENTAL

Phil Oester:
      [NETFILTER]: xt_pkttype: fix mismatches on locally generated packets
