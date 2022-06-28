Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D6A1FC433EF
	for <netfilter-devel@archiver.kernel.org>; Tue, 28 Jun 2022 17:13:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229835AbiF1RNI (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 28 Jun 2022 13:13:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54210 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232306AbiF1RNH (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 28 Jun 2022 13:13:07 -0400
Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 655DFC30
        for <netfilter-devel@vger.kernel.org>; Tue, 28 Jun 2022 10:13:06 -0700 (PDT)
Date:   Tue, 28 Jun 2022 19:13:02 +0200
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Daniel =?utf-8?Q?Gr=C3=B6ber?= <dxld@darkboxed.org>
Cc:     netfilter-devel@vger.kernel.org
Subject: Re: [PATCH nftables] Allow resetting the include search path
Message-ID: <Yrs2nn/amfnaUDk8@salvia>
References: <20220627222304.93139-1-dxld@darkboxed.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20220627222304.93139-1-dxld@darkboxed.org>
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Hi,

On Tue, Jun 28, 2022 at 12:23:04AM +0200, Daniel Gröber wrote:
> Currently there is no way to disable searching in DEFAULT_INCLUDE_PATH
> first. This is needed when testing nftables configurations spanning
> multiple files without overwriting the globally installed ones.

You can do

# cat x.nft
include "./z.nft"
# cat z.nft
add table x

then:

# nft -f x.nft

using ./ at the beginning of the path overrides DEFAULT_INCLUDE_PATH.

Is this what you are searching for?

> ---
>  doc/nft.txt | 4 ++--
>  src/main.c  | 4 +++-
>  2 files changed, 5 insertions(+), 3 deletions(-)
> 
> diff --git a/doc/nft.txt b/doc/nft.txt
> index f7a53ac9..f04c3e20 100644
> --- a/doc/nft.txt
> +++ b/doc/nft.txt
> @@ -55,8 +55,8 @@ understanding of their meaning. You can get information about options by running
>  
>  *-I*::
>  *--includepath directory*::
> -	Add the directory 'directory' to the list of directories to be searched for included files. This
> -	option may be specified multiple times.
> +	Append a directory to the end of the search path for the *include* statement. If the empty
> +	string is passed the list is reset. This option may be specified multiple times.
>  
>  *-c*::
>  *--check*::
> diff --git a/src/main.c b/src/main.c
> index 9bd25db8..f5dd3dba 100644
> --- a/src/main.c
> +++ b/src/main.c
> @@ -411,7 +411,9 @@ int main(int argc, char * const *argv)
>  			interactive = true;
>  			break;
>  		case OPT_INCLUDEPATH:
> -			if (nft_ctx_add_include_path(nft, optarg)) {
> +			if (strcmp(optarg, "") == 0) {
> +				nft_ctx_clear_include_paths(nft);
> +			} else if (nft_ctx_add_include_path(nft, optarg)) {
>  				fprintf(stderr,
>  					"Failed to add include path '%s'\n",
>  					optarg);
> -- 
> 2.30.2
> 
