Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 63A78C2B9F4
	for <netfilter-devel@archiver.kernel.org>; Tue, 22 Jun 2021 04:19:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 414C5610C7
	for <netfilter-devel@archiver.kernel.org>; Tue, 22 Jun 2021 04:19:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229574AbhFVEVz (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 22 Jun 2021 00:21:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47492 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229452AbhFVEVz (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 22 Jun 2021 00:21:55 -0400
Received: from mail-pf1-x42c.google.com (mail-pf1-x42c.google.com [IPv6:2607:f8b0:4864:20::42c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 89893C061574
        for <netfilter-devel@vger.kernel.org>; Mon, 21 Jun 2021 21:19:39 -0700 (PDT)
Received: by mail-pf1-x42c.google.com with SMTP id w71so5388023pfd.4
        for <netfilter-devel@vger.kernel.org>; Mon, 21 Jun 2021 21:19:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=iMVokX2Z00IfQRWoRydk4SrKS9rLfZcY8k50duvud0Q=;
        b=fY36i4CUHVJVwc9MyvTfPPNX3tvyxcABU0XeiIpcX/RA2NpwlkxKv39qJFbingKJEY
         t9cbrj7wsOCVxjvU8IHCikj4e9NUcyxE0L7b0iLqT8reNql0uUzm9RvQQtkCs5qEOzHA
         WtfdRm+jRPWPeW9bcjHd2g8AHxElx/D5HXOiRhn+twu8r7oyfl9S9izvEnitGRAoFU1O
         0EQ9ZuvwYHJdA5D6Amza+g9n1okBTiJ3e5cKI/71B0TlTLFnZjluycV2ovEegvU4EfY5
         pUFkyP7OAuWQpNPsD04wqZAo+zfA7g3iJ+dn9JrWgeMEMkAdhkZT2f8JUe2yFO2jqzYM
         qnzg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:from:to:cc:subject:date:message-id
         :mime-version:content-transfer-encoding;
        bh=iMVokX2Z00IfQRWoRydk4SrKS9rLfZcY8k50duvud0Q=;
        b=gKtJEB8DK9j3maX+OBPFDQTcozHT4V5wz13ESXYTym/Lu13LRYgq4sNEER9P2Bo9j+
         5A1RXV13HMk1dBtulB1OGSTgQD4QVDyME9W68TUDCVtSTG6c2iZtP0ZcaWDdtZkDnq8D
         CUblRyDI6qGrMMEtBXNgSc5X2UrH41qpe+8Mjwme+2Dv1v3Qj2HTBvOsvgV40NlGrPGX
         mmGui9E08Rn8f20rSQ9jQjHV30yy1sREzecXwM17N5prh/3SuowwWCiYmzLOEKabxAAo
         LG5uHlMKqdsvBj8Bmy7lOVRELjF11n+KySsY5K4tCtN8K9pNv/TWvmdVdziAlX2i3/PJ
         6byQ==
X-Gm-Message-State: AOAM530micTtH5cluwI4gpVA36dFpQl2X6iHV+8sH0Tc6synKiCVDKFb
        ZE3EF7LoCxKusZ1WlAHShr4=
X-Google-Smtp-Source: ABdhPJyCjZww1OA7LXqrccNZbM436ImIHdHfCrck2pcNG8zW0IZofe0fFUZNkEuLMdKB48GQvtIlSA==
X-Received: by 2002:a63:50b:: with SMTP id 11mr1809730pgf.411.1624335579162;
        Mon, 21 Jun 2021 21:19:39 -0700 (PDT)
Received: from slk1.local.net (n49-192-52-33.sun3.vic.optusnet.com.au. [49.192.52.33])
        by smtp.gmail.com with ESMTPSA id c6sm8734940pfb.39.2021.06.21.21.19.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 21 Jun 2021 21:19:38 -0700 (PDT)
Sender: Duncan Roe <duncan.roe2@gmail.com>
From:   Duncan Roe <duncan_roe@optusnet.com.au>
To:     pablo@netfilter.org
Cc:     netfilter-devel@vger.kernel.org, duncan_roe@optusnet.com.au
Subject: [PATCH libmnl 0/1] build: doc: "make" builds & installs a full set of man pages
Date:   Tue, 22 Jun 2021 14:19:32 +1000
Message-Id: <20210622041933.25654-1-duncan_roe@optusnet.com.au>
X-Mailer: git-send-email 2.30.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

This patch gets us out of the unfortunate situation where there are man pages
for all functions in (old, libnfnetlink-based) sample program
libnetfilter_queue/utils/nfqnl_test.c but not for the libmnl-based
libnetfilter_queue/examples/nf-queue.c.

From libnetfilter_queue we know how to generate a full set of man pages during
`make` so let's do it for libmnl.

This patch sets up the framework: in future patches I plan to update the
doxygen comments to be more man-page-friendly, e.g. by using \returns and \sa
where appropriate.

Duncan Roe (1):
  build: doc: "make" builds & installs a full set of man pages

 Makefile.am         |   4 +-
 configure.ac        |  24 +++++-
 doxygen.cfg.in      | 176 ++------------------------------------------
 doxygen/Makefile.am |  75 +++++++++++++++++++
 4 files changed, 107 insertions(+), 172 deletions(-)
 create mode 100644 doxygen/Makefile.am

-- 
2.17.5

