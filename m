From: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
Subject: Re: [libnftnl PATCH 0/3] expr: bitwise: Do not print unset values
Date: Fri, 20 Jun 2014 09:19:19 +0200
Message-ID: <CAOkSjBg89EWHK3CYazaQsmMRO7tGRpLEA=KQabCwWAmpanrH8g@mail.gmail.com>
References: <1403172339-29786-1-git-send-email-anarey@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Netfilter Development Mailing list
	<netfilter-devel@vger.kernel.org>
To: Ana Rey <anarey@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-lb0-f175.google.com ([209.85.217.175]:37025 "EHLO
	mail-lb0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934032AbaFTHTl convert rfc822-to-8bit (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 20 Jun 2014 03:19:41 -0400
Received: by mail-lb0-f175.google.com with SMTP id q8so2055498lbi.20
        for <netfilter-devel@vger.kernel.org>; Fri, 20 Jun 2014 00:19:39 -0700 (PDT)
In-Reply-To: <1403172339-29786-1-git-send-email-anarey@gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On 19 June 2014 12:05, Ana Rey <anarey@gmail.com> wrote:
> This patchset does tasks about does not print unset value in xml and =
json file
> and about refactoring code: "Get a nft_rule_expr type in
> nft_rule_expr_bitwise_snprintf_* functions"
>
> Ana Rey (3):
>   expr: bitwise: Get a nft_rule_expr type in
>     nft_rule_expr_bitwise_snprintf_* functions
>   expr: bitwise: Do not print unset values in xml
>   expr: bitwise: Do not print unset values in json
>
>  src/expr/bitwise.c | 212 ++++++++++++++++++++++++++++---------------=
----------
>  1 file changed, 112 insertions(+), 100 deletions(-)
>


Patch set reviewed. Ok to me.

regards.
--=20
Arturo Borrero Gonz=C3=A1lez
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
