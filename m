From: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
Subject: Re: [libnftnl PATCH 0/4] expr: payload: Do not print unset values in
 xml and json
Date: Mon, 23 Jun 2014 11:15:22 +0200
Message-ID: <CAOkSjBgCxWy5-hR-J2w=fHmKKak1LTkDGRaW3NkF42mTrRUtJA@mail.gmail.com>
References: <1403461941-21605-1-git-send-email-anarey@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Netfilter Development Mailing list
	<netfilter-devel@vger.kernel.org>
To: Ana Rey <anarey@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-lb0-f172.google.com ([209.85.217.172]:49393 "EHLO
	mail-lb0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753344AbaFWJPo convert rfc822-to-8bit (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 23 Jun 2014 05:15:44 -0400
Received: by mail-lb0-f172.google.com with SMTP id c11so4122785lbj.31
        for <netfilter-devel@vger.kernel.org>; Mon, 23 Jun 2014 02:15:42 -0700 (PDT)
In-Reply-To: <1403461941-21605-1-git-send-email-anarey@gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On 22 June 2014 20:32, Ana Rey <anarey@gmail.com> wrote:
> This patchset does tasks about does not print unset values in xml and=
 json file
> and about refactoring code:
> * "expr: payload: Use nft_rule_expr_set_* in the xml parsing code"
> * "expr: payload: get a nft_rule_expr type in
>     nft_rule_expr_payload_snprintf_* functions"
>
> Ana Rey (4):
>   expr: payload: Use nft_rule_expr_set_* in the xml parsing code
>   expr: payload: get a nft_rule_expr type in
>     nft_rule_expr_payload_snprintf_* functions
>   expr: payload: Do not print unset values in xml file
>   expr: payload: Do not print unset values in json file
>
>  src/expr/payload.c | 129 +++++++++++++++++++++++++++----------------=
----------
>  1 file changed, 66 insertions(+), 63 deletions(-)
>

Hi Ana,

series reviewed.

thanks.

--=20
Arturo Borrero Gonz=C3=A1lez
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
