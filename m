From: Jan Engelhardt <jengelh@medozas.de>
Subject: Re: [0/5] xtables: phase out case sensitivity
Date: Wed, 19 Jan 2011 20:44:10 +0100 (CET)
Message-ID: <alpine.LNX.2.01.1101192023290.19837@obet.zrqbmnf.qr>
References: <alpine.LNX.2.01.1101181628540.15366@obet.zrqbmnf.qr> <4D35BCC7.90805@trash.net> <alpine.LNX.2.01.1101181738390.16142@obet.zrqbmnf.qr> <4D370F56.5060901@trash.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Netfilter Developer Mailing List
	<netfilter-devel@vger.kernel.org>,
	Aaron Wright <wright_left@yahoo.com>,
	Jon Masters <jcm@jonmasters.org>
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from borg.medozas.de ([188.40.89.202]:48136 "EHLO borg.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753275Ab1ASToL (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 19 Jan 2011 14:44:11 -0500
In-Reply-To: <4D370F56.5060901@trash.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


On Wednesday 2011-01-19 17:20, Patrick McHardy wrote:
>> 
>> As a resident contributor, I stand behind the changes. In the unlikely 
>> even that it breaks, I see it as duty to fix it. The churn is on me 
>> already practically.
>
>It's quite likely that something breaks. Module aliases only work for
>loading modules, not for unloading them. So there's a big chance that
>some scripts will break.

Scripts can not rely on that being successful: Xtables modules may
pull in other modules, including using things like nf_ct_get_l3proto
which do not leave a trace in `lsmod` output. So rmmodding of xt
modules can fail _even_ in the present situation. Not to mention that
scripts currently have to battle the mulitple prefixes that are in
use (which the patchset addresses in part).

Since modinfo not following aliases has bothered myself for some time 
now, I should probably just add that to m-i-t modinfo as an option and, 
while at it, rmmod.
