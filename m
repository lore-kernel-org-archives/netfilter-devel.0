From: Patrick McHardy <kaber@trash.net>
Subject: [NETFILTER 2/3]: H.323 helper: fix sequence extension parsing
Date: Tue, 23 May 2006 11:41:51 +0200
Message-ID: <4472D8DF.60506@trash.net>
Mime-Version: 1.0
Content-Type: text/plain;
 name="02.diff"
Content-Transfer-Encoding: 7bit
Cc: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: "David S. Miller" <davem@davemloft.net>
Content-Disposition: inline;
 filename="02.diff"
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

[NETFILTER]: H.323 helper: fix sequence extension parsing

When parsing unknown sequence extensions the "son"-pointer points behind
the last known extension for this type, don't try to interpret it.

Signed-off-by: Patrick McHardy <kaber@trash.net>

---
commit e79f105111e9a6088868a879934d0574ce6230ad
tree 5d61518ccb84bd58632eca399235459d9a2cd49c
parent 97326cd6bc2a1360c213113cf1c7bc5514ad6d5b
author Patrick McHardy <kaber@trash.net> Tue, 23 May 2006 11:16:22 +0200
committer Patrick McHardy <kaber@trash.net> Tue, 23 May 2006 11:16:22 +0200

 net/ipv4/netfilter/ip_conntrack_helper_h323_asn1.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/net/ipv4/netfilter/ip_conntrack_helper_h323_asn1.c b/net/ipv4/netfilter/ip_conntrack_helper_h323_asn1.c
index 5d04438..26dfeca 100644
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
