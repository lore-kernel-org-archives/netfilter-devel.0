From: Patrick McHardy <kaber@trash.net>
Subject: netfilter 19/29: nf_conntrack: fix warning and prototype mismatch
Date: Thu, 27 Nov 2008 17:15:29 +0100 (MET)
Message-ID: <20081127161528.13891.67049.sendpatchset@x2.localnet>
References: <20081127161503.13891.62766.sendpatchset@x2.localnet>
Cc: netdev@vger.kernel.org, Patrick McHardy <kaber@trash.net>,
	netfilter-devel@vger.kernel.org
To: davem@davemloft.net
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20081127161503.13891.62766.sendpatchset@x2.localnet>
Sender: netdev-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

commit e17b666a468285409ab9f6caff9df16936d27d71
Author: Patrick McHardy <kaber@trash.net>
Date:   Tue Nov 18 12:24:17 2008 +0100

    netfilter: nf_conntrack: fix warning and prototype mismatch
    
    net/netfilter/nf_conntrack_core.c:46:1: warning: symbol 'nfnetlink_parse_nat_setup_hook' was not declared. Should it be static?
    
    Including the proper header also revealed an incorrect prototype.
    
    Signed-off-by: Patrick McHardy <kaber@trash.net>

diff --git a/net/netfilter/nf_conntrack_core.c b/net/netfilter/nf_conntrack_core.c
index dc3fea0..73419de 100644
--- a/net/netfilter/nf_conntrack_core.c
+++ b/net/netfilter/nf_conntrack_core.c
@@ -39,13 +39,13 @@
 #include <net/netfilter/nf_conntrack_extend.h>
 #include <net/netfilter/nf_conntrack_acct.h>
 #include <net/netfilter/nf_nat.h>
+#include <net/netfilter/nf_nat_core.h>
 
 #define NF_CONNTRACK_VERSION	"0.5.0"
 
-unsigned int
-(*nfnetlink_parse_nat_setup_hook)(struct nf_conn *ct,
-				  enum nf_nat_manip_type manip,
-				  struct nlattr *attr) __read_mostly;
+int (*nfnetlink_parse_nat_setup_hook)(struct nf_conn *ct,
+				      enum nf_nat_manip_type manip,
+				      struct nlattr *attr) __read_mostly;
 EXPORT_SYMBOL_GPL(nfnetlink_parse_nat_setup_hook);
 
 DEFINE_SPINLOCK(nf_conntrack_lock);
