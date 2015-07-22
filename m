From: Ken-ichirou MATSUZAWA <chamaken@gmail.com>
Subject: [RFC PATCH 3/5] netlink: mmap: fix status for not delivered skb
Date: Wed, 22 Jul 2015 10:13:05 +0900
Message-ID: <20150722011305.GD30012@gmail.com>
References: <20150722010938.GA30012@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: The netfilter developer mailinglist
	<netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-pa0-f52.google.com ([209.85.220.52]:35218 "EHLO
	mail-pa0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934008AbbGVBNK (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 21 Jul 2015 21:13:10 -0400
Received: by pabkd10 with SMTP id kd10so56995726pab.2
        for <netfilter-devel@vger.kernel.org>; Tue, 21 Jul 2015 18:13:10 -0700 (PDT)
Received: from gmail.com (softbank220009032004.bbtec.net. [220.9.32.4])
        by smtp.gmail.com with ESMTPSA id qn4sm12630052pdb.47.2015.07.21.18.13.08
        for <netfilter-devel@vger.kernel.org>
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 21 Jul 2015 18:13:09 -0700 (PDT)
Content-Disposition: inline
In-Reply-To: <20150722010938.GA30012@gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


Signed-off-by: Ken-ichirou MATSUZAWA <chamas@h4.dion.ne.jp>
---
 net/netlink/af_netlink.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/netlink/af_netlink.c b/net/netlink/af_netlink.c
index 5632ad0..a6fba4c 100644
--- a/net/netlink/af_netlink.c
+++ b/net/netlink/af_netlink.c
@@ -847,7 +847,7 @@ static void netlink_skb_destructor(struct sk_buff *skb)
 		} else {
 			if (!(NETLINK_CB(skb).flags & NETLINK_SKB_DELIVERED)) {
 				hdr->nm_len = 0;
-				netlink_set_status(hdr, NL_MMAP_STATUS_VALID);
+				netlink_set_status(hdr, NL_MMAP_STATUS_UNUSED);
 			}
 			ring = &nlk_sk(sk)->rx_ring;
 		}
-- 
1.7.10.4

