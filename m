From: Florian Westphal <fw@strlen.de>
Subject: [PATCH v2 0/3] netfilter: connlimit: scalability improvements
Date: Wed, 12 Mar 2014 23:49:48 +0100
Message-ID: <1394664591-21843-1-git-send-email-fw@strlen.de>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([80.244.247.6]:38333 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751865AbaCLWyO (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 12 Mar 2014 18:54:14 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Resending the last three patches of the set; I have addressed
the comments I've received.  See individual patches on whats
changed vs v1.

I've done a brief re-rest with 2-hrs of synflooding and
nf_conntrack_max=2000000 plus conntrack -F every 10 seconds and did not
encounter any issues.

I am copying the original v1 cover letter below.

The connlimit match suffers from two problems:

- lock contention when multiple cpus invoke the match function
- algorithmic complexity: on average the connlimit match will need to
  examine NUMBER_OF_CONNTRACKS % HASH_BUCKET (always 256) connections
  as the match will test for every connection assigned to the same bucked
  as the new one wheter the conntrack is still active.

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

this changes, entire test is now cpu-bound and we can only handle ~6kpps rx and
4kpps tx.

enabling rps helps (echo 7 > /sys/class/net/eth0/queues/rx-0/rps_cpus),
at cost of more cpu cycles, but we still max out at ~35kpps rx.

perf trace in this case shows lock contention:
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

 xt_connlimit.c |  259 ++++++++++++++++++++++++++++++++++++++++++++-------------
 1 file changed, 200 insertions(+), 59 deletions(-)
