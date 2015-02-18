From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: conntrackd refuses to work on interface with '_' in it's name
Date: Thu, 19 Feb 2015 00:58:06 +0100
Message-ID: <20150218235806.GA28804@salvia>
References: <CAE5AaEz=TwJKUgWp+uE4XgCjUVA3feqYeovURnNhpHwwYsPQzQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: AZ <ak47izatool@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:34188 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751144AbbBRXys (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 18 Feb 2015 18:54:48 -0500
Content-Disposition: inline
In-Reply-To: <CAE5AaEz=TwJKUgWp+uE4XgCjUVA3feqYeovURnNhpHwwYsPQzQ@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Tue, Feb 17, 2015 at 05:36:10PM +0700, AZ wrote:
> There is a syntax error if you'll try to use interface with the name
> containing underscore.
> The kernel works with such an interfaces, so there's no reason
> conntrackd shouldn't.

Just applied a similar patch, this one was not applying cleanly with
via git am.

> I propose the following patch to fix this, works for me:
> --- read_config_lex.l.orig      2015-02-17 16:35:08.160554333 +0600
> +++ read_config_lex.l   2015-02-17 16:35:24.053887237 +0600
> @@ -47,7 +47,7 @@ ip6_part      {hex_255}":"?
>  ip6_form1      {ip6_part}{0,7}"::"{ip6_part}{0,7}
>  ip6_form2      ({hex_255}":"){0,7}{hex_255}
>  ip6            {ip6_form1}{ip6_cidr}?|{ip6_form2}{ip6_cidr}?
> -string         [a-zA-Z][a-zA-Z0-9\.\-]*
> +string         [a-zA-Z][a-zA-Z0-9_\.\-]*
>  persistent     [P|p][E|e][R|r][S|s][I|i][S|s][T|t][E|e][N|n][T|T]
>  nack           [N|n][A|a][C|c][K|k]
>  alarm          [A|a][L|l][A|a][R|r][M|m]
> --
> To unsubscribe from this list: send the line "unsubscribe netfilter-devel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
