Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5BF34C432BE
	for <netfilter-devel@archiver.kernel.org>; Wed,  1 Sep 2021 08:22:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 30D5A6103A
	for <netfilter-devel@archiver.kernel.org>; Wed,  1 Sep 2021 08:22:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243004AbhIAIXq (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 1 Sep 2021 04:23:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56602 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243110AbhIAIXp (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 1 Sep 2021 04:23:45 -0400
Received: from mail-pg1-x52d.google.com (mail-pg1-x52d.google.com [IPv6:2607:f8b0:4864:20::52d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A72A0C061575
        for <netfilter-devel@vger.kernel.org>; Wed,  1 Sep 2021 01:22:48 -0700 (PDT)
Received: by mail-pg1-x52d.google.com with SMTP id y23so1992852pgi.7
        for <netfilter-devel@vger.kernel.org>; Wed, 01 Sep 2021 01:22:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=bsQfslKareM6zyS97x75SwvxJOyDEPBkPhUyGv33hPo=;
        b=fufkmkdgh6OEQdDhP7cN5WiMiIzWy3cemwOQ79zoStpNe444g075Uz7SgM+50CYtAB
         5nRtuS7nUw7w6Nk8jyJzMtqSbpsQ7fdkREKlLsWh+giYN2kDjIJjHJFwpWxI9lTs1vSx
         /yy5Lf3JmSiOp/MBdj8Xqm+YqnvXTbSFUL47j+gwQ/0CrE/1kzwcIJeNULEbjvOsA34I
         zw6S5cEdSZtamWpovlm6abumwPpFSn6imnf89TGB6ixrd/+DQ0FzDp50XiGavqtVjkLQ
         l5X8rxMCK4O7WfXxkwjIAqY5EFuQHkeCrBlKrLUs6VaNHRGT36G+4PmHnCUO9AxcRGPb
         auew==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:from:to:cc:subject:date:message-id
         :mime-version:content-transfer-encoding;
        bh=bsQfslKareM6zyS97x75SwvxJOyDEPBkPhUyGv33hPo=;
        b=TixVhfv+jIK7ROOLtJwC2UKwlJRvn2+7wAdYC2BfP9k+eVmmjH+s/w1R+d0WNszBuR
         ScgBu1bfscD3g1TjEB9dZx2LuVfLCPJli95T4bMJswhWqu1gXStJuR/PMbARZZHfYFJy
         qwc67DtuSpQDb0fG3XGThMJZ3uoyaqAvsZ5ndBDplsSubGQ95M2BJrN9wEbs0bSAKaHK
         hCb8hMjibQTB7UmH2ISH+A8B8Du5IkGVxfobonDgGpVPljwQUOZQiJrtuj80u/Ru9muc
         VSsiKnyA0jFwjOj+nyEDG+3DhOmiolwqUuvcLVA5NsmehdlOgt2GTdLao94sRKxCDOBi
         UW/Q==
X-Gm-Message-State: AOAM530174j+PYORMyMRhaipubPMtAhPiznYAJw8J2W0SiFWBdkDlMM+
        VqCMzrTtrAcTKcAYbMnvi87NiEqGe0k=
X-Google-Smtp-Source: ABdhPJyEPWMLhrpOD2R0R4iWRn9xwjNQRZpzWCizxG/ccltIdn93EE6OovFQ6lmdrO3HYDpCUKWgnA==
X-Received: by 2002:a63:d26:: with SMTP id c38mr7478032pgl.361.1630484568165;
        Wed, 01 Sep 2021 01:22:48 -0700 (PDT)
Received: from slk1.local.net (n49-192-82-34.sun3.vic.optusnet.com.au. [49.192.82.34])
        by smtp.gmail.com with ESMTPSA id a21sm5447600pjo.14.2021.09.01.01.22.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 01 Sep 2021 01:22:31 -0700 (PDT)
Sender: Duncan Roe <duncan.roe2@gmail.com>
From:   Duncan Roe <duncan_roe@optusnet.com.au>
To:     pablo@netfilter.org
Cc:     netfilter-devel@vger.kernel.org
Subject: [PATCH libnetfilter_log 0/1] src: doc: Eliminate doxygen warnings
Date:   Wed,  1 Sep 2021 18:22:11 +1000
Message-Id: <20210901082212.20830-1-duncan_roe@optusnet.com.au>
X-Mailer: git-send-email 2.32.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

This patch only fixes doxygen warnings and associated obviously-wrong lines.

I couldn't help noticing that many functions have an `nfad` argument which is
*always* of type struct nflog_data* but *sometimes* described as
"pointer to logging data" and (more often) as
"Netlink packet data handle passed to callback function".

These can't both be right. I suspect "pointer to logging data" is right but can
someone please confirm?

The discrepancy does not cause a doxygen warning so is not addresssed in this
patch.

Duncan Roe (1):
  src: doc: Eliminate doxygen warnings

 src/libnetfilter_log.c | 28 ++++++++++++++++++++--------
 1 file changed, 20 insertions(+), 8 deletions(-)

-- 
2.17.5

