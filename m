Return-Path: <SRS0=/MqZ=RG=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C9A49C10F00
	for <netfilter-devel@archiver.kernel.org>; Sun,  3 Mar 2019 08:17:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 92D4720857
	for <netfilter-devel@archiver.kernel.org>; Sun,  3 Mar 2019 08:17:32 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="bkWsd/XI"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725997AbfCCIRb (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sun, 3 Mar 2019 03:17:31 -0500
Received: from mail-pf1-f196.google.com ([209.85.210.196]:45315 "EHLO
        mail-pf1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725971AbfCCIRb (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sun, 3 Mar 2019 03:17:31 -0500
Received: by mail-pf1-f196.google.com with SMTP id v21so971999pfm.12;
        Sun, 03 Mar 2019 00:17:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=Qe+7DiZhI30mb03+kNwaNVnPsAkkMeH03PC8B0Tq58M=;
        b=bkWsd/XISDmU+L1034uHNnpNHWtb9yFd7thXaLTJkXR5JWOgpbm5roLFvDH/PxezrN
         gVs8/35UReTd435F73yWVeG6LzUuFvHnYcjHOQD9tdiOx+BiyKhywmQKCi+AmulSyJ1a
         0HyETlF0k0Rj4MU4j9FR1ud0oeMhVmrn80FNc0T+NGoilmQcRlVbQYP83ILHdqjnxneC
         qeWbyrk48sCnk+HRLaPysK7a66uhidwS4tM3xVCvo3DbC6sLKTDedLs/544Xrv5qlkQ6
         8Pdlg5ZoSbP99/diUV81NwXWjORvj0Inkg1yMXVPvmYS7mRQugX2kVUaxw3rUXGTiiVA
         7kmA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=Qe+7DiZhI30mb03+kNwaNVnPsAkkMeH03PC8B0Tq58M=;
        b=KDUiDtVj2lydhttT62NIfihgK9DHrdcuPy4Gu2hCpd+eCq0cs0UfwN/h5dwPkXl8+1
         z5N+tmAqJDom0s3Cs6GbU+hvCPnLtUVdnabxyy1tRD3P/Fw22WOCu5BbowONvlF9RxIZ
         HNNM78zRsugFriitMjSOEskODeLqmd5mffu0eSnBoNAqM98zYU/gPnou9LGbz99RxWxo
         v/rVs2YATAke/HeNVrDOktv645ntvblnb2GM5ZEnhyikNW2ziKZq54F4w5uhK5AFc2GT
         jL0Hxo5FtE/Ajhe9P4bM5QbbXqXnoh2ttRIRR/lv8aH2+K3dRG44JXhCWEil2O1xMJYI
         F9NQ==
X-Gm-Message-State: APjAAAVMkRhHAsvL/DyCSGu7VlfKs8hmz5fxBBY1EB3cEuICQ+0oRDlC
        XwWc4g1Zn07SnmJoqSy8hXnnCc0A
X-Google-Smtp-Source: APXvYqxv2LVuLfylRtSUCGRS7aa+YTKip41wWcyV+I0Fhxx1c21vdHBBYppJkExtIePOfzAgJZpetw==
X-Received: by 2002:a65:410a:: with SMTP id w10mr12755142pgp.206.1551601049920;
        Sun, 03 Mar 2019 00:17:29 -0800 (PST)
Received: from localhost ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id x23sm11113221pfe.0.2019.03.03.00.17.28
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 03 Mar 2019 00:17:29 -0800 (PST)
From:   Xin Long <lucien.xin@gmail.com>
To:     network dev <netdev@vger.kernel.org>,
        netfilter-devel@vger.kernel.org
Cc:     Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
        Neil Horman <nhorman@tuxdriver.com>, pablo@netfilter.org
Subject: [PATCH net] netfilter: set skb transport_header before calling sctp_compute_cksum
Date:   Sun,  3 Mar 2019 16:17:21 +0800
Message-Id: <740683890e28e93c1b2e940a28089ca10f006b7f.1551601041.git.lucien.xin@gmail.com>
X-Mailer: git-send-email 2.1.0
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

sctp_hdr(skb) only works when skb->transport_header is set
properly.

But in the path of nf_conntrack_in:

  sctp_packet() -> sctp_error() -> sctp_compute_cksum().

skb->transport_header is not guaranteed to be right value
for sctp. It will cause to fail to check the checksum for
sctp packets.

So fix it by setting skb transport_header before calling
sctp_compute_cksum().

Fixes: e6d8b64b34aa ("net: sctp: fix and consolidate SCTP checksumming code")
Reported-by: Li Shuang <shuali@redhat.com>
Signed-off-by: Xin Long <lucien.xin@gmail.com>
Acked-by: Neil Horman <nhorman@tuxdriver.com>
---
 net/netfilter/nf_conntrack_proto_sctp.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/net/netfilter/nf_conntrack_proto_sctp.c b/net/netfilter/nf_conntrack_proto_sctp.c
index d53e3e7..6b53cd2 100644
--- a/net/netfilter/nf_conntrack_proto_sctp.c
+++ b/net/netfilter/nf_conntrack_proto_sctp.c
@@ -343,7 +343,9 @@ static bool sctp_error(struct sk_buff *skb,
 			logmsg = "nf_ct_sctp: failed to read header ";
 			goto out_invalid;
 		}
-		sh = (const struct sctphdr *)(skb->data + dataoff);
+		/* sctp_compute_cksum() depends on correct transport header */
+		skb_set_transport_header(skb, dataoff);
+		sh = sctp_hdr(skb);
 		if (sh->checksum != sctp_compute_cksum(skb, dataoff)) {
 			logmsg = "nf_ct_sctp: bad CRC ";
 			goto out_invalid;
-- 
2.1.0

