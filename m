From: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
Subject: Re: [PATCH] extensions: libip6t_REJECT: Add translation to nft
Date: Tue, 5 Jan 2016 12:30:37 +0100
Message-ID: <CAOkSjBiBO6Aj-dmgBLB4jctWD_aXim3cJmoPcWC3_we-SG=YVQ@mail.gmail.com>
References: <20160105065504.GA5780@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Netfilter Development Mailing list
	<netfilter-devel@vger.kernel.org>
To: Shivani Bhardwaj <shivanib134@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-wm0-f50.google.com ([74.125.82.50]:37490 "EHLO
	mail-wm0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751798AbcAELa6 convert rfc822-to-8bit (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 5 Jan 2016 06:30:58 -0500
Received: by mail-wm0-f50.google.com with SMTP id f206so24431215wmf.0
        for <netfilter-devel@vger.kernel.org>; Tue, 05 Jan 2016 03:30:57 -0800 (PST)
In-Reply-To: <20160105065504.GA5780@gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On 5 January 2016 at 07:55, Shivani Bhardwaj <shivanib134@gmail.com> wr=
ote:
>
> +static const struct reject_names_xlate reject_table_xlate[] =3D {
> +       {"no-route",            IP6T_ICMP6_NO_ROUTE},
> +       {"admin-prohibited",    IP6T_ICMP6_ADM_PROHIBITED},
> +#if 0
> +       {"not-neighbour",       IP6T_ICMP6_NOT_NEIGHBOR},
> +#endif
> +       {"addr-unreachable",    IP6T_ICMP6_ADDR_UNREACH},
> +       {"port-unreachable",    IP6T_ICMP6_PORT_UNREACH},
> +       {"tcp reset",           IP6T_TCP_RESET},
> +       {"policy-fail",         IP6T_ICMP6_POLICY_FAIL},
> +       {"reject-route",        IP6T_ICMP6_REJECT_ROUTE}
> +};

I wonder the reason behind including code which seems is not going to
be compiled.
It was in the original extension code, perhaps you can revisit that now=
=2E

> +
> +static int REJECT_xlate(const struct xt_entry_target *target,
> +                       struct xt_buf *buf, int numeric)
> +{
> +       const struct ip6t_reject_info *reject =3D
> +                               (const struct ip6t_reject_info *)targ=
et->data;
> +       unsigned int i;
> +
> +       for (i =3D 0; i < ARRAY_SIZE(reject_table_xlate); ++i)
> +               if (reject_table_xlate[i].with =3D=3D reject->with)
> +                       break;
> +       if (reject->with =3D=3D IP6T_TCP_RESET)
> +               xt_buf_add(buf, "reject with %s", reject_table_xlate[=
i].name);
> +       else
> +               xt_buf_add(buf, "reject with icmpv6 type %s",
> +                          reject_table_xlate[i].name);
> +
> +       return 1;
> +}
> +

AFAIK, -j REJECT can be used without further options. However, this
_xlate() function doesn't seem to support it.

I would print unconditionally the 'reject' keyword and in case some
option was used, then include the 'with XXX' thing.

i.e:

the rule:
% [...] -p tcp --dport 22 -j REJECT
translates to:
% nft add rule [...] tcp dport 22 reject

and the rule:
% [...] -p tcp --dport 22 -j REJECT --reject-with no-route
translates to:
% nft add rule [...] tcp dport 22 reject with icmpv6 type no-route

--=20
Arturo Borrero Gonz=C3=A1lez
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
