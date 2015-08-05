From: Joe Stringer <joestringer@nicira.com>
Subject: [PATCH net] netfilter: conntrack: Use flags in nf_ct_tmpl_alloc()
Date: Tue,  4 Aug 2015 18:34:00 -0700
Message-ID: <1438738440-5320-1-git-send-email-joestringer@nicira.com>
Cc: linux-kernel@vger.kernel.org, netfilter-devel@vger.kernel.org
To: pablo@netfilter.org
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

The flags were ignored for this function when it was introduced. Also
fix the style problem in kzalloc.

Fixes: 0838aa7fc (netfilter: fix netns dependencies with conntrack
templates)
Signed-off-by: Joe Stringer <joestringer@nicira.com>
---
 net/netfilter/nf_conntrack_core.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/netfilter/nf_conntrack_core.c b/net/netfilter/nf_conntrack_core.c
index f168099..3c20d02 100644
--- a/net/netfilter/nf_conntrack_core.c
+++ b/net/netfilter/nf_conntrack_core.c
@@ -292,7 +292,7 @@ struct nf_conn *nf_ct_tmpl_alloc(struct net *net, u16 zone, gfp_t flags)
 {
 	struct nf_conn *tmpl;
 
-	tmpl = kzalloc(sizeof(struct nf_conn), GFP_KERNEL);
+	tmpl = kzalloc(sizeof(*tmpl), flags);
 	if (tmpl == NULL)
 		return NULL;
 
@@ -303,7 +303,7 @@ struct nf_conn *nf_ct_tmpl_alloc(struct net *net, u16 zone, gfp_t flags)
 	if (zone) {
 		struct nf_conntrack_zone *nf_ct_zone;
 
-		nf_ct_zone = nf_ct_ext_add(tmpl, NF_CT_EXT_ZONE, GFP_ATOMIC);
+		nf_ct_zone = nf_ct_ext_add(tmpl, NF_CT_EXT_ZONE, flags);
 		if (!nf_ct_zone)
 			goto out_free;
 		nf_ct_zone->id = zone;
-- 
2.1.4
