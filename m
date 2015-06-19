From: Jan Engelhardt <jengelh@inai.de>
Subject: Re: [PATCH nft] src: add tee statement
Date: Fri, 19 Jun 2015 16:07:52 +0200 (CEST)
Message-ID: <alpine.LSU.2.20.1506191553060.24212@nerf40.vanv.qr>
References: <1434709594-6460-1-git-send-email-pablo@netfilter.org> <20150619125724.GG22946@acer.localdomain> <2024102.ynN6JVsV1M@rofl> <alpine.LSU.2.20.1506191520530.15886@nerf40.vanv.qr> <20150619133708.GJ22946@acer.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Cc: Patrick Schaaf <netdev@bof.de>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	netfilter-devel@vger.kernel.org
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from ares41.inai.de ([46.4.122.207]:33086 "EHLO ares41.inai.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752101AbbFSOHx (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 19 Jun 2015 10:07:53 -0400
In-Reply-To: <20150619133708.GJ22946@acer.localdomain>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


On Friday 2015-06-19 15:37, Patrick McHardy wrote:
>
>[...] I don't think [tee] is necessarily well known among
>firewall admins.

I think different.


TEE has been in iptables for a long time (a little over five years),
the manpage for it has the important keywords "clone" and "redirect"
in it, and there are sufficiently many blog posts and StackExchange
on the matter (including duplication), and has become an established
name, like masquerade - another symbolic-mnemonic name - once did.
--
To unsubscribe from this list: send the line "unsubscribe netfilter-devel" in
