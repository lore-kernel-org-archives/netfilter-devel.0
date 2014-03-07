From: Florian Westphal <fw@strlen.de>
Subject: [PATCH 0/7] netfilter: connlimit: scalability improvements
Date: Fri,  7 Mar 2014 14:37:08 +0100
Message-ID: <1394199435-14395-1-git-send-email-fw@strlen.de>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([80.244.247.6]:45172 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753096AbaCGNlW (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 7 Mar 2014 08:41:22 -0500
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

The connlimit match suffers from two problems:

- lock contention when multiple cpus invoke the match function
- algorithmic complexity: on average the connlimit match will need to
  traverse list of length NUMBER_OF_CONNTRACKS % 256 (HASH_BUCKET); as
  it needs to test which entries are still active by querying conntrack.

This patch set tries to solve both issues.

Tested on 4-core machine, load was generated via synflood from
randomly-generated IP addresses.

Config:
sysctl net.nf_conntrack_max=256000
echo 65536 > /sys/module/nf_conntrack/parameters/hashsize

With conntrack but without any iptables rules, the machine is not cpu
limited when flooding, the network is simply not able to handle more
packets. (close to 100 kpps rx, 50 kpps outbound syn/acks).
RPS was disabled in this test.

When adding
-A INPUT -p tcp --syn -m connlimit --connlimit-above 5 --connlimit-mask 32 --connlimit-saddr

this changes, entire test is now cpu-bound; kernel only handles ~6kpps rx.

enabling rps helps (at cost of more cpus being busy), but still maxes
out at ~35kpps rx.

perf trace in RPS-on test shows lock contention:
+  20.84%   ksoftirqd/2  [kernel.kallsyms]              [k] _raw_spin_lock_bh
+  20.76%   ksoftirqd/1  [kernel.kallsyms]              [k] _raw_spin_lock_bh
+  20.42%   ksoftirqd/0  [kernel.kallsyms]              [k] _raw_spin_lock_bh
+   6.07%   ksoftirqd/2  [nf_conntrack]                 [k] ____nf_conntrack_find
+   6.07%   ksoftirqd/1  [nf_conntrack]                 [k] ____nf_conntrack_find
+   5.97%   ksoftirqd/0  [nf_conntrack]                 [k] ____nf_conntrack_find
+   2.47%   ksoftirqd/2  [nf_conntrack]                 [k] hash_conntrack_raw
+   2.45%   ksoftirqd/0  [nf_conntrack]                 [k] hash_conntrack_raw
+   2.44%   ksoftirqd/1  [nf_conntrack]                 [k] hash_conntrack_raw

With keyed locks the contention goes away, providing some improvement
(50 kpps rx, 10 kpps tx):
+  20.95%  ksoftirqd/0  [nf_conntrack]                 [k] ____nf_conntrack_find
+  20.50%  ksoftirqd/1  [nf_conntrack]                 [k] ____nf_conntrack_find
+  20.27%  ksoftirqd/2  [nf_conntrack]                 [k] ____nf_conntrack_find
+   5.76%  ksoftirqd/1  [nf_conntrack]                 [k] hash_conntrack_raw
+   5.39%  ksoftirqd/2  [nf_conntrack]                 [k] hash_conntrack_raw
+   5.35%  ksoftirqd/0  [nf_conntrack]                 [k] hash_conntrack_raw
+   2.00%  ksoftirqd/1  [kernel.kallsyms]              [k] __rcu_read_unlock
+   1.95%  ksoftirqd/0  [kernel.kallsyms]              [k] __rcu_read_unlock
+   1.86%  ksoftirqd/2  [kernel.kallsyms]              [k] __rcu_read_unlock
+   1.14%  ksoftirqd/0  [nf_conntrack]                 [k] __nf_conntrack_find_get
+   1.14%  ksoftirqd/2  [nf_conntrack]                 [k] __nf_conntrack_find_get
+   1.05%  ksoftirqd/1  [nf_conntrack]                 [k] __nf_conntrack_find_get

With rbtree-based storage (and keyed locks) we can however handle *almost* the
same load as without the rule, (90kpps, 51kpps outbound):

+  17.24%       swapper  [nf_conntrack]                 [k] ____nf_conntrack_find
+   6.60%   ksoftirqd/2  [nf_conntrack]                 [k] ____nf_conntrack_find
+   2.73%       swapper  [nf_conntrack]                 [k] hash_conntrack_raw
+   2.36%       swapper  [xt_connlimit]                 [k] count_tree
+   2.23%       swapper  [nf_conntrack]                 [k] __nf_conntrack_confirm
+   2.00%       swapper  [kernel.kallsyms]              [k] _raw_spin_lock
+   1.40%       swapper  [nf_conntrack]                 [k] __nf_conntrack_find_get
+   1.29%       swapper  [kernel.kallsyms]              [k] __rcu_read_unlock
+   1.13%       swapper  [kernel.kallsyms]              [k] _raw_spin_lock_bh
+   1.13%   ksoftirqd/2  [nf_conntrack]                 [k] hash_conntrack_raw
+   1.06%       swapper  [kernel.kallsyms]              [k] sha_transform

Comments welcome.

These changes may also be pulled from

git://git.breakpoint.cc/fw/nf-next connlimit_18

Florian Westphal (7):
      netfilter: connlimit: factor hlist search into new function
      netfilter: connlimit: improve packet-to-closed-connection logic
      netfilter: connlimit: move insertion of new element out of count function
      netfilter: connlimit: use kmem_cache for conn objects
      netfilter: connlimit: use keyed locks
      netfilter: connlimit: make same_source_net signed
      netfilter: connlimit: use rbtree for per-host conntrack obj storage

 net/netfilter/xt_connlimit.c | 300 +++++++++++++++++++++++++++++++++----------
 1 file changed, 231 insertions(+), 69 deletions(-)
