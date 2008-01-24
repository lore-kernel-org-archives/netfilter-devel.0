From: Jan Engelhardt <jengelh@computergmbh.de>
Subject: Re: [NETFILTER]: xt_TCPMSS: Consider reverse route's MTU in
 clamp-to-pmtu
Date: Thu, 24 Jan 2008 12:20:01 +0100 (CET)
Message-ID: <Pine.LNX.4.64.0801241219330.12676@fbirervta.pbzchgretzou.qr>
References: <Pine.LNX.4.64.0801232155020.12676@fbirervta.pbzchgretzou.qr>
 <4797BFE3.6090603@trash.net> <Pine.LNX.4.64.0801232341160.12676@fbirervta.pbzchgretzou.qr>
 <47980A57.2020702@uls.co.za> <47984409.9020204@trash.net> <479852DD.9000304@uls.co.za>
 <47986158.7050202@plouf.fr.eu.org> <47986D2D.4090406@uls.co.za>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Pascal Hambourg <pascal.mail@plouf.fr.eu.org>,
	Patrick McHardy <kaber@trash.net>,
	Netfilter Developer Mailing List
	<netfilter-devel@vger.kernel.org>
To: Jaco Kroon <jaco@uls.co.za>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:42991 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753050AbYAXLUD (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 24 Jan 2008 06:20:03 -0500
In-Reply-To: <47986D2D.4090406@uls.co.za>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


On Jan 24 2008 12:49, Jaco Kroon wrote:
>> 
>> Doesn't the patch "xt_TCPMSS: don't allow netfilter --setmss to increase mss"
>> applied to 2.6.25 about a month ago already do this ?
>
> I haven't followed that.  I'm running stable (2.6.23.14 atm) on most of my
> systems, my notebook is still on -rc8 for 2.6.24.  I've just had a specific
> problem that had a need to be scratched, but yes, based on the description you
> gave that would do _exactly_ that.
>
> Random question: What happens with the case where we explicitly _want_ to break
> the MSS?  In other words, to set it to something insane like 3000 in order to
> test other equipment.

Ideally, no TCPMSS would be needed as TCP does PMTUD itself,
similarly for UDP (though _you_ need to do it yourself there).
