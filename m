From: Jan Engelhardt <jengelh@computergmbh.de>
Subject: Re: [PATCH 6/8] [NETFILTER]: Make Ebtables use Xtables
 infrastructure
Date: Wed, 9 Apr 2008 15:12:53 +0200 (CEST)
Message-ID: <alpine.LNX.1.10.0804091511000.4411@fbirervta.pbzchgretzou.qr>
References: <5130e28c2130c57a9a07ae21c552fe7db519473c.1207668694.git.jengelh@computergmbh.de> <00e063673b63941c85b10b43cd1edec966d32e54.1207668694.git.jengelh@computergmbh.de> <47FCBFBF.5020805@trash.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel@vger.kernel.org,
	Bart De Schuymer <bdschuym@pandora.be>
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:49968 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753748AbYDINMy (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 9 Apr 2008 09:12:54 -0400
In-Reply-To: <47FCBFBF.5020805@trash.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


On Wednesday 2008-04-09 15:08, Patrick McHardy wrote:
> Jan Engelhardt wrote:
>> Signed-off-by: Jan Engelhardt <jengelh@computergmbh.de>
>
> I like these patches (modulo the small NFPROTO_ARP nitpicks),
> I'd like to get an ACK from Bart before applying them though.
>
> I assume this doesn't affect userspace compatibility?

Well it seemed fine to me. I could not test ebt_among because
there is not a single bit of info about how to use it, but
the -1 hack is obvious and should not fail.
