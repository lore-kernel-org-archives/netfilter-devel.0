Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D8BA1C77B7E
	for <netfilter-devel@archiver.kernel.org>; Thu, 20 Apr 2023 17:00:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229507AbjDTRA3 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 20 Apr 2023 13:00:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40278 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230414AbjDTRA0 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 20 Apr 2023 13:00:26 -0400
Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id C282455AB
        for <netfilter-devel@vger.kernel.org>; Thu, 20 Apr 2023 10:00:00 -0700 (PDT)
Date:   Thu, 20 Apr 2023 18:59:55 +0200
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Phil Sutter <phil@nwl.cc>
Cc:     netfilter-devel@vger.kernel.org,
        Stefano Brivio <sbrivio@redhat.com>
Subject: Re: [nft PATCH] tests: shell: Fix for unstable
 sets/0043concatenated_ranges_0
Message-ID: <ZEFvi9PIl846K0LD@calendula>
References: <20230420154723.27089-1-phil@nwl.cc>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20230420154723.27089-1-phil@nwl.cc>
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Thu, Apr 20, 2023 at 05:47:23PM +0200, Phil Sutter wrote:
> On my (slow?) testing VM, The test tends to fail when doing a full run
> (i.e., calling run-test.sh without arguments) and tends to pass when run
> individually.
> 
> The problem seems to be the 1s element timeout which in some cases may
> pass before element deletion occurs. Simply fix this by doubling the
> timeout. It has to pass just once, so shouldn't hurt too much.

I have seen this with CONFIG_KASAN too, thanks Phil.

> Fixes: 618393c6b3f25 ("tests: Introduce test for set with concatenated ranges")
> Cc: Stefano Brivio <sbrivio@redhat.com>
> Signed-off-by: Phil Sutter <phil@nwl.cc>
> ---
>  tests/shell/testcases/sets/0043concatenated_ranges_0 | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/tests/shell/testcases/sets/0043concatenated_ranges_0 b/tests/shell/testcases/sets/0043concatenated_ranges_0
> index 11767373bcd22..6e8f4000aa4ef 100755
> --- a/tests/shell/testcases/sets/0043concatenated_ranges_0
> +++ b/tests/shell/testcases/sets/0043concatenated_ranges_0
> @@ -147,7 +147,7 @@ for ta in ${TYPES}; do
>  			eval add_b=\$ADD_${tb}
>  			eval add_c=\$ADD_${tc}
>  			${NFT} add element inet filter test \
> -				"{ ${add_a} . ${add_b} . ${add_c} timeout 1s${mapv}}"
> +				"{ ${add_a} . ${add_b} . ${add_c} timeout 2s${mapv}}"
>  			[ $(${NFT} list ${setmap} inet filter test |	\
>  			   grep -c "${add_a} . ${add_b} . ${add_c}") -eq 1 ]
>  
> @@ -180,7 +180,7 @@ for ta in ${TYPES}; do
>  				continue
>  			fi
>  
> -			sleep 1
> +			sleep 2
>  			[ $(${NFT} list ${setmap} inet filter test |		\
>  			   grep -c "${add_a} . ${add_b} . ${add_c} ${mapv}") -eq 0 ]
>  			timeout_tested=1
> -- 
> 2.40.0
> 
