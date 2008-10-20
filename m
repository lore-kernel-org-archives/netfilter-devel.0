From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH] netfilter: fix arptable_filter wrong hook registering
Date: Mon, 20 Oct 2008 11:54:51 +0200
Message-ID: <48FC556B.80609@trash.net>
References: <20081016012451.6126.34071.stgit@Decadence> <alpine.LNX.1.10.0810152126380.28060@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Pablo Neira Ayuso <pablo@netfilter.org>,
	netfilter-devel@vger.kernel.org
To: Jan Engelhardt <jengelh@medozas.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:52375 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751240AbYJTJyx (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 20 Oct 2008 05:54:53 -0400
In-Reply-To: <alpine.LNX.1.10.0810152126380.28060@fbirervta.pbzchgretzou.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Jan Engelhardt wrote:
> commit 60318cc486d15253b5ffc39b662a329f7e8f73b4
> Author: Jan Engelhardt <jengelh@medozas.de>
> Date:   Wed Oct 15 21:31:21 2008 -0400
> 
> netfilter: replace old NF_ARP calls with NFPROTO_ARP
> 
> (Supplements: ee999d8b9573df1b547aacdc6d79f86eb79c25cd)
> 
> NFPROTO_ARP actually has a different value from NF_ARP, so ensure all
> callers use the new value so that packets _do_ get delivered to the
> registered hooks

Applied, thanks.
