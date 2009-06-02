From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [RFD,patch] ICMP echo conntrack timeout
Date: Tue, 02 Jun 2009 16:53:57 +0200
Message-ID: <4A253D05.3080409@netfilter.org>
References: <20090601174352.GH31797@fi.muni.cz> <4A251127.8000605@netfilter.org> <4A251FBB.8060804@trash.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: Jan Kasprzak <kas@fi.muni.cz>, netfilter-devel@vger.kernel.org
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:59594 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752168AbZFBO5t (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 2 Jun 2009 10:57:49 -0400
In-Reply-To: <4A251FBB.8060804@trash.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Patrick McHardy wrote:
> Pablo Neira Ayuso wrote:
>>>     I think it would be better to keep the default timeout of
>>> nf_ct_icmp_timeout even after the echo reply is received. Feel free
>>> to correct me why early deleting of ICMP conntrack entries is needed,
>>> or consider applying the following patch.
>>
>> The only problem that I see is that you patch relaxes the current
>> checking that we're doing. I mean, for every packet in one direction we
>> only accept one ICMP reply packet. With your patch, we can accept more
>> than one packet in the reply direction.
> 
> Thats the intention, isn't it? :) I don't see a problem with this,
> conntrack is supposed to accept valid responses and I don't think
> its unreasonable to consider duplicate echo-replies as valid.

I only wanted to point with this patch we're doing more relaxed ICMP
tracking, but I'm fine with this.

BTW, with this patch, we can add state synchronization in conntrackd for
ICMP (some bits are still missing to support this). This is something
that I don't particularly find very useful, but some people have
requested this.

-- 
"Los honestos son inadaptados sociales" -- Les Luthiers
