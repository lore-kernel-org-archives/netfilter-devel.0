From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [libnftables PATCH 11/13] expr: payload: add nft_str2base
 function
Date: Fri, 9 Aug 2013 13:43:47 +0200
Message-ID: <20130809114347.GA21458@localhost>
References: <20130809111148.29819.95689.stgit@Ph0enix>
 <20130809111415.29819.19869.stgit@Ph0enix>
 <CAOkSjBhD94HpSmHmNLtpbeKrjygKu9zg5eeQHnWZ=LPrMBF=ZQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Alvaro Neira <alvaroneay@gmail.com>,
	Netfilter Development Mailing list
	<netfilter-devel@vger.kernel.org>, Eric Leblond <eric@regit.org>
To: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:37061 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934248Ab3HILn5 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 9 Aug 2013 07:43:57 -0400
Content-Disposition: inline
In-Reply-To: <CAOkSjBhD94HpSmHmNLtpbeKrjygKu9zg5eeQHnWZ=LPrMBF=ZQ@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Fri, Aug 09, 2013 at 01:31:35PM +0200, Arturo Borrero Gonzalez wrote:
> >         if (base_str == NULL)
> >                 return -1;
> >
> > -       if (strcmp(base_str, "link") == 0)
> > -               payload->base = NFT_PAYLOAD_LL_HEADER;
> > -       else if (strcmp(base_str, "network") == 0)
> > -               payload->base = NFT_PAYLOAD_NETWORK_HEADER;
> > -       else if (strcmp(base_str, "transport") == 0)
> > -               payload->base = NFT_PAYLOAD_TRANSPORT_HEADER;
> > -       else
> > -               goto err;
> > +       base = nft_str2base(base_str);
> > +
> > +       if (base < 0)
> > +               return -1;
> 
> I think we need this:
> 
> payload->base = base;

Good catch, I'm going to manually fix this. Thanks for reviewing.

> Also, maybe goto err in case of base < 0

errno is already set from the new function.
