From: Patrick McHardy <kaber@trash.net>
Subject: [PATCH 2.6.11 3/4]: Fix ip_conntrack_ftp crash with debugging
	enabled
Date: Fri, 04 Feb 2005 04:05:14 +0100
Message-ID: <4202E66A.9070908@trash.net>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="------------020707000302070408020405"
Cc: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
To: "David S. Miller" <davem@davemloft.net>
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
--------------020707000302070408020405
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit

data doesn't exist, an integer is printed with %s



--------------020707000302070408020405
Content-Type: text/x-patch;
 name="03.diff"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="03.diff"

# This is a BitKeeper generated diff -Nru style patch.
#
# ChangeSet
#   2005/02/01 14:24:23+01:00 nib@cookinglinux.org 
#   [NETFILTER]: Fix ip_conntrack_ftp crash with debugging enabled
#   
#   Signed-off-by: Nicolas Bouliane <nib@cookinglinux.org>
#   Signed-off-by: Patrick McHardy <kaber@trash.net>
# 
# net/ipv4/netfilter/ip_conntrack_ftp.c
#   2005/02/01 14:24:15+01:00 nib@cookinglinux.org +3 -4
#   [NETFILTER]: Fix ip_conntrack_ftp crash with debugging enabled
#   
#   Signed-off-by: Nicolas Bouliane <nib@cookinglinux.org>
#   Signed-off-by: Patrick McHardy <kaber@trash.net>
# 
diff -Nru a/net/ipv4/netfilter/ip_conntrack_ftp.c b/net/ipv4/netfilter/ip_conntrack_ftp.c
--- a/net/ipv4/netfilter/ip_conntrack_ftp.c	2005-02-03 20:43:10 +01:00
+++ b/net/ipv4/netfilter/ip_conntrack_ftp.c	2005-02-03 20:43:10 +01:00
@@ -373,10 +373,9 @@
 		goto out_update_nl;
 	}
 
-	DEBUGP("conntrack_ftp: match `%.*s' (%u bytes at %u)\n",
-	       (int)matchlen, data + matchoff,
-	       matchlen, ntohl(th->seq) + matchoff);
-
+	DEBUGP("conntrack_ftp: match `%s' (%u bytes at %u)\n",
+	       fb_ptr + matchoff, matchlen, ntohl(th->seq) + matchoff);
+			 
 	/* Allocate expectation which will be inserted */
 	exp = ip_conntrack_expect_alloc();
 	if (exp == NULL) {

--------------020707000302070408020405--
