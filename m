From: Pablo Neira Ayuso <pablo@eurodev.net>
Subject: [LIBNFNETLINK 1/3] Add NLMSG_OK checking to nfnl_get_msg_next
Date: Sun, 12 Feb 2006 22:39:21 +0100
Message-ID: <43EFAB09.4020007@eurodev.net>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="------------000805050803040101060408"
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
--------------000805050803040101060408
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit

nfnl_get_msg_next must check is the message is OK after NLMSG_NEXT is
called.

-- 
Pablo

--------------000805050803040101060408
Content-Type: text/plain;
 name="01.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="01.patch"

[LIBNFNETLINK] Add NLMSG_OK checking to nfnl_get_msg_next

nfnl_get_msg_next must check is the message is OK after NLMSG_NEXT
is called.

Index: libnfnetlink/src/libnfnetlink.c
===================================================================
--- libnfnetlink.orig/src/libnfnetlink.c	2006-02-12 19:24:26.000000000 +0100
+++ libnfnetlink/src/libnfnetlink.c	2006-02-12 19:28:19.000000000 +0100
@@ -861,6 +861,11 @@ struct nlmsghdr *nfnl_get_msg_next(struc
 	remain_len = (len - ((unsigned char *)h->last_nlhdr - buf));
 	nlh = NLMSG_NEXT(h->last_nlhdr, remain_len);
 
+	if (!NLMSG_OK(nlh, remain_len)) {
+		h->last_nlhdr = NULL;
+		return NULL;
+	}
+
 	h->last_nlhdr = nlh;
 
 	return nlh;

--------------000805050803040101060408--
