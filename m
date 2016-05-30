From: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
Subject: Re: [PATCH v2] extensions: libxt_multiport: Add translation to nft
Date: Tue, 31 May 2016 00:08:57 +0200
Message-ID: <CAOkSjBgKZyr-GJLWwASNoLOftJbQu5boiTpMOfNsj7YCktYGxw@mail.gmail.com>
References: <20160530194748.GA25328@sonyv>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Netfilter Development Mailing list
	<netfilter-devel@vger.kernel.org>
To: Laura Garcia Liebana <nevola@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-wm0-f65.google.com ([74.125.82.65]:35046 "EHLO
	mail-wm0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161992AbcE3WJT convert rfc822-to-8bit (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 30 May 2016 18:09:19 -0400
Received: by mail-wm0-f65.google.com with SMTP id e3so26607068wme.2
        for <netfilter-devel@vger.kernel.org>; Mon, 30 May 2016 15:09:18 -0700 (PDT)
In-Reply-To: <20160530194748.GA25328@sonyv>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On 30 May 2016 at 21:47, Laura Garcia Liebana <nevola@gmail.com> wrote:
> Add translation for multiport to nftables, which it's supported nativ=
ely.
>
> Examples:
>
> $ sudo iptables-translate -t filter -A INPUT -p tcp -m multiport --dp=
orts 80,81 -j ACCEPT
> nft add rule ip filter INPUT ip protocol tcp tcp dport { 80,81} count=
er accept
>
> $ sudo iptables-translate -t filter -A INPUT -p tcp -m multiport --dp=
orts 80:88 -j ACCEPT
> nft add rule ip filter INPUT ip protocol tcp tcp dport { 80-88} count=
er accept
>
> $ sudo iptables-translate -t filter -A INPUT -p tcp -m multiport ! --=
dports 80:88 -j ACCEPT
> nft add rule ip filter INPUT ip protocol tcp tcp dport !=3D 80-88 cou=
nter accept
>

Lets clarify the syntax, this is valid:

tcp dport 8000-8100
tcp dport { 8000-8100}
tcp dport { 8000-8100, 9000-9100}

but they mean different things. It seems we should avoid the braces {}
for the range case, otherwise we would be using a set with a single
element.

However,

tcp dport {8000,8100} <-- valid
tcp dport 8000,8100 <-- invalid

So we should always use braces {} in the non-range case.

Same seems to apply in the case of inversion.

so we end with this combinations:

tcp dport {x,x}
tcp dport !=3D {x,x}
tcp dport x-x
tcp dport !=3D x-x

BTW, related to this, there seems to be a bug in nftables:

% nft add rule t c tcp dport !=3D {80, 81}
BUG: invalid expression type set
nft: evaluate.c:1463: expr_evaluate_relational: Assertion `0' failed.
Aborted


> Signed-off-by: Laura Garcia Liebana <nevola@gmail.com>
> ---
> Changes in v2:
>         - Add curley brackets to lists and range of ports.
>
>  extensions/libxt_multiport.c | 116 +++++++++++++++++++++++++++++++++=
++++++++++
>  1 file changed, 116 insertions(+)
>
> diff --git a/extensions/libxt_multiport.c b/extensions/libxt_multipor=
t.c
> index 03af5a9..25b5589 100644
> --- a/extensions/libxt_multiport.c
> +++ b/extensions/libxt_multiport.c
> @@ -468,6 +468,118 @@ static void multiport_save6_v1(const void *ip_v=
oid,
>         __multiport_save_v1(match, ip->proto);
>  }
>
> +static int __multiport_xlate(const void *ip, const struct xt_entry_m=
atch *match,
> +                            struct xt_xlate *xl, int numeric)
> +{
> +       const struct xt_multiport *multiinfo
> +               =3D (const struct xt_multiport *)match->data;
> +       unsigned int i;
> +
> +       switch (multiinfo->flags) {
> +       case XT_MULTIPORT_SOURCE:
> +               xt_xlate_add(xl, "sport ");
> +               break;
> +       case XT_MULTIPORT_DESTINATION:
> +               xt_xlate_add(xl, "dport ");
> +               break;
> +       case XT_MULTIPORT_EITHER:
> +               return 0;
> +       }

this case XT_MULTIPORT_EITHER seems unsupported in nftables.

Is there anything established to do in case we find an impossible
translation? print a warning or something? I don't know right now.
I guess we should avoid printing an invalid nftables rule as if the
translation was 100% ok (which is not true in this case).

Just wondering, I should check myself because I don't know this right n=
ow.


> +
> +       if (multiinfo->count > 1)
> +               xt_xlate_add(xl, "{ ");
> +
> +       for (i =3D 0; i < multiinfo->count; i++)
> +               xt_xlate_add(xl, "%s%u", i ? "," : "", multiinfo->por=
ts[i]);
> +
> +       if (multiinfo->count > 1)
> +               xt_xlate_add(xl, "}");
> +
> +       xt_xlate_add(xl, " ");
> +
> +       return 1;
> +}
> +
> +static int multiport_xlate(const void *ip, const struct xt_entry_mat=
ch *match,
> +                          struct xt_xlate *xl, int numeric)
> +{
> +       uint8_t proto =3D ((const struct ipt_ip *)ip)->proto;
> +
> +       xt_xlate_add(xl, "%s ", proto_to_name(proto));
> +       return __multiport_xlate(ip, match, xl, numeric);
> +}
> +
> +static int multiport_xlate6(const void *ip, const struct xt_entry_ma=
tch *match,
> +                           struct xt_xlate *xl, int numeric)
> +{
> +       uint8_t proto =3D ((const struct ip6t_ip6 *)ip)->proto;
> +
> +       xt_xlate_add(xl, "%s ", proto_to_name(proto));
> +       return __multiport_xlate(ip, match, xl, numeric);
> +}
> +
> +static int __multiport_xlate_v1(const void *ip,
> +                               const struct xt_entry_match *match,
> +                               struct xt_xlate *xl, int numeric)
> +{
> +       const struct xt_multiport_v1 *multiinfo
> +               =3D (const struct xt_multiport_v1 *)match->data;
> +       unsigned int i;
> +
> +       switch (multiinfo->flags) {
> +       case XT_MULTIPORT_SOURCE:
> +               xt_xlate_add(xl, "sport ");
> +               break;
> +       case XT_MULTIPORT_DESTINATION:
> +               xt_xlate_add(xl, "dport ");
> +               break;
> +       case XT_MULTIPORT_EITHER:
> +               return 0;
> +       }

same XT_MULTIPORT_EITHER here.

> +
> +       if (multiinfo->invert) {
> +               xt_xlate_add(xl, "!=3D ");
> +       } else {
> +               if (multiinfo->count > 1)
> +                       xt_xlate_add(xl, "{ ");
> +       }

This if/else seems bogus. We only allow port sets if not inverting?

> +
> +       for (i =3D 0; i < multiinfo->count; i++) {
> +               xt_xlate_add(xl, "%s%u", i ? "," : "", multiinfo->por=
ts[i]);
> +               if (i && multiinfo->invert)
> +                       return 0;

This return here could mean that we build an incomplete nftables rule
(ie, missing '}')

> +               if (multiinfo->pflags[i])
> +                       xt_xlate_add(xl, "-%u", multiinfo->ports[++i]=
);
> +       }
> +
> +       if (multiinfo->count > 1 && !multiinfo->invert)
> +               xt_xlate_add(xl, "}");
> +
> +       xt_xlate_add(xl, " ");
> +
> +       return 1;
> +}


--=20
Arturo Borrero Gonz=C3=A1lez
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
