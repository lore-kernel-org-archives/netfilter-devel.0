From: Patrick McHardy <kaber@trash.net>
Subject: [PATCH 2.6.11 4/4]: Use GFP_ATOMIC in ipt_hashlimit
Date: Fri, 04 Feb 2005 04:05:17 +0100
Message-ID: <4202E66D.2010905@trash.net>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="------------050901090906030906000906"
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
--------------050901090906030906000906
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit

Fix GFP_KERNEL allocation under spinlock.



--------------050901090906030906000906
Content-Type: text/x-patch;
 name="04.diff"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="04.diff"

# This is a BitKeeper generated diff -Nru style patch.
#
# ChangeSet
#   2005/02/01 15:08:47+01:00 sjean@cookinglinux.org 
#   [NETFILTER]: Use GFP_ATOMIC in ipt_hashlimit
#   
#   Signed-off-by: Samuel Jean <sjean@cookinglinux.org>
#   Signed-off-by: Patrick McHardy <kaber@trash.net>
# 
# net/ipv4/netfilter/ipt_hashlimit.c
#   2005/02/01 15:08:39+01:00 sjean@cookinglinux.org +1 -1
#   [NETFILTER]: Use GFP_ATOMIC in ipt_hashlimit
#   
#   Signed-off-by: Samuel Jean <sjean@cookinglinux.org>
#   Signed-off-by: Patrick McHardy <kaber@trash.net>
# 
diff -Nru a/net/ipv4/netfilter/ipt_hashlimit.c b/net/ipv4/netfilter/ipt_hashlimit.c
--- a/net/ipv4/netfilter/ipt_hashlimit.c	2005-02-03 20:43:16 +01:00
+++ b/net/ipv4/netfilter/ipt_hashlimit.c	2005-02-03 20:43:16 +01:00
@@ -570,7 +570,7 @@
 	if (*pos >= htable->cfg.size)
 		return NULL;
 
-	bucket = kmalloc(sizeof(unsigned int), GFP_KERNEL);
+	bucket = kmalloc(sizeof(unsigned int), GFP_ATOMIC);
 	if (!bucket)
 		return ERR_PTR(-ENOMEM);
 

--------------050901090906030906000906--
