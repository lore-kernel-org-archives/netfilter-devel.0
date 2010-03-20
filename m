From: Jan Engelhardt <jengelh@medozas.de>
Subject: Re: [PATCH 7/9] netfilter: xtables: inclusion of xt_SYSRQ
Date: Sat, 20 Mar 2010 02:47:01 +0100 (CET)
Message-ID: <alpine.LSU.2.01.1003200245510.762@obet.zrqbmnf.qr>
References: <1268831945-6041-1-git-send-email-jengelh@medozas.de> <1268831945-6041-8-git-send-email-jengelh@medozas.de> <4BA0DF81.3030204@trash.net> <4BA0E321.2030400@oracle.com> <4BA0EA76.9070307@trash.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: John Haxby <john.haxby@oracle.com>, netfilter-devel@vger.kernel.org
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from borg.medozas.de ([188.40.89.202]:33027 "EHLO borg.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752432Ab0CTBrE (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 19 Mar 2010 21:47:04 -0400
In-Reply-To: <4BA0EA76.9070307@trash.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


On Wednesday 2010-03-17 15:43, Patrick McHardy wrote:
>> 
>> I'm happy to defend the security aspects of this module, if that's
>> what's concerning you.
>> 
>> I do know that there are quite a few people here who want to be able to
>> do remote sysrq -- they used to have a "crash trolley" consisting of a
>> PS/2 keyboard and a monitor.   Unfortunately most of their new machines
>> only have USB and you can't hotplug a USB keyboard in many of the
>> circumstances for which you want to (for example) trigger a crash.
>> 
>> I guess that also means I'm happy to produce valid use-cases.
>
>It seems useful to me, I'm mainly wondering whether there's a chance
>that we'll get kdboe support in the forseeable future, which would
>make this pretty much obsolete I guess.

Well once there's kdboe, we can reevaluate and delete it again.
Which brings me to the point: is kdboe even secured?
