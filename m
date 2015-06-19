From: Patrick Schaaf <netdev@bof.de>
Subject: Re: [PATCH nft] src: add tee statement
Date: Fri, 19 Jun 2015 15:17:59 +0200
Message-ID: <2024102.ynN6JVsV1M@rofl>
References: <1434709594-6460-1-git-send-email-pablo@netfilter.org> <20150619125724.GG22946@acer.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Cc: Pablo Neira Ayuso <pablo@netfilter.org>,
	netfilter-devel@vger.kernel.org
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mars.intermailgate.com ([80.242.145.70]:37676 "EHLO
	mars.intermailgate.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751397AbbFSNSD (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 19 Jun 2015 09:18:03 -0400
In-Reply-To: <20150619125724.GG22946@acer.localdomain>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Friday 19 June 2015 14:57:24 Patrick McHardy wrote:
>
> Is tee a name we want to use for userspace syntax? It's not particulary
> descriptive for people who don't know what "tee" is, which I guess are
> quite a few.

Naming the thing "tee" was a conscious decision when I invented the it as an 
option to the ROUTE target back in 2004  - because it is a huge foot gun, and 
obscurity seemed appropriate.

best regards
  Patrick
--
To unsubscribe from this list: send the line "unsubscribe netfilter-devel" in
