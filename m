From: Patrick McHardy <kaber@trash.net>
Subject: Re: Ebtables hook order anomaly
Date: Wed, 09 Apr 2008 17:11:11 +0200
Message-ID: <47FCDC8F.5030701@trash.net>
References: <925A849792280C4E80C5461017A4B8A226A019@mail733.InfraSupportEtc.com> <alpine.LNX.1.10.0803250301140.9368@fbirervta.pbzchgretzou.qr> <alpine.LNX.1.10.0803250455030.9368@fbirervta.pbzchgretzou.qr> <47E8F6B4.4030800@trash.net> <alpine.LNX.1.10.0804081645450.2229@fbirervta.pbzchgretzou.qr> <47FCD47A.7060600@trash.net> <alpine.LNX.1.10.0804091639210.3866@fbirervta.pbzchgretzou.qr> <925A849792280C4E80C5461017A4B8A226A0F7@mail733.InfraSupportEtc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Jan Engelhardt <jengelh@computergmbh.de>,
	Netfilter Developer Mailing List
	<netfilter-devel@vger.kernel.org>
To: Greg Scott <GregScott@InfraSupportEtc.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:50349 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752641AbYDIPLO (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 9 Apr 2008 11:11:14 -0400
In-Reply-To: <925A849792280C4E80C5461017A4B8A226A0F7@mail733.InfraSupportEtc.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Greg Scott wrote:
>> there has been a L2-hooks back in the 2.4 days (at least the context
>> looks like it), and given that the ebtables targets now use
>> xtables, the l2hooks patch would actually be real easy.
> 
> All I ask is, please please please don't break the order with ebtables
> and iptables on input!  I really really really need to know the in-eth
> interface.  

Don't worry.

> Also, I'm willing to test any l2-hook patches that tell me the iptables
> out eth interface in a bridge.  I have a couple of sites where I can
> brew up kernels and rulesets.

That won't work. iptables *can't* know since it sits at the network
layer, while briding sits *below* it at the device layer.

I forgot why exactly you need the bridge port in iptables. But
in any case the only way to get it is within briding (where some
of the iptables features are not available). So a fix for all
of this should be to make the missing iptables features available
for briding natively.
