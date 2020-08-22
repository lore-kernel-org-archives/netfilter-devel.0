Return-Path: <SRS0=C2Rd=CA=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.6 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E1246C433DF
	for <netfilter-devel@archiver.kernel.org>; Sat, 22 Aug 2020 06:22:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BFC4D208E4
	for <netfilter-devel@archiver.kernel.org>; Sat, 22 Aug 2020 06:22:18 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ElEXP0Zf"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725922AbgHVGWS (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sat, 22 Aug 2020 02:22:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50048 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725917AbgHVGWL (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sat, 22 Aug 2020 02:22:11 -0400
Received: from mail-wm1-x336.google.com (mail-wm1-x336.google.com [IPv6:2a00:1450:4864:20::336])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7EA11C061573
        for <netfilter-devel@vger.kernel.org>; Fri, 21 Aug 2020 23:22:11 -0700 (PDT)
Received: by mail-wm1-x336.google.com with SMTP id k8so3701694wma.2
        for <netfilter-devel@vger.kernel.org>; Fri, 21 Aug 2020 23:22:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=NTFn+H8R6EoIXom1mWtxPOmPohHjUkvDRa4YLBpWnWk=;
        b=ElEXP0ZfLgaSEYntgTtefHeOr7jBwN6XLf1M8ng0OfqgjYn8MjtMwBZNm9ur5wvfy9
         JKDTl+cPPe43zGKvvyUsDNq6XZmQND4fhjY9xmSd4uPvseKPgN/xnjy/DuanTlTZVDMu
         1p1U12t+AcFE7MVL1E2yEwfR9RO44QY8jnFaqu2fgQViCYoGBDvtDo6Ez9zQC1DRONCE
         WAu3o8qqfI4nWFkW7zK8VCvH7XIrptoZjuNlxBC21aRMVnb2z0L28AAghkoqihlhYalh
         aKMpgkhOCtugEQ9RsZXiQ0r22qacxD4GF24B/HJeBDaj8/PDIv/sEs3mRwNMdImVQIlR
         i3Ow==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=NTFn+H8R6EoIXom1mWtxPOmPohHjUkvDRa4YLBpWnWk=;
        b=eStuJ8W+KrB5X+ubo5YmjncGVlZPyJ5pbhZ8u5te0JXylgKeoUoq9GGE99rHWCwnp/
         zFgkelNyy/eClcftmrYVaql9LF5BCxCq2irD60beQZAaEGwJO5R3DYIIY9+/E18Tkvu1
         C98U/fXajXzGyZXTsgJ4HMrawrU7rNvHjL0zW8fRQy2TAc6CJQK4XcHoPqUacXb3tRYm
         N9lGbcoNuPRpjr+yL+CyPsiuhv+gcadmDoDXsSqbXmYuobCGrT9Fp9ApyCmsHQvbHX77
         msUBGEjA1iVuxurntO7IvfB8gnsCBABj8RaPb1HpNtyLvnQlyWHYl1FIVBQEfW+KMqCs
         xBGA==
X-Gm-Message-State: AOAM530iVHVm4ZwfHI4flaYyAVmiWDgL74CTKVtfXOKv2E32nopkbpIL
        hup+M3+j/7kW8/OhLOgtHAEkdMT4jyM5mw==
X-Google-Smtp-Source: ABdhPJwwQIHSepUEDbKA2Gfo5IHwJU1FVzWUEwt2gRTfQYhJsQ3gDrw6nygcMai2tyA+YCmB5I2Lng==
X-Received: by 2002:a1c:4c17:: with SMTP id z23mr7362438wmf.49.1598077329726;
        Fri, 21 Aug 2020 23:22:09 -0700 (PDT)
Received: from localhost.localdomain (BC2467A7.dsl.pool.telekom.hu. [188.36.103.167])
        by smtp.gmail.com with ESMTPSA id h5sm7016321wrt.31.2020.08.21.23.22.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 21 Aug 2020 23:22:09 -0700 (PDT)
From:   Balazs Scheidler <bazsi77@gmail.com>
To:     netfilter-devel@vger.kernel.org
Cc:     Balazs Scheidler <bazsi77@gmail.com>
Subject: [PATCH nftables 2/4] doc: added documentation on "socket wildcard"
Date:   Sat, 22 Aug 2020 08:22:01 +0200
Message-Id: <20200822062203.3617-3-bazsi77@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200822062203.3617-1-bazsi77@gmail.com>
References: <20200822062203.3617-1-bazsi77@gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Signed-off-by: Balazs Scheidler <bazsi77@gmail.com>
---
 doc/primary-expression.txt | 11 ++++++++---
 1 file changed, 8 insertions(+), 3 deletions(-)

diff --git a/doc/primary-expression.txt b/doc/primary-expression.txt
index a9c39cbb..6d3383ed 100644
--- a/doc/primary-expression.txt
+++ b/doc/primary-expression.txt
@@ -195,7 +195,7 @@ raw prerouting meta ipsec exists accept
 SOCKET EXPRESSION
 ~~~~~~~~~~~~~~~~~
 [verse]
-*socket* {*transparent* | *mark*}
+*socket* {*transparent* | *mark* | *wildcard*}
 
 Socket expression can be used to search for an existing open TCP/UDP socket and
 its attributes that can be associated with a packet. It looks for an established
@@ -209,15 +209,20 @@ or non-zero bound listening socket (possibly with a non-local address).
 Value of the IP_TRANSPARENT socket option in the found socket. It can be 0 or 1.|
 boolean (1 bit)
 |mark| Value of the socket mark (SOL_SOCKET, SO_MARK). | mark
+|wildcard|
+Indicates weather the socket is wildcard-bound (e.g. 0.0.0.0 or ::0). |
+boolean (1 bit)
 |==================
 
 .Using socket expression
 ------------------------
-# Mark packets that correspond to a transparent socket
+# Mark packets that correspond to a transparent socket. "socket wildcard 0"
+# means that zero bound listener sockets are NOT matched (which is usually
+# exactly what you want).
 table inet x {
     chain y {
 	type filter hook prerouting priority -150; policy accept;
-        socket transparent 1 mark set 0x00000001 accept
+        socket transparent 1 socket wildcard 0 mark set 0x00000001 accept
     }
 }
 
-- 
2.17.1

