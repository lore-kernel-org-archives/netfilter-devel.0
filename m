Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D3485C61D97
	for <netfilter-devel@archiver.kernel.org>; Wed, 22 Nov 2023 21:18:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233157AbjKVVS5 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 22 Nov 2023 16:18:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35652 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231594AbjKVVS4 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 22 Nov 2023 16:18:56 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8B706101;
        Wed, 22 Nov 2023 13:18:53 -0800 (PST)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8A0BAC433C8;
        Wed, 22 Nov 2023 21:18:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1700687933;
        bh=HQPVNrL6PL+BztQ0r8Ah8wHIMisBl1OK8jWii2Jjquw=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=YajT2K0It3M/F8bNUrrtfrr8ARtYncDH6C6RzsI3ghZojVCk2YO4m6FkPnMAmx5e7
         LvrntJ69QgcP+qjAZaki9IpJPgm7cjSxNsvlMToVMC/Zsm/7lzpIkFfytpUREutAwr
         4LQ/6GYU1WS5Sfb5TONJJf/51fzfo4uQLzQ19NOd4xktKLyWLgdP3bod0duXzPrvj6
         1Wel7iDaM7yaypMScyCkFU9igkRihLnmEXSzgY3Gbh06dk85n4/U16yacDIxgS6RVz
         7EU83B3qP20hQPZbPczUSd0yyAO6I3IHLsREEkTqyAVuuxCDa2MUi3UeIWzh+/uXIK
         fTa3BIdcvjSDw==
Date:   Wed, 22 Nov 2023 16:18:48 -0500
From:   Sasha Levin <sashal@kernel.org>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Florian Westphal <fw@strlen.de>, stable@vger.kernel.org,
        netfilter-devel@vger.kernel.org
Subject: Re: [PATCH 6.6.y 0/2] netfilter: fix catchall element double-free
Message-ID: <ZV5wOBdT2v58Hwiq@sashalap>
References: <20231121121431.8612-1-fw@strlen.de>
 <ZV0jmKNgQpxCvf/R@calendula>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <ZV0jmKNgQpxCvf/R@calendula>
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Tue, Nov 21, 2023 at 10:39:54PM +0100, Pablo Neira Ayuso wrote:
>Hi Greg, Sasha,
>
>On Tue, Nov 21, 2023 at 01:14:20PM +0100, Florian Westphal wrote:
>> Hello,
>>
>> This series contains the backports of two related changes to fix
>> removal of timed-out catchall elements.
>>
>> As-is, removed element remains on the list and will be collected
>> again.
>>
>> The adjustments are needed because of missing commit
>> 0e1ea651c971 ("netfilter: nf_tables: shrink memory consumption of set elements"),
>> so we need to pass set_elem container struct instead of "elem_priv".
>
>Please, also apply this series to -stable 5.15, 6.1 and 6.5.
>
>This series apply cleanly to these -stable kernels, I have also tested
>this series on them.
>
>Tested-by: Pablo Neira Ayuso <pablo@netfilter.org>

Queued up, thanks!

-- 
Thanks,
Sasha
