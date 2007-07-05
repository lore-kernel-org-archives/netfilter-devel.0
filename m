From: Patrick McHardy <kaber@trash.net>
Subject: [NETFILTER]: nf_conntrack_h323: add checking of out-of-range on
 choices' index values
Date: Thu, 05 Jul 2007 20:42:14 +0200
Message-ID: <468D3B86.5020308@trash.net>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="------------090603060801030404070306"
Cc: security@kernel.org,
	Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>,
	stable@kernel.org
To: "David S. Miller" <davem@davemloft.net>
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

This is a multi-part message in MIME format.
--------------090603060801030404070306
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit

Fix a remotely triggerable crash in the netfilter H.323 connection
tracking helper. Patch applies to stable 2.6.20/2.6.21 and current
-git.


--------------090603060801030404070306
Content-Type: text/plain;
 name="x"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="x"

[NETFILTER]: nf_conntrack_h323: add checking of out-of-range on choices' index values

Choices' index values may be out of range while still encoded in the fixed
length bit-field. This bug may cause access to undefined types (NULL
pointers) and thus crashes (Reported by Zhongling Wen).

This patch also adds checking of decode flag when decoding SEQUENCEs.

Signed-off-by: Jing Min Zhao <zhaojingmin@vivecode.com>
Signed-off-by: Patrick McHardy <kaber@trash.net>

---
commit 5e8b2229d2d2bdbc4c05e4b3176d5054efe6b146
tree f99e5a063dac012f3caea6e78d3f73d64d1e576a
parent 190045d53b9a8341e8600d6eb468b6081e903afb
author Patrick McHardy <kaber@trash.net> Thu, 05 Jul 2007 20:30:59 +0200
committer Patrick McHardy <kaber@trash.net> Thu, 05 Jul 2007 20:30:59 +0200

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

--------------090603060801030404070306--
