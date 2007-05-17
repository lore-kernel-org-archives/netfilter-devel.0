From: zhaojingmin@vivecode.com (Jing Min Zhao)
Subject: [PATCH 4/4] H.323: Check range first in sequence extension
Date: Thu, 17 May 2007 15:17:57 -0400 (EDT)
Message-ID: <20070517191757.1047E3DA1FB@jzhao.vivecode.com>
Cc: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
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

Check range before checking STOP flag. This optimization may save a nanosecond or less :)

Signed-off-by: Jing Min Zhao <zhaojingmin@vivecode.com>
---
 net/netfilter/nf_conntrack_h323_asn1.c |   18 +++++++++---------
 1 files changed, 9 insertions(+), 9 deletions(-)

diff --git a/net/netfilter/nf_conntrack_h323_asn1.c b/net/netfilter/nf_conntrack_h323_asn1.c
index f6fad71..ceb39bd 100644
--- a/net/netfilter/nf_conntrack_h323_asn1.c
+++ b/net/netfilter/nf_conntrack_h323_asn1.c
@@ -555,15 +555,6 @@ int decode_seq(bitstr_t * bs, field_t * f, char *base, int level)
 
 	/* Decode the extension components */
 	for (opt = 0; opt < bmp2_len; opt++, i++, son++) {
-		if (i < f->ub && son->attr & STOP) {
-			PRINT("%*.s%s\n", (level + 1) * TAB_SIZE, " ",
-			      son->name);
-			return H323_ERROR_STOP;
-		}
-
-		if (!((0x80000000 >> opt) & bmp2))	/* Not present */
-			continue;
-
 		/* Check Range */
 		if (i >= f->ub) {	/* Newer Version? */
 			CHECK_BOUND(bs, 2);
@@ -573,6 +564,15 @@ int decode_seq(bitstr_t * bs, field_t * f, char *base, int level)
 			continue;
 		}
 
+		if (son->attr & STOP) {
+			PRINT("%*.s%s\n", (level + 1) * TAB_SIZE, " ",
+			      son->name);
+			return H323_ERROR_STOP;
+		}
+
+		if (!((0x80000000 >> opt) & bmp2))	/* Not present */
+			continue;
+
 		CHECK_BOUND(bs, 2);
 		len = get_len(bs);
 		CHECK_BOUND(bs, len);
-- 
1.4.4.3
