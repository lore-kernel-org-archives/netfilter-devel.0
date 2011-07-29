From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH] netfilter: xt_rateest: fix xt_rateest_mt_checkentry()
Date: Fri, 29 Jul 2011 16:25:28 +0200
Message-ID: <4E32C2D8.1040103@trash.net>
References: <1311911462.7845.5.camel@edumazet-laptop>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: Netfilter Development Mailinglist
	<netfilter-devel@vger.kernel.org>, netdev <netdev@vger.kernel.org>,
	Jan Engelhardt <jengelh@medozas.de>
To: Eric Dumazet <eric.dumazet@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:56326 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751087Ab1G2OZb (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 29 Jul 2011 10:25:31 -0400
In-Reply-To: <1311911462.7845.5.camel@edumazet-laptop>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On 29.07.2011 05:51, Eric Dumazet wrote:
> commit 4a5a5c73b7cfee (slightly better error reporting) added some
> useless code in xt_rateest_mt_checkentry().
> 
> Fix this so that different error codes can really be returned.
> 

Applied, thanks Eric.
