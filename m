From: Patrick McHardy <kaber@trash.net>
Subject: [NETFILTER 00/07]: Netfilter fixes for 2.6.17
Date: Fri, 21 Apr 2006 03:06:48 +0200 (MEST)
Message-ID: <20060421010648.8466.94593.sendpatchset@localhost.localdomain>
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

following are a couple of netfilter fixes for 2.6.17. The whitespace
problem is fixed now, apparently sed doesn't understand \t. I guess
I'm lucky that it didn't start stripping trailing t's :)


 include/linux/netfilter/x_tables.h           |    4 ++++
 net/ipv4/netfilter/Kconfig                   |    2 +-
 net/ipv6/netfilter/ip6_tables.c              |   13 -------------
 net/netfilter/nf_conntrack_core.c            |   15 ++++-----------
 net/netfilter/nf_conntrack_l3proto_generic.c |    1 -
 net/netfilter/x_tables.c                     |    2 +-
 net/sched/act_ipt.c                          |    5 +++++
 7 files changed, 15 insertions(+), 27 deletions(-)

Dmitry Mishin:
      [NETFILTER]: x_tables: move table->lock initialization

Patrick McHardy:
      [NETFILTER]: Fix compat_xt_counters alignment for non-x86
      [NETFILTER]: ip6_tables: remove broken comefrom debugging
      [NETFILTER]: ipt action: use xt_check_target for basic verification

Thomas Voegtle:
      [NETFILTER]: ULOG target is not obsolete

Yasuyuki Kozakai:
      [NETFILTER]: nf_conntrack: Fix module refcount dropping too far
      [NETFILTER]: nf_conntrack: kill unused callback init_conntrack
