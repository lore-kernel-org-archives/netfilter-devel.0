From: Jan Engelhardt <jengelh@medozas.de>
Subject: Re: Alignment problem with ebt_among
Date: Wed, 10 Sep 2008 10:29:24 -0400 (EDT)
Message-ID: <alpine.LNX.1.10.0809101027500.24942@fbirervta.pbzchgretzou.qr>
References: <alpine.LNX.1.10.0809100931120.24942@fbirervta.pbzchgretzou.qr> <48C7D84A.2010703@trash.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Bart De Schuymer <bdschuym@pandora.be>,
	Netfilter Developer Mailing List
	<netfilter-devel@vger.kernel.org>,
	David Miller <davem@davemloft.net>
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:57884 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751078AbYIJO3Z (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 10 Sep 2008 10:29:25 -0400
In-Reply-To: <48C7D84A.2010703@trash.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


On Wednesday 2008-09-10 10:23, Patrick McHardy wrote:
> Jan Engelhardt wrote:
>> But due to continued lack of alignment of the entire thing (e.g. EBT_ALIGN(,
>> I cannot rule out that
>> alignment-sensitive architectures like sparc64 continue choke on it.
>> (Due to lack of such machines, I am unable to test)
>> 
>> What we would need is, IMO,
>> 
>>  new_size = old_size + EBT_ALIGN(ebt_mac_wormhash_size(wh);
>>  h = malloc(new_size);
>> 
>> but this of course breaks the binary interface between userspace and
>> kernel. Possible solutions I can think of:
>> 
>>  (a) kill ebt_among
>>  (b) willingly change it and break ABI
>>  (c) continue planned transformation to Xtables and fix later
>> 
>> Which should it be?
>
> How about:
>
> (d) add compat support to ebtables, transform to xtables,
>    add compat translation

That's the same as (c) for me ;-)
except that the order is slightly different -- I think the patches
would also be smaller if we went for Xtables first, because its
structs at least already have the compat members, for example.
