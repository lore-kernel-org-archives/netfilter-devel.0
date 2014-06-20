From: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
Subject: Re: [libnftnl PATCH 0/5] expr: bitwise: Do not print unset values
Date: Fri, 20 Jun 2014 09:16:48 +0200
Message-ID: <CAOkSjBgwTqWXtP7dnBgF0hJr--R0M=6E133KMTSgC2vPMq4snQ@mail.gmail.com>
References: <1403190430-22173-1-git-send-email-anarey@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Netfilter Development Mailing list
	<netfilter-devel@vger.kernel.org>
To: Ana Rey <anarey@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-lb0-f182.google.com ([209.85.217.182]:62779 "EHLO
	mail-lb0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934032AbaFTHRK convert rfc822-to-8bit (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 20 Jun 2014 03:17:10 -0400
Received: by mail-lb0-f182.google.com with SMTP id c11so2108490lbj.27
        for <netfilter-devel@vger.kernel.org>; Fri, 20 Jun 2014 00:17:08 -0700 (PDT)
In-Reply-To: <1403190430-22173-1-git-send-email-anarey@gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On 19 June 2014 17:07, Ana Rey <anarey@gmail.com> wrote:
> This patchset does tasks about does not print unset value in xml and =
json file
> and about refactoring code:
>
> *"expr: byteorder: Get a nft_rule_expr type in
>     nft_rule_expr_byteorder_snprintf_* functions"
> * "expr: byteorder: Use nft_rule_expr_set_* in the xml parsing code"
> * "expr: byteorder: Rename variables in
>     nft_rule_expr_byteorder_json_parse functions"
>
> *** BLURB HERE ***
>
> Ana Rey (5):
>   expr: byteorder: Get a nft_rule_expr type in
>     nft_rule_expr_byteorder_snprintf_* functions
>   expr: byteorder: Use nft_rule_expr_set_* in the xml parsing code
>   expr: byteorder: Do not print unset values in xml file
>   expr: byteorder: Rename variables in
>     nft_rule_expr_byteorder_json_parse functions
>   expr: byteorder: Do not print unset values in json
>
>  src/expr/byteorder.c | 196 +++++++++++++++++++++++++++--------------=
----------
>  1 file changed, 102 insertions(+), 94 deletions(-)
>

Hi Ana,

I reviewed this patch set, and is OK to me.

regards.
--=20
Arturo Borrero Gonz=C3=A1lez
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
