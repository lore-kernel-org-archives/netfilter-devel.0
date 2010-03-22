From: John Haxby <john.haxby@oracle.com>
Subject: Re: [PATCH 7/9] netfilter: xtables: inclusion of xt_SYSRQ
Date: Mon, 22 Mar 2010 15:14:45 +0000
Message-ID: <4BA78965.5060701@oracle.com>
References: <1268831945-6041-1-git-send-email-jengelh@medozas.de> <1268831945-6041-8-git-send-email-jengelh@medozas.de> <4BA0DF81.3030204@trash.net> <4BA0E321.2030400@oracle.com> <4BA0EA76.9070307@trash.net> <alpine.LSU.2.01.1003200245510.762@obet.zrqbmnf.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Patrick McHardy <kaber@trash.net>, netfilter-devel@vger.kernel.org
To: Jan Engelhardt <jengelh@medozas.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from acsinet11.oracle.com ([141.146.126.233]:36714 "EHLO
	acsinet11.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752021Ab0CVPQZ (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 22 Mar 2010 11:16:25 -0400
In-Reply-To: <alpine.LSU.2.01.1003200245510.762@obet.zrqbmnf.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On 20/03/10 01:47, Jan Engelhardt wrote:
> On Wednesday 2010-03-17 15:43, Patrick McHardy wrote:
>    
>> It seems useful to me, I'm mainly wondering whether there's a chance
>> that we'll get kdboe support in the forseeable future, which would
>> make this pretty much obsolete I guess.
>>      
> Well once there's kdboe, we can reevaluate and delete it again.
> Which brings me to the point: is kdboe even secured?
>    


And does it have the useful low-overhead that xt_SYSRQ has which means 
it works even when the rest of the system is in deep trouble?

(I can't find kbdoe, google has let me down.)

jch
