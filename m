From: Laura Garcia <nevola@gmail.com>
Subject: Re: [PATCH v3] extensions: libxt_multiport: Add translation to nft
Date: Wed, 1 Jun 2016 22:16:18 +0200
Message-ID: <20160601201614.GA24726@sonyv>
References: <20160531182607.GA17802@sonyv>
 <CAOkSjBiGUCk83+Muwc6naTUJXTXgK7s0Bi+fvcCB6=WW50dxQQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Netfilter Development Mailing list
	<netfilter-devel@vger.kernel.org>
To: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-wm0-f67.google.com ([74.125.82.67]:33154 "EHLO
	mail-wm0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750807AbcFAUQX (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 1 Jun 2016 16:16:23 -0400
Received: by mail-wm0-f67.google.com with SMTP id a136so9986367wme.0
        for <netfilter-devel@vger.kernel.org>; Wed, 01 Jun 2016 13:16:22 -0700 (PDT)
Content-Disposition: inline
In-Reply-To: <CAOkSjBiGUCk83+Muwc6naTUJXTXgK7s0Bi+fvcCB6=WW50dxQQ@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Wed, Jun 01, 2016 at 04:43:45PM +0200, Arturo Borrero Gonzalez wrote:
> On 31 May 2016 at 20:26, Laura Garcia Liebana <nevola@gmail.com> wrote:
> > +static int __multiport_xlate_v1(const void *ip,
> > +                               const struct xt_entry_match *match,
> > +                               struct xt_xlate *xl, int numeric)
> > +{
> > +       const struct xt_multiport_v1 *multiinfo
> > +               = (const struct xt_multiport_v1 *)match->data;
> > +       unsigned int i;
> > +
> > +       switch (multiinfo->flags) {
> > +       case XT_MULTIPORT_SOURCE:
> > +               xt_xlate_add(xl, "sport ");
> > +               break;
> > +       case XT_MULTIPORT_DESTINATION:
> > +               xt_xlate_add(xl, "dport ");
> > +               break;
> > +       case XT_MULTIPORT_EITHER:
> > +               return 0;
> > +       }
> > +
> > +       if (multiinfo->invert)
> > +               xt_xlate_add(xl, "!= ");
> > +
> > +       if (multiinfo->count > 2 ||
> > +           (multiinfo->count > 1 && !multiinfo->pflags[0])) {
> > +               xt_xlate_add(xl, "{ ");
> > +               if (multiinfo->invert)
> > +                       return 0;
> > +       }
> > +
> 
> I fail to understand this return here
> 
> Other than that, the patch looks good.
>

It's only to return a non-translation available for the != {} thing
until is supported in nft.

