From: Jan Engelhardt <jengelh@medozas.de>
Subject: Re: [PATCH v0] netns NOTRACK
Date: Fri, 12 Feb 2010 13:36:05 +0100 (CET)
Message-ID: <alpine.LSU.2.01.1002121331370.29248@obet.zrqbmnf.qr>
References: <20100211173117.GD4099@x200> <4B744565.2010808@trash.net>  <alpine.LSU.2.01.1002111903100.19618@obet.zrqbmnf.qr> <b6fcc0a1002120424o17b278dqf0da86666bda7e62@mail.gmail.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Patrick McHardy <kaber@trash.net>, netfilter-devel@vger.kernel.org
To: Alexey Dobriyan <adobriyan@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from borg.medozas.de ([188.40.89.202]:54324 "EHLO borg.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751837Ab0BLMgI (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 12 Feb 2010 07:36:08 -0500
In-Reply-To: <b6fcc0a1002120424o17b278dqf0da86666bda7e62@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Friday 2010-02-12 13:24, Alexey Dobriyan wrote:

>On Thu, Feb 11, 2010 at 8:04 PM, Jan Engelhardt <jengelh@medozas.de> wrote:
>> On Thursday 2010-02-11 18:59, Patrick McHardy wrote:
>>>Alexey Dobriyan wrote:
>>>> This is netns NOTRACK fix we discussed earlier.
>>>>
>>>> The idea was to remove nf_conntrack_untracked and
>>>> declare that ->nfct=NULL and ->nfctinfo=IP_CT_UNTRACKED are untracked
>>>> connections.
>>
>> As invalid connections used nfct=NULL, how are they now
>> checked for?
>
>Sorry? if ->nfct == NULL && ->nfctinfo == IP_CT_UNTRACKED,
>then untracked, otherwise invalid.
>Additional checks were inserted where necesary.

I was under the impression that (before your commit), when ->nfct is 
NULL, then ->nfctinfo is undefined, but in fact, net/core/skbuff.c 
explicitly zeroes it, so invalid conncetions will have 
nfctinfo==IP_CT_ESTABLISHED in practice.

