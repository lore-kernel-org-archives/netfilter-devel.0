Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CDE6BC4332F
	for <netfilter-devel@archiver.kernel.org>; Thu, 22 Dec 2022 10:38:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235304AbiLVKiq (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 22 Dec 2022 05:38:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45188 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235142AbiLVKil (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 22 Dec 2022 05:38:41 -0500
Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 8A5EB6546
        for <netfilter-devel@vger.kernel.org>; Thu, 22 Dec 2022 02:38:39 -0800 (PST)
Date:   Thu, 22 Dec 2022 11:38:35 +0100
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Jeremy Sowden <jeremy@azazel.net>
Cc:     Netfilter Devel <netfilter-devel@vger.kernel.org>
Subject: Re: [PATCH nft] scanner: treat invalid octal strings as strings
Message-ID: <Y6Qzq48e+ihIf4La@salvia>
References: <20221216202714.1413699-1-jeremy@azazel.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20221216202714.1413699-1-jeremy@azazel.net>
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Hi Jeremy,

On Fri, Dec 16, 2022 at 08:27:14PM +0000, Jeremy Sowden wrote:
> The action associated with the `{numberstring}` pattern, passes `yytext`
> to `strtoull` with base 0:
> 
> 	errno = 0;
> 	yylval->val = strtoull(yytext, NULL, 0);
> 	if (errno != 0) {
> 		yylval->string = xstrdup(yytext);
> 		return STRING;
> 	}
> 	return NUM;
> 
> If `yytext` begins with '0', it will be parsed as octal.  However, this
> has unexpected consequences if the token contains non-octal characters.
> `09` will be parsed as 0; `0308` will be parsed as 24, because
> `strtoull` and its siblings stop parsing as soon as they reach a
> character in the input which is not valid for the base.
> 
> Replace the `{numberstring}` match with separate `{hexstring}` and
> `{decstring}` matches.  For `{decstring}` set the base to 8 if the
> leading character is '0', and handle an incompletely parsed token in
> the same way as one that causes `strtoull` to set `errno`.
> 
> Thus, instead of:
> 
>   $ sudo nft -f - <<<'
>     table x {
>       chain y {
>         ip saddr 0308 continue comment "parsed as 0.0.0.24/32"
>       }
>     }
>   '
>   $ sudo nft list chain x y
>   table ip x {
>     chain y {
>       ip saddr 0.0.0.24 continue comment "parsed as 0.0.0.24/32"
>     }
>   }
> 
> We get:
> 
>   $ sudo ./src/nft -f - <<<'
>   > table x {
>   >   chain y {
>   >     ip saddr 0308 continue comment "error"
>   >   }
>   > }
>   > '
>   /dev/stdin:4:14-17: Error: Could not resolve hostname: Name or service not known
>       ip saddr 0308 continue comment "error"
>                ^^^^
> 
> Add a test-case.

Applied, thanks.

I am sorry I missed this patch before the release.
