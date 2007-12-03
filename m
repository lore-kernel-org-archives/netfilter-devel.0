From: Patrick McHardy <kaber@trash.net>
Subject: Re: [rfc] using xor in mark targets
Date: Mon, 03 Dec 2007 16:09:57 +0100
Message-ID: <47541C45.3090804@trash.net>
References: <Pine.LNX.4.64.0711292335090.3089@fbirervta.pbzchgretzou.qr> <474F4AD4.5030502@trash.net> <Pine.LNX.4.64.0711300120310.3089@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Netfilter Developer Mailing List <netfilter-devel@vger.kernel.org>
To: Jan Engelhardt <jengelh@computergmbh.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:35550 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750706AbXLCPKO (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 3 Dec 2007 10:10:14 -0500
In-Reply-To: <Pine.LNX.4.64.0711300120310.3089@fbirervta.pbzchgretzou.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Jan Engelhardt wrote:
> I was asking what name I should give to the option that enables
> "new-style" handling (origmark & ~mask ^ val):
> 
> 	--set-extended-mark val/mask
> 
> because it is not sooo extended after all, just a different notation of 
> what libxt_MARK takes right now.


Why not simply "--and-mark", "--or-mark", "--xor-mark", ...?

