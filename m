From: Vlad Buslov <vladbu@mellanox.com>
Subject: [PATCH 00/14] Modify action API for implementing lockless actions
Date: Mon, 14 May 2018 17:27:01 +0300
Message-ID: <1526308035-12484-1-git-send-email-vladbu@mellanox.com>
Cc: davem@davemloft.net, jhs@mojatatu.com, xiyou.wangcong@gmail.com,
        jiri@resnulli.us, pablo@netfilter.org, kadlec@blackhole.kfki.hu,
        fw@strlen.de, ast@kernel.org, daniel@iogearbox.net,
        edumazet@google.com, vladbu@mellanox.com, keescook@chromium.org,
        linux-kernel@vger.kernel.org, netfilter-devel@vger.kernel.org,
        coreteam@netfilter.org, kliteyn@mellanox.com
To: netdev@vger.kernel.org
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

Currently, all netlink protocol handlers for updating rules, actions and
qdiscs are protected with single global rtnl lock which removes any
possibility for parallelism. This patch set is a first step to remove
rtnl lock dependency from TC rules update path. It updates act API to
use atomic operations, rcu and spinlocks for fine-grained locking. It
also extend API with functions that are needed to update existing
actions for parallel execution.

Outline of changes:
- Change tc action to use atomic reference and bind counters, rcu
  mechanism for cookie update.
- Extend action ops API with 'delete' function and 'unlocked' flag.
- Change action API to work with actions in lockless manner based on
  primitives implemented in previous patches.
- Extend action API with new functions necessary to implement unlocked
  actions.

Vlad Buslov (14):
  net: sched: use rcu for action cookie update
  net: sched: change type of reference and bind counters
  net: sched: add 'delete' function to action ops
  net: sched: implement unlocked action init API
  net: sched: always take reference to action
  net: sched: implement reference counted action release
  net: sched: use reference counting action init
  net: sched: account for temporary action reference
  net: sched: don't release reference on action overwrite
  net: sched: extend act API for lockless actions
  net: core: add new/replace rate estimator lock parameter
  net: sched: retry action check-insert on concurrent modification
  net: sched: use unique idr insert function in unlocked actions
  net: sched: implement delete for all actions

 include/net/act_api.h      |  16 ++-
 include/net/gen_stats.h    |   2 +
 include/net/pkt_cls.h      |   1 +
 net/core/gen_estimator.c   |  58 ++++++---
 net/netfilter/xt_RATEEST.c |   2 +-
 net/sched/act_api.c        | 298 ++++++++++++++++++++++++++++++++-------------
 net/sched/act_bpf.c        |  33 +++--
 net/sched/act_connmark.c   |  29 +++--
 net/sched/act_csum.c       |  33 +++--
 net/sched/act_gact.c       |  30 +++--
 net/sched/act_ife.c        |  37 ++++--
 net/sched/act_ipt.c        |  41 +++++--
 net/sched/act_mirred.c     |  32 +++--
 net/sched/act_nat.c        |  29 +++--
 net/sched/act_pedit.c      |  30 +++--
 net/sched/act_police.c     |  35 ++++--
 net/sched/act_sample.c     |  33 +++--
 net/sched/act_simple.c     |  31 +++--
 net/sched/act_skbedit.c    |  30 +++--
 net/sched/act_skbmod.c     |  33 +++--
 net/sched/act_tunnel_key.c |  34 ++++--
 net/sched/act_vlan.c       |  34 ++++--
 net/sched/cls_api.c        |   6 +-
 net/sched/sch_api.c        |   2 +
 net/sched/sch_cbq.c        |   4 +-
 net/sched/sch_drr.c        |   4 +-
 net/sched/sch_hfsc.c       |   4 +-
 net/sched/sch_htb.c        |   4 +-
 net/sched/sch_qfq.c        |   4 +-
 29 files changed, 673 insertions(+), 256 deletions(-)

-- 
2.7.5
