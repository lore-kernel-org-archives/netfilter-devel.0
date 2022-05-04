Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EF6FBC433F5
	for <netfilter-devel@archiver.kernel.org>; Wed,  4 May 2022 20:17:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355085AbiEDUVD (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 4 May 2022 16:21:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53464 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351588AbiEDUVD (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 4 May 2022 16:21:03 -0400
Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 189AF4552B
        for <netfilter-devel@vger.kernel.org>; Wed,  4 May 2022 13:17:25 -0700 (PDT)
Date:   Wed, 4 May 2022 22:17:21 +0200
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Phil Sutter <phil@nwl.cc>
Cc:     netfilter-devel@vger.kernel.org
Subject: Re: [iptables PATCH 4/4] nft: Fix EPERM handling for extensions
 without rev 0
Message-ID: <YnLfUU8V2G9pY1H7@salvia>
References: <20220504103416.19712-1-phil@nwl.cc>
 <20220504103416.19712-5-phil@nwl.cc>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20220504103416.19712-5-phil@nwl.cc>
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Wed, May 04, 2022 at 12:34:16PM +0200, Phil Sutter wrote:
> Treating revision 0 as compatible in EPERM case works fine as long as
> there is a revision 0 of that extension defined in DSO. Fix the code for
> others: Extend the EPERM handling to all revisions and keep the existing
> warning for revision 0.
> 
> Fixes: 17534cb18ed0a ("Improve error messages for unsupported extensions")
> Signed-off-by: Phil Sutter <phil@nwl.cc>
> ---
>  iptables/nft.c                                     | 14 ++++++++++----
>  .../shell/testcases/iptables/0008-unprivileged_0   |  6 ++++++
>  2 files changed, 16 insertions(+), 4 deletions(-)
> 
> diff --git a/iptables/nft.c b/iptables/nft.c
> index 33813ce1b9202..95e6c222682c0 100644
> --- a/iptables/nft.c
> +++ b/iptables/nft.c
> @@ -3510,15 +3510,21 @@ int nft_compatible_revision(const char *name, uint8_t rev, int opt)
>  err:
>  	mnl_socket_close(nl);
>  
> -	/* pretend revision 0 is valid -
> +	/* ignore EPERM and errors for revision 0 -
>  	 * this is required for printing extension help texts as user, also
>  	 * helps error messaging on unavailable kernel extension */
> -	if (ret < 0 && rev == 0) {
> -		if (errno != EPERM)
> +	if (ret < 0) {
> +		if (errno == EPERM) {
> +			fprintf(stderr,
> +				"%s: Could not determine whether revision %u is supported, assuming it is.\n",

I'm not sure the user can do much about this error message, to me the
revisions concept are developer-only, I don't think we expose this
implementation detail in the documentation.

Why warn users in this case?

> +				name, rev);
> +			return 1;
> +		} else if (rev == 0) {
>  			fprintf(stderr,
>  				"Warning: Extension %s revision 0 not supported, missing kernel module?\n",
>  				name);
> -		return 1;
> +			return 1;
> +		}
>  	}
>  
>  	return ret < 0 ? 0 : 1;
> diff --git a/iptables/tests/shell/testcases/iptables/0008-unprivileged_0 b/iptables/tests/shell/testcases/iptables/0008-unprivileged_0
> index 43e3bc8721dbd..983531fef4720 100755
> --- a/iptables/tests/shell/testcases/iptables/0008-unprivileged_0
> +++ b/iptables/tests/shell/testcases/iptables/0008-unprivileged_0
> @@ -35,6 +35,12 @@ let "rc+=$?"
>  grep_or_rc "DNAT target options:" <<< "$out"
>  let "rc+=$?"
>  
> +# TEE has no revision 0
> +out=$(run $XT_MULTI iptables -j TEE --help)
> +let "rc+=$?"
> +grep_or_rc "TEE target options:" <<< "$out"
> +let "rc+=$?"
> +
>  out=$(run $XT_MULTI iptables -p tcp -j DNAT --help)
>  let "rc+=$?"
>  grep_or_rc "tcp match options:" <<< "$out"
> -- 
> 2.34.1
> 
