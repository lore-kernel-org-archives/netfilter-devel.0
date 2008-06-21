From: Patrick McHardy <kaber@trash.net>
Subject: Re: ip6tables doesn't support --goto option
Date: Sat, 21 Jun 2008 10:27:34 +0200
Message-ID: <485CBB76.4020206@trash.net>
References: <1213980307.5485.5.camel@enterprise.ims-firmen.de>	 <alpine.LNX.1.10.0806202010030.25478@fbirervta.pbzchgretzou.qr> <1213988076.2466.2.camel@henriknordstrom.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Jan Engelhardt <jengelh@medozas.de>,
	Thomas Jacob <jacob@internet24.de>,
	netfilter-devel@vger.kernel.org
To: Henrik Nordstrom <henrik@henriknordstrom.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:52696 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751375AbYFUI1j (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 21 Jun 2008 04:27:39 -0400
In-Reply-To: <1213988076.2466.2.camel@henriknordstrom.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Henrik Nordstrom wrote:
> On fre, 2008-06-20 at 20:10 +0200, Jan Engelhardt wrote:
> 
>> I suppose it was just forgotten, as the original commit (17fc163b) only
>> touched iptables.c, not ip6tables.c.
> 
> Quite likely my fault as I only use iptables, not yet ip6tables..

I think it was me, I added the ip6_tables support, for seem to
have forgotten about userspace.

Does anyone wants to send a patch for this?
