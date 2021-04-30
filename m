Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 20E57C433B4
	for <netfilter-devel@archiver.kernel.org>; Fri, 30 Apr 2021 09:27:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E3EB8613ED
	for <netfilter-devel@archiver.kernel.org>; Fri, 30 Apr 2021 09:27:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229543AbhD3J2V (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 30 Apr 2021 05:28:21 -0400
Received: from mx2.suse.de ([195.135.220.15]:39254 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229524AbhD3J2T (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 30 Apr 2021 05:28:19 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1619774850; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=Fq4h/o8VKU5HAiHnUP753dpWOxHACAEB2O3bKo7tqgI=;
        b=hf98dQaP2r1PkZmeAQnpGiW2CWkjqSayqqqtExOTKf3uMHg7ryIevWcJwlZFcZrrPgRkqX
        6PV7wXvisgtSApQOkKrNXcWJYjO/by0dHWocDlC8MTOIHk/UZk9URI4HBdmNP+HHoxM0Ls
        ReI4c81xpYpyf/yax6Cw62S1egyM6nM=
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id AE69AAE38;
        Fri, 30 Apr 2021 09:27:30 +0000 (UTC)
Date:   Fri, 30 Apr 2021 11:27:29 +0200
From:   Ali Abdallah <ali.abdallah@suse.com>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org
Subject: Re: [PATCH] Avoid potentially erroneos RST check
Message-ID: <20210430092729.66f4jldpyqxedvpz@Fryzen495>
References: <20210428131147.w2ppmrt6hpcjin5i@Fryzen495>
 <20210428143041.GA24118@salvia>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20210428143041.GA24118@salvia>
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On 28.04.2021 16:30, Pablo Neira Ayuso wrote:
> I did not apply:
> 
> https://patchwork.ozlabs.org/project/netfilter-devel/patch/20210420122415.v2jtayiw3n4ds7t7@Fryzen495/
> 
> as you requested to send a v2.
> 
> Would it make sense to squash this patch and ("Reset the max ACK flag
> on SYN in ignore state") in one single patch?
> 
> Thanks.

Yes, I will send a single patch then. Thanks.

-- 
Ali Abdallah | SUSE Linux L3 Engineer
GPG fingerprint: 51A0 F4A0 C8CF C98F 842E  A9A8 B945 56F8 1C85 D0D5

