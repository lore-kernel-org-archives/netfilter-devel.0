From: Patrick McHardy <kaber@trash.net>
Subject: [PATCH 2.6 14/19]: Fix warning in CONNMARK
Date: Mon, 25 Oct 2004 02:49:52 +0200
Sender: netfilter-devel-bounces@lists.netfilter.org
Message-ID: <417C4DB0.3090206@trash.net>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="------------010207030005010508030209"
Cc: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: "David S. Miller" <davem@redhat.com>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: </pipermail/netfilter-devel>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
Errors-To: netfilter-devel-bounces@lists.netfilter.org
List-Id: netfilter-devel.vger.kernel.org

This is a multi-part message in MIME format.
--------------010207030005010508030209
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit

Fix warning in CONNMARK:
net/ipv4/netfilter/ipt_CONNMARK.c:63: warning: suggest parentheses 
around arithmetic in operand of ^



--------------010207030005010508030209
Content-Type: text/x-patch;
 name="14.diff"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="14.diff"

# This is a BitKeeper generated diff -Nru style patch.
#
# ChangeSet
#   2004/10/24 16:16:40+02:00 tgraf@suug.ch 
#   [NETFILTER]: Fix warning in CONNMARK
#   
#   Signed-off-by: Thomas Graf <tgraf@suug.ch>
#   Signed-off-by: Patrick McHardy <kaber@trash.net>
# 
# net/ipv4/netfilter/ipt_CONNMARK.c
#   2004/10/24 16:16:34+02:00 tgraf@suug.ch +1 -1
#   [NETFILTER]: Fix warning in CONNMARK
#   
#   Signed-off-by: Thomas Graf <tgraf@suug.ch>
#   Signed-off-by: Patrick McHardy <kaber@trash.net>
# 
diff -Nru a/net/ipv4/netfilter/ipt_CONNMARK.c b/net/ipv4/netfilter/ipt_CONNMARK.c
--- a/net/ipv4/netfilter/ipt_CONNMARK.c	2004-10-25 01:13:43 +02:00
+++ b/net/ipv4/netfilter/ipt_CONNMARK.c	2004-10-25 01:13:43 +02:00
@@ -60,7 +60,7 @@
 		break;
 	    case IPT_CONNMARK_RESTORE:
 		nfmark = (*pskb)->nfmark;
-		diff = (ct->mark ^ nfmark & markinfo->mask);
+		diff = (ct->mark ^ nfmark) & markinfo->mask;
 		if (diff != 0) {
 		    (*pskb)->nfmark = nfmark ^ diff;
 		    (*pskb)->nfcache |= NFC_ALTERED;

--------------010207030005010508030209--
