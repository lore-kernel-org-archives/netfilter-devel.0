From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [libnftables PATCH 2/2] Basic support for printing nft_data_reg
 in XML format.
Date: Thu, 4 Apr 2013 14:33:30 +0200
Message-ID: <20130404123330.GA6069@localhost>
References: <20130329153155.30122.21803.stgit@nfdev.cica.es>
 <20130329153432.30122.86772.stgit@nfdev.cica.es>
 <20130402114123.GC9973@localhost>
 <CAOkSjBjM57H+XAX7h5YFOPcfF_Hj3H_vfnMpBg6tnQVTee1CKA@mail.gmail.com>
 <20130402193229.GA16053@localhost>
 <CAOkSjBhNJAfa18_W8deetS=97X18H-5W=Z5n1a8txYm3WOzEjw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:35118 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758745Ab3DDMdl (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 4 Apr 2013 08:33:41 -0400
Content-Disposition: inline
In-Reply-To: <CAOkSjBhNJAfa18_W8deetS=97X18H-5W=Z5n1a8txYm3WOzEjw@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Wed, Apr 03, 2013 at 02:38:38PM +0200, Arturo Borrero Gonzalez wrote:
> 2013/4/2 Pablo Neira Ayuso <pablo@netfilter.org>:
> > On Tue, Apr 02, 2013 at 07:18:39PM +0200, Arturo Borrero Gonzalez wrote:
> >> If cmp and bitwise are going to always have DATA_VALUE, and imm
> >> depending on what was set, I think we could do:
> >>
> >> int nft_data_reg_snprintf(char *buf, union data_reg *data, int type, ...)
> >> switch(type)
> >> return nft_data_reg_snprintf_'type'(buf, data, ...)
> >
> > where 'type' can be: value, verdict or chain.
> >
> >> And the same applies when parsing XML.
> >
> > Exactly.
> 
> I propose to use this format:
> 
> for DATA_VALUE:
> 
> <expr type=cmp>
>    [...]
>    <cmpdata>
>      <data_reg type=value>
>       <len>N</len>
>       <data0>reg->val[i]</data0>
>        [...]
>        <dataN>reg->val[n]</dataN>
>     </data_reg>
>   </cmpdata>
> </expr>
> 
> This way we also export/import the len of reg->val (actually reg->len)
> 
> For DATA_VERDICT or DATA_CHAIN:
> <data_reg type=verdict>
>     <verdict>int</verdict>
>     <chain>string</chain>
> </data_reg>
> 
> assuming verdict and chain are always used together, despite of node
> '<verdict>' or '<chain>' being not set (but present with no value)
>
> For DATA_VERDICT or DATA_CHAIN:
> <data_reg type=verdict>
>     <verdict>int</verdict>
>     <chain>string</chain>
> </data_reg> 

The verdict and the chain are mutually exclusive. So it has to be:

* For DATA_VERDICT:

<data_reg type=verdict>
    <verdict>string</verdict>
</data_reg>

where string can be accept, drop, return. Better use the string than
the value, it's human readable and people can edit it without knowing
the mapping between values and verdicts.

* For DATA_CHAIN:

<data_reg type=verdict>
    <chain>string</chain>
</data_reg>

where string is the chain name. This chain is the chain to jump in
case of matching (like in iptables: -j some_chain).

Regards.
