From: Jan Engelhardt <jengelh@inai.de>
Subject: Re: [PATCH -next 3/4] netfilter: xtables: don't save/restore jumpstack
 offset
Date: Thu, 9 Jul 2015 10:16:29 +0200 (CEST)
Message-ID: <alpine.LSU.2.20.1507091014200.28956@nerf40.vanv.qr>
References: <1436390139-4405-1-git-send-email-fw@strlen.de> <1436390139-4405-4-git-send-email-fw@strlen.de> <alpine.LSU.2.20.1507082344210.16936@nerf40.vanv.qr> <20150709002955.GJ16864@breakpoint.cc>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Cc: netfilter-devel@vger.kernel.org, eric.dumazet@gmail.com
To: Florian Westphal <fw@strlen.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from ares41.inai.de ([46.4.122.207]:46110 "EHLO ares41.inai.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752283AbbGIIQb (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 9 Jul 2015 04:16:31 -0400
In-Reply-To: <20150709002955.GJ16864@breakpoint.cc>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Thursday 2015-07-09 02:29, Florian Westphal wrote:

>Jan Engelhardt <jengelh@inai.de> wrote:
>> On Wednesday 2015-07-08 23:15, Florian Westphal wrote:
>> 
>> >The jump stack overflow tests are no longer needed as well -- since 
>> >->stacksize is the largest call depth we cannot exceed it.
>> 
>> The tests were once added for the rare case that a cloned packet hits 
>> another TEE. Can we be sure they are no longer needed?
>
>If a TEE'd skb hits another TEE target there is no reentry since the
>tee_active percpu indicator is true.

Ah. I don't remember having written the "tee_active" code, but 
apparently I did some years ago.
