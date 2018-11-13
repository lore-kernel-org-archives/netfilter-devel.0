From: Xin Long <lucien.xin@gmail.com>
Subject: [PATCH net] ipvs: call ip_vs_dst_notifier before ipv6_dev_notf
Date: Wed, 14 Nov 2018 01:25:33 +0800
Message-ID: <4bfc74f2a94e3721afd5ee4dd3cb60f8e4b68c7c.1542129933.git.lucien.xin@gmail.com>
Cc: davem@davemloft.net, pablo@netfilter.org,
        Hans Schillstrom <hans@schillstrom.com>
To: network dev <netdev@vger.kernel.org>,
        netfilter-devel@vger.kernel.org
Return-path: <netdev-owner@vger.kernel.org>
Sender: netdev-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

ip_vs_dst_event is supposed to clean up all dst used in ipvs'
destinations when a net dev is going down. But it works only
when the dst's dev is the same as the dev from the event.

Now with the same priority but late registration,
ip_vs_dst_notifier is always called after ipv6_dev_notf where
the dst's dev is set to lo for NETDEV_DOWN event.

As the dst's dev lo is not the same as the dev from the event
in ip_vs_dst_event(), ipv6_dev_notf can actually never work.
Also as these dst have to wait for dest_trash_timer to clean
them up. It would cause some non-permanent kernel warnings:

  unregister_netdevice: waiting for br0 to become free. Usage count = 3

To fix it, call ip_vs_dst_notifier before ipv6_dev_notf by
increasing its priority to ADDRCONF_NOTIFY_PRIORITY + 5.

Fixes: 7a4f0761fce3 ("IPVS: init and cleanup restructuring")
Reported-by: Li Shuang <shuali@redhat.com>
Signed-off-by: Xin Long <lucien.xin@gmail.com>
---
 net/netfilter/ipvs/ip_vs_ctl.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/net/netfilter/ipvs/ip_vs_ctl.c b/net/netfilter/ipvs/ip_vs_ctl.c
index 83395bf6..aded477 100644
--- a/net/netfilter/ipvs/ip_vs_ctl.c
+++ b/net/netfilter/ipvs/ip_vs_ctl.c
@@ -3980,6 +3980,7 @@ static void __net_exit ip_vs_control_net_cleanup_sysctl(struct netns_ipvs *ipvs)
 
 static struct notifier_block ip_vs_dst_notifier = {
 	.notifier_call = ip_vs_dst_event,
+	.priority = ADDRCONF_NOTIFY_PRIORITY + 5,
 };
 
 int __net_init ip_vs_control_net_init(struct netns_ipvs *ipvs)
-- 
2.1.0
