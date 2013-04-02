From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [libnftables PATCH 2/2] Basic support for printing nft_data_reg
 in XML format.
Date: Tue, 2 Apr 2013 21:32:29 +0200
Message-ID: <20130402193229.GA16053@localhost>
References: <20130329153155.30122.21803.stgit@nfdev.cica.es>
 <20130329153432.30122.86772.stgit@nfdev.cica.es>
 <20130402114123.GC9973@localhost>
 <CAOkSjBjM57H+XAX7h5YFOPcfF_Hj3H_vfnMpBg6tnQVTee1CKA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:45748 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761551Ab3DBTcj (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 2 Apr 2013 15:32:39 -0400
Content-Disposition: inline
In-Reply-To: <CAOkSjBjM57H+XAX7h5YFOPcfF_Hj3H_vfnMpBg6tnQVTee1CKA@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Tue, Apr 02, 2013 at 07:18:39PM +0200, Arturo Borrero Gonzalez wrote:
> 2013/4/2 Pablo Neira Ayuso <pablo@netfilter.org>:
> > I think we need something similar to:
> >
> > int nft_parse_data(union nft_data_reg *data, struct nlattr *attr, int *type);
> >
> > We should pass a 'type' that indicates:
> >
> >         DATA_VALUE,
> >         DATA_VERDICT,
> >         DATA_CHAIN,
> >
> > So you know if you have print what the data_reg contains.
> >
> 
> If cmp and bitwise are going to always have DATA_VALUE, and imm
> depending on what was set, I think we could do:
> 
> int nft_data_reg_snprintf(char *buf, union data_reg *data, int type, ...)
> switch(type)
> return nft_data_reg_snprintf_'type'(buf, data, ...)

where 'type' can be: value, verdict or chain.

> And the same applies when parsing XML.

Exactly.
