From: Jan Engelhardt <jengelh@inai.de>
Subject: Re: state match is obsolete 1.4.17
Date: Tue, 15 Jan 2013 14:53:44 +0100 (CET)
Message-ID: <alpine.LNX.2.01.1301151444250.20224@nerf07.vanv.qr>
References: <CAMD-=V+PhM3NLpWyxB0G4KUN6D+-XKL0PZCBAuyUXUw56gmuJw@mail.gmail.com> <alpine.LNX.2.01.1301150958390.16853@nerf07.vanv.qr> <50F5273F.5020205@inliniac.net> <alpine.DEB.2.00.1301151102490.11129@blackhole.kfki.hu> <alpine.LNX.2.01.1301151342440.19279@nerf07.vanv.qr>
 <alpine.DEB.2.00.1301151406540.11172@blackhole.kfki.hu>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Victor Julien <lists@inliniac.net>,
	Nick Edwards <nick.z.edwards@gmail.com>,
	netfilter@vger.kernel.org, netfilter-devel@vger.kernel.org
To: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from ares07.inai.de ([5.9.24.206]:37858 "EHLO ares07.inai.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756196Ab3AONxq (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 15 Jan 2013 08:53:46 -0500
In-Reply-To: <alpine.DEB.2.00.1301151406540.11172@blackhole.kfki.hu>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


On Tuesday 2013-01-15 14:22, Jozsef Kadlecsik wrote:
>> 
>> state is currently aliased and translated to conntrack in iptables
>> if the kernel has it. No scripts are broken.
>> 
>> If the aliasing is done in userspace, the kernel part can be removed -
>> someday maybe.
>
>The aliasing is already done in userspace. One types in "state" and it's 
>converted into "conntrack" and that is then sent to the kernel. (So as far 
>as I see if the ipt_state, etc module aliases were added to the conntrack 
>module, even the state kernel module could be removed.)

The module aliases were added because the module in fact (still) supports
the "state" extension by that name.

>However I suggest to delete the obsolete warnings completely from iptables 
>and let these cases silently be handled as aliases.

Then users will complain about spooky action at a distance.
(silent changing of rules) - not a great perspective either.
The obsolescence warning is an important part of documenting
changed behavior, and you really really do not want to take
that away from users.
