From: Patrick McHardy <kaber@trash.net>
Subject: [NETFILTER 50/50]: x_tables: add more detail to error message about
	match/target mask mismatch
Date: Sat,  7 Jul 2007 14:24:11 +0200 (MEST)
Message-ID: <20070707122327.1589.77643.sendpatchset@localhost.localdomain>
References: <20070707122215.1589.12100.sendpatchset@localhost.localdomain>
Cc: netfilter-devel@lists.netfilter.org, Patrick McHardy <kaber@trash.net>
To: davem@davemloft.net
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
In-Reply-To: <20070707122215.1589.12100.sendpatchset@localhost.localdomain>
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

[NETFILTER]: x_tables: add more detail to error message about match/target mask mismatch

Signed-off-by: Balazs Scheidler <bazsi@balabit.hu>
Signed-off-by: Patrick McHardy <kaber@trash.net>

---
commit 89ada54fbb7711869e3731018de4d5447ea6aee4
tree 7152b6d8ae6664b4a99b014a015aae28e99f2694
parent 8e3656db48ab327c2d6648c67c05b6b6dd6d2a23
author Balazs Scheidler <bazsi@balabit.hu> Sat, 07 Jul 2007 12:16:12 +0200
committer Patrick McHardy <kaber@trash.net> Sat, 07 Jul 2007 12:16:12 +0200

 net/netfilter/x_tables.c |    9 +++++----
 1 files changed, 5 insertions(+), 4 deletions(-)

diff --git a/net/netfilter/x_tables.c b/net/netfilter/x_tables.c
index 0eb2504..520eddf 100644
--- a/net/netfilter/x_tables.c
+++ b/net/netfilter/x_tables.c
@@ -320,8 +320,8 @@ int xt_check_match(const struct xt_match *match, unsigned short family,
 		return -EINVAL;
 	}
 	if (match->hooks && (hook_mask & ~match->hooks) != 0) {
-		printk("%s_tables: %s match: bad hook_mask %u\n",
-		       xt_prefix[family], match->name, hook_mask);
+		printk("%s_tables: %s match: bad hook_mask %u/%u\n",
+		       xt_prefix[family], match->name, hook_mask, match->hooks);
 		return -EINVAL;
 	}
 	if (match->proto && (match->proto != proto || inv_proto)) {
@@ -410,8 +410,9 @@ int xt_check_target(const struct xt_target *target, unsigned short family,
 		return -EINVAL;
 	}
 	if (target->hooks && (hook_mask & ~target->hooks) != 0) {
-		printk("%s_tables: %s target: bad hook_mask %u\n",
-		       xt_prefix[family], target->name, hook_mask);
+		printk("%s_tables: %s target: bad hook_mask %u/%u\n",
+		       xt_prefix[family], target->name, hook_mask,
+		       target->hooks);
 		return -EINVAL;
 	}
 	if (target->proto && (target->proto != proto || inv_proto)) {
