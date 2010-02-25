From: Jiri Pirko <jpirko@redhat.com>
Subject: Re: [question] ipt_CLUSTERIP and address length
Date: Thu, 25 Feb 2010 13:56:32 +0100
Message-ID: <20100225125631.GF2667@psychotron.lab.eng.brq.redhat.com>
References: <20100225101257.GC2667@psychotron.lab.eng.brq.redhat.com>
 <4B864F9A.90207@trash.net>
 <4B866A7F.7070205@netfilter.org>
 <alpine.LSU.2.01.1002251347580.11377@obet.zrqbmnf.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Pablo Neira Ayuso <pablo@netfilter.org>,
	Patrick McHardy <kaber@trash.net>,
	netfilter-devel@vger.kernel.org, netfilter@vger.kernel.org
To: Jan Engelhardt <jengelh@medozas.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:33170 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754884Ab0BYM4r (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 25 Feb 2010 07:56:47 -0500
Content-Disposition: inline
In-Reply-To: <alpine.LSU.2.01.1002251347580.11377@obet.zrqbmnf.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Thu, Feb 25, 2010 at 01:54:50PM CET, jengelh@medozas.de wrote:
>On Thursday 2010-02-25 13:18, Pablo Neira Ayuso wrote:
>>>>
>>>> I want to ask if there is any particular reason for ipt_CLUSTERIP to support
>>>> only address length of 6 (ETH_ALEN)? It seems to me reasonable for this to work
>>>> even with another types of network hw with different addr_len.
>>> 
>>> None that I'm aware of, but the length is also used in the ABI,
>>> so you presently can't supply larger addresses.
>>
>>Not directly related to this but I wanted to discuss this time ago. Now
>>that we have xt_CLUSTER I think that we can deprecate ipt_CLUSTERIP.
>
>xt_CLUSTER - where in the tree would that be?

I was trying to find it too. I guess it stands out of it (at least net-next).
