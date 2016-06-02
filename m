From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH v3] extensions: libxt_multiport: Add translation to nft
Date: Thu, 2 Jun 2016 12:52:02 +0200
Message-ID: <20160602105202.GB2720@salvia>
References: <20160531182607.GA17802@sonyv>
 <CAOkSjBiGUCk83+Muwc6naTUJXTXgK7s0Bi+fvcCB6=WW50dxQQ@mail.gmail.com>
 <20160601201614.GA24726@sonyv>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>,
	Netfilter Development Mailing list
	<netfilter-devel@vger.kernel.org>
To: Laura Garcia <nevola@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:59328 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751833AbcFBKwJ (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 2 Jun 2016 06:52:09 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
	by mail.us.es (Postfix) with ESMTP id C81DA2CC3EC
	for <netfilter-devel@vger.kernel.org>; Thu,  2 Jun 2016 12:52:06 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id B980A1B32C4
	for <netfilter-devel@vger.kernel.org>; Thu,  2 Jun 2016 12:52:06 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id 729331B32D3
	for <netfilter-devel@vger.kernel.org>; Thu,  2 Jun 2016 12:52:03 +0200 (CEST)
Content-Disposition: inline
In-Reply-To: <20160601201614.GA24726@sonyv>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Wed, Jun 01, 2016 at 10:16:18PM +0200, Laura Garcia wrote:
> On Wed, Jun 01, 2016 at 04:43:45PM +0200, Arturo Borrero Gonzalez wrote:
> > On 31 May 2016 at 20:26, Laura Garcia Liebana <nevola@gmail.com> wrote:
> > > +static int __multiport_xlate_v1(const void *ip,
> > > +                               const struct xt_entry_match *match,
> > > +                               struct xt_xlate *xl, int numeric)
> > > +{
> > > +       const struct xt_multiport_v1 *multiinfo
> > > +               = (const struct xt_multiport_v1 *)match->data;
> > > +       unsigned int i;
> > > +
> > > +       switch (multiinfo->flags) {
> > > +       case XT_MULTIPORT_SOURCE:
> > > +               xt_xlate_add(xl, "sport ");
> > > +               break;
> > > +       case XT_MULTIPORT_DESTINATION:
> > > +               xt_xlate_add(xl, "dport ");
> > > +               break;
> > > +       case XT_MULTIPORT_EITHER:
> > > +               return 0;
> > > +       }
> > > +
> > > +       if (multiinfo->invert)
> > > +               xt_xlate_add(xl, "!= ");
> > > +
> > > +       if (multiinfo->count > 2 ||
> > > +           (multiinfo->count > 1 && !multiinfo->pflags[0])) {
> > > +               xt_xlate_add(xl, "{ ");
> > > +               if (multiinfo->invert)
> > > +                       return 0;
> > > +       }
> > > +
> > 
> > I fail to understand this return here
> > 
> > Other than that, the patch looks good.
> >
> 
> It's only to return a non-translation available for the != {} thing
> until is supported in nft.

I'd suggest you provide this already given that we'll soon have
support for this in nft.

Thanks.
