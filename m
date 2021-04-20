Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=0.2 required=3.0 tests=BAYES_40,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E3F01C433B4
	for <netfilter-devel@archiver.kernel.org>; Tue, 20 Apr 2021 06:07:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id AF864613AE
	for <netfilter-devel@archiver.kernel.org>; Tue, 20 Apr 2021 06:07:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229668AbhDTGIT (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 20 Apr 2021 02:08:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53598 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229577AbhDTGIS (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 20 Apr 2021 02:08:18 -0400
Received: from mail-wm1-x335.google.com (mail-wm1-x335.google.com [IPv6:2a00:1450:4864:20::335])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DA428C061763
        for <netfilter-devel@vger.kernel.org>; Mon, 19 Apr 2021 23:07:47 -0700 (PDT)
Received: by mail-wm1-x335.google.com with SMTP id i21-20020a05600c3555b029012eae2af5d4so9872293wmq.4
        for <netfilter-devel@vger.kernel.org>; Mon, 19 Apr 2021 23:07:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:from:date:message-id:subject:to;
        bh=RlAfnV+Sgo1+u/YAdbmZFEWGZih2bRK3xRqSACf2MJ0=;
        b=D8XKaRLZ+Ib3BfiDU6pPE17Mt6xXQyVxYhmbHLGOC19uGrpFeighMOMWLK/+0mtpV7
         DjBqmGCpWLY+Vw20go+9PLt/yLcm1rxGm7z3GSS6NMehUNybDo1wJiP/BGudiv1n5ghK
         cC3M+VtDe92HEAJeMayqPgN9w8TznQCjL1Zao8ioE9g0oR3yW/CIpyHBGPxa9Jc/YRR7
         Nisssi+qr9k+yqWOBceULFc+EpVkOND7KPcO57qKidxs0tH25STLJEVNir5idebXpZcQ
         vIPwZqwCTmaTtD2pFWd0ovC2KkM0NGZrf9E6qQPlcIJ+cR1KPaI5JcIYgKccB7UJf0dj
         lRtA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to;
        bh=RlAfnV+Sgo1+u/YAdbmZFEWGZih2bRK3xRqSACf2MJ0=;
        b=Ov6Yt4YZZr7Lsc8MMYkEkzgwQSFMoGtVZxDZtPP33Ox25/860OYhKHd8kzZzBwJBVs
         Mb0cZQBjIkQ9AqtuSGDa/eerW/nU9KqihCPUFhuDba7cd7Qn75OmefR+0frWjVRKNyvJ
         urzghaBCBfTR80wJVAM715hRqIdPKsUjSlBgERsByyNv0+JKyCpzjV8f4x4kkITiV/HE
         KOm8wtNqyEFOT6hWm4XeaTYiIEOdLDm+tv0uvrFealKTsHfpeJdxr+szdxBCBcA2RlCE
         tNrJphAo7RJsWxbZz1bcTTvTTO5JtetX5WOfjde5qBCXoo1oJbAi9s8Vc39umihsupzW
         ZesQ==
X-Gm-Message-State: AOAM530ICaq2i0fbh0SbWTZ4xdWY2S41QKwfb42aE1ouAMjEAbMj8AB2
        yvCXAmWhgDyYsTW23aMqkyrW3B43EsUifWPczB2KsSWG
X-Google-Smtp-Source: ABdhPJyk35XeT5cZNEuKYidKNGwIRDd2yop3SmNzERTEnUGT/1chbg7iZJPa8RzyFWNzXGFsNKbB2vrsRo4LdGjRREI=
X-Received: by 2002:a1c:a54a:: with SMTP id o71mr2671580wme.172.1618898866436;
 Mon, 19 Apr 2021 23:07:46 -0700 (PDT)
MIME-Version: 1.0
Received: by 2002:adf:e683:0:0:0:0:0 with HTTP; Mon, 19 Apr 2021 23:07:46
 -0700 (PDT)
From:   Mohan Das <rajarammohandas@gmail.com>
Date:   Tue, 20 Apr 2021 10:07:46 +0400
Message-ID: <CAJmxYnuVhnpUam4CTNihE4jvuUZ6eMfpmrQssTr6G=T1XwPOOw@mail.gmail.com>
Subject: Error when using clone option in iptables
To:     netfilter-devel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Dear Team,

We are receiving below error when trying to clone traffic and send to
another system, please check and suggest for help.


[root@ossfce01 ~]# ip6tables -t mangle -A POSTROUTING -i eth3 --jump
TEE -gateway 10.175.220.68
ip6tables v1.8.7 (legacy): multiple -j flags not allowed
Try `ip6tables -h' or 'ip6tables --help' for more information.



Regards,
Raja Banda
