Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 483D3C433B4
	for <netfilter-devel@archiver.kernel.org>; Thu,  6 May 2021 09:18:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 10A4D610E6
	for <netfilter-devel@archiver.kernel.org>; Thu,  6 May 2021 09:18:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231758AbhEFJTQ (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 6 May 2021 05:19:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33810 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229800AbhEFJTP (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 6 May 2021 05:19:15 -0400
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8772EC061574
        for <netfilter-devel@vger.kernel.org>; Thu,  6 May 2021 02:18:17 -0700 (PDT)
Received: from n0-1 by orbyte.nwl.cc with local (Exim 4.94.2)
        (envelope-from <n0-1@orbyte.nwl.cc>)
        id 1lea98-0002NX-Tf; Thu, 06 May 2021 11:18:14 +0200
Date:   Thu, 6 May 2021 11:18:14 +0200
From:   Phil Sutter <phil@nwl.cc>
To:     Stefano Brivio <sbrivio@redhat.com>
Cc:     Pablo Neira Ayuso <pablo@netfilter.org>,
        PetrB <petr.boltik@gmail.com>, netfilter-devel@vger.kernel.org
Subject: Re: [PATCH nft 1/2] segtree: Fix range_mask_len() for subnet ranges
 exceeding unsigned int
Message-ID: <20210506091814.GG12403@orbyte.nwl.cc>
Mail-Followup-To: Phil Sutter <phil@nwl.cc>,
        Stefano Brivio <sbrivio@redhat.com>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        PetrB <petr.boltik@gmail.com>, netfilter-devel@vger.kernel.org
References: <cover.1620252768.git.sbrivio@redhat.com>
 <5ff3ceab3d3a547ab23144adbfa2000f1604c39f.1620252768.git.sbrivio@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5ff3ceab3d3a547ab23144adbfa2000f1604c39f.1620252768.git.sbrivio@redhat.com>
Sender:  <n0-1@orbyte.nwl.cc>
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Thu, May 06, 2021 at 12:23:13AM +0200, Stefano Brivio wrote:
> As concatenated ranges are fetched from kernel sets and displayed to
> the user, range_mask_len() evaluates whether the range is suitable for
> display as netmask, and in that case it calculates the mask length by
> right-shifting the endpoints until no set bits are left, but in the
> existing version the temporary copies of the endpoints are derived by
> copying their unsigned int representation, which doesn't suffice for
> IPv6 netmask lengths, in general.
> 
> PetrB reports that, after inserting a /56 subnet in a concatenated set
> element, it's listed as a /64 range. In fact, this happens for any
> IPv6 mask shorter than 64 bits.
> 
> Fix this issue by simply sourcing the range endpoints provided by the
> caller and setting the temporary copies with mpz_init_set(), instead
> of fetching the unsigned int representation. The issue only affects
> displaying of the masks, setting elements already works as expected.
> 

Fixes: 8ac2f3b2fca38 ("src: Add support for concatenated set ranges")

> Reported-by: PetrB <petr.boltik@gmail.com>
> Bugzilla: https://bugzilla.netfilter.org/show_bug.cgi?id=1520
> Signed-off-by: Stefano Brivio <sbrivio@redhat.com>
> ---
>  src/segtree.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/src/segtree.c b/src/segtree.c
> index ad199355532e..353a0053ebc0 100644
> --- a/src/segtree.c
> +++ b/src/segtree.c
> @@ -838,8 +838,8 @@ static int range_mask_len(const mpz_t start, const mpz_t end, unsigned int len)
>  	mpz_t tmp_start, tmp_end;
>  	int ret;
>  
> -	mpz_init_set_ui(tmp_start, mpz_get_ui(start));
> -	mpz_init_set_ui(tmp_end, mpz_get_ui(end));
> +	mpz_init_set(tmp_start, start);
> +	mpz_init_set(tmp_end, end);

The old code is a bit funny, was there a specific reason why you
exported the values into a C variable intermediately?

Cheers, Phil
