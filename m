Return-Path: <SRS0=WVDP=RA=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3CB82C43381
	for <netfilter-devel@archiver.kernel.org>; Mon, 25 Feb 2019 11:27:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0BAD62083D
	for <netfilter-devel@archiver.kernel.org>; Mon, 25 Feb 2019 11:27:56 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="RiVAY7nt"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726788AbfBYL1x (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 25 Feb 2019 06:27:53 -0500
Received: from mail-pl1-f194.google.com ([209.85.214.194]:39089 "EHLO
        mail-pl1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726701AbfBYL1w (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 25 Feb 2019 06:27:52 -0500
Received: by mail-pl1-f194.google.com with SMTP id b65so1350676plb.6;
        Mon, 25 Feb 2019 03:27:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=ATcGWvPXiFZ5ZnV6x2Wb8by30V2j57mq5MAEbXRhWj8=;
        b=RiVAY7ntbRVGip4h3XiIInVuSvT8ZNywMOc7D3LTxxytmEdIlJ4q99osQbJ29vvC2v
         WhYV/EgPsVFmkZpCmgJjSmF4HJtcXhGnSqRH1EGiySW4DtemFhvUMI+iTyxSDWAr7be5
         VE6C7puDvyAcfUCq4In3RzjlLeBZcw7W6d5A7mrOtFqHUAb19V8neKDTne3H7HcQE9O4
         q8jNtf9T0jxZTQTouv1FGT518EVjQ0qHxaOo8uWURbb3hAc7OqDNZHY00929WqiSK4tX
         hRah2gX1Cv+KpdEOScN7j5drUYJLh2+dAnWgAdEWOApOnCi7gmfPgnXaGxjPstj2ZiZi
         fKAw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=ATcGWvPXiFZ5ZnV6x2Wb8by30V2j57mq5MAEbXRhWj8=;
        b=PbgCVsrP4e64Oha1squzjn5cjAL+rd6QnOYb/nTLCXB216RBNM7d7+CX161Sy4TBVV
         Ycx6w8ocrElGl0gUHkuXFnZ4RV20m36tSYXz6UsFPdnTuPwtTzUJ+D//IsLDj3hs11eT
         EZLb/TFV58DKWWneesGrFovzpOOKfm4duA7iTIWJgL0qsCj666OQUbxEGyza1OXJ6CiV
         o57V1KuHO/h3iFJAC4k9B7S1E4fS/qIs/Yc9U4On5x1oHFN89NgoGb9Z3D/rNRE5YppY
         aq0wXDu6FG7pvatQblQ6Wb4MMZ8/V/b9Av/TVEX9mJOlq7VWqn05d/DjaYcIFeCLQS6D
         3YxA==
X-Gm-Message-State: AHQUAuY7iFW+u0aqiUivU+jBSCoJfHceZtyk1iYeOrgGjvPfHoqK+hHI
        ihB/JrTaGKO1kAe0M37wT/ijFHqm
X-Google-Smtp-Source: AHgI3IZx5ddv8Kll0w8rfdpKo9+uh5PbgQEh30auqRXyEFwd+z7wIyhMP+nSs+YjKf82RkbQ2lwmwQ==
X-Received: by 2002:a17:902:8485:: with SMTP id c5mr19794684plo.67.1551094071820;
        Mon, 25 Feb 2019 03:27:51 -0800 (PST)
Received: from localhost ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id a24sm11938268pfo.160.2019.02.25.03.27.50
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 25 Feb 2019 03:27:51 -0800 (PST)
From:   Xin Long <lucien.xin@gmail.com>
To:     network dev <netdev@vger.kernel.org>,
        netfilter-devel@vger.kernel.org
Cc:     Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
        Neil Horman <nhorman@tuxdriver.com>, pablo@netfilter.org
Subject: [PATCH net] ipvs: get sctphdr by sctphoff in sctp_csum_check
Date:   Mon, 25 Feb 2019 19:27:43 +0800
Message-Id: <cd1c829cfd9ee916e57c51f6879947f0f88c1eb1.1551094063.git.lucien.xin@gmail.com>
X-Mailer: git-send-email 2.1.0
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

sctp_csum_check() is called by sctp_s/dnat_handler() where it calls
skb_make_writable() to ensure sctphdr to be linearized.

So there's no need to get sctphdr by calling skb_header_pointer()
in sctp_csum_check().

Signed-off-by: Xin Long <lucien.xin@gmail.com>
---
 net/netfilter/ipvs/ip_vs_proto_sctp.c | 7 ++-----
 1 file changed, 2 insertions(+), 5 deletions(-)

diff --git a/net/netfilter/ipvs/ip_vs_proto_sctp.c b/net/netfilter/ipvs/ip_vs_proto_sctp.c
index b0cd7d0..0ecf241 100644
--- a/net/netfilter/ipvs/ip_vs_proto_sctp.c
+++ b/net/netfilter/ipvs/ip_vs_proto_sctp.c
@@ -183,7 +183,7 @@ static int
 sctp_csum_check(int af, struct sk_buff *skb, struct ip_vs_protocol *pp)
 {
 	unsigned int sctphoff;
-	struct sctphdr *sh, _sctph;
+	struct sctphdr *sh;
 	__le32 cmp, val;
 
 #ifdef CONFIG_IP_VS_IPV6
@@ -193,10 +193,7 @@ sctp_csum_check(int af, struct sk_buff *skb, struct ip_vs_protocol *pp)
 #endif
 		sctphoff = ip_hdrlen(skb);
 
-	sh = skb_header_pointer(skb, sctphoff, sizeof(_sctph), &_sctph);
-	if (sh == NULL)
-		return 0;
-
+	sh = (struct sctphdr *)(skb->data + sctphoff);
 	cmp = sh->checksum;
 	val = sctp_compute_cksum(skb, sctphoff);
 
-- 
2.1.0

