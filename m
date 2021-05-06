Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E12A5C433ED
	for <netfilter-devel@archiver.kernel.org>; Thu,  6 May 2021 07:33:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A76FE60FF3
	for <netfilter-devel@archiver.kernel.org>; Thu,  6 May 2021 07:33:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233340AbhEFHej (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 6 May 2021 03:34:39 -0400
Received: from mx2.suse.de ([195.135.220.15]:37364 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233240AbhEFHei (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 6 May 2021 03:34:38 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1620286420; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=khtSrVfB3QthcMXttruXhmO5ZQAFs/KmHKeGy3OjcbU=;
        b=MOIlUyLljuOfsWvIiuQ4CIyqX0eWSdkN17bPx/i5N60w4lBFkYzph3q2dnepap+3Sh0lZo
        e3QLJdFQohclh6A3/1V2flo9ABaTuFpbPNfjzkqsjgmeWwcFoP8Ajeg3itJbBFxCpj0LWV
        F/roTrMJB6A94ck+40wMOdjb2DW1k6w=
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 1ABEAAE03;
        Thu,  6 May 2021 07:33:40 +0000 (UTC)
Date:   Thu, 6 May 2021 09:33:39 +0200
From:   Ali Abdallah <ali.abdallah@suse.com>
To:     Florian Westphal <fw@strlen.de>
Cc:     netfilter-devel@vger.kernel.org
Subject: Re: [PATCH] Avoid potentially erroneos RST drop.
Message-ID: <20210506073339.5ah5dyzqdhwxyovh@Fryzen495>
References: <20210430093601.zibczc4cjnwx3qwn@Fryzen495>
 <YJL30q7mCUezag48@strlen.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <YJL30q7mCUezag48@strlen.de>
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On 05.05.2021 21:53, Florian Westphal wrote:
> Ali, sorry for coming back to this again and again.
> 
> What do you think of this change?
> 
> Its an incremental change on top of your patch.
> 
> The only real change is that this will skip window check if
> conntrack thinks connection is closing already.
> 
> In addition, tcp window check is skipped in that case.
> 
> This is supposed to expedite conntrack eviction in case of tuple reuse
> by some nat/pat middlebox, or a peer that has lower timeouts than
> conntrack before a port is re-used.

Thanks Florian, this looks sane for me, I will give a try and report
back here.

-- 
Ali Abdallah | SUSE Linux L3 Engineer
GPG fingerprint: 51A0 F4A0 C8CF C98F 842E  A9A8 B945 56F8 1C85 D0D5

