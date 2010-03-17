From: John Haxby <john.haxby@oracle.com>
Subject: Re: [PATCH 7/9] netfilter: xtables: inclusion of xt_SYSRQ
Date: Wed, 17 Mar 2010 14:11:45 +0000
Message-ID: <4BA0E321.2030400@oracle.com>
References: <1268831945-6041-1-git-send-email-jengelh@medozas.de> <1268831945-6041-8-git-send-email-jengelh@medozas.de> <4BA0DF81.3030204@trash.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Jan Engelhardt <jengelh@medozas.de>,
	netfilter-devel@vger.kernel.org
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from acsinet12.oracle.com ([141.146.126.234]:58895 "EHLO
	acsinet12.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752356Ab0CQONc (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 17 Mar 2010 10:13:32 -0400
In-Reply-To: <4BA0DF81.3030204@trash.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On 17/03/10 13:56, Patrick McHardy wrote:
> Jan Engelhardt wrote:
>    
>> The SYSRQ target will allow to remotely invoke sysrq on the local
>> machine. Authentication is by means of a pre-shared key that can
>> either be transmitted plaintext or digest-secured.
>>      
> Lets deal with the other modules first while I make up my mind.
>    


I'm happy to defend the security aspects of this module, if that's 
what's concerning you.

I do know that there are quite a few people here who want to be able to 
do remote sysrq -- they used to have a "crash trolley" consisting of a 
PS/2 keyboard and a monitor.   Unfortunately most of their new machines 
only have USB and you can't hotplug a USB keyboard in many of the 
circumstances for which you want to (for example) trigger a crash.

I guess that also means I'm happy to produce valid use-cases.

jch
