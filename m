From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [libnftnl PATCH 2/5] src: set: Do not print unset values in xml
Date: Wed, 11 Jun 2014 19:49:01 +0200
Message-ID: <20140611174901.GA17843@localhost>
References: <1402501851-22208-1-git-send-email-anarey@gmail.com>
 <1402501851-22208-4-git-send-email-anarey@gmail.com>
 <CAOkSjBjU6X1nZ1QY7TK08Ft22pZdSEQHmrrVxPWYCbUQuC+qrg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Ana Rey <anarey@gmail.com>,
	Netfilter Development Mailing list
	<netfilter-devel@vger.kernel.org>
To: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:56944 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751633AbaFKRtJ (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 11 Jun 2014 13:49:09 -0400
Content-Disposition: inline
In-Reply-To: <CAOkSjBjU6X1nZ1QY7TK08Ft22pZdSEQHmrrVxPWYCbUQuC+qrg@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Wed, Jun 11, 2014 at 06:14:40PM +0200, Arturo Borrero Gonzalez wrote:
> Hi Ana,
> 
> a small thing below,
> 
> On 11 June 2014 17:50, Ana Rey <anarey@gmail.com> wrote:
> [...]
> > @@ -563,17 +560,26 @@ static int nft_set_elem_snprintf_xml(char *buf, size_t size,
> >  {
> >         int ret, len = size, offset = 0, type = DATA_NONE;
> >
> > -       ret = snprintf(buf, size, "<set_elem>"
> > -                               "<flags>%u</flags><key>",
> > -                               e->set_elem_flags);
> > +       ret = snprintf(buf, size, "<set_elem>");
> >         SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
> >
> > -       ret = nft_data_reg_snprintf(buf+offset, len, &e->key,
> > -                                   NFT_OUTPUT_XML, flags, DATA_VALUE);
> > -       SNPRINTF_BUFFER_SIZE(ret, size, len, offset);
> > +       if (e->flags & (1 << NFT_SET_ELEM_ATTR_FLAGS)) {
> > +               ret = snprintf(buf, size, "<flags>%u</flags>",
> > +                              e->set_elem_flags);
> 
> I think this snprintf call may overwrite the buffer, so you should use
> snprintf(buf+offset, len, ...)

Thanks for reviewing Arturo.

I have fixed this here and applied.
