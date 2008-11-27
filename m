From: Patrick McHardy <kaber@trash.net>
Subject: netfilter 28/29: fix warning in net/netfilter/nf_conntrack_proto_tcp.c
Date: Thu, 27 Nov 2008 17:15:41 +0100 (MET)
Message-ID: <20081127161541.13891.36600.sendpatchset@x2.localnet>
References: <20081127161503.13891.62766.sendpatchset@x2.localnet>
Cc: netdev@vger.kernel.org, Patrick McHardy <kaber@trash.net>,
	netfilter-devel@vger.kernel.org
To: davem@davemloft.net
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20081127161503.13891.62766.sendpatchset@x2.localnet>
Sender: netdev-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

commit 65f233fb1669e6c990cd1d7fd308ac7dc66dc207
Author: Ingo Molnar <mingo@elte.hu>
Date:   Tue Nov 25 18:20:13 2008 +0100

    netfilter: fix warning in net/netfilter/nf_conntrack_proto_tcp.c
    
    fix this warning:
    
      net/netfilter/nf_conntrack_proto_tcp.c: In function \u2018tcp_in_window\u2019:
      net/netfilter/nf_conntrack_proto_tcp.c:491: warning: unused variable \u2018net\u2019
      net/netfilter/nf_conntrack_proto_tcp.c: In function \u2018tcp_packet\u2019:
      net/netfilter/nf_conntrack_proto_tcp.c:812: warning: unused variable \u2018net\u2019
    
    Signed-off-by: Ingo Molnar <mingo@elte.hu>
    Signed-off-by: Patrick McHardy <kaber@trash.net>

diff --git a/include/net/netfilter/nf_conntrack_l4proto.h b/include/net/netfilter/nf_conntrack_l4proto.h
index 7f2f43c..debdaf7 100644
--- a/include/net/netfilter/nf_conntrack_l4proto.h
+++ b/include/net/netfilter/nf_conntrack_l4proto.h
@@ -129,7 +129,7 @@ extern const struct nla_policy nf_ct_port_nla_policy[];
 	 && net_ratelimit())
 #endif
 #else
-#define LOG_INVALID(net, proto) 0
+static inline int LOG_INVALID(struct net *net, int proto) { return 0; }
 #endif /* CONFIG_SYSCTL */
 
 #endif /*_NF_CONNTRACK_PROTOCOL_H*/
