From: Patrick McHardy <kaber@trash.net>
Subject: Re: [0/5] xtables: phase out case sensitivity
Date: Wed, 19 Jan 2011 20:54:13 +0100
Message-ID: <4D374165.7020504@trash.net>
References: <alpine.LNX.2.01.1101181628540.15366@obet.zrqbmnf.qr> <4D35BCC7.90805@trash.net> <alpine.LNX.2.01.1101181738390.16142@obet.zrqbmnf.qr> <4D370F56.5060901@trash.net> <alpine.LNX.2.01.1101192023290.19837@obet.zrqbmnf.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: Netfilter Developer Mailing List
	<netfilter-devel@vger.kernel.org>,
	Aaron Wright <wright_left@yahoo.com>,
	Jon Masters <jcm@jonmasters.org>
To: Jan Engelhardt <jengelh@medozas.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:52748 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753219Ab1ASTyT (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 19 Jan 2011 14:54:19 -0500
In-Reply-To: <alpine.LNX.2.01.1101192023290.19837@obet.zrqbmnf.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Am 19.01.2011 20:44, schrieb Jan Engelhardt:
> 
> On Wednesday 2011-01-19 17:20, Patrick McHardy wrote:
>>>
>>> As a resident contributor, I stand behind the changes. In the unlikely 
>>> even that it breaks, I see it as duty to fix it. The churn is on me 
>>> already practically.
>>
>> It's quite likely that something breaks. Module aliases only work for
>> loading modules, not for unloading them. So there's a big chance that
>> some scripts will break.
> 
> Scripts can not rely on that being successful: Xtables modules may
> pull in other modules, including using things like nf_ct_get_l3proto
> which do not leave a trace in `lsmod` output. So rmmodding of xt
> modules can fail _even_ in the present situation. Not to mention that
> scripts currently have to battle the mulitple prefixes that are in
> use (which the patchset addresses in part).

Pulling in other modules though things like nf_ct_get_l3proto()
is not a problem, you just have to flush the tables before trying
to rmmod. This works well and I've seen plenty of scripts doing
exactly that.

> Since modinfo not following aliases has bothered myself for some time 
> now, I should probably just add that to m-i-t modinfo as an option and, 
> while at it, rmmod.

Sure, that sounds fine to me, though it should probably follow
aliases by default instead of as an option if you want to
preserve compatiblity when renaming things.
