Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 18F24EB64D9
	for <netfilter-devel@archiver.kernel.org>; Mon, 19 Jun 2023 13:49:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232066AbjFSNtV (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 19 Jun 2023 09:49:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46280 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229861AbjFSNtU (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 19 Jun 2023 09:49:20 -0400
Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id EC2EBBD
        for <netfilter-devel@vger.kernel.org>; Mon, 19 Jun 2023 06:49:18 -0700 (PDT)
Date:   Mon, 19 Jun 2023 15:49:14 +0200
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Jeremy Sowden <jeremy@azazel.net>
Cc:     Netfilter Devel <netfilter-devel@vger.kernel.org>
Subject: Re: [PATCH nf] lib/ts_bm: reset initial match offset for every block
 of text
Message-ID: <ZJBc2qInxGK7yY34@calendula>
References: <20230611081719.612675-1-jeremy@azazel.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20230611081719.612675-1-jeremy@azazel.net>
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Hi Jeremy,

On Sun, Jun 11, 2023 at 09:17:19AM +0100, Jeremy Sowden wrote:
> The `shift` variable which indicates the offset in the string at which
> to start matching the pattern is initialized to `bm->patlen - 1`, but it
> is not reset when a new block is retrieved.  This means the implemen-
> tation may start looking at later and later positions in each successive
> block and miss occurrences of the pattern at the beginning.  E.g.,
> consider a HTTP packet held in a non-linear skb, where the HTTP request
> line occurs in the second block:
> 
>   [... 52 bytes of packet headers ...]
>   GET /bmtest HTTP/1.1\r\nHost: www.example.com\r\n\r\n
> 
> and the pattern is "GET /bmtest".
> 
> Once the first block comprising the packet headers has been examined,
> `shift` will be pointing to somewhere near the end of the block, and so
> when the second block is examined the request line at the beginning will
> be missed.
> 
> Reinitialize the variable for each new block.
> 
> Adjust some indentation and remove some trailing white-space at the same
> time.
> 
> Fixes: 8082e4ed0a61 ("[LIB]: Boyer-Moore extension for textsearch infrastructure strike #2")
> Link: https://bugzilla.netfilter.org/show_bug.cgi?id=1390
> Signed-off-by: Jeremy Sowden <jeremy@azazel.net>
> ---
>  lib/ts_bm.c | 16 +++++++++-------
>  1 file changed, 9 insertions(+), 7 deletions(-)
> 
> diff --git a/lib/ts_bm.c b/lib/ts_bm.c
> index 1f2234221dd1..ef448490a2cc 100644
> --- a/lib/ts_bm.c
> +++ b/lib/ts_bm.c
> @@ -60,23 +60,25 @@ static unsigned int bm_find(struct ts_config *conf, struct ts_state *state)
>  	struct ts_bm *bm = ts_config_priv(conf);
>  	unsigned int i, text_len, consumed = state->offset;
>  	const u8 *text;
> -	int shift = bm->patlen - 1, bs;
> +	int bs;
>  	const u8 icase = conf->flags & TS_IGNORECASE;
>  
>  	for (;;) {
> +		int shift = bm->patlen - 1;

This line is the fix, right?

>  		text_len = conf->get_next_block(consumed, &text, conf, state);
>  
>  		if (unlikely(text_len == 0))
>  			break;
>

These updates below are a clean up, right? If so, maybe split this in
two patches I'd suggest?

>  		while (shift < text_len) {
> -			DEBUGP("Searching in position %d (%c)\n", 
> -				shift, text[shift]);
> -			for (i = 0; i < bm->patlen; i++) 
> +			DEBUGP("Searching in position %d (%c)\n",
> +			       shift, text[shift]);
> +			for (i = 0; i < bm->patlen; i++)
>  				if ((icase ? toupper(text[shift-i])
> -				    : text[shift-i])
> -					!= bm->pattern[bm->patlen-1-i])
> -				     goto next;
> +				     : text[shift-i])
> +				    != bm->pattern[bm->patlen-1-i])

Maybe disentagle this with a few helper functions?

static char bm_get_char(const char *text, unsigned int pos, bool icase)
{
        return icase ? toupper(text[pos]) : text[pos];
}

Thanks

>  				if ((icase ? toupper(text[shift-i])
> -				    : text[shift-i])
> +					goto next;
>  
>  			/* London calling... */
>  			DEBUGP("found!\n");
> -- 
> 2.39.2
> 
