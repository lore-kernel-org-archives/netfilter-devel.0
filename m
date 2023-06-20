Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AD50EEB64DB
	for <netfilter-devel@archiver.kernel.org>; Tue, 20 Jun 2023 11:21:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231826AbjFTLV5 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 20 Jun 2023 07:21:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53614 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231371AbjFTLVy (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 20 Jun 2023 07:21:54 -0400
Received: from mail-yw1-x1133.google.com (mail-yw1-x1133.google.com [IPv6:2607:f8b0:4864:20::1133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 36AE9CF
        for <netfilter-devel@vger.kernel.org>; Tue, 20 Jun 2023 04:21:53 -0700 (PDT)
Received: by mail-yw1-x1133.google.com with SMTP id 00721157ae682-570284c7e61so51429687b3.1
        for <netfilter-devel@vger.kernel.org>; Tue, 20 Jun 2023 04:21:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=mojatatu-com.20221208.gappssmtp.com; s=20221208; t=1687260112; x=1689852112;
        h=cc:to:subject:message-id:date:from:mime-version:from:to:cc:subject
         :date:message-id:reply-to;
        bh=dfQ3niVaGcWe3CQjn+06HwWkagYAmvQ0PFrIW9MH5sY=;
        b=dkZagKoNk7qH5HItxayVJ/GdY8MxAM1NWs2uOqaIEU0KBEA4ZvG02Iyzb4jdgA1Ymh
         tRvjCK5fN8vMVJreaWUK+oUanOhNaeJWvZQQJ/E1JG9mJCT64BX936ZXD3JmQnh26UI9
         fSad1kK7noc1ZRymZ6XGpRFZVB9wgdSsG4jLocnQ8AAlkgTvKGI/cVk/Ur4A0ARCJGXY
         /RR/EDpz6f3ESTHM/vH/FGVC89W65hHxFC8i37WAkxpKDaEMViAmrrxPdtw2hpote2uj
         wjJ2/gBzCFFZZJvDTcaEQBhavPfAuElJA8+oaUN81Qdkkh6RasH6aFadI2b3CymoqXIh
         9cBA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1687260112; x=1689852112;
        h=cc:to:subject:message-id:date:from:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=dfQ3niVaGcWe3CQjn+06HwWkagYAmvQ0PFrIW9MH5sY=;
        b=a2adWte0ve0IuFBeULc6q2HVCLoyZ9luwFS6xiAt+tnTvsSJo04WbeFkeSzKSmJ2nj
         BOKtHPygpwKlYMow1sjjdahUJ+IigIGKOWOKg6vLVLQde54ZyMjCrs+cLpqsjThtpDcn
         FVIfd8Fk9oFk9yNOA1zpkCdyMgWf+SILNr4gQTwZx6JRzvycosXv0r0lkkHuv7CB82Vb
         BcuXnrtZjcijmEA3DdEWf1ptdb460EphbHm3eh19TdqWm5JONmHFLngaylqsfq4gZ4fF
         RDl082HWg/WJoCMPfAFL85OK2itsIWkj1a7l62zHe4kQ+G+QYR9RnPA260T7JPUQFPgz
         ZjVQ==
X-Gm-Message-State: AC+VfDwurszPFIWQt0QP/4LEeOb2RM+P7cT72Df6VLqM4NBIAmiAzhoJ
        NFr5PZ9CbEiqRIISFiDl/NsrSewbzoln1nbLRYo9XQ==
X-Google-Smtp-Source: ACHHUZ6TCTiLciePb3TWcbuXpNxVdq9lpTes2TguKKkhNfh9aJZUMfKfX2271vdu+AWYQFS5WibYMmGGFZ3+CKKmj3Q=
X-Received: by 2002:a81:c201:0:b0:569:e7cb:cd4e with SMTP id
 z1-20020a81c201000000b00569e7cbcd4emr12722225ywc.48.1687260112492; Tue, 20
 Jun 2023 04:21:52 -0700 (PDT)
MIME-Version: 1.0
From:   Jamal Hadi Salim <jhs@mojatatu.com>
Date:   Tue, 20 Jun 2023 07:21:41 -0400
Message-ID: <CAM0EoMkRZE2XQcgzxt63jke1q4RVqrHBuw5rc5Pu0rGtW+Vz3A@mail.gmail.com>
Subject: CFS for Netdev 0x17 open!    
To:     people <people@netdevconf.info>
Cc:     "board@netdevconf.org" <board@netdevconf.info>,
        Christie Geldart <christie@ambedia.com>,
        Kimberley Jeffries <kimberleyjeffries@gmail.com>,
        Jeremy Carter <jeremy@jeremycarter.ca>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>,
        lwn@lwn.net, netfilter-devel@vger.kernel.org,
        Lael Santos <lael.santos@expertisesolutions.com.br>,
        Felipe Magno de Almeida <felipe@expertise.dev>,
        linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

We are pleased to announce the opening of Call For Submissions(CFS)
for Netdev 0x17.
This session will happen in beautiful Vancouver, British Columbia

For overview of topics, submissions and requirements please visit:
https://netdevconf.info/0x17/pages/submit-proposal.html

For all submitted sessions, we employ a blind review process carried
out by the Program Committee. Please refer to:
https://netdevconf.info/0x17/pages/about-us.html#committees

Important dates:
Closing of CFS Sunday, August 27, 2023
Notification by Friday, Sept. 15, 2023
Conference dates Oct 30th - Nov, 2023

cheers,
jamal (on behalf of the Netdev Society)
