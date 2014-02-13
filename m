From: Mart Frauenlob <mart.frauenlob@chello.at>
Subject: Re: [PATCH 2/2 nft] scanner: fix parsing of tc handle
Date: Thu, 13 Feb 2014 14:08:17 +0100
Message-ID: <52FCC3C1.9070702@chello.at>
References: <1392291672-7885-1-git-send-email-pablo@netfilter.org> <1392291672-7885-2-git-send-email-pablo@netfilter.org> <20140213115112.GA30397@macbook.localnet> <20140213130102.GB4223@macbook.localnet>
Reply-To: mart.frauenlob@chello.at
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: Patrick McHardy <kaber@trash.net>,
	Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from fep14.mx.upcmail.net ([62.179.121.34]:52034 "EHLO
	fep14.mx.upcmail.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752760AbaBMNGl (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 13 Feb 2014 08:06:41 -0500
In-Reply-To: <20140213130102.GB4223@macbook.localnet>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On 13.02.2014 14:01, Patrick McHardy wrote:
...

> Generally it seems like using a ':' in maps might not be the best idea
> after all, its used for too many other things already. This might be
> the reason why I initially used =>, not sure anymore.
>
> Is there a reasonable alternative to ':' with a single character?

x = y or x=y sounds and looks very reasonable and fitting the case to 
me, would it break something else?

Thanks


