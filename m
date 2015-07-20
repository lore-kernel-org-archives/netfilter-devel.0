From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH nf-next v2 3/3] netfilter: nf_conntrack: add efficient
 mark to zone mapping
Date: Mon, 20 Jul 2015 20:24:30 +0200
Message-ID: <20150720182429.GA3572@salvia>
References: <cover.1436574843.git.daniel@iogearbox.net>
 <8b1e8907e8dd9a51f2e40b39cd5f5c2b0eae94fd.1436574843.git.daniel@iogearbox.net>
 <20150715175056.GA7436@salvia>
 <55A6BCD8.2010905@iogearbox.net>
 <55AD1F6F.1090607@iogearbox.net>
 <20150720170327.GA22681@salvia>
 <55AD2F75.7090607@iogearbox.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: tgraf@suug.ch, challa@noironetworks.com,
	netfilter-devel@vger.kernel.org
To: Daniel Borkmann <daniel@iogearbox.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:40324 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752193AbbGTSSu (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 20 Jul 2015 14:18:50 -0400
Content-Disposition: inline
In-Reply-To: <55AD2F75.7090607@iogearbox.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Mon, Jul 20, 2015 at 07:27:17PM +0200, Daniel Borkmann wrote:
> On 07/20/2015 07:03 PM, Pablo Neira Ayuso wrote:
> >On Mon, Jul 20, 2015 at 06:18:55PM +0200, Daniel Borkmann wrote:
> >[...]
> >>The current approach implemented here that I found so far most appealing
> >>and having the least complexity, was to just have a /single/ template and to
> >>overwrite the zone->id with skb->mark on the ptr we have sitting on the stack.
> >>It avoids all the issues mentioned. But perhaps you mean something entirely
> >>different and I just seem to misinterpret your answer, hmm.
> >
> >You mean something that from command line would look like:
> >
> >         iptables -A PREROUTING -t raw -j CT --zone mark
> >
> >So we set the zone ID in the CT target based on the existing mark,
> >right?
> 
> Not in the target callback, in the example script and patches I've provided,
> I'm indeed configuring ...
> 
>   iptables -t raw -A PREROUTING -j CT --zone mark --zone-dir ORIGINAL
> 
> ... which in nf_ct_zone_tmpl() call-sites will return the skb->mark mapped
> zone ID, that is then used f.e. directly for the lookup in the hash table
> resp. following ct entry allocation in case a lookup didn't return a ct entry.

I see, thanks for explaining.

I would like to avoid the use of the ct->status bit to set this. Can
you see a clean way to store this bit in the zone extension instead?
