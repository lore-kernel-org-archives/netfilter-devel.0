From: Patrick McHardy <kaber@trash.net>
Subject: Re: [rfc] netfilter: copy less data to the user
Date: Thu, 15 Jul 2010 17:29:48 +0200
Message-ID: <4C3F296C.2090402@trash.net>
References: <20100714210430.GB5164@bicker> <4C3ED959.4080007@trash.net> <20100715101645.GB17585@bicker>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: ebtables-devel@lists.sourceforge.net,
	netfilter-devel@vger.kernel.org,
	Jan Engelhardt <jengelh@medozas.de>
To: Dan Carpenter <error27@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:47028 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933463Ab0GOP3y (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 15 Jul 2010 11:29:54 -0400
In-Reply-To: <20100715101645.GB17585@bicker>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Am 15.07.2010 12:16, schrieb Dan Carpenter:
> On Thu, Jul 15, 2010 at 11:48:09AM +0200, Patrick McHardy wrote:
>> Am 14.07.2010 23:04, schrieb Dan Carpenter:
>>> Smatch complains that we copy too much data to the user in ebtables.
>>> We copied EBT_FUNCTION_MAXNAMELEN (32) characters to the user here, but 
>>> "m->u.match->name" has XT_EXTENSION_MAXNAMELEN (29) characters.
>>>
>>> I'm not sure if this is a bug where someone got confused with m->u.name
>>> which has 32 characters or if this is done for backwards compatability.
>>
>> Looking at ebtables.h, ebt_entry_match->name uses
>> EBT_FUNCTION_MAXNAMELEN, which is 32 bytes. Where did you get
>> XT_EXTENSION_MAXNAMELEN from?
>>
> 
> Exactly.  ebt_entry_match->u.name uses EBT_FUNCTION_MAXNAMELEN but this is
> from ebt_entry_match->u.match->name which is type struct xt_match.

Right, I see.

> But it looks like we're exporting struct ebt_match which also uses
> EBT_FUNCTION_MAXNAMELEN.  So maybe the fix is to copy ->u.name instead
> of ->u.match->name.

That name is not valid within the kernel, the union contains the
xt_match pointer. So your patch seems correct, but we probably
also need to adjust ebtables userspace.

Jan?
