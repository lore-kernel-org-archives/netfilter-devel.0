From: Jan Engelhardt <jengelh@medozas.de>
Subject: Re: NAT - randomize the port selection
Date: Wed, 20 Aug 2008 11:11:49 -0400 (EDT)
Message-ID: <alpine.LNX.1.10.0808201107350.21065@fbirervta.pbzchgretzou.qr>
References: <48A0497C.9060607@suse.cz>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel@vger.kernel.org
To: Pavol Rusnak <prusnak@suse.cz>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:42116 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752723AbYHTPLv (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 20 Aug 2008 11:11:51 -0400
In-Reply-To: <48A0497C.9060607@suse.cz>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Monday 2008-08-11 10:15, Pavol Rusnak wrote:

> Hello!
>
> Recently there was an issue identified on DNS module about the need to
> randomize the port selection.  I'd like to know if this is already taken care
> in NAT modules in iptables? Could you please let me know if port selection is
> already randomized in these modules ?

If the client randomizes its source port, the NAT will obviously do the same.
Then there is --random for SNAT/MASQUERADE and others.
And now there has just been a patch merged to take some secure port number
it seems.
(http://marc.info/?l=netfilter-devel&m=121912048304189&w=2 )
