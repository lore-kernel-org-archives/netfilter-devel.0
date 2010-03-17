From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH 7/9] netfilter: xtables: inclusion of xt_SYSRQ
Date: Wed, 17 Mar 2010 15:43:02 +0100
Message-ID: <4BA0EA76.9070307@trash.net>
References: <1268831945-6041-1-git-send-email-jengelh@medozas.de> <1268831945-6041-8-git-send-email-jengelh@medozas.de> <4BA0DF81.3030204@trash.net> <4BA0E321.2030400@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: Jan Engelhardt <jengelh@medozas.de>,
	netfilter-devel@vger.kernel.org
To: John Haxby <john.haxby@oracle.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:59308 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754247Ab0CQOnF (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 17 Mar 2010 10:43:05 -0400
In-Reply-To: <4BA0E321.2030400@oracle.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

John Haxby wrote:
> On 17/03/10 13:56, Patrick McHardy wrote:
>> Jan Engelhardt wrote:
>>   
>>> The SYSRQ target will allow to remotely invoke sysrq on the local
>>> machine. Authentication is by means of a pre-shared key that can
>>> either be transmitted plaintext or digest-secured.
>>>      
>> Lets deal with the other modules first while I make up my mind.
>>    
> 
> 
> I'm happy to defend the security aspects of this module, if that's
> what's concerning you.
> 
> I do know that there are quite a few people here who want to be able to
> do remote sysrq -- they used to have a "crash trolley" consisting of a
> PS/2 keyboard and a monitor.   Unfortunately most of their new machines
> only have USB and you can't hotplug a USB keyboard in many of the
> circumstances for which you want to (for example) trigger a crash.
> 
> I guess that also means I'm happy to produce valid use-cases.

It seems useful to me, I'm mainly wondering whether there's a chance
that we'll get kdboe support in the forseeable future, which would
make this pretty much obsolete I guess.

I also want to wait a bit to see whether there are any comments from
other developers since I guess most haven't looked at this module so
far.
