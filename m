Return-Path: <SRS0=cwGx=Q6=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.2 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1EADBC43381
	for <netfilter-devel@archiver.kernel.org>; Sat, 23 Feb 2019 21:26:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D604820661
	for <netfilter-devel@archiver.kernel.org>; Sat, 23 Feb 2019 21:26:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1550957174;
	bh=TJujedEa0EOAob1JMwa38YiaFQoLXZWex8194y3XZrg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:List-ID:From;
	b=XJZDWRE/k6YClbTSbdxt2dKKEaXn7LCduSn+SkEKEfaBLCxOGnnH7fVrMG6QDtyYG
	 9xgnYKJteJzFSAokdXLot5m52uoIX5bmXG2G3Zu7M0PWhPJKHlTMu9Shmz5NrLiH/E
	 nogaV4fUUtfbPFDXEJduoAF55thJ455OPgewv9VA=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729238AbfBWVZx (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sat, 23 Feb 2019 16:25:53 -0500
Received: from mail.kernel.org ([198.145.29.99]:42886 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727945AbfBWVHj (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Sat, 23 Feb 2019 16:07:39 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 384FD20861;
        Sat, 23 Feb 2019 21:07:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1550956059;
        bh=TJujedEa0EOAob1JMwa38YiaFQoLXZWex8194y3XZrg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ganbVuJc11d2Wa0PQ0WJWlTyJ/F38WmzYpMW1qmqx8Nc0nkHZVH5KMPgjZQNPunOC
         mlIL4Ncyl66diVy+608qx9YmEmhXJ6iUpjg0GTbyEx3Usgh3U9LV8xQshcYmXM7VKH
         o1C9mro15jkA+/OF0GQ2kD8wgA0mtWhp4Q6Dv7cg=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Fernando Fernandez Mancera <ffmancera@riseup.net>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Sasha Levin <sashal@kernel.org>,
        netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
        netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 34/65] netfilter: nfnetlink_osf: add missing fmatch check
Date:   Sat, 23 Feb 2019 16:06:09 -0500
Message-Id: <20190223210640.200911-34-sashal@kernel.org>
X-Mailer: git-send-email 2.19.1
In-Reply-To: <20190223210640.200911-1-sashal@kernel.org>
References: <20190223210640.200911-1-sashal@kernel.org>
MIME-Version: 1.0
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

From: Fernando Fernandez Mancera <ffmancera@riseup.net>

[ Upstream commit 1a6a0951fc009f6d9fe8ebea2d2417d80d54097b ]

When we check the tcp options of a packet and it doesn't match the current
fingerprint, the tcp packet option pointer must be restored to its initial
value in order to do the proper tcp options check for the next fingerprint.

Here we can see an example.
Assumming the following fingerprint base with two lines:

S10:64:1:60:M*,S,T,N,W6:      Linux:3.0::Linux 3.0
S20:64:1:60:M*,S,T,N,W7:      Linux:4.19:arch:Linux 4.1

Where TCP options are the last field in the OS signature, all of them overlap
except by the last one, ie. 'W6' versus 'W7'.

In case a packet for Linux 4.19 kicks in, the osf finds no matching because the
TCP options pointer is updated after checking for the TCP options in the first
line.

Therefore, reset pointer back to where it should be.

Fixes: 11eeef41d5f6 ("netfilter: passive OS fingerprint xtables match")
Signed-off-by: Fernando Fernandez Mancera <ffmancera@riseup.net>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/netfilter/nfnetlink_osf.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/net/netfilter/nfnetlink_osf.c b/net/netfilter/nfnetlink_osf.c
index 00db27dfd2ff7..b0bc130947c94 100644
--- a/net/netfilter/nfnetlink_osf.c
+++ b/net/netfilter/nfnetlink_osf.c
@@ -71,6 +71,7 @@ static bool nf_osf_match_one(const struct sk_buff *skb,
 			     int ttl_check,
 			     struct nf_osf_hdr_ctx *ctx)
 {
+	const __u8 *optpinit = ctx->optp;
 	unsigned int check_WSS = 0;
 	int fmatch = FMATCH_WRONG;
 	int foptsize, optnum;
@@ -160,6 +161,9 @@ static bool nf_osf_match_one(const struct sk_buff *skb,
 		}
 	}
 
+	if (fmatch != FMATCH_OK)
+		ctx->optp = optpinit;
+
 	return fmatch == FMATCH_OK;
 }
 
-- 
2.19.1

