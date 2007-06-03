From: Jan Engelhardt <jengelh@linux01.gwdg.de>
Subject: [PATCH] libipt_hashlimit doc update
Date: Sun, 3 Jun 2007 14:34:41 +0200 (MEST)
Message-ID: <Pine.LNX.4.61.0706031434090.10578@yvahk01.tjqt.qr>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Netfilter Developer Mailing List <netfilter-devel@lists.netfilter.org>
To: kaber@trash.net
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


Add srcip,srcport to hashlimit manpage.

Signed-off-by: Jan Engelhardt <jengelh@gmx.de>

---
 extensions/libipt_hashlimit.man |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

Index: iptables/extensions/libipt_hashlimit.man
===================================================================
--- iptables.orig/extensions/libipt_hashlimit.man
+++ iptables/extensions/libipt_hashlimit.man
@@ -16,8 +16,8 @@ A rate just like the limit match
 .BI "--hashlimit-burst " "num"
 Burst value, just like limit match
 .TP
-.BI "--hashlimit-mode " "destip | destip-destport"
-Limit per IP or per port
+.BI "--hashlimit-mode " "dstip,srcip,dstport,srcport"
+A comma-separated list of objects to take into consideration
 .TP
 .BI "--hashlimit-name " "foo"
 The name for the /proc/net/ipt_hashlimit/foo entry
