From: Bart De Schuymer <bdschuym@pandora.be>
Subject: Re: [PATCH 6/8] [NETFILTER]: Make Ebtables use Xtables
	infrastructure
Date: Thu, 10 Apr 2008 22:11:46 +0200
Message-ID: <1207858306.2899.8.camel@localhost.localdomain>
References: <5130e28c2130c57a9a07ae21c552fe7db519473c.1207668694.git.jengelh@computergmbh.de>
	 <00e063673b63941c85b10b43cd1edec966d32e54.1207668694.git.jengelh@computergmbh.de>
	 <47FCBFBF.5020805@trash.net>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Cc: Jan Engelhardt <jengelh@computergmbh.de>,
	netfilter-devel@vger.kernel.org
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from monty.telenet-ops.be ([195.130.132.56]:59403 "EHLO
	monty.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757376AbYDJULt (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 10 Apr 2008 16:11:49 -0400
In-Reply-To: <47FCBFBF.5020805@trash.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Op wo, 09-04-2008 te 15:08 +0200, schreef Patrick McHardy:
> Jan Engelhardt wrote:
> > Signed-off-by: Jan Engelhardt <jengelh@computergmbh.de>
> 
> 
> I like these patches (modulo the small NFPROTO_ARP nitpicks),
> I'd like to get an ACK from Bart before applying them though.
> 
> I assume this doesn't affect userspace compatibility?

I'm wondering why the checks for the size of the match info is removed
in every module, except for the among match. This seems strange to me.
If it isn't wrong, I presume there is an obvious way for someone to find
out this is required?
I didn't check the xtables specific stuff too much but I presume Jan
tested this with a released ebtables version...
It looks fine to me from a backwards compatibility point of view.

cheers,
Bart


