From: Roel Kluin <12o3l@tiscali.nl>
Subject: [PATCH] net/netfilter/nf_conntrack_h323_main.c: logical-bitwise &
 confusion in process_setup()
Date: Tue, 11 Mar 2008 09:50:44 +0100
Message-ID: <47D647E4.5000102@tiscali.nl>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org, netfilter@vger.kernel.org,
	coreteam@netfilter.org
To: kaber@trash.net
Return-path: <netfilter-owner@vger.kernel.org>
Sender: netfilter-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

logical-bitwise & confusion

Signed-off-by: Roel Kluin <12o3l@tiscali.nl>
---
diff --git a/net/netfilter/nf_conntrack_h323_main.c b/net/netfilter/nf_conntrack_h323_main.c
index 6213787..898f192 100644
--- a/net/netfilter/nf_conntrack_h323_main.c
+++ b/net/netfilter/nf_conntrack_h323_main.c
@@ -842,7 +842,7 @@ static int process_setup(struct sk_buff *skb, struct nf_conn *ct,
 
 	set_h225_addr = rcu_dereference(set_h225_addr_hook);
 	if ((setup->options & eSetup_UUIE_destCallSignalAddress) &&
-	    (set_h225_addr) && ct->status && IPS_NAT_MASK &&
+	    (set_h225_addr) && ct->status & IPS_NAT_MASK &&
 	    get_h225_addr(ct, *data, &setup->destCallSignalAddress,
 			  &addr, &port) &&
 	    memcmp(&addr, &ct->tuplehash[!dir].tuple.src.u3, sizeof(addr))) {
