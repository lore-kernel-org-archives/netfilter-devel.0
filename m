From: Pablo Neira <pablo@eurodev.net>
Subject: [PATCH] Fix definition of NFNL_HEADER_LEN
Date: Sat, 29 Oct 2005 15:00:57 +0200
Message-ID: <43637289.7020403@eurodev.net>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="------------050208090002090204070204"
Cc: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Harald Welte <laforge@netfilter.org>
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
--------------050208090002090204070204
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit

Hi Harald,

The current definition of NFNL_HEADER_LEN isn't OK. NLMSG_LENGTH already 
includes the size of the netlink header. We have to use NLMSG_ALIGN 
instead. NLMSG_LENGTH is a bit misleading, I didn't notice this at first 
sight either.

BTW, I think that we should add some kind of versioning of libnfnetlink 
as well, still missing.

cheers,
Pablo

--------------050208090002090204070204
Content-Type: text/plain;
 name="x"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="x"

Index: include/libnfnetlink/libnfnetlink.h
===================================================================
--- include/libnfnetlink/libnfnetlink.h	(revision 4394)
+++ include/libnfnetlink/libnfnetlink.h	(working copy)
@@ -1,6 +1,9 @@
 /* libnfnetlink.h: Header file for generic netfilter netlink interface
  *
  * (C) 2002 Harald Welte <laforge@gnumonks.org>
+ *
+ * 2005-10-29 Pablo Neira Ayuso <pablo@netfilter.org>:
+ * 	Fix NFNL_HEADER_LEN
  */
 
 #ifndef __LIBNFNETLINK_H
@@ -18,8 +21,8 @@
 #define NLMSG_TAIL(nlh) \
 	(((void *) (nlh)) + NLMSG_ALIGN((nlh)->nlmsg_len))
 
-#define NFNL_HEADER_LEN	(NLMSG_LENGTH(sizeof(struct nlmsghdr))	\
-			 +NLMSG_LENGTH(sizeof(struct nfgenmsg)))
+#define NFNL_HEADER_LEN	(NLMSG_ALIGN(sizeof(struct nlmsghdr))	\
+			 +NLMSG_ALIGN(sizeof(struct nfgenmsg)))
 
 #define NFNL_BUFFSIZE		8192
 

--------------050208090002090204070204--
