From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 3/6] Remove duplicate checkings in nfnetlink_check_attributes
Date: Thu, 15 Feb 2007 04:23:07 +0100
Message-ID: <45D3D21B.1050509@netfilter.org>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="------------050204020102070508010307"
Cc: Patrick McHardy <kaber@trash.net>
To: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
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

This is a multi-part message in MIME format.
--------------050204020102070508010307
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

nfnetlink_check_attributes duplicates message size and callback id
checkings. nfnetlink_find_client and nfnetlink_rcv_msg already do such
checkings.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>

-- 
The dawn of the fourth age of Linux firewalling is coming; a time of
great struggle and heroic deeds -- J.Kadlecsik got inspired by J.Morris

--------------050204020102070508010307
Content-Type: text/plain;
 name="04.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="04.patch"

[PATCH] Remove duplicate checkings in nfnetlink_check_attributes

nfnetlink_check_attributes duplicates message size and callback id checkings. 
nfnetlink_find_client and nfnetlink_rcv_msg already do such checkings.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>

Index: net-2.6.git/net/netfilter/nfnetlink.c
===================================================================
--- net-2.6.git.orig/net/netfilter/nfnetlink.c	2006-12-26 04:45:09.000000000 +0100
+++ net-2.6.git/net/netfilter/nfnetlink.c	2006-12-26 04:49:28.000000000 +0100
@@ -127,17 +127,10 @@ static int
 nfnetlink_check_attributes(struct nfnetlink_subsystem *subsys,
 			   struct nlmsghdr *nlh, struct nfattr *cda[])
 {
-	int min_len;
+	int min_len = NLMSG_SPACE(sizeof(struct nfgenmsg));
 	u_int16_t attr_count;
 	u_int8_t cb_id = NFNL_MSG_TYPE(nlh->nlmsg_type);
 
-	if (unlikely(cb_id >= subsys->cb_count))
-		return -EINVAL;
-
-	min_len = NLMSG_SPACE(sizeof(struct nfgenmsg));
-	if (unlikely(nlh->nlmsg_len < min_len))
-		return -EINVAL;
-
 	attr_count = subsys->cb[cb_id].attr_count;
 	memset(cda, 0, sizeof(struct nfattr *) * attr_count);
 

--------------050204020102070508010307--
