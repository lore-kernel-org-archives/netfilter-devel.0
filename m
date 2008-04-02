From: Patrick McHardy <kaber@trash.net>
Subject: Re: Bug in bridge or netfilter code (REJECT + incorrect MAC)?
Date: Wed, 02 Apr 2008 12:43:21 +0200
Message-ID: <47F36349.8050400@trash.net>
References: <47F2723D.2080509@kotiportti.fi>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: Casper Gripenberg <casper.gripenberg@kotiportti.fi>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:60975 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751501AbYDBKn0 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 2 Apr 2008 06:43:26 -0400
In-Reply-To: <47F2723D.2080509@kotiportti.fi>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Casper Gripenberg wrote:
> 
> Hi,
> 
> I sent this to the netfilter list, but nobody replied there.
> 
> I've found something strange with REJECT and DNAT rules
> where the MAC address for packets coming back through
> the bridge get rewritten incorrectly.
> 
> The setup to test this is fairly simple, and I can
> reproduce it consistently on my stock Ubuntu 7.10
> installation (kernel 2.6.22-14).
> 
> Is it something I'm doing wrong, or any idea what is
> going on? I filed a bug report here:
> 
> https://bugzilla.netfilter.org/cgi-bin/bugzilla/show_bug.cgi?id=531


I'm wondering, why does your client care about the source MAC
address of the REJECT packet? Or is there another switch in
between that does MAC filtering?

