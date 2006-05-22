From: Patrick McHardy <kaber@trash.net>
Subject: [NETFILTER]: H.323 helper: fix sequence extension parsing
Date: Mon, 22 May 2006 12:46:29 +0200
Message-ID: <44719685.6000906@trash.net>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="------------070102050207020506040903"
Cc: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Jing Min Zhao <zhaojingmin@users.sourceforge.net>
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
--------------070102050207020506040903
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit

Doesn't really fix the crash I was seeing, but does hide it away :)
Anyway, its a real bug ...


--------------070102050207020506040903
Content-Type: text/plain;
 name="02.diff"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="02.diff"

[NETFILTER]: H.323 helper: fix sequence extension parsing

When parsing unknown sequence extensions the "son"-pointer points behind
the last known extension for this type, don't try to interpret it.

Signed-off-by: Patrick McHardy <kaber@trash.net>

---
commit b3199d41dfddb7521bcc09ab0fc9925b5702c954
tree 7da1d63f6fa658506616cba8621dd1c348ef0c31
parent 27ce42efc29f421d4238c426769f057dd384bd14
author Patrick McHardy <kaber@trash.net> Mon, 22 May 2006 12:40:03 +0200
committer Patrick McHardy <kaber@trash.net> Mon, 22 May 2006 12:40:03 +0200

 net/ipv4/netfilter/ip_conntrack_helper_h323_asn1.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/net/ipv4/netfilter/ip_conntrack_helper_h323_asn1.c b/net/ipv4/netfilter/ip_conntrack_helper_h323_asn1.c
index 5f4d114..11862f1 100644
--- a/net/ipv4/netfilter/ip_conntrack_helper_h323_asn1.c
+++ b/net/ipv4/netfilter/ip_conntrack_helper_h323_asn1.c
@@ -555,7 +555,7 @@ int decode_seq(bitstr_t * bs, field_t * 
 
 	/* Decode the extension components */
 	for (opt = 0; opt < bmp2_len; opt++, i++, son++) {
-		if (son->attr & STOP) {
+		if (i < f->ub && son->attr & STOP) {
 			PRINT("%*.s%s\n", (level + 1) * TAB_SIZE, " ",
 			      son->name);
 			return H323_ERROR_STOP;

--------------070102050207020506040903--
