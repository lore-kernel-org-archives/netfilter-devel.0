Return-Path: <SRS0=SfI0=TX=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.9 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9EB88C282DE
	for <netfilter-devel@archiver.kernel.org>; Thu, 23 May 2019 19:37:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 633EC2075E
	for <netfilter-devel@archiver.kernel.org>; Thu, 23 May 2019 19:37:28 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="lvVHede5"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390857AbfEWTh1 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 23 May 2019 15:37:27 -0400
Received: from mail-wr1-f46.google.com ([209.85.221.46]:46949 "EHLO
        mail-wr1-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2390940AbfEWTYi (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 23 May 2019 15:24:38 -0400
Received: by mail-wr1-f46.google.com with SMTP id r7so7468774wrr.13
        for <netfilter-devel@vger.kernel.org>; Thu, 23 May 2019 12:24:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=fpq8fqriernE9axW0XtYVRi98MiE0xbAOb/sSkXoc1g=;
        b=lvVHede5b423hMj2zFGTDdG8r5dfQQpwB9YxA0ELG4Ql4yZ3tJqIOEDumgaIYjoNoE
         jYeF2BwBeh7+UFCoQE4GZS2Hl0RKpuys2shellcm25+yC5HvDRob/Xa7aziUY2+hTnXM
         AxMH68hwCPcwzVpHpt4H0YCb8dBj221bu7JkXf35HZ+0akrT8cVfaKrt6rqXnH9+3P9d
         hOHwEcxEjG1UQ9hKCyDSQ05Dom2pzRwdXnYwnZY7VtEYSVphUJRS12XgWXSMwnB4vHIo
         B1+hSSS4z3T44ZvfUD4PvadAvXY0W/tDXxIilDb9KWa3xIy5gdkGANpdO7NSBZGIQZUf
         WKEQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=fpq8fqriernE9axW0XtYVRi98MiE0xbAOb/sSkXoc1g=;
        b=ELfNBut7Ff5uHmW8glpkYHLlOwuAg2zkZj8VFtP76uGrfoG9nuLNAvxiVml45AxCaI
         gHu9SBHUCzoHIPpoQJcMh0LW09wBa9HtZdmEvMhEH6EgcTvZJQb965ipfYzuZYJUU1I5
         N5XLlvQ+2A4HGwKtK9ordDdnEDXJiPQ/GBf3kSFmC4u0dztceuIwXuYilsxmmyH5E+de
         gPF40+aPv4pqYPij6usDr589OUNcZnP9Z5RXJBZtMiN5YZT5URdcN3qWySLxJF85cbzD
         VBEL+O9yyzXvqx5A8NwJo+v75FylaMyfeLgEk34lGjGANYnt1GSDOENtBymxlL3Uws28
         D1aw==
X-Gm-Message-State: APjAAAXZplzwlcF1wcioUuxnw+j5TULK6TsNScaw0NeATr4GXH7geldZ
        aO4sCvySx3w4TMjAlJIbCd/1jfSJ
X-Google-Smtp-Source: APXvYqzEICO6jrP6dHXZfXA6SihERQHaq7zEmwHaLOYvZchcAeYLVdlcI9VB9K//Pl+IY6jIraxXCA==
X-Received: by 2002:adf:f704:: with SMTP id r4mr3870602wrp.27.1558639477045;
        Thu, 23 May 2019 12:24:37 -0700 (PDT)
Received: from VGer.neptura.lan (neptura.org. [88.174.209.153])
        by smtp.gmail.com with ESMTPSA id j28sm245649wrd.64.2019.05.23.12.24.36
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 23 May 2019 12:24:36 -0700 (PDT)
From:   =?UTF-8?q?St=C3=A9phane=20Veyret?= <sveyret@gmail.com>
To:     netfilter-devel@vger.kernel.org
Cc:     =?UTF-8?q?St=C3=A9phane=20Veyret?= <sveyret@gmail.com>
Subject: [PATCH nf-next v4 0/1] add ct expectation support
Date:   Thu, 23 May 2019 21:22:10 +0200
Message-Id: <20190523192211.25402-1-sveyret@gmail.com>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Please find the patch for kernel including suggested modifications.
I will send library and nft modifications when code review will be finished for kernel part.
Thank you.

Stéphane Veyret (1):
  netfilter: nft_ct: add ct expectations support

 include/uapi/linux/netfilter/nf_tables.h |  14 ++-
 net/netfilter/nft_ct.c                   | 145 ++++++++++++++++++++++-
 2 files changed, 156 insertions(+), 3 deletions(-)

-- 
2.21.0

