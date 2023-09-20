Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D619DCE79AC
	for <netfilter-devel@archiver.kernel.org>; Wed, 20 Sep 2023 09:27:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234175AbjITJ10 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 20 Sep 2023 05:27:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60362 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234150AbjITJ1G (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 20 Sep 2023 05:27:06 -0400
Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1B92CDE;
        Wed, 20 Sep 2023 02:26:58 -0700 (PDT)
Received: from lhrpeml500004.china.huawei.com (unknown [172.18.147.226])
        by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4RrCmQ2jmTz6HJc4;
        Wed, 20 Sep 2023 17:24:54 +0800 (CST)
Received: from mscphis00759.huawei.com (10.123.66.134) by
 lhrpeml500004.china.huawei.com (7.191.163.9) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.31; Wed, 20 Sep 2023 10:26:55 +0100
From:   Konstantin Meskhidze <konstantin.meskhidze@huawei.com>
To:     <mic@digikod.net>
CC:     <willemdebruijn.kernel@gmail.com>, <gnoack3000@gmail.com>,
        <linux-security-module@vger.kernel.org>, <netdev@vger.kernel.org>,
        <netfilter-devel@vger.kernel.org>, <yusongping@huawei.com>,
        <artem.kuzin@huawei.com>
Subject: [PATCH v12 04/12] landlock: Refactor merge/inherit_ruleset functions
Date:   Wed, 20 Sep 2023 17:26:32 +0800
Message-ID: <20230920092641.832134-5-konstantin.meskhidze@huawei.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20230920092641.832134-1-konstantin.meskhidze@huawei.com>
References: <20230920092641.832134-1-konstantin.meskhidze@huawei.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.123.66.134]
X-ClientProxiedBy: mscpeml500002.china.huawei.com (7.188.26.138) To
 lhrpeml500004.china.huawei.com (7.191.163.9)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Refactor merge_ruleset() and inherit_ruleset() functions to support
new rule types. This patch adds merge_tree() and inherit_tree()
helpers. They use a specific ruleset's red-black tree according to
a key type argument.

Signed-off-by: Konstantin Meskhidze <konstantin.meskhidze@huawei.com>
---

Changes since v11:
* Fixes comment in inherit_ruleset().
https://lore.kernel.org/netdev/3b52ba0c-d013-b7a9-0f08-2e6d677a1df0@digikod.net/

Changes since v10:
* Refactors merge_tree() function.

Changes since v9:
* None

Changes since v8:
* Refactors commit message.
* Minor fixes.

Changes since v7:
* Adds missed lockdep_assert_held it inherit_tree() and merge_tree().
* Fixes comment.

Changes since v6:
* Refactors merge_ruleset() and inherit_ruleset() functions to support
  new rule types.
* Renames tree_merge() to merge_tree() (and reorder arguments), and
  tree_copy() to inherit_tree().

Changes since v5:
* Refactors some logic errors.
* Formats code with clang-format-14.

Changes since v4:
* None

---
 security/landlock/ruleset.c | 116 +++++++++++++++++++++++-------------
 1 file changed, 74 insertions(+), 42 deletions(-)

diff --git a/security/landlock/ruleset.c b/security/landlock/ruleset.c
index d5993e6254e4..958d57654b8e 100644
--- a/security/landlock/ruleset.c
+++ b/security/landlock/ruleset.c
@@ -299,36 +299,22 @@ static void put_hierarchy(struct landlock_hierarchy *hierarchy)
 	}
 }

-static int merge_ruleset(struct landlock_ruleset *const dst,
-			 struct landlock_ruleset *const src)
+static int merge_tree(struct landlock_ruleset *const dst,
+		      struct landlock_ruleset *const src,
+		      const enum landlock_key_type key_type)
 {
 	struct landlock_rule *walker_rule, *next_rule;
 	struct rb_root *src_root;
 	int err = 0;

 	might_sleep();
-	/* Should already be checked by landlock_merge_ruleset() */
-	if (WARN_ON_ONCE(!src))
-		return 0;
-	/* Only merge into a domain. */
-	if (WARN_ON_ONCE(!dst || !dst->hierarchy))
-		return -EINVAL;
+	lockdep_assert_held(&dst->lock);
+	lockdep_assert_held(&src->lock);

-	src_root = get_root(src, LANDLOCK_KEY_INODE);
+	src_root = get_root(src, key_type);
 	if (IS_ERR(src_root))
 		return PTR_ERR(src_root);

-	/* Locks @dst first because we are its only owner. */
-	mutex_lock(&dst->lock);
-	mutex_lock_nested(&src->lock, SINGLE_DEPTH_NESTING);
-
-	/* Stacks the new layer. */
-	if (WARN_ON_ONCE(src->num_layers != 1 || dst->num_layers < 1)) {
-		err = -EINVAL;
-		goto out_unlock;
-	}
-	dst->access_masks[dst->num_layers - 1] = src->access_masks[0];
-
 	/* Merges the @src tree. */
 	rbtree_postorder_for_each_entry_safe(walker_rule, next_rule, src_root,
 					     node) {
@@ -337,23 +323,52 @@ static int merge_ruleset(struct landlock_ruleset *const dst,
 		} };
 		const struct landlock_id id = {
 			.key = walker_rule->key,
-			.type = LANDLOCK_KEY_INODE,
+			.type = key_type,
 		};

-		if (WARN_ON_ONCE(walker_rule->num_layers != 1)) {
-			err = -EINVAL;
-			goto out_unlock;
-		}
-		if (WARN_ON_ONCE(walker_rule->layers[0].level != 0)) {
-			err = -EINVAL;
-			goto out_unlock;
-		}
+		if (WARN_ON_ONCE(walker_rule->num_layers != 1))
+			return -EINVAL;
+
+		if (WARN_ON_ONCE(walker_rule->layers[0].level != 0))
+			return -EINVAL;
+
 		layers[0].access = walker_rule->layers[0].access;

 		err = insert_rule(dst, id, &layers, ARRAY_SIZE(layers));
 		if (err)
-			goto out_unlock;
+			return err;
 	}
