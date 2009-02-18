From: Patrick McHardy <kaber@trash.net>
Subject: Re: [resend] netfilter: make proc/net/ip* print names from foreign
 NFPROTO
Date: Wed, 18 Feb 2009 16:45:41 +0100
Message-ID: <499C2D25.5010105@trash.net>
References: <alpine.LSU.2.00.0902131354570.9310@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Netfilter Developer Mailing List <netfilter-devel@vger.kernel.org>
To: Jan Engelhardt <jengelh@medozas.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:56280 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752783AbZBRPpn (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 18 Feb 2009 10:45:43 -0500
In-Reply-To: <alpine.LSU.2.00.0902131354570.9310@fbirervta.pbzchgretzou.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Jan Engelhardt wrote:
> netfilter: make proc/net/ip* print names from foreign NFPROTO
> 
> When extensions were moved to the NFPROTO_UNSPEC wildcard in
> ab4f21e6fb1c09b13c4c3cb8357babe8223471bd, they disappeared from the
> procfs files.

I used the old version previously, but now replaced it with this
one, thanks.
