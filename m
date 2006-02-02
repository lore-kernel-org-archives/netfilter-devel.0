From: Holger Eitzenberger <heitzenberger@astaro.com>
Subject: [PATCH] [NETFILTER] Remove BUG_ON() in destroy_conntrack()
Date: Thu, 2 Feb 2006 12:38:26 +0100
Message-ID: <11388803061179-git-send-email-heitzenberger@astaro.com>
References: <11388803061231-git-send-email-heitzenberger@astaro.com>
Reply-To: Holger Eitzenberger <heitzenberger@astaro.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: 8bit
Cc: Harald Welte <laforge@netfilter.org>, Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
In-Reply-To: <11388803061231-git-send-email-heitzenberger@astaro.com>
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

Remove BUG_ON(list_empty(...)) check in destroy_conntrack because
it is perfectly valid for conntracks to be in no list at all, e. g.
if ct_sync is used.

Signed-off-by: Harald Welte <laforge@netfilter.org>
Signed-off-by: Patrick McHardy <kaber@trash.net>
Signed-off-by: Holger Eitzenberger <heitzenberger@astaro.com>

---

 net/ipv4/netfilter/ip_conntrack_core.c |    4 +---
 1 files changed, 1 insertions(+), 3 deletions(-)

8f62bac9822927ea1306d4752ca48cb1d9f73ff0
diff --git a/net/ipv4/netfilter/ip_conntrack_core.c b/net/ipv4/netfilter/ip_conntrack_core.c
index 14660db..6bec236 100644
--- a/net/ipv4/netfilter/ip_conntrack_core.c
+++ b/net/ipv4/netfilter/ip_conntrack_core.c
@@ -339,10 +339,8 @@ destroy_conntrack(struct nf_conntrack *n
 	ip_ct_remove_expectations(ct);
 
 	/* We overload first tuple to link into unconfirmed list. */
-	if (!is_confirmed(ct)) {
-		BUG_ON(list_empty(&ct->tuplehash[IP_CT_DIR_ORIGINAL].list));
+	if (!is_confirmed(ct))
 		list_del(&ct->tuplehash[IP_CT_DIR_ORIGINAL].list);
-	}
 
 	CONNTRACK_STAT_INC(delete);
 	write_unlock_bh(&ip_conntrack_lock);
-- 
-dirty
