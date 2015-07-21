From: Daniel Borkmann <daniel@iogearbox.net>
Subject: Re: [PATCH nf-next v2 3/3] netfilter: nf_conntrack: add efficient
 mark to zone mapping
Date: Tue, 21 Jul 2015 11:08:56 +0200
Message-ID: <55AE0C28.60702@iogearbox.net>
References: <cover.1436574843.git.daniel@iogearbox.net> <8b1e8907e8dd9a51f2e40b39cd5f5c2b0eae94fd.1436574843.git.daniel@iogearbox.net> <20150715175056.GA7436@salvia> <55A6BCD8.2010905@iogearbox.net> <55AD1F6F.1090607@iogearbox.net> <20150720170327.GA22681@salvia> <55AD2F75.7090607@iogearbox.net> <20150720182429.GA3572@salvia> <55AD547C.9000500@iogearbox.net> <20150721073724.GA3681@salvia>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Cc: tgraf@suug.ch, challa@noironetworks.com,
	netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from www62.your-server.de ([213.133.104.62]:52353 "EHLO
	www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753195AbbGUJJJ (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 21 Jul 2015 05:09:09 -0400
In-Reply-To: <20150721073724.GA3681@salvia>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On 07/21/2015 09:37 AM, Pablo Neira Ayuso wrote:
> On Mon, Jul 20, 2015 at 10:05:16PM +0200, Daniel Borkmann wrote:
>> On 07/20/2015 08:24 PM, Pablo Neira Ayuso wrote:
>> ...
>>> I see, thanks for explaining.
>>>
>>> I would like to avoid the use of the ct->status bit to set this. Can
>>> you see a clean way to store this bit in the zone extension instead?
>>
>> Okay, understood, i.e. since it's unfortunately exported through UAPI
>> and there's limited space. I'm thinking of renaming the u16 for the
>> direction in the zones structure into 'flags' and just add an indicator
>> there [as we still have unused bits there] ... would that seem better?
>
> Grab u8 for flags. u8 to store directions should be sufficient I'd
> suggest.

That's fine as well, will do.

> BTW, did you consider replacing NF_CT_DEFAULT_ZONE by a global object?
> It looks like a natural way in the patch that replaces the u16 by
> struct nf_conntrack_zone.

We still need the NF_CT_DEFAULT_ZONE itself, the ID I mean, in a couple
of places, but I'll look into having a global default struct and replace
it in these places that don't have zone support.

Thanks,
Daniel
