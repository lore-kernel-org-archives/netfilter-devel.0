From: Ken-ichirou MATSUZAWA <chamaken@gmail.com>
Subject: [RFC PATCH 4/5] netlink: mmap: update tx type check
Date: Wed, 22 Jul 2015 10:14:04 +0900
Message-ID: <20150722011404.GE30012@gmail.com>
References: <20150722010938.GA30012@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: The netfilter developer mailinglist
	<netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-pa0-f48.google.com ([209.85.220.48]:35766 "EHLO
	mail-pa0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934008AbbGVBOJ (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 21 Jul 2015 21:14:09 -0400
Received: by pabkd10 with SMTP id kd10so57008863pab.2
        for <netfilter-devel@vger.kernel.org>; Tue, 21 Jul 2015 18:14:08 -0700 (PDT)
Received: from gmail.com (softbank220009032004.bbtec.net. [220.9.32.4])
        by smtp.gmail.com with ESMTPSA id kx14sm29839401pab.0.2015.07.21.18.14.07
        for <netfilter-devel@vger.kernel.org>
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 21 Jul 2015 18:14:08 -0700 (PDT)
Content-Disposition: inline
In-Reply-To: <20150722010938.GA30012@gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

We need to accept msg_iter.type 1(WRITE) which is set in sendto/sendmsg.

Signed-off-by: Ken-ichirou MATSUZAWA <chamas@h4.dion.ne.jp>
---
 net/netlink/af_netlink.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/netlink/af_netlink.c b/net/netlink/af_netlink.c
index a6fba4c..7e1610e 100644
--- a/net/netlink/af_netlink.c
+++ b/net/netlink/af_netlink.c
@@ -2394,7 +2394,7 @@ static int netlink_sendmsg(struct socket *sock, struct msghdr *msg, size_t len)
 	 * sendmsg(), but that's what we've got...
 	 */
 	if (netlink_tx_is_mmaped(sk) &&
-	    msg->msg_iter.type == ITER_IOVEC &&
+	    !(msg->msg_iter.type & (ITER_KVEC | ITER_BVEC)) &&
 	    msg->msg_iter.nr_segs == 1 &&
 	    msg->msg_iter.iov->iov_base == NULL) {
 		err = netlink_mmap_sendmsg(sk, msg, dst_portid, dst_group,
-- 
1.7.10.4

