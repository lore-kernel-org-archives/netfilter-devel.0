From: Balazs Scheidler <bazsi@balabit.hu>
Subject: [PATCH] some more detail to error message about match/target mask
	mismatch
Date: Fri, 06 Jul 2007 09:04:17 +0200
Message-ID: <1183705457.7093.7.camel@bzorp.balabit>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
To: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
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

Hi,

The error message about an invalid hook_mask in x_tables contained to
little detail (for me), so I added some more information. It's not of
utter importance to integrate it, but it helped for me, it might help
for others. With this mail, I'm dropping this patch from my patch queue.

Please apply, if you want. Thanks.

Signed-of-by: Balazs Scheidler <bazsi@balabit.hu>

diff --git a/net/netfilter/x_tables.c b/net/netfilter/x_tables.c
index 99293c6..e406300 100644
--- a/net/netfilter/x_tables.c
+++ b/net/netfilter/x_tables.c
@@ -260,8 +260,8 @@ int xt_check_match(const struct xt_match *match, unsigned short family,
                return -EINVAL;
        }
        if (match->hooks && (hook_mask & ~match->hooks) != 0) {
-               printk("%s_tables: %s match: bad hook_mask %u\n",
-                      xt_prefix[family], match->name, hook_mask);
+               printk("%s_tables: %s match: bad hook_mask %u/%u\n",
+                      xt_prefix[family], match->name, hook_mask, match->hooks);
                return -EINVAL;
        }
        if (match->proto && (match->proto != proto || inv_proto)) {
@@ -337,8 +337,8 @@ int xt_check_target(const struct xt_target *target, unsigned short family,
                return -EINVAL;
        }
        if (target->hooks && (hook_mask & ~target->hooks) != 0) {
-               printk("%s_tables: %s target: bad hook_mask %u\n",
-                      xt_prefix[family], target->name, hook_mask);
+               printk("%s_tables: %s target: bad hook_mask %u/%u\n",
+                      xt_prefix[family], target->name, hook_mask, target->hooks);
                return -EINVAL;
        }
        if (target->proto && (target->proto != proto || inv_proto)) {


-- 
Bazsi
