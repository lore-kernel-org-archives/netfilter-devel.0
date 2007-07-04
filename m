From: zhaojingmin@vivecode.com (Jing Min Zhao)
Subject: [PATCH 1/1] Add checking of out-of-range on Choices' index values
Date: Wed,  4 Jul 2007 12:49:52 -0400 (EDT)
Message-ID: <20070704164952.834B114369A@jzhao.vivecode.com>
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

Choices' index values may be out of range while still encoded in the fixed length bit-field. This bug may cause access to undefined types (NULL pointers) and thus crashes (Reported by Zhongling Wen).

This patch also adds checking of decode flag when decoding SEQUENCEs.

Signed-off-by: Jing Min Zhao <zhaojingmin@vivecode.com>
---
 net/netfilter/nf_conntrack_h323_asn1.c |    4 +++-
 1 files changed, 3 insertions(+), 1 deletions(-)

diff --git a/net/netfilter/nf_conntrack_h323_asn1.c b/net/netfilter/nf_conntrack_h323_asn1.c
index f6fad71..6b7eaa0 100644
--- a/net/netfilter/nf_conntrack_h323_asn1.c
+++ b/net/netfilter/nf_conntrack_h323_asn1.c
@@ -518,7 +518,7 @@ int decode_seq(bitstr_t * bs, field_t * f, char *base, int level)
 			CHECK_BOUND(bs, 2);
 			len = get_len(bs);
 			CHECK_BOUND(bs, len);
-			if (!base) {
+			if (!base || !(son->attr & DECODE)) {
 				PRINT("%*.s%s\n", (level + 1) * TAB_SIZE,
 				      " ", son->name);
 				bs->cur += len;
@@ -704,6 +704,8 @@ int decode_choice(bitstr_t * bs, field_t * f, char *base, int level)
 	} else {
 		ext = 0;
 		type = get_bits(bs, f->sz);
+		if (type >= f->lb)
+			return H323_ERROR_RANGE;
 	}
 
 	/* Write Type */
-- 
1.4.4.3
