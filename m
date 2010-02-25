From: Jan Engelhardt <jengelh@medozas.de>
Subject: Re: [question] ipt_CLUSTERIP and address length
Date: Thu, 25 Feb 2010 13:57:02 +0100 (CET)
Message-ID: <alpine.LSU.2.01.1002251355510.11377@obet.zrqbmnf.qr>
References: <20100225101257.GC2667@psychotron.lab.eng.brq.redhat.com> <4B864F9A.90207@trash.net> <4B866A7F.7070205@netfilter.org> <alpine.LSU.2.01.1002251347580.11377@obet.zrqbmnf.qr>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Patrick McHardy <kaber@trash.net>, Jiri Pirko <jpirko@redhat.com>,
	netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
	netfilter@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from borg.medozas.de ([188.40.89.202]:58817 "EHLO borg.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932397Ab0BYM5E (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 25 Feb 2010 07:57:04 -0500
In-Reply-To: <alpine.LSU.2.01.1002251347580.11377@obet.zrqbmnf.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Thursday 2010-02-25 13:54, Jan Engelhardt wrote:

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

Oh nevermind, it's xt_cluster actually.
