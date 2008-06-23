From: Patrick McHardy <kaber@trash.net>
Subject: Re: ip6tables doesn't support --goto option
Date: Mon, 23 Jun 2008 11:36:04 +0200
Message-ID: <485F6E84.3020208@trash.net>
References: <1213980307.5485.5.camel@enterprise.ims-firmen.de> <alpine.LNX.1.10.0806202010030.25478@fbirervta.pbzchgretzou.qr> <1213988076.2466.2.camel@henriknordstrom.net> <485CBB76.4020206@trash.net> <20080621144311.GA24248@internet24.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: Thomas Jacob <jacob@internet24.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:43005 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751208AbYFWJgM (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 23 Jun 2008 05:36:12 -0400
In-Reply-To: <20080621144311.GA24248@internet24.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Thomas Jacob wrote:
> On Sat, Jun 21, 2008 at 10:27:34AM +0200, Patrick McHardy wrote:
>> I think it was me, I added the ip6_tables support, for seem to
>> have forgotten about userspace.
>>
>> Does anyone wants to send a patch for this?
> 
> Here's what I got by copying the --goto changes from iptables.c,
> not sure if it's complete, but it seems to work for me.


Applied, thanks. Please remember to sign off your patches in
the future.

