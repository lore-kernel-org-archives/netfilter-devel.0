From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 00/14] Netfilter fixes for net
Date: Tue,  6 Nov 2018 00:28:18 +0100
Message-ID: <20181105232832.21896-1-pablo@netfilter.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Cc: davem@davemloft.net, netdev@vger.kernel.org
To: netfilter-devel@vger.kernel.org
Return-path: <netdev-owner@vger.kernel.org>
Sender: netdev-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

Hi David,

The following patchset contains the first batch of Netfilter fixes for
your net tree:

1) Fix splat with IPv6 defragmenting locally generated fragments,
   from Florian Westphal.

2) Fix Incorrect check for missing attribute in nft_osf.

3) Missing INT_MIN & INT_MAX definition for netfilter bridge uapi
   header, from Jiri Slaby.

4) Revert map lookup in nft_numgen, this is already possible with
   the existing infrastructure without this extension.

5) Fix wrong listing of set reference counter, make counter
   synchronous again, from Stefano Brivio.

6) Fix CIDR 0 in hash:net,port,net, from Eric Westbrook.

7) Fix allocation failure with large set, use kvcalloc().
   From Andrey Ryabinin.

8) No need to disable BH when fetch ip set comment, patch from
   Jozsef Kadlecsik.

9) Sanity check for valid sysfs entry in xt_IDLETIMER, from
   Taehee Yoo.

10) Fix suspicious rcu usage via ip_set() macro at netlink dump,
    from Jozsef Kadlecsik.

11) Fix setting default timeout via nfnetlink_cttimeout, this
    comes with preparation patch to add nf_{tcp,udp,...}_pernet()
    helper.

12) Allow ebtables table nat to be of filter type via nft_compat.
    From Florian Westphal.

13) Incorrect calculation of next bucket in early_drop, do no bump
    hash value, update bucket counter instead. From Vasily Khoruzhick.

You can pull these changes from:

  git://git.kernel.org/pub/scm/linux/kernel/git/pablo/nf.git

Thanks!

----------------------------------------------------------------

The following changes since commit 4f3ebb04d05fe36f74ef17c6ee06559626d47964:

  Merge branch '100GbE' of git://git.kernel.org/pub/scm/linux/kernel/git/jkirsher/net-queue (2018-10-24 16:27:33 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/pablo/nf.git HEAD

for you to fetch changes up to f393808dc64149ccd0e5a8427505ba2974a59854:

  netfilter: conntrack: fix calculation of next bucket number in early_drop (2018-11-03 14:16:28 +0100)

----------------------------------------------------------------
Andrey Ryabinin (1):
      netfilter: ipset: fix ip_set_list allocation failure

Eric Westbrook (1):
      netfilter: ipset: actually allow allowable CIDR 0 in hash:net,port,net

Florian Westphal (2):
      netfilter: ipv6: fix oops when defragmenting locally generated fragments
      netfilter: nft_compat: ebtables 'nat' table is normal chain type

Jiri Slaby (1):
      netfilter: bridge: define INT_MIN & INT_MAX in userspace

Jozsef Kadlecsik (2):
      netfilter: ipset: Correct rcu_dereference() call in ip_set_put_comment()
      netfilter: ipset: Fix calling ip_set() macro at dumping

Pablo Neira Ayuso (4):
      netfilter: nft_osf: check if attribute is present
      Revert "netfilter: nft_numgen: add map lookups for numgen random operations"
      netfilter: conntrack: add nf_{tcp,udp,sctp,icmp,dccp,icmpv6,generic}_pernet()
      netfilter: nfnetlink_cttimeout: pass default timeout policy to obj_to_nlattr

Stefano Brivio (1):
      netfilter: ipset: list:set: Decrease refcount synchronously on deletion and replace

Taehee Yoo (1):
      netfilter: xt_IDLETIMER: add sysfs filename checking routine

Vasily Khoruzhick (1):
      netfilter: conntrack: fix calculation of next bucket number in early_drop

 include/linux/netfilter/ipset/ip_set.h         |   2 +-
 include/linux/netfilter/ipset/ip_set_comment.h |   4 +-
 include/net/netfilter/nf_conntrack_l4proto.h   |  39 ++++++++
 include/uapi/linux/netfilter/nf_tables.h       |   4 +-
 include/uapi/linux/netfilter_bridge.h          |   4 +
 net/ipv6/netfilter/nf_conntrack_reasm.c        |  13 ++-
 net/netfilter/ipset/ip_set_core.c              |  43 +++++----
 net/netfilter/ipset/ip_set_hash_netportnet.c   |   8 +-
 net/netfilter/ipset/ip_set_list_set.c          |  17 ++--
 net/netfilter/nf_conntrack_core.c              |  13 ++-
 net/netfilter/nf_conntrack_proto_dccp.c        |  13 +--
 net/netfilter/nf_conntrack_proto_generic.c     |  11 +--
 net/netfilter/nf_conntrack_proto_icmp.c        |  11 +--
 net/netfilter/nf_conntrack_proto_icmpv6.c      |  11 +--
 net/netfilter/nf_conntrack_proto_sctp.c        |  11 +--
 net/netfilter/nf_conntrack_proto_tcp.c         |  15 +--
 net/netfilter/nf_conntrack_proto_udp.c         |  11 +--
 net/netfilter/nfnetlink_cttimeout.c            |  47 +++++++--
 net/netfilter/nft_compat.c                     |  21 ++--
 net/netfilter/nft_numgen.c                     | 127 -------------------------
 net/netfilter/nft_osf.c                        |   2 +-
 net/netfilter/xt_IDLETIMER.c                   |  20 ++++
 22 files changed, 200 insertions(+), 247 deletions(-)
