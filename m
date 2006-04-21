From: Patrick McHardy <kaber@trash.net>
Subject: [NETFILTER 07/07]: ipt action: use xt_check_target for basic
	verification
Date: Fri, 21 Apr 2006 03:06:57 +0200 (MEST)
Message-ID: <20060421010657.8466.36526.sendpatchset@localhost.localdomain>
References: <20060421010648.8466.94593.sendpatchset@localhost.localdomain>
Cc: netfilter-devel@lists.netfilter.org, Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: davem@davemloft.net
In-Reply-To: <20060421010648.8466.94593.sendpatchset@localhost.localdomain>
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

[NETFILTER]: ipt action: use xt_check_target for basic verification

The targets don't do the basic verification themselves anymore so
the ipt action needs to take care of it.

Signed-off-by: Patrick McHardy <kaber@trash.net>

---
commit 42a2de55185ffa55f70e289e708d492eae2685c5
tree 49d5316c896a1801f2f1abedb73b8e052522c6c9
parent 81b536eef7989c16a2d59ced319aafaaf9e3ed03
author Patrick McHardy <kaber@trash.net> Fri, 21 Apr 2006 03:03:53 +0200
committer Patrick McHardy <kaber@trash.net> Fri, 21 Apr 2006 03:03:53 +0200

 net/sched/act_ipt.c |    5 +++++
 1 files changed, 5 insertions(+), 0 deletions(-)

diff --git a/net/sched/act_ipt.c b/net/sched/act_ipt.c
index 6056d20..37640c6 100644
--- a/net/sched/act_ipt.c
+++ b/net/sched/act_ipt.c
@@ -69,6 +69,11 @@ ipt_init_target(struct ipt_entry_target 
 	DPRINTK("ipt_init_target: found %s\n", target->name);
 	t->u.kernel.target = target;
 
+	ret = xt_check_target(target, AF_INET, t->u.target_size - sizeof(*t),
+			      table, hook, 0, 0);
+	if (ret)
+		return ret;
+
 	if (t->u.kernel.target->checkentry
 	    && !t->u.kernel.target->checkentry(table, NULL,
 		    			       t->u.kernel.target, t->data,
