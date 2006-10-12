From: Patrick McHardy <kaber@trash.net>
Subject: [NETFILTER 01/06]: fix cut-and-paste error in exit functions
Date: Thu, 12 Oct 2006 11:54:20 +0200 (MEST)
Message-ID: <20061012095548.11462.69520.sendpatchset@localhost.localdomain>
References: <20061012095547.11462.58507.sendpatchset@localhost.localdomain>
Cc: netfilter-devel@lists.netfilter.org, Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: davem@davemloft.net
In-Reply-To: <20061012095547.11462.58507.sendpatchset@localhost.localdomain>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: </pipermail/netfilter-devel>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
Sender: netfilter-devel-bounces@lists.netfilter.org
Errors-To: netfilter-devel-bounces@lists.netfilter.org
List-Id: netfilter-devel.vger.kernel.org

[NETFILTER]: fix cut-and-paste error in exit functions

Signed-off-by: Patrick McHardy <kaber@trash.net>

---
commit c7b1507f3c040c02efa1b955f7180a33a232c4d9
tree fd21258deca0e5d8859271bb2c745302ce5a1e2a
parent 26da6cf44bc574d528d715a17e48f54da061c151
author Patrick McHardy <kaber@trash.net> Wed, 11 Oct 2006 08:35:50 +0200
committer Patrick McHardy <kaber@trash.net> Wed, 11 Oct 2006 08:35:50 +0200

 net/netfilter/xt_NFQUEUE.c  |    2 +-
 net/netfilter/xt_connmark.c |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/netfilter/xt_NFQUEUE.c b/net/netfilter/xt_NFQUEUE.c
index db9b896..39e1175 100644
--- a/net/netfilter/xt_NFQUEUE.c
+++ b/net/netfilter/xt_NFQUEUE.c
@@ -68,7 +68,7 @@ static int __init xt_nfqueue_init(void)
 
 static void __exit xt_nfqueue_fini(void)
 {
-	xt_register_targets(xt_nfqueue_target, ARRAY_SIZE(xt_nfqueue_target));
+	xt_unregister_targets(xt_nfqueue_target, ARRAY_SIZE(xt_nfqueue_target));
 }
 
 module_init(xt_nfqueue_init);
diff --git a/net/netfilter/xt_connmark.c b/net/netfilter/xt_connmark.c
index 92a5726..a8f0305 100644
--- a/net/netfilter/xt_connmark.c
+++ b/net/netfilter/xt_connmark.c
@@ -147,7 +147,7 @@ static int __init xt_connmark_init(void)
 
 static void __exit xt_connmark_fini(void)
 {
-	xt_register_matches(xt_connmark_match, ARRAY_SIZE(xt_connmark_match));
+	xt_unregister_matches(xt_connmark_match, ARRAY_SIZE(xt_connmark_match));
 }
 
 module_init(xt_connmark_init);
