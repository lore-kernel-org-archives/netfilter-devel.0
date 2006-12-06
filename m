From: Randy Dunlap <randy.dunlap@oracle.com>
Subject: [PATCH] netfilter: fix non-ANSI func. decl.
Date: Tue, 5 Dec 2006 19:37:13 -0800
Message-ID: <20061205193713.e6f106a3.randy.dunlap@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netdev-owner@vger.kernel.org>
To: netdev <netdev@vger.kernel.org>
Sender: netdev-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

From: Randy Dunlap <randy.dunlap@oracle.com>

Fix non-ANSI function declaration:
net/netfilter/nf_conntrack_core.c:1096:25: warning: non-ANSI function declaration of function 'nf_conntrack_flush'

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
---
 net/netfilter/nf_conntrack_core.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- linux-2.6.19-git7.orig/net/netfilter/nf_conntrack_core.c
+++ linux-2.6.19-git7/net/netfilter/nf_conntrack_core.c
@@ -1093,7 +1093,7 @@ static void free_conntrack_hash(struct l
 			   get_order(sizeof(struct list_head) * size));
 }
 
-void nf_conntrack_flush()
+void nf_conntrack_flush(void)
 {
 	nf_ct_iterate_cleanup(kill_all, NULL);
 }


---
