From: Paul Robert Marino <prmarino1@gmail.com>
Subject: Re: conntrackd refuses to work on interface with '_' in it's name
Date: Tue, 17 Feb 2015 17:11:54 -0500
Message-ID: <CAPJdpdDsCdYBXXPFh4=BgmzegLsJXDtKkttQyqBhS6s3EpDBnQ@mail.gmail.com>
References: <CAE5AaEz=TwJKUgWp+uE4XgCjUVA3feqYeovURnNhpHwwYsPQzQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: netfilter-devel@vger.kernel.org
To: AZ <ak47izatool@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-ob0-f182.google.com ([209.85.214.182]:51212 "EHLO
	mail-ob0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752197AbbBQWLy (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 17 Feb 2015 17:11:54 -0500
Received: by mail-ob0-f182.google.com with SMTP id nt9so57300186obb.13
        for <netfilter-devel@vger.kernel.org>; Tue, 17 Feb 2015 14:11:54 -0800 (PST)
In-Reply-To: <CAE5AaEz=TwJKUgWp+uE4XgCjUVA3feqYeovURnNhpHwwYsPQzQ@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

The iproute2 commands really don't put many restrictions on interface
names but most people generally avoid strange names because of
compatibility issues, and the fact that it can be confusing for admins
who are not properly taught the logic behind the custom names.
While the idea is not bad per say it is definitely an edge case.

On Tue, Feb 17, 2015 at 5:36 AM, AZ <ak47izatool@gmail.com> wrote:
> There is a syntax error if you'll try to use interface with the name
> containing underscore.
> The kernel works with such an interfaces, so there's no reason
> conntrackd shouldn't.
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
