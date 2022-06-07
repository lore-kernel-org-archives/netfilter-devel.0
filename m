Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 45B09C433EF
	for <netfilter-devel@archiver.kernel.org>; Tue,  7 Jun 2022 16:37:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345052AbiFGQhJ (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 7 Jun 2022 12:37:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33368 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345051AbiFGQhI (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 7 Jun 2022 12:37:08 -0400
Received: from mail-ot1-x32b.google.com (mail-ot1-x32b.google.com [IPv6:2607:f8b0:4864:20::32b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 249C47B9F6
        for <netfilter-devel@vger.kernel.org>; Tue,  7 Jun 2022 09:37:07 -0700 (PDT)
Received: by mail-ot1-x32b.google.com with SMTP id 61-20020a9d0bc3000000b0060b9bfcfe76so13256865oth.9
        for <netfilter-devel@vger.kernel.org>; Tue, 07 Jun 2022 09:37:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=mojatatu-com.20210112.gappssmtp.com; s=20210112;
        h=mime-version:from:date:message-id:subject:to:cc;
        bh=V2h9z/Ifbd6f4YrmaVfXNCHrvbCppjkt75BAO7WtpHM=;
        b=Bde9pbF8/kL2J+zYmNeX1Cy7rEupQvGPik/dAD0mz6TBfvu0v/svVPKmsUiEdbZQvX
         pEaEmtyF85i4F0GONmezo5JDuuP5wYfkFLHNE2DnVGnw6Fdion1COkG92tF17sznC31H
         S66iE0/jHww5XBFRJyMUk0tHl+KWJReHe11jMFxKhBtpKoPvF/f5OccBGKB8qcf6U/eu
         fjGMGw7qJcY1BXr+cYm2MmBpPoX2x8ZHkXXybXYq7JO4V2C0N/h+/GWBZNuornWxwh2M
         y47ZBnjUitDBWdekiF4M90d7oSkNGxCRaJlDlzY9fPjIuSyqldGQw/uGr1Yu0khMxEZW
         CcJQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to:cc;
        bh=V2h9z/Ifbd6f4YrmaVfXNCHrvbCppjkt75BAO7WtpHM=;
        b=BMAGe8KZCTxGvCz3pWOqUd3MPuBo4qfnQHLUVKeSOpUB0zXmZTA7UAFdU817XLen+9
         oTxjmcpLAcSHVghP7q1L5FdN6OnC1eDqUjd8s5URhflzjf3sz+SSQaublYcG90Dzbz3N
         sK5fT6YpniVC2DbVS6644+An6PeNhTei8wzYGv4mJWakjt9smvlnOMwVru1P5seN5vbT
         YC2WIBp59s1mGNTpkkAGwvZFV3Zwf8wJDFVIOHMLuPH+p6I6O6AL5DxZFs4OuOq7LtRY
         BoaNoaK46FhShyjxgzKyujhOEJcJXiIfSdzC1tirZdYD2sBiLwIRwMJ6Z4rCQdexzId3
         wkOA==
X-Gm-Message-State: AOAM531jiCJlyz3FQP4MMxcup1pegELfdmsW14aimGwQXHYrMFXmP36u
        k1LVt9J8RmngqBwsz5xvQKSbvpa5smThbey5XtOBIqPlmwfVQQ==
X-Google-Smtp-Source: ABdhPJw4ZEmR71RxBkUJKriac+k6z7Gaxe2UYTNIXIQ4Ge1yRvWFkuVPXxOeKiawse/tQZlZhJY7p4uiWEb5pTFs0dM=
X-Received: by 2002:a9d:2649:0:b0:60b:fd52:a47 with SMTP id
 a67-20020a9d2649000000b0060bfd520a47mr4497090otb.246.1654619825215; Tue, 07
 Jun 2022 09:37:05 -0700 (PDT)
MIME-Version: 1.0
From:   Jamal Hadi Salim <jhs@mojatatu.com>
Date:   Tue, 7 Jun 2022 12:36:54 -0400
Message-ID: <CAM0EoMn_4k_w_maX=0=tmiK5k1nTEWpByGP+83qiJHdM0DbigA@mail.gmail.com>
Subject: CFS for Netdev 0x16 open!
To:     people <people@netdevconf.info>, netfilter-devel@vger.kernel.org,
        linux-wireless <linux-wireless@vger.kernel.org>, lwn@lwn.net,
        Linux Kernel Network Developers <netdev@vger.kernel.org>
Cc:     prog-committee-0x16@netdevconf.info,
        "board@netdevconf.org" <board@netdevconf.info>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

We are pleased to announce the opening of Call For
Submissions(CFS) for Netdev 0x16.

For overview of topics, submissions and requirements
please visit:
https://netdevconf.info/0x16/submit-proposal.html

For all submitted sessions, we employ a blind
review process carried out by the Program Committee.
Please refer to:
https://www.netdevconf.info/0x16/pc_review.html

Important dates:
Closing of CFS: Wed, Sept. 7, 2022
Notification by: Thu, Sept. 15, 2022
Conference dates: Oct 24th - 28th, 2022

cheers,
jamal (on behalf of the Netdev Society)
