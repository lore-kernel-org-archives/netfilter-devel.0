Return-Path: <SRS0=avf6=DC=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A6EE7C4363D
	for <netfilter-devel@archiver.kernel.org>; Fri, 25 Sep 2020 09:58:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 637D42085B
	for <netfilter-devel@archiver.kernel.org>; Fri, 25 Sep 2020 09:58:34 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="e/AFUCwS"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727899AbgIYJ6d (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 25 Sep 2020 05:58:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40238 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727346AbgIYJ6d (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 25 Sep 2020 05:58:33 -0400
Received: from mail-io1-xd36.google.com (mail-io1-xd36.google.com [IPv6:2607:f8b0:4864:20::d36])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 62EA8C0613CE
        for <netfilter-devel@vger.kernel.org>; Fri, 25 Sep 2020 02:58:33 -0700 (PDT)
Received: by mail-io1-xd36.google.com with SMTP id r25so2123210ioj.0
        for <netfilter-devel@vger.kernel.org>; Fri, 25 Sep 2020 02:58:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:from:date:message-id:subject:to;
        bh=A2hArcNbZMya3jLLslgtzXsAMIdyoe7SEmvBz4399Gw=;
        b=e/AFUCwSALVGqIBQLrgJtPWYct/gBjyO1/0AdIPe9MMzbwZW1SmnFiOQtcxef1XvAo
         I+9G3QRq56ONV5fZ8s/UTHxcqc0ZgrMxHJb9dyu7D1RsOCxWR7K7TKMFVY0NpBakh32X
         va190naZk8vTK8qTOm2MPnhkPqnMKpD3ahVllUlCJP/jtU5nMbkXL1S6nyEw2APN2aks
         /Aj8jc2IMff8PsHOi2Hh1gFMUotSqYtMxl4hukwpsDiE5Oo4tvkDQZvixRIwaM3LlEFn
         ehJQfEziiVZt1RbvZCYkk7rHzz3g723p9HGnCzWFaKcBtg9lTdIptapyarpp0CxyN7BH
         AzfQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to;
        bh=A2hArcNbZMya3jLLslgtzXsAMIdyoe7SEmvBz4399Gw=;
        b=HkfMAV66OLAtD7zXPvbGmz8v0rWVSrBQNBLZYEdHGLn2RU4kOIzgPUqTF7qfLJwAGd
         OMtAVCxPN2olBNs5RjROwW8Y4LI2KTe1lqGzCNCB41Z3QF4XgrzxqQ0kxV5noCGlvWTI
         emDKRaHDxz9qP+/nwaKLE+8Nr0SbX4NyQNylzyFEAJsU5x0i+LnLt7jv88zY0RCBzJJ+
         2dS5QAO2i1IV65dvdU1q1s5nzJQrL3WlYWNXfcjF0KVTyPzsnjySYnr4ROpIgRYiPKwr
         hTVHnmJjS4lX9uQuk6Bgxe6l/0AEBSiJ/ie4bKuLLccCwrKjelPkicpMmkSA9Kzmq8ls
         n0CA==
X-Gm-Message-State: AOAM532KODNR31LDsu8U7q6bGEmvu8zE/TC/ZPNsgbAM38TwC9uxd9Zn
        S0ELcgH+Wj5n4351Ar5eyI8WKuqDNmwtw9+yfwQaSJ8UMU2+Gw==
X-Google-Smtp-Source: ABdhPJwgSfkalBmsC7T0xh+YikQ7WBZfieYFRskE3icXyBCJ5jiKS7kJDG1tkbXBCiXd/DNGn7IEQgnd5FpWWutFG1Y=
X-Received: by 2002:a02:9086:: with SMTP id x6mr2725367jaf.126.1601027912441;
 Fri, 25 Sep 2020 02:58:32 -0700 (PDT)
MIME-Version: 1.0
From:   Gopal Yadav <gopunop@gmail.com>
Date:   Fri, 25 Sep 2020 15:28:21 +0530
Message-ID: <CAAUOv8hCduUMOOdJktn6YJpdqDWnO9qinhAuBVfkh71A0vMoWA@mail.gmail.com>
Subject: [nftables] dynamic flag missing from wiki and using counter
To:     netfilter-devel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Hi,

To solve this issue https://bugzilla.netfilter.org/show_bug.cgi?id=1462
I am trying to create a rule just like the one mentioned in the bug report.

table inet dev {
    set ports_udp {
        type inet_service
        size 65536
        flags dynamic,timeout
        timeout 30d
        elements = { 53 expires 29d23h58m25s672ms counter packets 35
bytes 2515, 389 expires 29d23h59m15s144ms counter packets 1 bytes 80,
515 expires 29d23h56m14s136ms counter packets 1 bytes 57, 1194 expires
29d23h58m18s460ms counter packets 2 bytes 84, 1504 expires
29d23h51m14s28ms counter packets 1 bytes 223,
   ...
}

To create the above I am doing:

nft add table inet dev
nft add set inet dev ports_udp { type inet_service\; size 65536\;
flags dynamic, timeout\; timeout 30d\; }

1) There is no mention of the "dynamic" flag at
https://wiki.nftables.org/wiki-nftables/index.php/Sets#Named_sets_specifications.
What does it do and how is it useful?


2) I understand this statement "53 expires 29d23h58m25s672ms counter
packets 35 bytes 2515" as
"This element expires in 29d23h58m25s672ms and at port 53(DNS) we have
received/sent 35 packets which make a total of 2515 bytes."

Is my understanding of "counter" correct? are those packets received
or sent or both? And how to apply a counter to an element in a set?

Thanks
Gopal
