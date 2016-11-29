From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH nft v3 2/2] datatype: Implement binary search in
 symbolic_constant_print()
Date: Tue, 29 Nov 2016 09:35:48 +0100
Message-ID: <20161129083548.GA973@salvia>
References: <20161128202312.GA8763@lennorien.com>
 <20161128221223.GB9858@breakpoint.cc>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Elise Lennion <elise.lennion@gmail.com>,
        netfilter-devel@vger.kernel.org
To: Florian Westphal <fw@strlen.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:32798 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753935AbcK2Ify (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 29 Nov 2016 03:35:54 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 57C21C1060
        for <netfilter-devel@vger.kernel.org>; Tue, 29 Nov 2016 09:35:51 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 46C13DA80B
        for <netfilter-devel@vger.kernel.org>; Tue, 29 Nov 2016 09:35:51 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 467D3DA814
        for <netfilter-devel@vger.kernel.org>; Tue, 29 Nov 2016 09:35:49 +0100 (CET)
Content-Disposition: inline
In-Reply-To: <20161128221223.GB9858@breakpoint.cc>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Mon, Nov 28, 2016 at 11:12:23PM +0100, Florian Westphal wrote:
> Elise Lennion <elise.lennion@gmail.com> wrote:
> > Because a linear search is used, which is slower.
> > 
> > This approach demands that the symbol_table have a variable with its
> > size, also, it must be sorted by value.
> 
> Did Pablo put you up to this?  Bad Pablo, bad!  :-P

Yep, Elise don't feel bad, that's my fault ;-)

> because:
> 
> >  static const struct symbol_table ethertype_tbl = {
> > +	.size 		= 4,
> >  	.symbols	= {
> >  		SYMBOL("ip",		__constant_htons(ETH_P_IP)),
> > +		SYMBOL("vlan",		__constant_htons(ETH_P_8021Q)),
> >  		SYMBOL("arp",		__constant_htons(ETH_P_ARP)),
> >  		SYMBOL("ip6",		__constant_htons(ETH_P_IPV6)),
> > -		SYMBOL("vlan",		__constant_htons(ETH_P_8021Q)),
> >  		SYMBOL_LIST_END
> >  	},
> 
> This is unmaintanable.  I have no clue what value ETH_P_8021Q is, and that
> this has to be placed at spot #2 to not break things.

OK, let's try to make this a bit more maintainable, another proposal
in steps:

1) Update symbol_table definition to:

struct symbol_table {
        unsignd int                     size;
        const struct symbolic_constant  *symbols; <---
};

so we don't have a flexible array anymore. Then, split this array of
symbols from struct symbol_table so this looks like:

static cont struct symbolic_constant ethertype_symbols[] = {
 		SYMBOL("ip",		__constant_htons(ETH_P_IP)),
		SYMBOL("vlan",		__constant_htons(ETH_P_8021Q)),
 		SYMBOL("arp",		__constant_htons(ETH_P_ARP)),
  		SYMBOL("ip6",		__constant_htons(ETH_P_IPV6)),
  		SYMBOL_LIST_END
};

static const struct symbol_table ethertype_tbl = {
        .size                   = SYMTBL_SIZE(ethertype_symbols),
        .symbolic_constant      = ethertype_symbols,
};

I can see 19 symbol_tables from here at quick glace, so this would be
an initial patch to update this. SYMTBL_SIZE needs to be define too, yes.

2) Then, second patch would look like:

struct symbol_table {
        unsignd int                     size;
        bool                            qsort; <---
        const struct symbolic_constant  *symbols;
};

If qsort field if true, then we can just validate when calling
datatype_register() that the array is not sorted and spot a BUG().
Moreover, the new qsort field would restrict this qsort to the large
inet_service symbol table.

Florian, are you OK if Elise follows this approach? If this is overly
complicated and not worth, rise your hand.
