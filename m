From: Patrick McHardy <kaber@trash.net>
Subject: [NETFILTER 01/50]: nf_conntrack_h323: check range first in sequence
	extension
Date: Sat,  7 Jul 2007 14:23:01 +0200 (MEST)
Message-ID: <20070707122217.1589.66775.sendpatchset@localhost.localdomain>
References: <20070707122215.1589.12100.sendpatchset@localhost.localdomain>
Cc: netfilter-devel@lists.netfilter.org, Patrick McHardy <kaber@trash.net>
To: davem@davemloft.net
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
In-Reply-To: <20070707122215.1589.12100.sendpatchset@localhost.localdomain>
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

[NETFILTER]: nf_conntrack_h323: check range first in sequence extension

Check range before checking STOP flag. This optimization may save a
nanosecond or less :)

Signed-off-by: Jing Min Zhao <zhaojingmin@vivecode.com>
Signed-off-by: Patrick McHardy <kaber@trash.net>

---
commit f32236698107064a21157edb09cf06645f63409f
tree a2e0ecdb5fdee79963b3dca60e37f447416056d3
parent 0e430d6461fe5661dd2214dbb9aaf6d7fcceaeb9
author Jing Min Zhao <zhaojingmin@vivecode.com> Sat, 07 Jul 2007 12:15:02 +0200
committer Patrick McHardy <kaber@trash.net> Sat, 07 Jul 2007 12:15:02 +0200

 net/netfilter/nf_conntrack_h323_asn1.c |   18 +++++++++---------
 1 files changed, 9 insertions(+), 9 deletions(-)

diff --git a/net/netfilter/nf_conntrack_h323_asn1.c b/net/netfilter/nf_conntrack_h323_asn1.c
index 6b7eaa0..a869403 100644
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
