Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8482FC433B4
	for <netfilter-devel@archiver.kernel.org>; Tue, 20 Apr 2021 09:56:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3C7366109E
	for <netfilter-devel@archiver.kernel.org>; Tue, 20 Apr 2021 09:56:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231200AbhDTJ5L (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 20 Apr 2021 05:57:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47400 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230264AbhDTJ5L (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 20 Apr 2021 05:57:11 -0400
Received: from a3.inai.de (a3.inai.de [IPv6:2a01:4f8:10b:45d8::f5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2F4ECC06174A
        for <netfilter-devel@vger.kernel.org>; Tue, 20 Apr 2021 02:56:40 -0700 (PDT)
Received: by a3.inai.de (Postfix, from userid 25121)
        id 9C59D58634DAA; Tue, 20 Apr 2021 11:56:38 +0200 (CEST)
Received: from localhost (localhost [127.0.0.1])
        by a3.inai.de (Postfix) with ESMTP id 9815060D220CA;
        Tue, 20 Apr 2021 11:56:38 +0200 (CEST)
Date:   Tue, 20 Apr 2021 11:56:38 +0200 (CEST)
From:   Jan Engelhardt <jengelh@inai.de>
To:     Mohan Das <rajarammohandas@gmail.com>
cc:     netfilter-devel@vger.kernel.org
Subject: Re: Error when using clone option in iptables
In-Reply-To: <CAJmxYnuVhnpUam4CTNihE4jvuUZ6eMfpmrQssTr6G=T1XwPOOw@mail.gmail.com>
Message-ID: <39783p73-83s4-7342-61o7-57n38r93ss3@vanv.qr>
References: <CAJmxYnuVhnpUam4CTNihE4jvuUZ6eMfpmrQssTr6G=T1XwPOOw@mail.gmail.com>
User-Agent: Alpine 2.24 (LSU 510 2020-10-10)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Tuesday 2021-04-20 08:07, Mohan Das wrote:

>Dear Team,
>
>We are receiving below error when trying to clone traffic and send to
>another system, please check and suggest for help.
>
>
>[root@ossfce01 ~]# ip6tables -t mangle -A POSTROUTING -i eth3 --jump
>TEE -gateway 10.175.220.68
>ip6tables v1.8.7 (legacy): multiple -j flags not allowed

-j cannot be combined with -g.
(GIGO - check the options you actually used and how you specified them.)
