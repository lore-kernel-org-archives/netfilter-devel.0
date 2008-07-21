From: Alexey Dobriyan <adobriyan@gmail.com>
Subject: [PATCH 02/31] ip6tables RAW in netns for real
Date: Mon, 21 Jul 2008 20:31:57 +0400
Message-ID: <20080721163157.GF13264@martell.zuzino.mipt.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netdev@vger.kernel.org, netfilter-devel@vger.kernel.org,
	xemul@openvz.org, den@openvz.org, ebiederm@xmission.com,
	dlezcano@fr.ibm.com, benjamin.thery@bull.net
To: kaber@trash.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from fg-out-1718.google.com ([72.14.220.158]:47843 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752001AbYGUQdp (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 21 Jul 2008 12:33:45 -0400
Received: by fg-out-1718.google.com with SMTP id 19so686396fgg.17
        for <netfilter-devel@vger.kernel.org>; Mon, 21 Jul 2008 09:33:44 -0700 (PDT)
Content-Disposition: inline
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

PREROUTING -- grab netns from in device,
OUTPUT -- from out device.

Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
---

 net/ipv6/netfilter/ip6table_raw.c |   20 ++++++++++++++++----
 1 file changed, 16 insertions(+), 4 deletions(-)

--- a/net/ipv6/netfilter/ip6table_raw.c
+++ b/net/ipv6/netfilter/ip6table_raw.c
@@ -45,25 +45,37 @@ static struct xt_table packet_raw = {
 
 /* The work comes in here from netfilter.c. */
 static unsigned int
-ip6t_hook(unsigned int hook,
+ip6t_pre_routing_hook(unsigned int hook,
 	 struct sk_buff *skb,
 	 const struct net_device *in,
 	 const struct net_device *out,
 	 int (*okfn)(struct sk_buff *))
 {
-	return ip6t_do_table(skb, hook, in, out, init_net.ipv6.ip6table_raw);
+	return ip6t_do_table(skb, hook, in, out,
+			     dev_net(in)->ipv6.ip6table_raw);
+}
+
+static unsigned int
+ip6t_local_out_hook(unsigned int hook,
+	 struct sk_buff *skb,
+	 const struct net_device *in,
+	 const struct net_device *out,
+	 int (*okfn)(struct sk_buff *))
+{
+	return ip6t_do_table(skb, hook, in, out,
+			     dev_net(out)->ipv6.ip6table_raw);
 }
 
 static struct nf_hook_ops ip6t_ops[] __read_mostly = {
 	{
-	  .hook = ip6t_hook,
+	  .hook = ip6t_pre_routing_hook,
 	  .pf = PF_INET6,
 	  .hooknum = NF_INET_PRE_ROUTING,
 	  .priority = NF_IP6_PRI_FIRST,
 	  .owner = THIS_MODULE,
 	},
 	{
-	  .hook = ip6t_hook,
+	  .hook = ip6t_local_out_hook,
 	  .pf = PF_INET6,
 	  .hooknum = NF_INET_LOCAL_OUT,
 	  .priority = NF_IP6_PRI_FIRST,
-- 
1.5.4.5


