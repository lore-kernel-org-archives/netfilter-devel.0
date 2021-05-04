Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DAAD4C433B4
	for <netfilter-devel@archiver.kernel.org>; Tue,  4 May 2021 06:56:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B23D4613B3
	for <netfilter-devel@archiver.kernel.org>; Tue,  4 May 2021 06:56:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229724AbhEDG4z (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 4 May 2021 02:56:55 -0400
Received: from mx2.suse.de ([195.135.220.15]:48612 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229848AbhEDG4y (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 4 May 2021 02:56:54 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1620111357; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=dkbCxPrYFV4GJjMPiiZ2LdxgdOU2zAbh0muw8m8KHLg=;
        b=CugbecTHdFRPzfloRxXkGsBJftf9CnEMQhj+NXUGWPVIONcq4j+w92VuAO/1LcacShu838
        ebq/3mDqoi5VM7RcDP4CwNfDnrxm4/98LJNn2HkkME2kZoDqB5ahg4ChmcJPbasmA1Q522
        iEQwMECCoya1t7RkC8rG9I4nne0rdpM=
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 1E470AD71;
        Tue,  4 May 2021 06:55:57 +0000 (UTC)
Date:   Tue, 4 May 2021 08:55:56 +0200
From:   Ali Abdallah <ali.abdallah@suse.com>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org
Subject: Re: [PATCH] Avoid potentially erroneos RST check
Message-ID: <20210504065556.plfc37rghlxi7qyj@frix230>
References: <20210428131147.w2ppmrt6hpcjin5i@Fryzen495>
 <20210428143041.GA24118@salvia>
 <20210430092729.66f4jldpyqxedvpz@Fryzen495>
 <20210503210702.GA13695@salvia>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20210503210702.GA13695@salvia>
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On 03.05.2021 23:07, Pablo Neira Ayuso wrote:
> Thanks.
> 
> There are three patches in patchwork now (they come with no
> versioning, not sure if one of these is replaced by another).
> 
> So which ones below should be consider to be applied upstream?
> 
> https://patchwork.ozlabs.org/project/netfilter-devel/patch/20210420122415.v2jtayiw3n4ds7t7@Fryzen495/

Please discard the above, only kindly apply the following two commits:

> https://patchwork.ozlabs.org/project/netfilter-devel/patch/20210428130911.cteglt52r5if7ynp@Fryzen495/
> https://patchwork.ozlabs.org/project/netfilter-devel/patch/20210430093601.zibczc4cjnwx3qwn@Fryzen495/

-- 
Ali Abdallah | SUSE Linux L3 Engineer
GPG fingerprint: 51A0 F4A0 C8CF C98F 842E  A9A8 B945 56F8 1C85 D0D5

