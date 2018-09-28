From: Flavio Leitner <fbl@redhat.com>
Subject: [PATCH] Revert "openvswitch: Fix template leak in error cases."
Date: Fri, 28 Sep 2018 14:55:34 -0300
Message-ID: <20180928175534.13590-1-fbl@redhat.com>
Cc: Pravin B Shelar <pshelar@ovn.org>, Joe Stringer <joe@ovn.org>,
        Flavio Leitner <fbl@redhat.com>
To: netfilter-devel@vger.kernel.org, netdev@vger.kernel.org,
        dev@openvswitch.org
Return-path: <netdev-owner@vger.kernel.org>
Sender: netdev-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

This reverts commit 90c7afc96cbbd77f44094b5b651261968e97de67.

When the commit was merged, the code used nf_ct_put() to free
the entry, but later on commit 76644232e612 ("openvswitch: Free
tmpl with tmpl_free.") replaced that with nf_ct_tmpl_free which
is a more appropriate. Now the original problem is removed.

Then 44d6e2f27328 ("net: Replace NF_CT_ASSERT() with WARN_ON().")
replaced a debug assert with a WARN_ON() which is trigged now.

Signed-off-by: Flavio Leitner <fbl@redhat.com>
---
 net/openvswitch/conntrack.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/net/openvswitch/conntrack.c b/net/openvswitch/conntrack.c
index 86a75105af1a..0aeb34c6389d 100644
--- a/net/openvswitch/conntrack.c
+++ b/net/openvswitch/conntrack.c
@@ -1624,10 +1624,6 @@ int ovs_ct_copy_action(struct net *net, const struct nlattr *attr,
 		OVS_NLERR(log, "Failed to allocate conntrack template");
 		return -ENOMEM;
 	}
-
-	__set_bit(IPS_CONFIRMED_BIT, &ct_info.ct->status);
-	nf_conntrack_get(&ct_info.ct->ct_general);
-
 	if (helper) {
 		err = ovs_ct_add_helper(&ct_info, helper, key, log);
 		if (err)
@@ -1639,6 +1635,8 @@ int ovs_ct_copy_action(struct net *net, const struct nlattr *attr,
 	if (err)
 		goto err_free_ct;
 
+	__set_bit(IPS_CONFIRMED_BIT, &ct_info.ct->status);
+	nf_conntrack_get(&ct_info.ct->ct_general);
 	return 0;
 err_free_ct:
 	__ovs_ct_free_action(&ct_info);
-- 
2.14.4
