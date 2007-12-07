From: Stephanie Lockwood-Childs <sjl@vctlabs.com>
Subject: [PATCH] netfilter_queue: byte order of mark
Date: Fri, 7 Dec 2007 15:50:38 -0800 (PST)
Message-ID: <Pine.LNX.4.64.0712071544240.2760@dent.vctlabs.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from netblock-66-159-209-61.dslextreme.com ([66.159.209.61]:51135
	"EHLO dent.vctlabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752356AbXLHAe3 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 7 Dec 2007 19:34:29 -0500
Received: from sjl (helo=localhost)
	by dent.vctlabs.com with local-esmtp (Exim 4.63)
	(envelope-from <sjl@vctlabs.com>)
	id 1J0mxq-0001oe-5a
	for netfilter-devel@vger.kernel.org; Fri, 07 Dec 2007 15:50:43 -0800
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Apologies to those who subscribe to both netfilter and netfilter-devel 
lists and get a dupe -- I meant to send this only to -devel, but managed 
to copy the wrong 'send mail' link from netfilter home page...

--------
Hi,

when trying to set marks with netfilter_queue library, I discovered there is
a discrepency in byte ordering between the library and the nfnetlink_queue
kernel model. The kernel code expects to receive the mark attribute in
network order

net/netfilter/nfnetlink_queue.c
if (nfqa[NFQA_MARK-1])
 	entry->skb->mark = ntohl(*(__be32 *)
 				NFA_DATA(nfqa[NFQA_MARK-1]));

so netfilter_queue library should put the mark into network order when
sending it.

diff -ur libnetfilter_queue.orig/src/libnetfilter_queue.c
libnetfilter_queue/src/libnetfilter_queue.c
--- netfilter/libnetfilter_queue/src/libnetfilter_queue.c	2007-12-05
11:26:24.000000000 -0800
+++ libnetfilter_queue-0.0.15/src/libnetfilter_queue.c	2007-12-05
16:47:44.000000000 -0800
@@ -333,8 +333,9 @@
  	/* add verdict header */
  	nfnl_addattr_l(nmh, sizeof(buf), NFQA_VERDICT_HDR, &vh, sizeof(vh));

+	/* kernel module expects mark to be in network byte order */
  	if (set_mark)
-		nfnl_addattr32(nmh, sizeof(buf), NFQA_MARK, mark);
+		nfnl_addattr32(nmh, sizeof(buf), NFQA_MARK, htonl(mark));

  	iov[0].iov_base = nmh;
  	iov[0].iov_len = NLMSG_TAIL(nmh) - (void *)nmh;
