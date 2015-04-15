From: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
Subject: Re: [PATCH nf-next v3] netfilter: x_tables: add context to know if
 extension runs from nft_compat
Date: Wed, 15 Apr 2015 10:40:39 +0200
Message-ID: <CAOkSjBgx5cmjOZhqGKi4si+cA2-AiMPN97KOFfJt45pah8FvLw@mail.gmail.com>
References: <1425311196-5271-1-git-send-email-pablo@netfilter.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Netfilter Development Mailing list
	<netfilter-devel@vger.kernel.org>,
	Patrick McHardy <kaber@trash.net>, fw@strlen.de
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-la0-f48.google.com ([209.85.215.48]:32803 "EHLO
	mail-la0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752981AbbDOIlB convert rfc822-to-8bit (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 15 Apr 2015 04:41:01 -0400
Received: by layy10 with SMTP id y10so27238245lay.0
        for <netfilter-devel@vger.kernel.org>; Wed, 15 Apr 2015 01:41:00 -0700 (PDT)
In-Reply-To: <1425311196-5271-1-git-send-email-pablo@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On 2 March 2015 at 16:46, Pablo Neira Ayuso <pablo@netfilter.org> wrote=
:
> Currently, we have four xtables extensions that cannot be used from t=
he
> xt over nft compat layer. The problem is that they need real access t=
o
> the full blown xt_entry to validate that the rule comes with the righ=
t
> dependencies. This check was introduced to overcome the lack of
> sufficient userspace dependency validation in iptables.
>
> To resolve this problem, this patch introduces a new field to the
> xt_tgchk_param structure that tell us if the extension is run from
> nft_compat context.
>
> The four affected extensions are:
>
> 1) CLUSTERIP, this target has been superseded by xt_cluster. So just
>    bail out by returning -EINVAL.
>
> 2) TCPMSS. Relax the checking when used from nft_compat. If used with
>    the wrong configuration, it will corrupt !syn packets by adding TC=
P
>    MSS option.
>
> 3) SYNPROXY6. Don't check for e->ipv6.flags if used from nft_compat.
>
> 4) ebt_stp. Relax the check to make sure it uses the reserved
>    destination MAC address for STP.
>
> Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>

Tested-by: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>

--=20
Arturo Borrero Gonz=C3=A1lez
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
