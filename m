From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 0/9] Netfilter fixes for net
Date: Sat, 29 Dec 2018 13:57:54 +0100
Message-ID: <20181229125803.7415-1-pablo@netfilter.org>
Cc: davem@davemloft.net, netdev@vger.kernel.org
To: netfilter-devel@vger.kernel.org
Return-path: <netdev-owner@vger.kernel.org>
Sender: netdev-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

Hi David,

The following patchset contains Netfilter fixes for net, specifically
fixes for the nf_conncount infrastructure which is causing troubles
since 5c789e131cbb9 ("netfilter: nf_conncount: Add list lock and gc
worker, and RCU for init tree search"). Patches aim to simplify this
infrastructure while fixing up the problems:

1) Use fixed size CONNCOUNT_SLOTS in nf_conncount, from Shawn Bohrer.

2) Incorrect signedness in age calculation from find_or_evict(),
   from Florian Westphal.

3) Proper locking for the garbage collector workqueue callback,
   first make a patch to count how many nodes can be collected
   without holding locks, then grab lock and release them. Also
   from Florian.

4) Restart node lookup from the insertion path, after releasing nodes
   via packet path garbage collection. Shawn Bohrer described a scenario
   that may result in inserting a connection in an already dead list
   node. Patch from Florian.

5) Merge lookup and add function to avoid a hold release and re-grab.
   From Florian.

6) Be safe and iterate over the node lists under the spinlock.

7) Speculative list nodes removal via garbage collection, check if
   list node got a connection while it was scheduled for deletion
   via gc.

8) Accidental argument swap in find_next_bit() that leads to more
   frequent scheduling of the workqueue. From Florian Westphal.

And one patch that falls within the miscelanea category in this batch:

9) Missing error path for nla_nest_start(), from Kangjie Lu.

You can pull these changes from:

  git://git.kernel.org/pub/scm/linux/kernel/git/pablo/nf.git

Thanks!

----------------------------------------------------------------

The following changes since commit a3c9311f62b4943228ae90f769775dd3bcbfa7c0:

  include/linux/phy/phy.h: fix minor kerneldoc errors (2018-12-27 16:31:10 -0800)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/pablo/nf.git HEAD

for you to fetch changes up to a007232066f6839d6f256bab21e825d968f1a163:

  netfilter: nf_conncount: fix argument order to find_next_bit (2018-12-29 02:45:22 +0100)

----------------------------------------------------------------
Florian Westphal (5):
      netfilter: nf_conncount: don't skip eviction when age is negative
      netfilter: nf_conncount: split gc in two phases
      netfilter: nf_conncount: restart search when nodes have been erased
      netfilter: nf_conncount: merge lookup and add functions
      netfilter: nf_conncount: fix argument order to find_next_bit

Kangjie Lu (1):
      netfilter: nf_tables: fix a missing check of nla_put_failure

Pablo Neira Ayuso (2):
      netfilter: nf_conncount: move all list iterations under spinlock
      netfilter: nf_conncount: speculative garbage collection on empty lists

Shawn Bohrer (1):
      netfilter: nf_conncount: replace CONNCOUNT_LOCK_SLOTS with CONNCOUNT_SLOTS

 include/net/netfilter/nf_conntrack_count.h |  19 +-
 net/netfilter/nf_conncount.c               | 290 +++++++++++++----------------
 net/netfilter/nf_tables_api.c              |   2 +
 net/netfilter/nft_connlimit.c              |  14 +-
 4 files changed, 136 insertions(+), 189 deletions(-)
