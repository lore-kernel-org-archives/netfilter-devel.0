From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 15/23] netfilter: ipvs: Fix inappropriate output of procfs
Date: Tue,  7 Nov 2017 01:52:05 +0100
Message-ID: <20171107005213.22618-16-pablo@netfilter.org>
References: <20171107005213.22618-1-pablo@netfilter.org>
Cc: davem@davemloft.net, netdev@vger.kernel.org
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:59012 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S964878AbdKGAxV (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 6 Nov 2017 19:53:21 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 8FC501F4B6F
        for <netfilter-devel@vger.kernel.org>; Tue,  7 Nov 2017 01:53:19 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 7CF2CDA80B
        for <netfilter-devel@vger.kernel.org>; Tue,  7 Nov 2017 01:53:19 +0100 (CET)
In-Reply-To: <20171107005213.22618-1-pablo@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

From: KUWAZAWA Takuya <albatross0@gmail.com>

Information about ipvs in different network namespace can be seen via procfs.

How to reproduce:

  # ip netns add ns01
  # ip netns add ns02
  # ip netns exec ns01 ip a add dev lo 127.0.0.1/8
  # ip netns exec ns02 ip a add dev lo 127.0.0.1/8
  # ip netns exec ns01 ipvsadm -A -t 10.1.1.1:80
  # ip netns exec ns02 ipvsadm -A -t 10.1.1.2:80

The ipvsadm displays information about its own network namespace only.

  # ip netns exec ns01 ipvsadm -Ln
  IP Virtual Server version 1.2.1 (size=4096)
  Prot LocalAddress:Port Scheduler Flags
    -> RemoteAddress:Port           Forward Weight ActiveConn InActConn
  TCP  10.1.1.1:80 wlc

  # ip netns exec ns02 ipvsadm -Ln
  IP Virtual Server version 1.2.1 (size=4096)
  Prot LocalAddress:Port Scheduler Flags
    -> RemoteAddress:Port           Forward Weight ActiveConn InActConn
  TCP  10.1.1.2:80 wlc

But I can see information about other network namespace via procfs.

  # ip netns exec ns01 cat /proc/net/ip_vs
  IP Virtual Server version 1.2.1 (size=4096)
  Prot LocalAddress:Port Scheduler Flags
    -> RemoteAddress:Port Forward Weight ActiveConn InActConn
  TCP  0A010101:0050 wlc
  TCP  0A010102:0050 wlc

  # ip netns exec ns02 cat /proc/net/ip_vs
  IP Virtual Server version 1.2.1 (size=4096)
  Prot LocalAddress:Port Scheduler Flags
    -> RemoteAddress:Port Forward Weight ActiveConn InActConn
  TCP  0A010102:0050 wlc

Signed-off-by: KUWAZAWA Takuya <albatross0@gmail.com>
Acked-by: Julian Anastasov <ja@ssi.bg>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/ipvs/ip_vs_ctl.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/net/netfilter/ipvs/ip_vs_ctl.c b/net/netfilter/ipvs/ip_vs_ctl.c
index b825835752e6..fac8c802b4ea 100644
--- a/net/netfilter/ipvs/ip_vs_ctl.c
+++ b/net/netfilter/ipvs/ip_vs_ctl.c
@@ -2034,12 +2034,16 @@ static int ip_vs_info_seq_show(struct seq_file *seq, void *v)
 		seq_puts(seq,
 			 "  -> RemoteAddress:Port Forward Weight ActiveConn InActConn\n");
 	} else {
+		struct net *net = seq_file_net(seq);
+		struct netns_ipvs *ipvs = net_ipvs(net);
 		const struct ip_vs_service *svc = v;
 		const struct ip_vs_iter *iter = seq->private;
 		const struct ip_vs_dest *dest;
 		struct ip_vs_scheduler *sched = rcu_dereference(svc->scheduler);
 		char *sched_name = sched ? sched->name : "none";
 
+		if (svc->ipvs != ipvs)
+			return 0;
 		if (iter->table == ip_vs_svc_table) {
 #ifdef CONFIG_IP_VS_IPV6
 			if (svc->af == AF_INET6)
-- 
2.11.0

