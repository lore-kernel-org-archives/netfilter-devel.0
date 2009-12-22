From: Patrick McHardy <kaber@trash.net>
Subject: Re: [patch 1/1] net/netfilter/ipvs/ip_vs_wrr.c: use lib/gcd.c
Date: Tue, 22 Dec 2009 09:43:19 +0100
Message-ID: <4B3086A7.20006@trash.net>
References: <200912220037.nBM0bNBZ005989@imap1.linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org, florian@openwrt.org,
	davem@davemloft.net, horms@verge.net.au, juliusv@google.com,
	sshtylyov@ru.mvista.com, tiwai@suse.de
To: akpm@linux-foundation.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:53665 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751069AbZLVIn1 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 22 Dec 2009 03:43:27 -0500
In-Reply-To: <200912220037.nBM0bNBZ005989@imap1.linux-foundation.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

akpm@linux-foundation.org wrote:
> From: Florian Fainelli <florian@openwrt.org>
> 
> Remove the private version of the greatest common divider to use
> lib/gcd.c, the latter also implementing the a < b case.

Applied, thanks.

