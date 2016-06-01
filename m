From: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
Subject: Re: [PATCH v3] extensions: libxt_multiport: Add translation to nft
Date: Wed, 1 Jun 2016 16:43:45 +0200
Message-ID: <CAOkSjBiGUCk83+Muwc6naTUJXTXgK7s0Bi+fvcCB6=WW50dxQQ@mail.gmail.com>
References: <20160531182607.GA17802@sonyv>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Netfilter Development Mailing list
	<netfilter-devel@vger.kernel.org>
To: Laura Garcia Liebana <nevola@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-wm0-f67.google.com ([74.125.82.67]:34949 "EHLO
	mail-wm0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751648AbcFAOoH convert rfc822-to-8bit (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 1 Jun 2016 10:44:07 -0400
Received: by mail-wm0-f67.google.com with SMTP id e3so7457408wme.2
        for <netfilter-devel@vger.kernel.org>; Wed, 01 Jun 2016 07:44:06 -0700 (PDT)
In-Reply-To: <20160531182607.GA17802@sonyv>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On 31 May 2016 at 20:26, Laura Garcia Liebana <nevola@gmail.com> wrote:
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
> +
> +       if (multiinfo->invert)
> +               xt_xlate_add(xl, "!=3D ");
> +
> +       if (multiinfo->count > 2 ||
> +           (multiinfo->count > 1 && !multiinfo->pflags[0])) {
> +               xt_xlate_add(xl, "{ ");
> +               if (multiinfo->invert)
> +                       return 0;
> +       }
> +

I fail to understand this return here

Other than that, the patch looks good.

> +       for (i =3D 0; i < multiinfo->count; i++) {
> +               xt_xlate_add(xl, "%s%u", i ? "," : "", multiinfo->por=
ts[i]);
> +               if (multiinfo->pflags[i])
> +                       xt_xlate_add(xl, "-%u", multiinfo->ports[++i]=
);
> +       }
> +
> +       if (multiinfo->count > 2 ||
> +           (multiinfo->count > 1 && !multiinfo->pflags[0]))
> +               xt_xlate_add(xl, "}");
> +
> +       xt_xlate_add(xl, " ");
> +
> +       return 1;
> +}

I missed this in previous revisions of your patch:

% iptables -A t -p tcp -m multiport --dports 80:100
% iptables -A t -p tcp -m multiport --dports 80:100,299:444

both rules are valid. This means that avoiding the single-element set
in the port-range case doesn't seems that important, sorry for that.

--=20
Arturo Borrero Gonz=C3=A1lez
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
