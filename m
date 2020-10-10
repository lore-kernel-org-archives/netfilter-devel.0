Return-Path: <SRS0=0qAu=DR=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A4533C2BD0C
	for <netfilter-devel@archiver.kernel.org>; Sat, 10 Oct 2020 22:57:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6B01E2080C
	for <netfilter-devel@archiver.kernel.org>; Sat, 10 Oct 2020 22:57:21 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="J9DRHcSP"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731091AbgJJW5U (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sat, 10 Oct 2020 18:57:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41796 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731109AbgJJTwx (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sat, 10 Oct 2020 15:52:53 -0400
Received: from mail-pf1-x431.google.com (mail-pf1-x431.google.com [IPv6:2607:f8b0:4864:20::431])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 45B48C0610CF
        for <netfilter-devel@vger.kernel.org>; Sat, 10 Oct 2020 05:01:04 -0700 (PDT)
Received: by mail-pf1-x431.google.com with SMTP id f19so9197361pfj.11
        for <netfilter-devel@vger.kernel.org>; Sat, 10 Oct 2020 05:01:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:from:date:message-id:subject:to;
        bh=McaAe4xg+u6Al1zaMAh0vWZE392TsCmmqetPorSk0wo=;
        b=J9DRHcSPrilE4I24q8t46kQ5Qcz/Sr7vABUCvHEwi3RByj/ElYb2KiPUbGZGfv2kpg
         jv7krcnaBApwgUUPvxRQaLLwduXilhvZLfhKCdfDjSYfrmOLpgSiOILl2ODqIm1UWem2
         iivCY0ySSNzbb0DUvAi6+IFeY8NiSoJjL/thLCwpugp9hyxGylN/NmpUuk+hFujg24ez
         nwOEV1og3TAjT3qHTDlXTSfrZb749QxUHo2tJSuLWRubR5oFkn66+WXSrBwDTtChxRYD
         GcBSf1IOq/NHfm0bs/pomNrySIScl+Wov49WQYYqqwK1V5nARM+CG7ADPVwi92ePe0yh
         emOw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to;
        bh=McaAe4xg+u6Al1zaMAh0vWZE392TsCmmqetPorSk0wo=;
        b=ShI3+5n8IRxtIv/tVE3Z6r2ZcDu7qv+2D7K8tEtaqCR/9ex46UxVFRJ1jWA8KbHNyP
         DNFvTcpLUTPNphmVl2FfV+5mmpffs4AjIGy98+xENCIEdlMEZzGTz1djABFGvMMi/M9p
         gLMcMboi2bupsO1mrf8YukUmv3PE+ykFh3VAmOip4PJjPb03YILFR5d+YMA+pYgbGKJd
         xAEUImh4ucVP5uyNVKQAOfXZsqzYlMH8rGDYxK7u6QOqizQi+hqaZsKy19owXjaiLBvK
         3FaqVLR9o4KiGRKMKRo//kpJopNyPZ6qFxKpoCuxHbPE8ZmXFFavFxeoKJuJq8G8Ec/l
         kPwA==
X-Gm-Message-State: AOAM5314IbcX7eCvgKERUb2MB2GCeqBqK39rlCknccM0xbhuKlLY7c8T
        HdzykmUZAv44IF7EfAuPRkTSOczu/gz3PlXb90+qZQSVkIj+lQ==
X-Google-Smtp-Source: ABdhPJxC5lLIJrf5eVBuB7EoTX6X5MXziGjAJtN/La55vYwOnjnbNH0YTpKSz/ykSPyvEpn+gRmaluPNGYZGxtjQOwA=
X-Received: by 2002:a62:7a0a:0:b029:152:192d:9231 with SMTP id
 v10-20020a627a0a0000b0290152192d9231mr15755257pfc.61.1602331263637; Sat, 10
 Oct 2020 05:01:03 -0700 (PDT)
MIME-Version: 1.0
From:   Amiq Nahas <m992493@gmail.com>
Date:   Sat, 10 Oct 2020 17:30:52 +0530
Message-ID: <CAPicJaHQfiy+AOZeb0XbzR4g-cJqdwrq3jeM0bB1BOBk7Dwk_w@mail.gmail.com>
Subject: [ulogd2] Problem while running
To:     netfilter-devel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

I am building ulogd2 and when I do "/ulogd --uid ulog --pidfile
/run/ulog/ulogd.pid -v"
I get the below errors:

ulogd.c:722 load_plugin: '/usr/local/lib/ulogd/ulogd_BASE.so':
/usr/local/lib/ulogd/ulogd_BASE.so: undefined symbol:
register_interpreter

ulogd.c:722 load_plugin: '/usr/local/lib/ulogd/ulogd_LOGEMU.so':
/usr/local/lib/ulogd/ulogd_LOGEMU.so: undefined symbol: ulogd_keyh

ulogd.c:1597 not even a single working plugin stack

Fatal error.

Couldn't find any solution for this. Any suggestions?
Thanks
