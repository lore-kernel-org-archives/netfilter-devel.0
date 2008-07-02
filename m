From: Patrick McHardy <kaber@trash.net>
Subject: Re: Further speedup of iptables when modifying an existing ruleset
Date: Wed, 02 Jul 2008 12:27:32 +0200
Message-ID: <486B5814.6000708@trash.net>
References: <1214930900.9800.32.camel@enterprise.ims-firmen.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: Thomas Jacob <jacob@internet24.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:32867 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753110AbYGBK1e (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 2 Jul 2008 06:27:34 -0400
In-Reply-To: <1214930900.9800.32.camel@enterprise.ims-firmen.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Thomas Jacob wrote:
> Hello list,
> 
> Here's a patch to speed up iptcc_find_chain_by_offset 
> (O(n)->O(log(n)) by creating a lookup table while
> initially translating the kernel blob.
> 
> In my test case a second iptables-restore with a file containing
> ~50k chains with 120k~ rules takes 11s instead of 1m30s (on a VM).
> iptables -vnL SOMECHAIN takes 0.5s instead of 1m12s.

That sounds great.

> Comments and suggestions would be very welcome, as would
> be inclusion into the mainline distribution ;-)

Please resend the patch inline (or using Content-Disposition: inline;
instead of attachment) so people can view it in their mail clients.
