From: Patrick McHardy <kaber@trash.net>
Subject: netfilter 19/62: nf_conntrack_ipv6: delete the redundant macro definitions
Date: Tue, 16 Feb 2010 15:55:46 +0100 (MET)
Message-ID: <20100216145543.2796.12875.sendpatchset@x2.localnet>
References: <20100216145517.2796.40634.sendpatchset@x2.localnet>
Cc: netdev@vger.kernel.org, Patrick McHardy <kaber@trash.net>,
	netfilter-devel@vger.kernel.org
To: davem@davemloft.net
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20100216145517.2796.40634.sendpatchset@x2.localnet>
Sender: netdev-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

commit b38f6eddeee510ce8178c2d2db54ed25f1d7cb63
Author: Shan Wei <shanwei@cn.fujitsu.com>
Date:   Wed Jan 20 10:39:14 2010 +0100

    netfilter: nf_conntrack_ipv6: delete the redundant macro definitions
    
    The following three macro definitions are never used, so delete them.
    
    Signed-off-by: Shan Wei <shanwei@cn.fujitsu.com>
    Acked-by: David S. Miller <davem@davemloft.net>
    Signed-off-by: Patrick McHardy <kaber@trash.net>

diff --git a/net/ipv6/netfilter/nf_conntrack_reasm.c b/net/ipv6/netfilter/nf_conntrack_reasm.c
index 312c20a..1030ce1 100644
--- a/net/ipv6/netfilter/nf_conntrack_reasm.c
+++ b/net/ipv6/netfilter/nf_conntrack_reasm.c
@@ -45,9 +45,6 @@
 #include <linux/kernel.h>
 #include <linux/module.h>
 
-#define NF_CT_FRAG6_HIGH_THRESH 262144 /* == 256*1024 */
-#define NF_CT_FRAG6_LOW_THRESH 196608  /* == 192*1024 */
-#define NF_CT_FRAG6_TIMEOUT IPV6_FRAG_TIMEOUT
 
 struct nf_ct_frag6_skb_cb
 {
