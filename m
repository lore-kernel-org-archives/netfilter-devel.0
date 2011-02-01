From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH] CT: add "none" as parameter for --ctevents
Date: Tue, 01 Feb 2011 16:19:40 +0100
Message-ID: <4D48248C.6070000@trash.net>
References: <20110131224856.4390.31272.stgit@decadence>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:44159 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751682Ab1BAPTo (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 1 Feb 2011 10:19:44 -0500
In-Reply-To: <20110131224856.4390.31272.stgit@decadence>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Am 31.01.2011 23:48, schrieb Pablo Neira Ayuso:
> This allows not to deliver any event. This can be useful if you want
> no events for some protocols, for example:
> 
> iptables -I PREROUTING -t raw -p udp -j CT --ctevents none
> 
> Thus, no events for UDP traffic are delivered to user-space.

Looks fine to me.
