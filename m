Return-Path: <SRS0=UdzR=75=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 79BDFC433E0
	for <netfilter-devel@archiver.kernel.org>; Tue, 16 Jun 2020 16:33:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5D9EA20882
	for <netfilter-devel@archiver.kernel.org>; Tue, 16 Jun 2020 16:33:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729941AbgFPQdf (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 16 Jun 2020 12:33:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53656 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729857AbgFPQdf (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 16 Jun 2020 12:33:35 -0400
Received: from a3.inai.de (a3.inai.de [IPv6:2a01:4f8:10b:45d8::f5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DD89EC061573
        for <netfilter-devel@vger.kernel.org>; Tue, 16 Jun 2020 09:33:34 -0700 (PDT)
Received: by a3.inai.de (Postfix, from userid 25121)
        id 9BF7558718CD5; Tue, 16 Jun 2020 18:33:33 +0200 (CEST)
Received: from localhost (localhost [127.0.0.1])
        by a3.inai.de (Postfix) with ESMTP id 9AB9160EE6341;
        Tue, 16 Jun 2020 18:33:33 +0200 (CEST)
Date:   Tue, 16 Jun 2020 18:33:33 +0200 (CEST)
From:   Jan Engelhardt <jengelh@inai.de>
To:     Eugene Crosser <crosser@average.org>
cc:     netfilter-devel@vger.kernel.org
Subject: Re: ebtables: load-on-demand extensions
In-Reply-To: <1566db8a-00d4-d9de-8c3d-6625fe2149fa@average.org>
Message-ID: <nycvar.YFH.7.77.849.2006161830320.16707@n3.vanv.qr>
References: <76cd59a3-6403-9408-1b8c-af5f11d5fa85@average.org> <nycvar.YFH.7.77.849.2006161717590.16107@n3.vanv.qr> <1566db8a-00d4-d9de-8c3d-6625fe2149fa@average.org>
User-Agent: Alpine 2.22 (LSU 394 2020-01-19)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org


On Tuesday 2020-06-16 17:54, Eugene Crosser wrote:
>>> 2. Is it correct that "new generation" `nft` filtering infrastructure
>>> does not support dynamically loadable extensions at all? (We need a
>>> custom kernel module because we need access to the fields in the skb
>>> that are not exposed to `nft` [..]
>> 
>> Why not make a patch to publicly expose the skb's data via nft_meta?
>> No more custom modules, no more userspace modifications [..]
>
>For our particular use case, we are running the skb through the kernel
>function `skb_validate_network_len()` with custom mtu size [..]

I find no such function in the current or past kernels. Perhaps you could post
the code of the module(s) you already have, and we can assess if it, or the
upstream ideals, can be massaged to make the code stick.
