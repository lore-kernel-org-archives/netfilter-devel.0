From: Jan Engelhardt <jengelh@medozas.de>
Subject: Re: [rfc] netfilter: copy less data to the user
Date: Sun, 25 Jul 2010 18:36:58 +0200 (CEST)
Message-ID: <alpine.LSU.2.01.1007251835190.14790@obet.zrqbmnf.qr>
References: <20100714210430.GB5164@bicker> <4C3ED959.4080007@trash.net> <20100715101645.GB17585@bicker> <4C3F296C.2090402@trash.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Dan Carpenter <error27@gmail.com>,
	ebtables-devel@lists.sourceforge.net,
	Netfilter Developer Mailing List
	<netfilter-devel@vger.kernel.org>
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from borg.medozas.de ([188.40.89.202]:41758 "EHLO borg.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751384Ab0GYQg7 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 25 Jul 2010 12:36:59 -0400
In-Reply-To: <4C3F296C.2090402@trash.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


On Thursday 2010-07-15 17:29, Patrick McHardy wrote:
>Am 15.07.2010 12:16, schrieb Dan Carpenter:
>> On Thu, Jul 15, 2010 at 11:48:09AM +0200, Patrick McHardy wrote:
>>> Am 14.07.2010 23:04, schrieb Dan Carpenter:
>>>> Smatch complains that we copy too much data to the user in ebtables.
>>>> We copied EBT_FUNCTION_MAXNAMELEN (32) characters to the user here, but 
>>>> "m->u.match->name" has XT_EXTENSION_MAXNAMELEN (29) characters.
>>>>
>>>> I'm not sure if this is a bug where someone got confused with m->u.name
>>>> which has 32 characters or if this is done for backwards compatability.
>>>
>>> Looking at ebtables.h, ebt_entry_match->name uses
>>> EBT_FUNCTION_MAXNAMELEN, which is 32 bytes. Where did you get
>>> XT_EXTENSION_MAXNAMELEN from?
>>>
>> 
>> Exactly.  ebt_entry_match->u.name uses EBT_FUNCTION_MAXNAMELEN but this is
>> from ebt_entry_match->u.match->name which is type struct xt_match.
>
>Right, I see.
>
>> But it looks like we're exporting struct ebt_match which also uses
>> EBT_FUNCTION_MAXNAMELEN.  So maybe the fix is to copy ->u.name instead
>> of ->u.match->name.
>
>That name is not valid within the kernel, the union contains the
>xt_match pointer. So your patch seems correct, but we probably
>also need to adjust ebtables userspace.
>
>Jan?

Hm this mail is not marked in my MUA as being answered, though I could 
swear I replied. Well again:

I'd say copy 29 chars from the name, and fill the rest with \0s.
