From: Bart De Schuymer <bdschuym@pandora.be>
Subject: Re: [PATCH 1/4] [NETFILTER]: ebtables: expand/remove unneeded
	macros
Date: Sun, 20 Jan 2008 15:26:39 +0100
Message-ID: <1200839199.2868.25.camel@localhost.localdomain>
References: <Pine.LNX.4.64.0801172110060.18447@fbirervta.pbzchgretzou.qr>
	 <47934659.50303@trash.net>
	 <Pine.LNX.4.64.0801201407280.14598@fbirervta.pbzchgretzou.qr>
	 <479349D3.6050103@trash.net>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Cc: Jan Engelhardt <jengelh@computergmbh.de>,
	Netfilter Developer Mailing List
	<netfilter-devel@vger.kernel.org>
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from ananke.telenet-ops.be ([195.130.137.78]:43236 "EHLO
	ananke.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751991AbYATO0l (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 20 Jan 2008 09:26:41 -0500
In-Reply-To: <479349D3.6050103@trash.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Op zo, 20-01-2008 te 14:17 +0100, schreef Patrick McHardy:
> Jan Engelhardt wrote:
> > On Jan 20 2008 14:02, Patrick McHardy wrote:
> >> Jan Engelhardt wrote:
> >>> commit a6c73fee39cedc87ef2562f84d5b1f68a315a79b
> >>> Author: Jan Engelhardt <jengelh@computergmbh.de>
> >>> Date:   Thu Jan 17 18:58:05 2008 +0100
> >>>
> >>>     [NETFILTER]: ebtables: expand/remove unneeded macros
> >>>     
> >>>     The EBT_*_{MATCH,TARGET,WATCHER} macros are only used within the
> >>>     accompanying .c source file, so they can be moved to it. And since
> >>>     they are only used once, we can just as well expand them.
> >>>     
> >>>     Signed-off-by: Jan Engelhardt <jengelh@computergmbh.de>
> >>
> >> Your patches all look fine, but please CC Bart on ebtables patches,
> >> I think its impolite to bypass him when he's stated as maintainer.
> >>
> >>
> > Sorry for the inconvenience! Links are:
> > 
> > [1] marc missed that one(!?)
> > [2] http://marc.info/?l=netfilter-devel&m=120060092423718&w=2
> > [3] http://marc.info/?l=netfilter-devel&m=120060092523724&w=2
> > [4] http://marc.info/?l=netfilter-devel&m=120060075523444&w=2
> 
> 
> Thanks. Bart, please let me know if you have any objections or
> want to add a Signed-off-by: line.

Hi, thanks for putting me in CC. If you remove the EBT_*_ macros from
ebtables.h this will break the ebtables userspace compilation. For the
other patches I have no objection except that the MODULE_DESCRIPTION
isn't consistent with using upper case after 'Ebtables: ', but I guess
that's nitpicking :) Anyway, thanks Jan.

Btw, Patrick, I'm sure you've noticed I'm not very active in ebtables
development anymore. It has come to the point that I no longer find
pleasure in investing my spare time and energy in serious ebtables
development: most interesting ebtables things have been done for me. I'm
still around for bugfixing or commenting on patches, though (I tend to
only read things on ebtables-devel and stuff I'm CC'ed in). So if there
would ever arrive an active developer who has some serious ebtables
contributions (like getting access to the xt_ matches) and a long-term
commitment, I'm willing to step down as maintainer ((s)he'd have to take
over the responsibility for the userspace tool too). Anyway, no need to
worry that I'll suddenly abandon my project :) I think for bridge-nf
you're already the true maintainer, though you can always CC me for my
opinion (feel free to update the header of br_netfilter.c).

cheers,
Bart


