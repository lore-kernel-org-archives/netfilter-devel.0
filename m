Return-Path: <SRS0=tvQP=ST=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0F097C282DA
	for <netfilter-devel@archiver.kernel.org>; Wed, 17 Apr 2019 09:18:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id CF20020835
	for <netfilter-devel@archiver.kernel.org>; Wed, 17 Apr 2019 09:18:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730926AbfDQJSf (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 17 Apr 2019 05:18:35 -0400
Received: from szxga05-in.huawei.com ([45.249.212.191]:6755 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727087AbfDQJSf (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 17 Apr 2019 05:18:35 -0400
Received: from DGGEMS408-HUB.china.huawei.com (unknown [172.30.72.60])
        by Forcepoint Email with ESMTP id 101631DEAD168EB86EA5;
        Wed, 17 Apr 2019 17:18:33 +0800 (CST)
Received: from [127.0.0.1] (10.184.189.20) by DGGEMS408-HUB.china.huawei.com
 (10.3.19.208) with Microsoft SMTP Server id 14.3.408.0; Wed, 17 Apr 2019
 17:18:26 +0800
To:     <wensong@linux-vs.org>, <horms@verge.net.au>, <ja@ssi.bg>,
        <pablo@netfilter.org>, <kadlec@blackhole.kfki.hu>, <fw@strlen.de>,
        <davem@davemloft.net>, <netdev@vger.kernel.org>,
        <lvs-devel@vger.kernel.org>, <netfilter-devel@vger.kernel.org>,
        <coreteam@netfilter.org>, <linux-kernel@vger.kernel.org>
From:   linmiaohe <linmiaohe@huawei.com>
Subject: [PATCH] ipvs:set sock send/receive buffer correctly
CC:     Mingfangsen <mingfangsen@huawei.com>, <liujie165@huawei.com>,
        <linmiaohe@huawei.com>
Message-ID: <501e5522-1d69-7c67-a1bc-fd8502d3b5d1@huawei.com>
Date:   Wed, 17 Apr 2019 17:18:17 +0800
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.5.1
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.184.189.20]
X-CFilter-Loop: Reflected
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

From: Jie Liu <liujie165@huawei.com>

If we set sysctl_wmem_max or sysctl_rmem_max larger than INT_MAX,
the send/receive buffer of sock will be an negative value. Same as
when the val is larger than INT_MAX/2.

Fixes: 1c003b1580e2 ("ipvs: wakeup master thread")
Reported-by: Qiang Ning <ningqiang1@huawei.com>
Reviewed-by: Miaohe Lin <linmiaohe@huawei.com>
Signed-off-by: Jie Liu <liujie165@huawei.com>
---
 net/netfilter/ipvs/ip_vs_sync.c | 10 ++++------
 1 file changed, 4 insertions(+), 6 deletions(-)

diff --git a/net/netfilter/ipvs/ip_vs_sync.c b/net/netfilter/ipvs/ip_vs_sync.c
index 2526be6b3d90..c0e4cbed6e74 100644
--- a/net/netfilter/ipvs/ip_vs_sync.c
+++ b/net/netfilter/ipvs/ip_vs_sync.c
@@ -1278,14 +1278,12 @@ static void set_sock_size(struct sock *sk, int mode, int val)
 	/* setsockopt(sock, SOL_SOCKET, SO_RCVBUF, &val, sizeof(val)); */
 	lock_sock(sk);
 	if (mode) {
-		val = clamp_t(int, val, (SOCK_MIN_SNDBUF + 1) / 2,
-			      sysctl_wmem_max);
-		sk->sk_sndbuf = val * 2;
+		val = min_t(u32, val, sysctl_wmem_max);
+		sk->sk_sndbuf = max_t(int, val * 2, SOCK_MIN_SNDBUF);
 		sk->sk_userlocks |= SOCK_SNDBUF_LOCK;
 	} else {
-		val = clamp_t(int, val, (SOCK_MIN_RCVBUF + 1) / 2,
-			      sysctl_rmem_max);
-		sk->sk_rcvbuf = val * 2;
+		val = min_t(u32, val, sysctl_rmem_max);
+		sk->sk_rcvbuf = max_t(int, val * 2, SOCK_MIN_RCVBUF);
 		sk->sk_userlocks |= SOCK_RCVBUF_LOCK;
 	}
 	release_sock(sk);
-- 
2.19.1


