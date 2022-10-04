Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 53F55C433F5
	for <netfilter-devel@archiver.kernel.org>; Tue,  4 Oct 2022 18:19:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230074AbiJDSTD (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 4 Oct 2022 14:19:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44840 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230051AbiJDSTC (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 4 Oct 2022 14:19:02 -0400
Received: from mail-oa1-x41.google.com (mail-oa1-x41.google.com [IPv6:2001:4860:4864:20::41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 557C32B608
        for <netfilter-devel@vger.kernel.org>; Tue,  4 Oct 2022 11:19:00 -0700 (PDT)
Received: by mail-oa1-x41.google.com with SMTP id 586e51a60fabf-127dca21a7dso17347172fac.12
        for <netfilter-devel@vger.kernel.org>; Tue, 04 Oct 2022 11:19:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=mojatatu-com.20210112.gappssmtp.com; s=20210112;
        h=cc:to:subject:message-id:date:from:mime-version:from:to:cc:subject
         :date;
        bh=J/u7DVEXjJmIG7E07wTucPWE0DEZVNW1Zgg6U1VTcqU=;
        b=DZucEzQg4rd/R2rQfRYiNG8xzIFGzkQ+xHLY+JeVdNNAMEvuiDRo+WRZ/vr9fFsOVh
         8gV2V5PttaNSdcQwoEY57/BeiVqrOSxy9iFD8EWqkHrAj3qLIErM79UVC1f2WCUk8x5F
         uPdeLvfmr0U9NLISaGT4K1PgGuOOFYFBu79qIMWvyRpVp+THbkA5TxJhsqfyuzsoFYQV
         E+L5KAYa+NuFPbS6FcKLl8mGiRqRqfZ4JUG6/mjuDXtzVhQEGM94B1UB2vRR9N9oMRQ4
         8CO1DpISaB7U41Wll7EiLSI9kQelMc9LbfLtB8feFnMJvQ/gL9IRN4Z0zJyAS41W5J5b
         Qgzw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:mime-version:x-gm-message-state
         :from:to:cc:subject:date;
        bh=J/u7DVEXjJmIG7E07wTucPWE0DEZVNW1Zgg6U1VTcqU=;
        b=awmgBHjDf0fh1hKl/9EB4cu/dIW3oxqN6S+cCuYx2zykRZAcHpiZYLNHXL+NAaE374
         bTemq98TipXlHc5dMAiSwazKZ57FhznnG5I/cRDZn5eFidF0xep+8MD8/GbKm11GRz+e
         RCuavDeojQTcm0PSSlVJTjVSd25caP2onY7zttZqmY7g8x68ehW30JH5Rdg5D9XQvllO
         XRt6McQqBCLYHl7DbxOShDFurQVQeN20RucRxCGHTkDmW/d4YYrIXcxbmY3POL9Cq1at
         SgXNsfWUA4JbWozWA126Wql3XVQMggp6P9as/fTI5ZwfpEKV9VgcqqGcvFA3q/kfj/Kr
         jsIA==
X-Gm-Message-State: ACrzQf2v9U2htdGHCQpeyPGi/IFoir5KtG8DiuBhlvrAjKcui2vi73eb
        bwdnv5Iv7ronDUxYsuWrp07YbvJHxKLtrmcdU8kPBg==
X-Google-Smtp-Source: AMsMyM5eYgJZ0rdYt1FfA/mNTnuOkQ439BsgHDHgbvv+i3JhcKSs7GCeRJ9scZeaNGCeY0vOQzdoffZxmx0OYeEljes=
X-Received: by 2002:a05:6870:390b:b0:132:9ca3:8dc1 with SMTP id
 b11-20020a056870390b00b001329ca38dc1mr590447oap.106.1664907539754; Tue, 04
 Oct 2022 11:18:59 -0700 (PDT)
MIME-Version: 1.0
From:   Jamal Hadi Salim <jhs@mojatatu.com>
Date:   Tue, 4 Oct 2022 14:18:48 -0400
Message-ID: <CAM0EoMmZy1+VRTvpN0OYkOzdCrJ24hb1h2rz8XdDLXGp3YH81w@mail.gmail.com>
Subject: netdev conf 0x16 schedule posted
To:     people <people@netdevconf.info>
Cc:     Christie Geldart <christie@ambedia.com>,
        Kimberley Jeffries <kimberleyjeffries@gmail.com>,
        prog-committee-0x16@netdevconf.info, lwn@lwn.net,
        Linux Kernel Network Developers <netdev@vger.kernel.org>,
        netfilter-devel@vger.kernel.org,
        linux-wireless <linux-wireless@vger.kernel.org>,
        xdp-hints@xdp-project.net, lartc@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

The tentative schedule for netdevconf 0x16 is now published,
See: https://netdevconf.info/0x16/schedule.html

Last day for Reel cheep early bird registration. You get
served lunch too with that price ;->
See: https://netdevconf.info/0x16/registration.html

cheers,
jamal
