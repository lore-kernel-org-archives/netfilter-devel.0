From: Patrick McHardy <kaber@trash.net>
Subject: [PATCH 2.4 7/8]: Fix refreshing of overlapping expectations
Date: Fri, 04 Mar 2005 13:18:54 +0100
Message-ID: <4228522E.2030704@trash.net>
Mime-Version: 1.0
Content-Type: text/x-patch;
 name="07.diff"
Content-Transfer-Encoding: 7bit
Cc: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
To: "David S. Miller" <davem@davemloft.net>
Content-Disposition: inline;
 filename="07.diff"
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

# This is a BitKeeper generated diff -Nru style patch.
#
# ChangeSet
#   2005/03/04 01:03:49+01:00 kaber@coreworks.de 
#   [NETFILTER]: Fix refreshing of overlapping expectations
#   
#   Backport from 2.6, original patch from Rusty:
#   
#   More importantly, a previous expectation should only be refreshed and return
#   EEXIST if it's owned by the same connection (nfsim found this bug).
#   
#   Slightly different from 2.6 patch, it had a bug that was corrected
#   in a different patch. We still want to return -EEXIST if the
#   expectation is owned by a different connection as the expectation
#   list is global.
#   
#   Signed-off-by: Patrick McHardy <kaber@trash.net>
# 
# net/ipv4/netfilter/ip_conntrack_core.c
#   2005/03/04 01:03:48+01:00 kaber@coreworks.de +2 -1
#   [NETFILTER]: Fix refreshing of overlapping expectations
#   
#   Backport from 2.6, original patch from Rusty:
#   
#   More importantly, a previous expectation should only be refreshed and return
#   EEXIST if it's owned by the same connection (nfsim found this bug).
#   
#   Slightly different from 2.6 patch, it had a bug that was corrected
#   in a different patch. We still want to return -EEXIST if the
#   expectation is owned by a different connection as the expectation
#   list is global.
#   
#   Signed-off-by: Patrick McHardy <kaber@trash.net>
# 
diff -Nru a/net/ipv4/netfilter/ip_conntrack_core.c b/net/ipv4/netfilter/ip_conntrack_core.c
--- a/net/ipv4/netfilter/ip_conntrack_core.c	2005-03-04 01:52:08 +01:00
+++ b/net/ipv4/netfilter/ip_conntrack_core.c	2005-03-04 01:52:08 +01:00
@@ -973,7 +973,8 @@
 		   pointing into the payload - otherwise we should have to copy 
 		   the data filled out by the helper over the old one */
 		DEBUGP("expect_related: resent packet\n");
-		if (related_to->helper->timeout) {
+		if (old->expectant == related_to &&
+		    related_to->helper->timeout) {
 			if (!del_timer(&old->timeout)) {
 				/* expectation is dying. Fall through */
 				old = NULL;
