From: Jan Engelhardt <jengelh@linux01.gwdg.de>
Subject: [PATCH 5/4] Use bools for xt_match
Date: Mon, 4 Jun 2007 17:29:57 +0200 (MEST)
Message-ID: <Pine.LNX.4.61.0706041729030.20829@yvahk01.tjqt.qr>
References: <Pine.LNX.4.61.0706041707410.20829@yvahk01.tjqt.qr>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Netfilter Developer Mailing List <netfilter-devel@lists.netfilter.org>
To: kaber@trash.net
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
In-Reply-To: <Pine.LNX.4.61.0706041707410.20829@yvahk01.tjqt.qr>
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


Hi, this one slipped by (I am just going through some more cleanups), 
hence, an extra 5th patch on the bools stuff.

Signed-off-by: Jan Engelhardt <jengelh@gmx.de>

---
 net/netfilter/xt_physdev.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

Index: linux-2.6.22-rc3-git6/net/netfilter/xt_physdev.c
===================================================================
--- linux-2.6.22-rc3-git6.orig/net/netfilter/xt_physdev.c
+++ linux-2.6.22-rc3-git6/net/netfilter/xt_physdev.c
@@ -76,13 +76,13 @@ match(const struct sk_buff *skb,
 	if (!(info->bitmask & XT_PHYSDEV_OP_IN))
 		goto match_outdev;
 	indev = nf_bridge->physindev ? nf_bridge->physindev->name : nulldevname;
-	for (i = 0, ret = 0; i < IFNAMSIZ/sizeof(unsigned int); i++) {
+	for (i = 0, ret = false; i < IFNAMSIZ/sizeof(unsigned int); i++) {
 		ret |= (((const unsigned int *)indev)[i]
 			^ ((const unsigned int *)info->physindev)[i])
 			& ((const unsigned int *)info->in_mask)[i];
 	}
 
-	if ((ret == 0) ^ !(info->invert & XT_PHYSDEV_OP_IN))
+	if (!ret ^ !(info->invert & XT_PHYSDEV_OP_IN))
 		return false;
 
 match_outdev:
@@ -90,7 +90,7 @@ match_outdev:
 		return true;
 	outdev = nf_bridge->physoutdev ?
 		 nf_bridge->physoutdev->name : nulldevname;
-	for (i = 0, ret = 0; i < IFNAMSIZ/sizeof(unsigned int); i++) {
+	for (i = 0, ret = false; i < IFNAMSIZ/sizeof(unsigned int); i++) {
 		ret |= (((const unsigned int *)outdev)[i]
 			^ ((const unsigned int *)info->physoutdev)[i])
 			& ((const unsigned int *)info->out_mask)[i];
