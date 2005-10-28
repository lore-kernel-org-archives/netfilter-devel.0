From: Pablo Neira <pablo@eurodev.net>
Subject: Re: problem with conntrack utility and kernel 2.6.14
Date: Fri, 28 Oct 2005 21:22:55 +0200
Message-ID: <43627A8F.9060307@eurodev.net>
References: <4361EAAB.1090206@fliegl.de> <4361F6DF.3050106@eurodev.net>
	<43621028.40705@fliegl.de>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="------------040307070501030906020007"
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Deti Fliegl <deti@fliegl.de>
In-Reply-To: <43621028.40705@fliegl.de>
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
--------------040307070501030906020007
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit

Hi,

Deti Fliegl wrote:
> Pablo Neira wrote:
> 
>> This problem was already fixed days ago in libnetfilter_conntrack on 
>> Oct 17, see SVN. I'm not able to reproduce what you're reporting. Please 
> 
> What I'm doing is to request a file from a local webserver in an endless 
> loop.
> 
>> send me a gdb backtrace, together with other extra info. Are you 
>> running conntrack on a x86?
> 
> It's a x64_64 system.
> 
> Backtrace from gdb:

Thanks for the very detailed report. The patch fixes some aligment 
issues that I didn't handle properly :(. Please, give a try to the patch 
attached and tell if it fixes your problem.

-- 
Pablo

--------------040307070501030906020007
Content-Type: text/plain;
 name="x"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="x"

Index: src/libnetfilter_conntrack.c
===================================================================
--- src/libnetfilter_conntrack.c	(revision 4394)
+++ src/libnetfilter_conntrack.c	(working copy)
@@ -424,9 +424,8 @@
 					  struct nlmsghdr *nlh, void *arg)
 {
 	struct nfgenmsg *nfmsg;
-	int min_len = sizeof(struct nfgenmsg) + sizeof(struct nlmsghdr);
 	struct nfattr *attr = NFM_NFA(NLMSG_DATA(nlh));
-	int attrlen = nlh->nlmsg_len - NLMSG_ALIGN(min_len);
+	int attrlen = NLMSG_LENGTH(nlh->nlmsg_len) - NFNL_HEADER_LEN;
 	struct nfct_conntrack ct;
 	unsigned int flags = 0;
 	int type = NFNL_MSG_TYPE(nlh->nlmsg_type), ret = 0;
@@ -435,7 +434,7 @@
 
 	nfmsg = NLMSG_DATA(nlh);
 
-	if (nlh->nlmsg_len < min_len)
+	if (NLMSG_LENGTH(nlh->nlmsg_len) < NFNL_HEADER_LEN)
 		return -EINVAL;
 
 	while (NFA_OK(attr, attrlen)) {
@@ -666,9 +665,8 @@
 				       struct nlmsghdr *nlh, void *arg)
 {
 	struct nfgenmsg *nfmsg;
-	int min_len = sizeof(struct nfgenmsg) + sizeof(struct nlmsghdr);
 	struct nfattr *attr = NFM_NFA(NLMSG_DATA(nlh));
-	int attrlen = nlh->nlmsg_len - NLMSG_ALIGN(min_len);
+	int attrlen = NLMSG_LENGTH(nlh->nlmsg_len) - NFNL_HEADER_LEN;
 	struct nfct_expect exp;
 	int type = NFNL_MSG_TYPE(nlh->nlmsg_type), ret = 0;
 
@@ -676,7 +674,7 @@
 
 	nfmsg = NLMSG_DATA(nlh);
 
-	if (nlh->nlmsg_len < min_len)
+	if (NLMSG_LENGTH(nlh->nlmsg_len) < NFNL_HEADER_LEN)
 		return -EINVAL;
 
 	while (NFA_OK(attr, attrlen)) {

--------------040307070501030906020007--
