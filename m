From: Pablo Neira Ayuso <pablo@eurodev.net>
Subject: [LIBNFNETLINK 2/3] Fix wrong nfnetlink header size
Date: Sun, 12 Feb 2006 22:39:39 +0100
Message-ID: <43EFAB1B.3040309@eurodev.net>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="------------050700090601010409040808"
Cc: Harald Welte <laforge@netfilter.org>, Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
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
--------------050700090601010409040808
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit

Fix wrong size of the netfilter netlink header. This implicitely fixes
an alignment issue when nfnl_handle_packet is called as well.

-- 
Pablo

--------------050700090601010409040808
Content-Type: text/plain;
 name="02.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="02.patch"

[LIBNFNETLINK] Fix wrong nfnetlink header size

Fix wrong size of the netfilter netlink header. This implicitely fixes an
alignment issue when nfnl_handle_packet is called as well.

Index: libnfnetlink/src/libnfnetlink.c
===================================================================
--- libnfnetlink.orig/src/libnfnetlink.c	2006-02-12 19:28:19.000000000 +0100
+++ libnfnetlink/src/libnfnetlink.c	2006-02-12 19:30:00.000000000 +0100
@@ -914,7 +914,7 @@ int nfnl_check_attributes(const struct n
 	if (type >= ssh->cb_count)
 		return -EINVAL;
 
-	min_len = NLMSG_ALIGN(sizeof(struct nfgenmsg));
+	min_len = NLMSG_SPACE(sizeof(struct nfgenmsg));
 	if (nlh->nlmsg_len < min_len)
 		return -EINVAL;
 #endif

--------------050700090601010409040808--
