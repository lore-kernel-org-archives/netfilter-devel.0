From: Charlie Sale <chucks.8090@gmail.com>
Subject: [PATCH] Net: netfilter: vmalloc/vfree to kvmalloc/kvfree
Date: Fri,  3 Nov 2017 16:07:31 -0400
Message-ID: <20171103200731.6576-1-chucks.8090@gmail.com>
Cc: netfilter-devel@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Charlie Sale <chucks.8090@gmail.com>
To: pablo@netfilter.org
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

Fixed FIXME by changing memory allocation and freeing
in htable_create to kvmalloc and kvfree from vmalloc and vfree.
Changes are made throughout the file in order to account
for the different allocation of htable_create.
Small note: This is a replacement of an earlier patch that did not
work. Enough was changed, so I thought I would just submit a new
patch.

Signed-off-by: Charlie Sale <chucks.8090@gmail.com>
---
 net/netfilter/xt_hashlimit.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/net/netfilter/xt_hashlimit.c b/net/netfilter/xt_hashlimit.c
index 5da8746f7b88..28ad74b3e3d0 100644
--- a/net/netfilter/xt_hashlimit.c
+++ b/net/netfilter/xt_hashlimit.c
@@ -286,9 +286,9 @@ static int htable_create(struct net *net, struct hashlimit_cfg3 *cfg,
 		if (size < 16)
 			size = 16;
 	}
-	/* FIXME: don't use vmalloc() here or anywhere else -HW */
-	hinfo = vmalloc(sizeof(struct xt_hashlimit_htable) +
-	                sizeof(struct hlist_head) * size);
+
+	hinfo = kvmalloc(sizeof(*hinfo) + sizeof(struct hlist_head) * size,
+			 GPT_KERNEL);
 	if (hinfo == NULL)
 		return -ENOMEM;
 	*out_hinfo = hinfo;
@@ -314,7 +314,7 @@ static int htable_create(struct net *net, struct hashlimit_cfg3 *cfg,
 	hinfo->rnd_initialized = false;
 	hinfo->name = kstrdup(name, GFP_KERNEL);
 	if (!hinfo->name) {
-		vfree(hinfo);
+		kvfree(hinfo);
 		return -ENOMEM;
 	}
 	spin_lock_init(&hinfo->lock);
@@ -336,7 +336,7 @@ static int htable_create(struct net *net, struct hashlimit_cfg3 *cfg,
 		fops, hinfo);
 	if (hinfo->pde == NULL) {
 		kfree(hinfo->name);
-		vfree(hinfo);
+		kvfree(hinfo);
 		return -ENOMEM;
 	}
 	hinfo->net = net;
@@ -414,7 +414,7 @@ static void htable_destroy(struct xt_hashlimit_htable *hinfo)
 	htable_remove_proc_entry(hinfo);
 	htable_selective_cleanup(hinfo, select_all);
 	kfree(hinfo->name);
-	vfree(hinfo);
+	kvfree(hinfo);
 }
 
 static struct xt_hashlimit_htable *htable_find_get(struct net *net,
-- 
2.13.6
