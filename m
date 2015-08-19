From: Daniel Borkmann <daniel@iogearbox.net>
Subject: Re: [PATCH nf-next v5 2/2] netfilter: nf_conntrack: add efficient
 mark to zone mapping
Date: Wed, 19 Aug 2015 17:10:57 +0200
Message-ID: <55D49C81.5080906@iogearbox.net>
References: <cover.1439559328.git.daniel@iogearbox.net> <bd41c7f8120e86cde496acc43feea600ad3537cb.1439559328.git.daniel@iogearbox.net> <20150818230556.GB17497@salvia>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Cc: tgraf@suug.ch, challa@noironetworks.com,
	netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from www62.your-server.de ([213.133.104.62]:41930 "EHLO
	www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751042AbbHSPLE (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 19 Aug 2015 11:11:04 -0400
In-Reply-To: <20150818230556.GB17497@salvia>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On 08/19/2015 01:05 AM, Pablo Neira Ayuso wrote:
...
> This change to nf_ct_zone_tmpl() is OK by now. I can see you're doing
> this because we cannot use the template object to perform tmpl->mark =
> skb->mark since the template is shared between all packets.
>
> However, this is showing the limitations that we have in iptables
> since we can't do mappings there, with nft we could do things in the
> near future that look like:
>
>          meta mark { 0x123 : ct template zone 1, ... }
>
> I think this can be refined by having a scratchpad template object
> per-cpu that we can modify from the CT target. This will also resolve
> the existing limitations that we have: Only the first rule that uses
> the CT target to attach a template actually applies, follow up rules
> trying to attach a template are simply ignored.
>
> This per-cpu template object should have a zone and timeout extension
> area preallocated, so we skip that memory allocation overhead from the
> packet path. Another alternative can be to add a struct nf_conn_tmpl
> object whose layout until the status flag is the same, so we can place
> the configuration there without the need of the extension areas, a
> trick similar to what we have with reqsock and twsock objects.
>
> Would you have a look into this so we can get this in better shape and
> resolve the existing limitations by the next merge window? Thanks!

Yes, I'll look into this and will get back to you. Btw, the remaining
two user space patches (conntrack, libnetfilter_conntrack) I'll post
next week when I'm back from Plumbers.

Thanks Pablo!

Best,
Daniel
