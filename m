From: Patrick McHardy <kaber@trash.net>
Subject: [NETFILTER 05/05]: ebt_mark: add or/and/xor action support to mark
	target
Date: Mon,  2 Oct 2006 17:46:10 +0200 (MEST)
Message-ID: <20061002154723.13121.55358.sendpatchset@localhost.localdomain>
References: <20061002154716.13121.53265.sendpatchset@localhost.localdomain>
Cc: netfilter-devel@lists.netfilter.org, Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: davem@davemloft.net
In-Reply-To: <20061002154716.13121.53265.sendpatchset@localhost.localdomain>
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

[NETFILTER]: ebt_mark: add or/and/xor action support to mark target

The following patch adds or/and/xor functionality for the mark target,
while staying backwards compatible.

Signed-off-by: Bart De Schuymer <bdschuym@pandora.be>
Signed-off-by: Patrick McHardy <kaber@trash.net>

---
commit 9a2c1735d4cf9c120d67d9bf82bb4455804f2041
tree 9049c23fafecd717254cbe066c1f9e310e5227a8
parent 606add40816396611545a6239c1029a473448d9f
author Bart De Schuymer <bdschuym@pandora.be> Mon, 02 Oct 2006 17:39:55 +0200
committer Patrick McHardy <kaber@trash.net> Mon, 02 Oct 2006 17:39:55 +0200

 include/linux/netfilter_bridge/ebt_mark_t.h |   12 ++++++++++++
 net/bridge/netfilter/ebt_mark.c             |   21 +++++++++++++++++----
 2 files changed, 29 insertions(+), 4 deletions(-)

diff --git a/include/linux/netfilter_bridge/ebt_mark_t.h b/include/linux/netfilter_bridge/ebt_mark_t.h
index 110fec6..6270f6f 100644
--- a/include/linux/netfilter_bridge/ebt_mark_t.h
+++ b/include/linux/netfilter_bridge/ebt_mark_t.h
@@ -1,6 +1,18 @@
 #ifndef __LINUX_BRIDGE_EBT_MARK_T_H
 #define __LINUX_BRIDGE_EBT_MARK_T_H
 
+/* The target member is reused for adding new actions, the
+ * value of the real target is -1 to -NUM_STANDARD_TARGETS.
+ * For backward compatibility, the 4 lsb (2 would be enough,
+ * but let's play it safe) are kept to designate this target.
+ * The remaining bits designate the action. By making the set
+ * action 0xfffffff0, the result will look ok for older
+ * versions. [September 2006] */
+#define MARK_SET_VALUE (0xfffffff0)
+#define MARK_OR_VALUE  (0xffffffe0)
+#define MARK_AND_VALUE (0xffffffd0)
+#define MARK_XOR_VALUE (0xffffffc0)
+
 struct ebt_mark_t_info
 {
 	unsigned long mark;
diff --git a/net/bridge/netfilter/ebt_mark.c b/net/bridge/netfilter/ebt_mark.c
index 770c0df..b54306a 100644
--- a/net/bridge/netfilter/ebt_mark.c
+++ b/net/bridge/netfilter/ebt_mark.c
@@ -22,24 +22,37 @@ static int ebt_target_mark(struct sk_buf
    const void *data, unsigned int datalen)
 {
 	struct ebt_mark_t_info *info = (struct ebt_mark_t_info *)data;
+	int action = info->target & -16;
 
-	if ((*pskb)->nfmark != info->mark)
+	if (action == MARK_SET_VALUE)
 		(*pskb)->nfmark = info->mark;
+	else if (action == MARK_OR_VALUE)
+		(*pskb)->nfmark |= info->mark;
+	else if (action == MARK_AND_VALUE)
+		(*pskb)->nfmark &= info->mark;
+	else
+		(*pskb)->nfmark ^= info->mark;
 
-	return info->target;
+	return info->target | -16;
 }
 
 static int ebt_target_mark_check(const char *tablename, unsigned int hookmask,
    const struct ebt_entry *e, void *data, unsigned int datalen)
 {
 	struct ebt_mark_t_info *info = (struct ebt_mark_t_info *)data;
+	int tmp;
 
 	if (datalen != EBT_ALIGN(sizeof(struct ebt_mark_t_info)))
 		return -EINVAL;
-	if (BASE_CHAIN && info->target == EBT_RETURN)
+	tmp = info->target | -16;
+	if (BASE_CHAIN && tmp == EBT_RETURN)
 		return -EINVAL;
 	CLEAR_BASE_CHAIN_BIT;
-	if (INVALID_TARGET)
+	if (tmp < -NUM_STANDARD_TARGETS || tmp >= 0)
+		return -EINVAL;
+	tmp = info->target & -16;
+	if (tmp != MARK_SET_VALUE && tmp != MARK_OR_VALUE &&
+	    tmp != MARK_AND_VALUE && tmp != MARK_XOR_VALUE)
 		return -EINVAL;
 	return 0;
 }
