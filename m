From: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
Subject: Re: [PATCH] iptables: extensions: libxt_ecn: Add translation to nft
Date: Wed, 29 Jun 2016 08:41:20 +0200
Message-ID: <CAOkSjBhBgbczkxGdMpS+ZbnBuJyN2JgJiHz53jHN=QM4iTgZHA@mail.gmail.com>
References: <1467143937-19755-1-git-send-email-rodanber@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Netfilter Development Mailing list
	<netfilter-devel@vger.kernel.org>,
	Pablo Neira Ayuso <pablo@netfilter.org>
To: =?UTF-8?Q?Roberto_Garc=C3=ADa?= <rodanber@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-wm0-f66.google.com ([74.125.82.66]:34128 "EHLO
	mail-wm0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751266AbcF2Gll convert rfc822-to-8bit (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 29 Jun 2016 02:41:41 -0400
Received: by mail-wm0-f66.google.com with SMTP id 187so11799714wmz.1
        for <netfilter-devel@vger.kernel.org>; Tue, 28 Jun 2016 23:41:40 -0700 (PDT)
In-Reply-To: <1467143937-19755-1-git-send-email-rodanber@gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On 28 June 2016 at 21:58,  <rodanber@gmail.com> wrote:
> From: Roberto Garc=C3=ADa <rodanber@gmail.com>
>
> Add translation of the ecn match to nftables.
>
> Examples:
>   # iptables-translate -A INPUT -m ecn --ecn-ip-ect 0
>   nft add rule ip filter INPUT ip ecn not-ect counter
>
>   # iptables-translate -A INPUT -m ecn --ecn-ip-ect 1
>   nft add rule ip filter INPUT ip ecn ect1 counter
>
>   # iptables-translate -A INPUT -m ecn --ecn-ip-ect 2
>   nft add rule ip filter INPUT ip ecn ect0 counter
>
>   # iptables-translate -A INPUT -m ecn --ecn-ip-ect 3
>   nft add rule ip filter INPUT ip ecn ce counter
>
>   # iptables-translate -A INPUT -m ecn ! --ecn-ip-ect 0
>   nft add rule ip filter INPUT ip ecn !=3D not-ect counter
>
>   # iptables-translate -A INPUT -m ecn ! --ecn-ip-ect 1
>   nft add rule ip filter INPUT ip ecn !=3D ect1 counter
>
>   # iptables-translate -A INPUT -m ecn ! --ecn-ip-ect 2
>   nft add rule ip filter INPUT ip ecn !=3D ect0 counter
>
>   # iptables-translate -A INPUT -m ecn ! --ecn-ip-ect 3
>   nft add rule ip filter INPUT ip ecn !=3D ce counter
>
> Signed-off-by: Roberto Garc=C3=ADa <rodanber@gmail.com>
> ---
>  extensions/libxt_ecn.c | 45 ++++++++++++++++++++++++++++++++++++++++=
+++++
>  1 file changed, 45 insertions(+)
>
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
> +               xt_xlate_add(xl, "ip ecn ");
> +               if (einfo->invert) {
> +                       switch (einfo->ip_ect) {
> +                       case 0:
> +                               xt_xlate_add(xl, "!=3D not-ect ");
> +                               break;
> +                       case 1:
> +                               xt_xlate_add(xl, "!=3D ect1 ");
> +                               break;
> +                       case 2:
> +                               xt_xlate_add(xl, "!=3D ect0 ");
> +                               break;
> +                       case 3:
> +                               xt_xlate_add(xl, "!=3D ce ");
> +                               break;
> +                       }
> +               } else {
> +                       switch (einfo->ip_ect) {
> +                       case 0:
> +                               xt_xlate_add(xl, "not-ect ");
> +                               break;
> +                       case 1:
> +                               xt_xlate_add(xl, "ect1 ");
> +                               break;
> +                       case 2:
> +                               xt_xlate_add(xl, "ect0 ");
> +                               break;
> +                       case 3:
> +                               xt_xlate_add(xl, "ce ");
> +                               break;

I would try to compact a bit the code, ie:

[...]
xt_xlate_add(xl, "ip ecn ");

if (einfo->invert)
   xt_xlate_add(xl, "!=3D ");

switch (einfo->ip_ect) {
case 0:
   xt_xlate_add(xl, "not-ect");
   break;
[...]

--=20
Arturo Borrero Gonz=C3=A1lez
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
