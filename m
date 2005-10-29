From: Pablo Neira <pablo@eurodev.net>
Subject: Re: problem with conntrack utility and kernel 2.6.14
Date: Sat, 29 Oct 2005 15:06:48 +0200
Message-ID: <436373E8.7040606@eurodev.net>
References: <4361EAAB.1090206@fliegl.de>	<4361F6DF.3050106@eurodev.net>	<43621028.40705@fliegl.de>	<43627A8F.9060307@eurodev.net>
	<436281BB.2010100@fliegl.de>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="------------000906080102030701050007"
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Deti Fliegl <deti@fliegl.de>
In-Reply-To: <436281BB.2010100@fliegl.de>
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
--------------000906080102030701050007
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit

Hi,

Deti Fliegl wrote:
> Thanks for the patch (which seemed to be already checked into svn) - 
> conntrack now works properly - no seg faults occured :)

Could you give a try to the patch attached and tell me if it fixes the 
problem as well?

> The kernel oops still happens - but this time I had access to the 
> console (hope that helps):

Thanks a lot for the report, I'll have a look at it asap.

-- 
Pablo

--------------000906080102030701050007
Content-Type: text/plain;
 name="x"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="x"

Index: libnfnetlink/include/libnfnetlink/libnfnetlink.h
===================================================================
--- libnfnetlink/include/libnfnetlink/libnfnetlink.h	(revision 4394)
+++ libnfnetlink/include/libnfnetlink/libnfnetlink.h	(working copy)
@@ -18,8 +21,8 @@
 #define NLMSG_TAIL(nlh) \
 	(((void *) (nlh)) + NLMSG_ALIGN((nlh)->nlmsg_len))
 
-#define NFNL_HEADER_LEN	(NLMSG_LENGTH(sizeof(struct nlmsghdr))	\
-			 +NLMSG_LENGTH(sizeof(struct nfgenmsg)))
+#define NFNL_HEADER_LEN	(NLMSG_ALIGN(sizeof(struct nlmsghdr))	\
+			 +NLMSG_ALIGN(sizeof(struct nfgenmsg)))
 
 #define NFNL_BUFFSIZE		8192
 
Index: libnetfilter_conntrack/src/libnetfilter_conntrack.c
===================================================================
--- libnetfilter_conntrack/src/libnetfilter_conntrack.c	(revision 4398)
+++ libnetfilter_conntrack/src/libnetfilter_conntrack.c	(working copy)
@@ -433,7 +433,7 @@
 {
 	struct nfgenmsg *nfmsg;
 	struct nfattr *attr = NFM_NFA(NLMSG_DATA(nlh));
-	int attrlen = NLMSG_LENGTH(nlh->nlmsg_len) - NFNL_HEADER_LEN;
+	int attrlen = nlh->nlmsg_len - NFNL_HEADER_LEN;
 	struct nfct_conntrack ct;
 	unsigned int flags = 0;
 	int type = NFNL_MSG_TYPE(nlh->nlmsg_type), ret = 0;
@@ -442,7 +442,7 @@
 
 	nfmsg = NLMSG_DATA(nlh);
 
-	if (NLMSG_LENGTH(nlh->nlmsg_len) < NFNL_HEADER_LEN)
+	if (nlh->nlmsg_len < NFNL_HEADER_LEN)
 		return -EINVAL;
 
 	while (NFA_OK(attr, attrlen)) {
@@ -674,7 +674,7 @@
 {
 	struct nfgenmsg *nfmsg;
 	struct nfattr *attr = NFM_NFA(NLMSG_DATA(nlh));
-	int attrlen = NLMSG_LENGTH(nlh->nlmsg_len) - NFNL_HEADER_LEN;
+	int attrlen = nlh->nlmsg_len - NFNL_HEADER_LEN;
 	struct nfct_expect exp;
 	int type = NFNL_MSG_TYPE(nlh->nlmsg_type), ret = 0;
 
@@ -682,7 +682,7 @@
 
 	nfmsg = NLMSG_DATA(nlh);
 
-	if (NLMSG_LENGTH(nlh->nlmsg_len) < NFNL_HEADER_LEN)
+	if (nlh->nlmsg_len < NFNL_HEADER_LEN)
 		return -EINVAL;
 
 	while (NFA_OK(attr, attrlen)) {

--------------000906080102030701050007--
