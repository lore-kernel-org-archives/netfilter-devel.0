Return-Path: <SRS0=sEEs=Z2=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EB326C43603
	for <netfilter-devel@archiver.kernel.org>; Wed,  4 Dec 2019 23:14:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id BD7212073C
	for <netfilter-devel@archiver.kernel.org>; Wed,  4 Dec 2019 23:14:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728060AbfLDXOF (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 4 Dec 2019 18:14:05 -0500
Received: from orbyte.nwl.cc ([151.80.46.58]:59472 "EHLO orbyte.nwl.cc"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727116AbfLDXOF (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 4 Dec 2019 18:14:05 -0500
Received: from n0-1 by orbyte.nwl.cc with local (Exim 4.91)
        (envelope-from <n0-1@orbyte.nwl.cc>)
        id 1icdqO-0005GI-23; Thu, 05 Dec 2019 00:14:04 +0100
Date:   Thu, 5 Dec 2019 00:14:04 +0100
From:   Phil Sutter <phil@nwl.cc>
To:     Florian Westphal <fw@strlen.de>
Cc:     netfilter-devel@vger.kernel.org
Subject: Re: [PATCH nf] selftests: netfilter: use randomized netns names
Message-ID: <20191204231404.GA14469@orbyte.nwl.cc>
Mail-Followup-To: Phil Sutter <phil@nwl.cc>,
        Florian Westphal <fw@strlen.de>, netfilter-devel@vger.kernel.org
References: <20191202173540.12230-1-fw@strlen.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191202173540.12230-1-fw@strlen.de>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Hi,

On Mon, Dec 02, 2019 at 06:35:40PM +0100, Florian Westphal wrote:
[...]
> @@ -532,32 +547,32 @@ EOF
>  	# ns1 should not have seen packets from ns2, due to masquerade
>  	expect="packets 0 bytes 0"
>  	for dir in "in" "out" ; do
> -		cnt=$(ip netns exec ns1 nft list counter inet filter ns2${dir} | grep -q "$expect")
> +		cnt=$(ip netns exec "$ns1" nft list counter inet filter ns2${dir} | grep -q "$expect")
>  		if [ $? -ne 0 ]; then
> -			bad_counter ns1 ns0$dir "$expect"
> +			bad_counter "$ns1" ns0$dir "$expect" "test_masquerade 5"
>  			lret=1
>  		fi
>  
> -		cnt=$(ip netns exec ns1 nft list counter inet filter ns2${dir} | grep -q "$expect")
> +		cnt=$(ip netns exec "$ns0" nft list counter inet filter ns1${dir} | grep -q "$expect")

This is confusing. You're fixing a bug and it is correct?

>  		if [ $? -ne 0 ]; then
> -			bad_counter ns2 ns1$dir "$expect"
> +			bad_counter "$ns0" ns1$dir "$expect" "test_masquerade 6"

And here as well?

[...]
> @@ -708,28 +723,28 @@ EOF
>  	# ns0 should have seen packets from ns2, due to masquerade
>  	expect="packets 1 bytes 84"
>  	for dir in "in" "out" ; do
> -		cnt=$(ip netns exec ns0 nft list counter inet filter ns2${dir} | grep -q "$expect")
> +		cnt=$(ip netns exec "$ns0" nft list counter inet filter ns2${dir} | grep -q "$expect")
>  		if [ $? -ne 0 ]; then
> -			bad_counter ns1 ns0$dir "$expect"
> +			bad_counter "$ns0" ns0$dir "$expect" "test_redirect 4"

This is actually a bugfix, right?

Assuming the above non-trivial cases are correct:

Acked-by: Phil Sutter <phil@nwl.cc>

Cheers, Phil
