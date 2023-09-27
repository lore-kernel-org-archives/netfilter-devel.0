Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9470EE82CA5
	for <netfilter-devel@archiver.kernel.org>; Wed, 27 Sep 2023 15:02:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232360AbjI0PCQ (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 27 Sep 2023 11:02:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35532 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232332AbjI0PCK (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 27 Sep 2023 11:02:10 -0400
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B822B192
        for <netfilter-devel@vger.kernel.org>; Wed, 27 Sep 2023 08:02:06 -0700 (PDT)
Received: from n0-1 by orbyte.nwl.cc with local (Exim 4.94.2)
        (envelope-from <n0-1@orbyte.nwl.cc>)
        id 1qlW3A-0002gk-Sb; Wed, 27 Sep 2023 17:02:04 +0200
Date:   Wed, 27 Sep 2023 17:02:04 +0200
From:   Phil Sutter <phil@nwl.cc>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org
Subject: Re: [PATCH nft] tests: shell: fix spurious errors in
 sets/0036add_set_element_expiration_0
Message-ID: <ZRRD7B/dvuCwgfvD@orbyte.nwl.cc>
Mail-Followup-To: Phil Sutter <phil@nwl.cc>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        netfilter-devel@vger.kernel.org
References: <20230927144803.138869-1-pablo@netfilter.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230927144803.138869-1-pablo@netfilter.org>
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Wed, Sep 27, 2023 at 04:48:03PM +0200, Pablo Neira Ayuso wrote:
> Add seconds as expiration, otherwise 14m59 reports 14m in minute
> granularity, this ensures suficient time in a very slow environment with
> debugging instrumentation.
> 
> Fixes: adf38fd84257 ("tests: shell: use minutes granularity in sets/0036add_set_element_expiration_0")
> Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
> ---
> I still see this failing occasionally due to timing issues, fix it.
> 
>  tests/shell/testcases/sets/0036add_set_element_expiration_0 | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/tests/shell/testcases/sets/0036add_set_element_expiration_0 b/tests/shell/testcases/sets/0036add_set_element_expiration_0
> index 12f10074409f..a50ac91d43a6 100755
> --- a/tests/shell/testcases/sets/0036add_set_element_expiration_0
> +++ b/tests/shell/testcases/sets/0036add_set_element_expiration_0
> @@ -8,7 +8,7 @@ drop_seconds() {
>  
>  RULESET="add table ip x
>  add set ip x y { type ipv4_addr; flags dynamic,timeout; } 
> -add element ip x y { 1.1.1.1 timeout 30m expires 15m }"
> +add element ip x y { 1.1.1.1 timeout 30m expires 15m59s }"
>  
>  test_output=$($NFT -e -f - <<< "$RULESET" 2>&1 | grep -v '# new generation' | drop_seconds)

The next line in that file is:

| if [ "$test_output" != "$RULESET" ] ; then

You add "59s" to $RULESET and drop it from $test_output. I guess, to
make it work, you also need to pipe $RULESET through drop_seconds before
the comparison.

Cheers, Phil
