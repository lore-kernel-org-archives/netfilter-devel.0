From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCHv3 2/5] Adds AF_BRIDGE and ARP header interpreter to  
    BASE plugin
Date: Thu, 14 Feb 2008 16:23:59 +0100
Message-ID: <47B45D0F.8070008@netfilter.org>
References: <20080211220753.796791654@endian.com>    <20080211221056.242019648@endian.com> <47B377A2.6080309@endian.com> <4279.80.214.249.17.1202974766.squirrel@mail.inl.fr> <47B42760.5080603@endian.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: Eric Leblond <eric@inl.fr>, netfilter-devel@vger.kernel.org
To: Peter Warasin <peter@endian.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:33690 "EHLO us.es"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754271AbYBNPYK (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 14 Feb 2008 10:24:10 -0500
In-Reply-To: <47B42760.5080603@endian.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Peter Warasin wrote:
> Eric Leblond wrote:
>> I did not drink cofee this morning, and thus I may be wrong, but it seems
>> you've sent the same patch as yesterday. KEY_ARP_SPA is still of type RAW
>> for example. The other patch seems also unchanged.
>>   
> 
> Oh my. I think it was to late yesterday. Took the
> wrong directory :/
> 
> Here is the correct patch attached.
> I hope so, did not drink coffee either :)

Hm, I get this warnings with your patch:

ulogd_raw2packet_BASE.c: In function '_interp_arp':
ulogd_raw2packet_BASE.c:899: warning: assignment makes integer from
pointer without a cast
ulogd_raw2packet_BASE.c:904: warning: assignment makes integer from
pointer without a cast

> +	ret[KEY_ARP_SHA].u.value.ptr = &arph->arp_sha;
> +	SET_VALID(ret[KEY_ARP_SHA]);
> +	ret[KEY_ARP_SPA].u.value.ui32 = &arph->arp_spa;
> +	SET_VALID(ret[KEY_ARP_SPA]);
> +
> +	ret[KEY_ARP_THA].u.value.ptr = &arph->arp_tha;
> +	SET_VALID(ret[KEY_ARP_THA]);
> +	ret[KEY_ARP_TPA].u.value.ui32 = &arph->arp_tpa;
> +	SET_VALID(ret[KEY_ARP_TPA]);

Now arp_spa and arp_tpa use ptr instead of ui32. Please, clarify.

-- 
"Los honestos son inadaptados sociales" -- Les Luthiers
