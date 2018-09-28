From: Flavio Leitner <fbl@redhat.com>
Subject: [PATCH] openvswitch: load NAT helper
Date: Fri, 28 Sep 2018 14:51:28 -0300
Message-ID: <20180928175128.13126-1-fbl@redhat.com>
Cc: Pravin B Shelar <pshelar@ovn.org>, Flavio Leitner <fbl@redhat.com>
To: netfilter-devel@vger.kernel.org, netdev@vger.kernel.org,
        dev@openvswitch.org
Return-path: <netdev-owner@vger.kernel.org>
Sender: netdev-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

Load the respective NAT helper module if the flow uses it.

Signed-off-by: Flavio Leitner <fbl@redhat.com>
---
 net/openvswitch/conntrack.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/net/openvswitch/conntrack.c b/net/openvswitch/conntrack.c
index 86a75105af1a..7e9a5283e236 100644
--- a/net/openvswitch/conntrack.c
+++ b/net/openvswitch/conntrack.c
@@ -1312,6 +1312,10 @@ static int ovs_ct_add_helper(struct ovs_conntrack_info *info, const char *name,
 
 	rcu_assign_pointer(help->helper, helper);
 	info->helper = helper;
+
+	if (info->nat)
+		request_module("ip_nat_%s", name);
+
 	return 0;
 }
 
-- 
2.14.4
