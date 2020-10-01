Return-Path: <SRS0=AsZf=DI=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.9 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 89BA3C4727C
	for <netfilter-devel@archiver.kernel.org>; Thu,  1 Oct 2020 13:05:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 034BE2075F
	for <netfilter-devel@archiver.kernel.org>; Thu,  1 Oct 2020 13:05:02 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=doubly.so header.i=@doubly.so header.b="OKVqDpxu"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732046AbgJANFC (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 1 Oct 2020 09:05:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44904 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731952AbgJANFC (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 1 Oct 2020 09:05:02 -0400
Received: from mout-p-201.mailbox.org (mout-p-201.mailbox.org [IPv6:2001:67c:2050::465:201])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BD16AC0613D0
        for <netfilter-devel@vger.kernel.org>; Thu,  1 Oct 2020 06:05:01 -0700 (PDT)
Received: from smtp1.mailbox.org (smtp1.mailbox.org [80.241.60.240])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-384) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mout-p-201.mailbox.org (Postfix) with ESMTPS id 4C2Cyf1TQkzQlVP;
        Thu,  1 Oct 2020 15:04:58 +0200 (CEST)
X-Virus-Scanned: amavisd-new at heinlein-support.de
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=doubly.so; s=MBO0001;
        t=1601557496;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=MJiENjd5fwyGAUmlAVyTjKD4sQsH9dHlvJTxoGmPoxY=;
        b=OKVqDpxuvJAh9LdWhDQymal4jw+6wfqE0e5Q8AeozS4pjMgGyEZxGD0r1i7JiJx0YPQLsG
        Kde9K4TrERiTm8PbHWN29kr6mYYsI2gtfkfCwYBS+5r2LL3zDqLZRW+MTXzlFbYL5b6+Yw
        YmXnMBA+0EVQOa3pv6mjGRGsnwK1A9xuQdlta6HX1poDXmLkAl3rbH4j4oDgafAlK1VH3l
        /KABfa92cUnDZuGG0dEroGF3KJhXcaLpi4KE8Z+ZAG50duh3FRPE/np9bm9Bo4uaj/0mSg
        mQzAMRzLM8v7LyHQ4zy2X3PZ51w5oWmjfA0OBVmteHlH5LPUM264kWuGSiPIsw==
Received: from smtp1.mailbox.org ([80.241.60.240])
        by spamfilter06.heinlein-hosting.de (spamfilter06.heinlein-hosting.de [80.241.56.125]) (amavisd-new, port 10030)
        with ESMTP id hGcR0ULR8S-U; Thu,  1 Oct 2020 15:04:55 +0200 (CEST)
Subject: Re: [PATCH] nft: migrate man page examples with `meter` directive to
 sets
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org
References: <b35b744f-a29c-d76b-6969-8cf6371c2a1a@doubly.so>
 <20201001122638.GA17685@salvia>
From:   Devin Bayer <dev@doubly.so>
Message-ID: <760d81b9-b722-8bce-baa5-a186d3b293d7@doubly.so>
Date:   Thu, 1 Oct 2020 15:04:53 +0200
MIME-Version: 1.0
In-Reply-To: <20201001122638.GA17685@salvia>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-MBO-SPAM-Probability: 
X-Rspamd-Score: -3.85 / 15.00 / 15.00
X-Rspamd-Queue-Id: 4283E17DD
X-Rspamd-UID: aea4c0
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On 01/10/2020 14.26, Pablo Neira Ayuso wrote:
> Applied with small nitpick.
> 
> Missing semi-colons after size.
> 
> Please, double-check that what I have applied looks correct to you.

I didn't realize it was needed, since it's not needed for the braces in 
the `rule` command.

Looks good to me 👍

~ Devin
