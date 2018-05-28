From: Toke =?utf-8?q?H=C3=B8iland-J=C3=B8rgensen?= <toke@toke.dk>
Subject: [PATCH net-next v16 0/8] sched: Add Common Applications Kept
 Enhanced (cake) qdisc
Date: Mon, 28 May 2018 16:27:46 +0200
Message-ID: <152751762093.30935.15398977119837536494.stgit@alrua-kau>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Cc: Georgios Amanakis <gamanakis@gmail.com>,
        Pete Heist <peteheist@gmail.com>,
        Yuchung Cheng <ycheng@google.com>,
        Neal Cardwell <ncardwell@google.com>,
        Dave Taht <dave.taht@gmail.com>,
        netfilter-devel@vger.kernel.org
To: netdev@vger.kernel.org, cake@lists.bufferbloat.net
Return-path: <netdev-owner@vger.kernel.org>
Sender: netdev-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

This patch series adds the CAKE qdisc, and has been split up to ease
review.

I have attempted to split out each configurable feature into its own patch.
The first commit adds the base shaper and packet scheduler, while
subsequent commits add the optional features. The full userspace API and
most data structures are included in this commit, but options not
understood in the base version will be ignored.

The result of applying the entire series is identical to the out of tree
version that have seen extensive testing in previous deployments, most
notably as an out of tree patch to OpenWrt. However, note that I have only
compile tested the individual patches; so the whole series should be
considered as a unit.

---
Changelog

v16:
  - Move conntrack lookup function into conntrack core and read it via
    RCU so it is only active when the nf_conntrack module is loaded.
    This avoids the module dependency on conntrack for NAT mode. Thanks
    to Pablo for the idea.

v15:
  - Handle ECN flags in ACK filter

v14:
  - Handle seqno wraps and DSACKs in ACK filter

v13:
  - Avoid ktime_t to scalar compares
  - Add class dumping and basic stats
  - Fail with ENOTSUPP when requesting NAT mode and conntrack is not
    available.
  - Parse all TCP options in ACK filter and make sure to only drop safe
    ones. Also handle SACK ranges properly.

v12:
  - Get rid of custom time typedefs. Use ktime_t for time and u64 for
    duration instead.

v11:
  - Fix overhead compensation calculation for GSO packets
  - Change configured rate to be u64 (I ran out of bits before I ran out
    of CPU when testing the effects of the above)

v10:
  - Christmas tree gardening (fix variable declarations to be in reverse
    line length order)

v9:
  - Remove duplicated checks around kvfree() and just call it
    unconditionally.
  - Don't pass __GFP_NOWARN when allocating memory
  - Move options in cake_dump() that are related to optional features to
    later patches implementing the features.
  - Support attaching filters to the qdisc and use the classification
    result to select flow queue.
  - Support overriding diffserv priority tin from skb->priority

v8:
  - Remove inline keyword from function definitions
  - Simplify ACK filter; remove the complex state handling to make the
    logic easier to follow. This will potentially be a bit less efficient,
    but I have not been able to measure a difference.

v7:
  - Split up patch into a series to ease review.
  - Constify the ACK filter.

v6:
  - Fix 6in4 encapsulation checks in ACK filter code
  - Checkpatch fixes

v5:
  - Refactor ACK filter code and hopefully fix the safety issues
    properly this time.

v4:
  - Only split GSO packets if shaping at speeds <= 1Gbps
  - Fix overhead calculation code to also work for GSO packets
  - Don't re-implement kvzalloc()
  - Remove local header include from out-of-tree build (fixes kbuild-bot
    complaint).
  - Several fixes to the ACK filter:
    - Check pskb_may_pull() before deref of transport headers.
    - Don't run ACK filter logic on split GSO packets
    - Fix TCP sequence number compare to deal with wraparounds

v3:
  - Use IS_REACHABLE() macro to fix compilation when sch_cake is
    built-in and conntrack is a module.
  - Switch the stats output to use nested netlink attributes instead
    of a versioned struct.
  - Remove GPL boilerplate.
  - Fix array initialisation style.

v2:
  - Fix kbuild test bot complaint
  - Clean up the netlink ABI
  - Fix checkpatch complaints
  - A few tweaks to the behaviour of cake based on testing carried out
    while writing the paper.


---

Toke Høiland-Jørgensen (8):
      sched: Add Common Applications Kept Enhanced (cake) qdisc
      sch_cake: Add ingress mode
      sch_cake: Add optional ACK filter
      netfilter: Add nf_ct_get_tuple_skb callback
      sch_cake: Add NAT awareness to packet classifier
      sch_cake: Add DiffServ handling
      sch_cake: Add overhead compensation support to the rate shaper
      sch_cake: Conditionally split GSO segments


 include/linux/netfilter.h         |    6 
 include/uapi/linux/pkt_sched.h    |  113 +
 net/netfilter/core.c              |   21 
 net/netfilter/nf_conntrack_core.c |   37 
 net/sched/Kconfig                 |   11 
 net/sched/Makefile                |    1 
 net/sched/sch_cake.c              | 2987 +++++++++++++++++++++++++++++++++++++
 7 files changed, 3176 insertions(+)
 create mode 100644 net/sched/sch_cake.c
