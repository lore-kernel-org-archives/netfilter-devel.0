Return-Path: <SRS0=uVIa=Y6=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 04B64C5DF63
	for <netfilter-devel@archiver.kernel.org>; Wed,  6 Nov 2019 20:49:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C80912166E
	for <netfilter-devel@archiver.kernel.org>; Wed,  6 Nov 2019 20:49:19 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="QfPv8XYX"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732203AbfKFUtQ (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 6 Nov 2019 15:49:16 -0500
Received: from mail-pg1-f196.google.com ([209.85.215.196]:33563 "EHLO
        mail-pg1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727351AbfKFUtQ (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 6 Nov 2019 15:49:16 -0500
Received: by mail-pg1-f196.google.com with SMTP id h27so1010179pgn.0;
        Wed, 06 Nov 2019 12:49:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=8wP7W7VhRKRhnObCodIzliyafUDrJwYnPDy/mCCnQxM=;
        b=QfPv8XYX/pGPv9G9yjRbcsVUqkLDp8CQ1dUXN0tkbuFE4kz5VdnJ0YakBPNyzCp31O
         NVunSHZkmtTbTII5lArccXo9TYTJq7u0zVsTxdjli/t39pMyycKVsPYPZfCGSfFs8Ymh
         DYud5/SgSnUW4+Pzvs4NHDiD+RzdW3X8l1UD2fSxIlf+Ut+nAp4nsQl0sv9gQvX/e94r
         DCNq44uARSL+16uNtsX7lbSy7tByfbqvoqfTgVvaE87fpmF5QRqOxZC5O61mgd2aoR3S
         bbIm2V4QVRrv/TDjLfQ300FPRkVLlkrow1KhSKoKsM9Hz/sVcBPHtYXd2naOjDvyh+xI
         wJpQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=8wP7W7VhRKRhnObCodIzliyafUDrJwYnPDy/mCCnQxM=;
        b=eaX/6bpCrY88aL2pD9B7fwMJuXxntTQRGlSbqzKG7woC3RYXkpR+2Q3qPBkv2vFCJy
         CbiKftgjH9BWE79ZsAnl72OnD8sEHRaKKvcpg9PWqy7qy/aEot1Bs9mnfaABO3npj4Vt
         5U68mzaoKON362Pltvf/gf8hsxqeahUdlSe2HX34wAaUNavE8FYi9E0Xb4yfAuQsZB7O
         QKQwNPIVL5yd5UM/9Ej2IW4Qfn0JF7ksuRv6onig8rmBcmiDGSSOZJKKv0aqMc+bNqdV
         xvPq/UVwqShd2uA3UejOGERMJ8sUiNe9gkuA90BNf6x1fjDxgLTpyFuzvXtwUY1Ep8vZ
         YrsA==
X-Gm-Message-State: APjAAAVJqrR1YbICtDaN2Dchr5edCmKUqaH2FCvr156rtJLVSYz8pXF3
        vIaRdL3IsHtOCROefviQow==
X-Google-Smtp-Source: APXvYqz70Ek9/AUiWYKz7ykWOcnNBanfcQv/E3r+kyzdSJawus2+OO0JbenuV5DGszEdbGYfJ8N7JA==
X-Received: by 2002:aa7:934a:: with SMTP id 10mr5672308pfn.150.1573073355348;
        Wed, 06 Nov 2019 12:49:15 -0800 (PST)
Received: from localhost.localdomain ([216.52.21.4])
        by smtp.gmail.com with ESMTPSA id r13sm7191895pgh.37.2019.11.06.12.49.13
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Wed, 06 Nov 2019 12:49:14 -0800 (PST)
From:   Praveen Chaudhary <praveen5582@gmail.com>
X-Google-Original-From: Praveen Chaudhary <pchaudhary@linkedin.com>
To:     pablo@netfilter.org
Cc:     astracner@linkedin.com, davem@davemloft.net, fw@strlen.de,
        kadlec@netfilter.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, netfilter-devel@vger.kernel.org,
        praveen5582@gmail.com, zxu@linkedin.com
Subject: RE: [netfilter]: Fix skb->csum calculation when netfilter manipulation for NF_NAT_MANIP_SRC\DST is done on IPV6 packet.
Date:   Wed,  6 Nov 2019 12:48:58 -0800
Message-Id: <1573073338-2078-1-git-send-email-pchaudhary@linkedin.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <20191106093347.inrzhrlrle6g6naf@salvia>
References: <20191106093347.inrzhrlrle6g6naf@salvia>
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Thanks Pablo for review,
Sure, I will update a.) patch subject, b.) description and c.) the full document of function.

I feel, the bug was exposed with e6afc8ace6dd5cef5e812f26c72579da8806f5ac i.e with introduction of udp_csum_pull_header function.

