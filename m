From: Patrick McHardy <kaber@trash.net>
Subject: Re: [0/5] xtables: phase out case sensitivity
Date: Wed, 19 Jan 2011 17:20:38 +0100
Message-ID: <4D370F56.5060901@trash.net>
References: <alpine.LNX.2.01.1101181628540.15366@obet.zrqbmnf.qr> <4D35BCC7.90805@trash.net> <alpine.LNX.2.01.1101181738390.16142@obet.zrqbmnf.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: Netfilter Developer Mailing List
	<netfilter-devel@vger.kernel.org>,
	Aaron Wright <wright_left@yahoo.com>
To: Jan Engelhardt <jengelh@medozas.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:48306 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754490Ab1ASQUj (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 19 Jan 2011 11:20:39 -0500
In-Reply-To: <alpine.LNX.2.01.1101181738390.16142@obet.zrqbmnf.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On 18.01.2011 19:21, Jan Engelhardt wrote:
> On Tuesday 2011-01-18 17:16, Patrick McHardy wrote:
>> On 18.01.2011 16:38, Jan Engelhardt wrote:
>>> http://bugzilla.netfilter.org/show_bug.cgi?id=694 [...] While I
>>> have to question why users are relying on inferior filesystems
>>> (the issue was raised before on the lists), I feel inclined to
>>> solve bugs. So here is a proposed patchset that starts the
>>> migration. [...]
>>
>> I don't want to apply this. Feel free to try to convince other 
>> netfilter developers that this is a good idea and I'll pull it in, but 
>> so far this looks like useless noise to me.
>>
>> [...] I don't see any benefit in causing so much churn just for one* 
>> *user, who has been feeling unhappy about his scripts not working 
>> properly.
> 
> I'll try to add to my case then; The dependency on case-sensitivity is a 
> long-known issue, so much that in fact, Bart avoided doing this again as 
> early as ebtables's inception around 2002.
> 
> I am pretty sure there was more than just this one 2011 user -- needless 
> to say you have to count me in --, and that there was discussion [during 
> my time 2007 onwards]. Google fails me on finding that, though I dug up 
> another report from 2004: http://lkml.org/lkml/2004/10/17/147
> 
> At that time Harald argued "iptables fundamentally relies on the 
> destinction", though that does not apply today thanks to module aliases.
> 
> As a resident contributor, I stand behind the changes. In the unlikely 
> even that it breaks, I see it as duty to fix it. The churn is on me 
> already practically.

It's quite likely that something breaks. Module aliases only work for
loading modules, not for unloading them. So there's a big chance that
some scripts will break. We've done renames occasionally when necessary
(f.i. ip_conntrack => nf_conntrack), but this really rare case of users
using stupid file systems doesn't really justify this in my opinion.
Anyone actually using Linux is not going to have this problem.
