Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E40EFC433E0
	for <netfilter-devel@archiver.kernel.org>; Wed, 31 Mar 2021 07:26:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id AEC2A619D6
	for <netfilter-devel@archiver.kernel.org>; Wed, 31 Mar 2021 07:26:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234003AbhCaHZs (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 31 Mar 2021 03:25:48 -0400
Received: from m43-7.mailgun.net ([69.72.43.7]:14056 "EHLO m43-7.mailgun.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233925AbhCaHZq (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 31 Mar 2021 03:25:46 -0400
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1617175546; h=Content-Transfer-Encoding: MIME-Version:
 Message-Id: Date: Subject: Cc: To: From: Sender;
 bh=d+v3PqBqmobTpf4UPrjE7XKvG2o6TTpsv6c3K4j1hbo=; b=lL+GA2HchVW4KgcrbasRC0JACN2w90pKsPhe8AEmk8gYV4tICdcTUpSfLXemOdHjUhZmhJOj
 /Q1H0CRzL4Cifu1Ha+0+qrU0Iq2mH3vWGP9S277YAxXCloPaXKTZXKz8no639C+1NGUhsutk
 fb1TDAo/uZxQBztN7dxWPoJ37VQ=
X-Mailgun-Sending-Ip: 69.72.43.7
X-Mailgun-Sid: WyJlM2NhZSIsICJuZXRmaWx0ZXItZGV2ZWxAdmdlci5rZXJuZWwub3JnIiwgImJlOWU0YSJd
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n04.prod.us-east-1.postgun.com with SMTP id
 606423f08166b7eff743f3ed (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Wed, 31 Mar 2021 07:25:36
 GMT
Sender: manojbm=codeaurora.org@mg.codeaurora.org
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id D3044C43463; Wed, 31 Mar 2021 07:25:35 +0000 (UTC)
Received: from manojbm-linux.qualcomm.com (unknown [202.46.22.19])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: manojbm)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id C745BC433C6;
        Wed, 31 Mar 2021 07:25:31 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org C745BC433C6
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=fail smtp.mailfrom=manojbm@codeaurora.org
From:   Manoj Basapathi <manojbm@codeaurora.org>
To:     netfilter-devel@vger.kernel.org
Cc:     fw@strlen.de, pablo@netfilter.org, sharathv@qti.qualcomm.com,
        ssaha@qti.qualcomm.com, vidulak@qti.qualcomm.com,
        manojbm@qti.qualcomm.com, subashab@quicinc.com,
        rpavan@qti.qualcomm.com, Manoj Basapathi <manojbm@codeaurora.org>,
        Sauvik Saha <ssaha@codeaurora.org>
Subject: [PATCH] tcp: Reset tcp connections in SYN-SENT state
Date:   Wed, 31 Mar 2021 12:55:22 +0530
Message-Id: <20210331072522.8576-1-manojbm@codeaurora.org>
X-Mailer: git-send-email 2.29.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Userspace sends tcp connection (sock) destroy on network switch
i.e switching the default network of the device between multiple
networks(Cellular/Wifi/Ethernet).

Kernel though doesn't send reset for the connections in SYN-SENT state
and these connections continue to remain.
Even as per RFC 793, there is no hard rule to not send RST on ABORT in
this state.

Modify tcp_abort and tcp_disconnect behavior to send RST for connections
in syn-sent state to avoid lingering connections on network switch.

Signed-off-by: Manoj Basapathi <manojbm@codeaurora.org>
Signed-off-by: Sauvik Saha <ssaha@codeaurora.org>
---
 net/ipv4/tcp.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/net/ipv4/tcp.c b/net/ipv4/tcp.c
index e14fd0c50c10..627a472161fb 100644
--- a/net/ipv4/tcp.c
+++ b/net/ipv4/tcp.c
@@ -2888,7 +2888,7 @@ static inline bool tcp_need_reset(int state)
 {
 	return (1 << state) &
 	       (TCPF_ESTABLISHED | TCPF_CLOSE_WAIT | TCPF_FIN_WAIT1 |
-		TCPF_FIN_WAIT2 | TCPF_SYN_RECV);
+		TCPF_FIN_WAIT2 | TCPF_SYN_RECV | TCPF_SYN_SENT);
 }
 
 static void tcp_rtx_queue_purge(struct sock *sk)
@@ -2954,8 +2954,7 @@ int tcp_disconnect(struct sock *sk, int flags)
 		 */
 		tcp_send_active_reset(sk, gfp_any());
 		sk->sk_err = ECONNRESET;
-	} else if (old_state == TCP_SYN_SENT)
-		sk->sk_err = ECONNRESET;
+	}
 
 	tcp_clear_xmit_timers(sk);
 	__skb_queue_purge(&sk->sk_receive_queue);
-- 
2.29.0

