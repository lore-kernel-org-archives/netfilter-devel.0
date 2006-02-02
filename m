From: Holger Eitzenberger <heitzenberger@astaro.com>
Subject: [PATCH] [CT_SYNC] Fix use of unitializied tuplehash list-head
Date: Thu, 2 Feb 2006 12:38:26 +0100
Message-ID: <11388803061231-git-send-email-heitzenberger@astaro.com>
References: <11388803064149-git-send-email-heitzenberger@astaro.com>
Reply-To: Holger Eitzenberger <heitzenberger@astaro.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: 8bit
Cc: Harald Welte <laforge@netfilter.org>, Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
In-Reply-To: <11388803064149-git-send-email-heitzenberger@astaro.com>
To: netfilter-devel@lists.netfilter.org
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

ct_sync fails to initialize its tuplehash list-head upon creation
of a new conntrack, so that an list_del() later on in
destroy_conntrack() leads to a crash.

This patch initializes the list-head.

Signed-off-by: Harald Welte <laforge@netfilter.org>
Signed-off-by: Patrick McHardy <kaber@trash.net>
Signed-off-by: Holger Eitzenberger <heitzenberger@astaro.com>

---

 ct_sync/ct_sync_main.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

3bdbf56aa5e9e7411d8f32fa896f51ebd5a8ce15
diff --git a/ct_sync/ct_sync_main.c b/ct_sync/ct_sync_main.c
index 372374d..a73fd97 100644
--- a/ct_sync/ct_sync_main.c
+++ b/ct_sync/ct_sync_main.c
@@ -613,6 +613,8 @@ ct_sync_msg_process_update_ct(struct ct_
 			CT_SYNC_LEAVE();
 			return -1;
 		}
+
+		INIT_LIST_HEAD(&ct->tuplehash[IP_CT_DIR_ORIGINAL].list);
 		new = 1;
 	}
 
-- 
-dirty
