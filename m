From: Yasuyuki KOZAKAI <yasuyuki.kozakai@toshiba.co.jp>
Subject: [PATCH 1/2] conntrack: fix incomplete copying IPv6 addresses
Date: Sun, 25 Dec 2005 16:36:36 +0900 (JST)
Message-ID: <200512250736.jBP7abcI006772@toshiba.co.jp>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: pablo@eurodev.net
Content-Disposition: inline; filename="01-copy-addr.patch"
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

[CONNTRACK] fix incomplete copying IPv6 addresses

If only addresses of orig(reply) tuple is specified, conntrack automatically
copy them to reply(orig) tuple. This fix makes conntrack possible to copy
IPv6 addresses correctly and set address family to invert tuple.

Signed-off-by: Yasuyuki Kozakai <yasuyuki.kozakai@toshiba.co.jp>

---
commit dcc6b2fb1e018f7ceda135c731417ce92755bc77
tree 2c153fed854cee7253f8484bcf7a67b9f82c62bc
parent 7789192e0f5cfb4e8903be500880984c29c10b2c
author Yasuyuki Kozakai <yasuyuki.kozakai@toshiba.co.jp> Sat, 24 Dec 2005 13:53:21 +0900
committer Yasuyuki Kozakai <yasuyuki.kozakai@toshiba.co.jp> Sat, 24 Dec 2005 13:53:21 +0900

 src/conntrack.c |   20 ++++++++++++--------
 1 files changed, 12 insertions(+), 8 deletions(-)

diff --git a/src/conntrack.c b/src/conntrack.c
index 1160bf6..63d2757 100644
--- a/src/conntrack.c
+++ b/src/conntrack.c
@@ -912,12 +912,14 @@ int main(int argc, char *argv[])
 	case CT_CREATE:
 		if ((options & CT_OPT_ORIG) 
 		    && !(options & CT_OPT_REPL)) {
-			reply.src.v4 = orig.dst.v4;
-			reply.dst.v4 = orig.src.v4;
+			reply.l3protonum = orig.l3protonum;
+			memcpy(&reply.src, &orig.dst, sizeof(reply.src));
+			memcpy(&reply.dst, &orig.src, sizeof(reply.dst));
 		} else if (!(options & CT_OPT_ORIG)
 			   && (options & CT_OPT_REPL)) {
-			orig.src.v4 = reply.dst.v4;
-			orig.dst.v4 = reply.src.v4;
+			orig.l3protonum = reply.l3protonum;
+			memcpy(&orig.src, &reply.dst, sizeof(orig.src));
+			memcpy(&orig.dst, &reply.src, sizeof(orig.dst));
 		}
 		if (options & CT_OPT_NATRANGE)
 			ct = nfct_conntrack_alloc(&orig, &reply, timeout, 
@@ -963,12 +965,14 @@ int main(int argc, char *argv[])
 	case CT_UPDATE:
 		if ((options & CT_OPT_ORIG) 
 		    && !(options & CT_OPT_REPL)) {
-			reply.src.v4 = orig.dst.v4;
-			reply.dst.v4 = orig.src.v4;
+			reply.l3protonum = orig.l3protonum;
+			memcpy(&reply.src, &orig.dst, sizeof(reply.src));
+			memcpy(&reply.dst, &orig.src, sizeof(reply.dst));
 		} else if (!(options & CT_OPT_ORIG)
 			   && (options & CT_OPT_REPL)) {
-			orig.src.v4 = reply.dst.v4;
-			orig.dst.v4 = reply.src.v4;
+			orig.l3protonum = reply.l3protonum;
+			memcpy(&orig.src, &reply.dst, sizeof(orig.src));
+			memcpy(&orig.dst, &reply.src, sizeof(orig.dst));
 		}
 		ct = nfct_conntrack_alloc(&orig, &reply, timeout,
 					  &proto, status, mark, id,
