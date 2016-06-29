From: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
Subject: Re: [PATCH] iptables: extensions: libxt_ecn: Add translation to nft
Date: Wed, 29 Jun 2016 10:29:44 +0200
Message-ID: <CAOkSjBg9y-NoqyHV38-SeG_LUjg2UbjozJ=-PXDWgcMDSDT45Q@mail.gmail.com>
References: <1467143937-19755-1-git-send-email-rodanber@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Netfilter Development Mailing list
	<netfilter-devel@vger.kernel.org>,
	Pablo Neira Ayuso <pablo@netfilter.org>
To: =?UTF-8?Q?Roberto_Garc=C3=ADa?= <rodanber@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-wm0-f65.google.com ([74.125.82.65]:36538 "EHLO
	mail-wm0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750873AbcF2IaF convert rfc822-to-8bit (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 29 Jun 2016 04:30:05 -0400
Received: by mail-wm0-f65.google.com with SMTP id c82so12447363wme.3
        for <netfilter-devel@vger.kernel.org>; Wed, 29 Jun 2016 01:30:05 -0700 (PDT)
In-Reply-To: <1467143937-19755-1-git-send-email-rodanber@gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On 28 June 2016 at 21:58,  <rodanber@gmail.com> wrote:
> diff --git a/extensions/libxt_ecn.c b/extensions/libxt_ecn.c
> index 286782a..8e0c35b 100644
> --- a/extensions/libxt_ecn.c
> +++ b/extensions/libxt_ecn.c
> @@ -118,6 +118,50 @@ static void ecn_save(const void *ip, const struc=
t xt_entry_match *match)
>         }
>  }
>
> +static int ecn_xlate(const void *ip, const struct xt_entry_match *ma=
tch,
> +                    struct xt_xlate *xl, int numeric)
> +{
> +       const struct xt_ecn_info *einfo =3D
> +               (const struct xt_ecn_info *)match->data;
> +
> +       if (einfo->operation & XT_ECN_OP_MATCH_IP) {

You could also do an early return here, given the case of this if ()
failing we have nothing to translate.

--=20
Arturo Borrero Gonz=C3=A1lez
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
