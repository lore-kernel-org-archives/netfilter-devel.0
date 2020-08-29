Return-Path: <SRS0=fjj5=CH=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DE86BC433E2
	for <netfilter-devel@archiver.kernel.org>; Sat, 29 Aug 2020 07:04:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B996B20738
	for <netfilter-devel@archiver.kernel.org>; Sat, 29 Aug 2020 07:04:16 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="iuENatEK"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726614AbgH2HEP (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sat, 29 Aug 2020 03:04:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40484 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725886AbgH2HEO (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sat, 29 Aug 2020 03:04:14 -0400
Received: from mail-wr1-x42b.google.com (mail-wr1-x42b.google.com [IPv6:2a00:1450:4864:20::42b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E481EC061236
        for <netfilter-devel@vger.kernel.org>; Sat, 29 Aug 2020 00:04:13 -0700 (PDT)
Received: by mail-wr1-x42b.google.com with SMTP id e16so1130465wrm.2
        for <netfilter-devel@vger.kernel.org>; Sat, 29 Aug 2020 00:04:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id;
        bh=BZLlLa3Hlaiq35ZTA7sA2UlrjtA3U5jNJPzosqXWGis=;
        b=iuENatEKRyLW22S3uvX1HNn1mwZLa67iekMwYvJfMbg5Jo+yv8Z/NiUrfm6cY+pmZn
         1MUpf9pCMoRGoaUPargX+UjitKLEXV87iKWPuIUOfulxP59DxFiq5o6AdN9uRyKyOKYY
         TVemMp2sJ7JzzUBNHSVu0/z+CZLQmCs0blRHBp3gnC5A8wstfj8V/B/oxik1y2MH7Nds
         qJVKDKgy05ZXKlMBj7YzzY0spaHp/uS0s3dYr5Q/yuMyNjkjJCasLyrlLmSlKcO/YmTg
         IQLM7RfLnx7g3lFSoPyTPM/NSF/AmHYh7w8YDJbT4BaYiAX8VdrvxwTmvqBLBXKCGOpt
         HP0A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id;
        bh=BZLlLa3Hlaiq35ZTA7sA2UlrjtA3U5jNJPzosqXWGis=;
        b=fyCNRhyq/mLLRee9+KEdMW7c5V6jraUHNJq2VgvwG5b7FS9o1d0AYPKxb+rlxl4pgc
         lZgTV3kbTHrzCVA1M8CZfzNXn56nlN87sBJwfMTIP/BxHEJ40tPUbHfO7eWgL4sKqiWJ
         yng+WmzcD75oCCIUieEHEulwqUmVWcHBBWuy6I/XT2jgfpoBVC3JahNBd5Bk4MR5SK0F
         a0JBkhFyH0wBTPg+Eo6GW+4Fb3+h5HFx8qOVCnG/gHUwnWnijrzEzESlwX01p3li3mGN
         SFsP+9rm/h/pquWr9w/CNqlZx+i9uDs2mJZjTFYjMKNLq6cHcNMeo3hkaAOFYaC4fd3C
         MGhw==
X-Gm-Message-State: AOAM533/JT4DSePYCb5SEDJAYPQHF2V5lB1skPn86gMMz5l21d/KTyft
        HyLk31Tq23MV9IcN9E+Idy6cjb9u6CkTnw==
X-Google-Smtp-Source: ABdhPJwKkekl1XNFR9Y+3jVERCCxJBNMY1p9S8LkhHwy9GTLRiRg/EkTU/ziROPnt/A15P2xhEc4sg==
X-Received: by 2002:a5d:4b0f:: with SMTP id v15mr401170wrq.296.1598684650612;
        Sat, 29 Aug 2020 00:04:10 -0700 (PDT)
Received: from localhost.localdomain (94-21-174-118.pool.digikabel.hu. [94.21.174.118])
        by smtp.gmail.com with ESMTPSA id f2sm2489756wrj.54.2020.08.29.00.04.09
        for <netfilter-devel@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 29 Aug 2020 00:04:10 -0700 (PDT)
From:   Balazs Scheidler <bazsi77@gmail.com>
To:     netfilter-devel@vger.kernel.org
Subject: 
Date:   Sat, 29 Aug 2020 09:04:00 +0200
Message-Id: <20200829070405.23636-1-bazsi77@gmail.com>
X-Mailer: git-send-email 2.17.1
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org


This is the userspace counterpart of "netfilter: nft_socket: add wildcard
support" posted a few minutes ago. 

Compared from v1:
  - it incorporating the changes requested by @Pablo and @Stefano.

It doesn't - yet - incorporate changing the type to "boolean", since that
would probably touch both "wildcard" and "transparent" I would do that in a
followup branch.

Cheers,
Bazsi