+	return err;
+}
+
+static int merge_ruleset(struct landlock_ruleset *const dst,
+			 struct landlock_ruleset *const src)
+{
+	int err = 0;
+
+	might_sleep();
+	/* Should already be checked by landlock_merge_ruleset() */
+	if (WARN_ON_ONCE(!src))
+		return 0;
+	/* Only merge into a domain. */
+	if (WARN_ON_ONCE(!dst || !dst->hierarchy))
+		return -EINVAL;
+
+	/* Locks @dst first because we are its only owner. */
+	mutex_lock(&dst->lock);
+	mutex_lock_nested(&src->lock, SINGLE_DEPTH_NESTING);
+
+	/* Stacks the new layer. */
+	if (WARN_ON_ONCE(src->num_layers != 1 || dst->num_layers < 1)) {
+		err = -EINVAL;
+		goto out_unlock;
+	}
+	dst->access_masks[dst->num_layers - 1] = src->access_masks[0];
+
+	/* Merges the @src inode tree. */
+	err = merge_tree(dst, src, LANDLOCK_KEY_INODE);
+	if (err)
+		goto out_unlock;

 out_unlock:
 	mutex_unlock(&src->lock);
@@ -361,38 +376,55 @@ static int merge_ruleset(struct landlock_ruleset *const dst,
 	return err;
 }

-static int inherit_ruleset(struct landlock_ruleset *const parent,
-			   struct landlock_ruleset *const child)
+static int inherit_tree(struct landlock_ruleset *const parent,
+			struct landlock_ruleset *const child,
+			const enum landlock_key_type key_type)
 {
 	struct landlock_rule *walker_rule, *next_rule;
 	struct rb_root *parent_root;
 	int err = 0;

 	might_sleep();
-	if (!parent)
-		return 0;
+	lockdep_assert_held(&parent->lock);
+	lockdep_assert_held(&child->lock);

-	parent_root = get_root(parent, LANDLOCK_KEY_INODE);
+	parent_root = get_root(parent, key_type);
 	if (IS_ERR(parent_root))
 		return PTR_ERR(parent_root);

-	/* Locks @child first because we are its only owner. */
-	mutex_lock(&child->lock);
-	mutex_lock_nested(&parent->lock, SINGLE_DEPTH_NESTING);
-
-	/* Copies the @parent tree. */
+	/* Copies the @parent inode or network tree. */
 	rbtree_postorder_for_each_entry_safe(walker_rule, next_rule,
 					     parent_root, node) {
 		const struct landlock_id id = {
 			.key = walker_rule->key,
-			.type = LANDLOCK_KEY_INODE,
+			.type = key_type,
 		};

 		err = insert_rule(child, id, &walker_rule->layers,
 				  walker_rule->num_layers);
 		if (err)
-			goto out_unlock;
+			return err;
 	}
+	return err;
+}
+
+static int inherit_ruleset(struct landlock_ruleset *const parent,
+			   struct landlock_ruleset *const child)
+{
+	int err = 0;
+
+	might_sleep();
+	if (!parent)
+		return 0;
+
+	/* Locks @child first because we are its only owner. */
+	mutex_lock(&child->lock);
+	mutex_lock_nested(&parent->lock, SINGLE_DEPTH_NESTING);
+
+	/* Copies the @parent inode tree. */
+	err = inherit_tree(parent, child, LANDLOCK_KEY_INODE);
+	if (err)
+		goto out_unlock;

 	if (WARN_ON_ONCE(child->num_layers <= parent->num_layers)) {
 		err = -EINVAL;
--
2.25.1

