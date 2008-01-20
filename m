From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH 1/4] [NETFILTER]: ebtables: expand/remove unneeded	macros
Date: Sun, 20 Jan 2008 15:45:14 +0100
Message-ID: <47935E7A.1000908@trash.net>
References: <Pine.LNX.4.64.0801172110060.18447@fbirervta.pbzchgretzou.qr>	 <47934659.50303@trash.net>	 <Pine.LNX.4.64.0801201407280.14598@fbirervta.pbzchgretzou.qr>	 <479349D3.6050103@trash.net> <1200839199.2868.25.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Jan Engelhardt <jengelh@computergmbh.de>,
	Netfilter Developer Mailing List
	<netfilter-devel@vger.kernel.org>
To: Bart De Schuymer <bdschuym@pandora.be>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:59472 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753159AbYATOqT (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 20 Jan 2008 09:46:19 -0500
In-Reply-To: <1200839199.2868.25.camel@localhost.localdomain>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Bart De Schuymer wrote:
> Op zo, 20-01-2008 te 14:17 +0100, schreef Patrick McHardy:
>
>> Thanks. Bart, please let me know if you have any objections or
>> want to add a Signed-off-by: line.
> 
> Hi, thanks for putting me in CC. If you remove the EBT_*_ macros from
> ebtables.h this will break the ebtables userspace compilation. For the
> other patches I have no objection except that the MODULE_DESCRIPTION
> isn't consistent with using upper case after 'Ebtables: ', but I guess
> that's nitpicking :) Anyway, thanks Jan.


I'll drop the first patch then and apply the others, thanks.

> Btw, Patrick, I'm sure you've noticed I'm not very active in ebtables
> development anymore. It has come to the point that I no longer find
> pleasure in investing my spare time and energy in serious ebtables
> development: most interesting ebtables things have been done for me. I'm
> still around for bugfixing or commenting on patches, though (I tend to
> only read things on ebtables-devel and stuff I'm CC'ed in). So if there
> would ever arrive an active developer who has some serious ebtables
> contributions (like getting access to the xt_ matches) and a long-term
> commitment, I'm willing to step down as maintainer ((s)he'd have to take
> over the responsibility for the userspace tool too). Anyway, no need to
> worry that I'll suddenly abandon my project :) I think for bridge-nf
> you're already the true maintainer, though you can always CC me for my
> opinion (feel free to update the header of br_netfilter.c).


Yes, for br_netfilter.c this makes sense I guess. For ebtables I'm
not sure - I have no problem reviewing and applying kernel patches,
but I'm lacking the time for taking care of userspace as well, at
least for doing it alone. But since ebtables, arptables and iptables
are pretty similar, perhaps it would be possible to merge ebtables
and arptables support with iptables. It would certainly make sense,
but I expect it to be quite a lot of work. Well, anyways, for now
I guess we'll just have to continue as usual :)

