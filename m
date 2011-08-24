From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH] netfilter: better wording for table-full message
Date: Wed, 24 Aug 2011 09:28:55 +0200
Message-ID: <4E54A837.1010305@trash.net>
References: <alpine.LNX.2.01.1108231507040.24849@frira.zrqbmnf.qr> <20110823132503.GE25003@Chamillionaire.breakpoint.cc>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: Jan Engelhardt <jengelh@medozas.de>, hawk@diku.dk,
	Netfilter Developer Mailing List
	<netfilter-devel@vger.kernel.org>
To: Florian Westphal <fw@strlen.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:40169 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750952Ab1HXH24 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 24 Aug 2011 03:28:56 -0400
In-Reply-To: <20110823132503.GE25003@Chamillionaire.breakpoint.cc>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Am 23.08.2011 15:25, schrieb Florian Westphal:
> Jan Engelhardt <jengelh@medozas.de> wrote:
>> parent ad146381889371c2d1b89b27d9dc70ae257fc1c8 (v3.1-rc2-2-gad14638)
>> commit 51b33b93d4c2e6c63afb177158f660fd17daf47c
>> Author: Jan Engelhardt <jengelh@medozas.de>
>> Date:   Tue Aug 23 15:07:00 2011 +0200
>>
>> netfilter: better wording for table-full message
>> -				       "nf_conntrack: table full, dropping"
>> -				       " packet.\n");
>> +				       "nf_conntrack: table full, no new "
>> +				       "CT created, packet will have "
>> +				       "classification INVALID.\n");
> 
> packets seem to be dropped after all; call chain is:
> 
> nf_conntrack_in -> resolve_normal_ct -> init_conntrack -> __nf_conntrack_alloc.
> 
> AFAICS, the -ENOMEM is propagated back to nf_conntrack_in, where ret
> will be set to NF_DROP.

Right, I was following the !ct path.

> The important point is resolve_normal_ct() return value;
> on NULL the packet would be untracked.
