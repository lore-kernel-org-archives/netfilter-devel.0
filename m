From: Chenbo Feng <chenbofeng.kernel@gmail.com>
Subject: [PATCH net-next iptables] Rework the xt_quota module
Date: Mon,  1 Oct 2018 18:23:06 -0700
Message-ID: <1538443388-6881-1-git-send-email-chenbofeng.kernel@gmail.com>
Cc: kernel-team@android.com, Lorenzo Colitti <lorenzo@google.com>,
        maze@google.com, Chenbo Feng <fengc@google.com>
To: netdev@vger.kernel.org, netfilter-devel@vger.kernel.org,
        pablo@netfilter.org
Return-path: <netdev-owner@vger.kernel.org>
Sender: netdev-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

From: Chenbo Feng <fengc@google.com>

MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

The current xt_quota module uses an additional kernel struct to store
the remaining quota of an iptables match and does not expose it to
userspace. The major flaw of the current implementation is the quota
will be reset whenever an unrelated rule gets updated in the same table
as an xt_quota rule exists. Such behavior makes xt_quota rules not very
useful in a dynamically changing iptables setup.

To fix the problem above, a new remain field is introduced to replace
the kernel struct pointer. It is used in the kernel as an atomic64_t and
treated as an __aligned_u64 when it is copied to userspace. Since the
struct xt_quota_info uses __aligned_u64 to record the quota, it is
guaranteed the padding space at the end of the current struct is 64bit
wide even on a 32bit machine. So we can safely pass the current quota
from kernel to userspace without adding an extra revision to the
xt_quota module. Userspace can set the remaining quota with new
"--remain x" option when restoring a rule that is previously saved.

For general quota rule insertion/deletion, the user can choose whether
to specify the remaining quota or not. If a quota rule is inserted
without specifying the remaining quota, it will be set to the original
quota. As for rule deletion, the remaining part is not matched since it
is a dynamically changing field when there is live networking traffic
and makes no sense to specify the exact value of current remaining
quota.

For an old kernel with new iptables with this fix, the remain field will
not get copied into kernel memory because of the usersize definition in
kernel xt_quota module. So it will still act the same as old xt_quota
module. When dumping or saving the iptables rule, the kernel pointer
will not get copied to userspace and iptables will ignore the remaining
field if it is just zero initilized memory.

For a kernel with fix running against old iptables, insertion or
deletion of an unrelated rule no longer resets the quota since the
remain field will be copied out of kernel and updated back during the
rule insertion/deletion process.

kernel changes:

Chenbo Feng (1):
  netfilter: xt_quota: fix the behavior of xt_quota module

 include/uapi/linux/netfilter/xt_quota.h |  8 +++--
 net/netfilter/xt_quota.c                | 55 +++++++++++++--------------------
 2 files changed, 27 insertions(+), 36 deletions(-)

iptables changes:

Chenbo Feng (1):
  extensions: libxt_quota: Allow setting the remaining quota

 extensions/libxt_quota.c           | 23 +++++++++++++++++++++--
 include/linux/netfilter/xt_quota.h |  8 +++++---
 2 files changed, 26 insertions(+), 5 deletions(-)

-- 
2.7.4
