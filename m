From: Patrick McHardy <kaber@trash.net>
Subject: Re: DROP still returns -EPERM to userspace in OUTPUT chain
Date: Mon, 25 May 2009 16:56:52 +0200
Message-ID: <4A1AB1B4.6010700@trash.net>
References: <alpine.LSU.2.00.0905211707050.23519@fbirervta.pbzchgretzou.qr> <4A17D45C.6040909@netfilter.org> <alpine.LSU.2.00.0905231309250.361@fbirervta.pbzchgretzou.qr> <4A17E14B.5040701@netfilter.org> <alpine.LSU.2.00.0905231517400.4949@fbirervta.pbzchgretzou.qr> <4A18100B.1080803@netfilter.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Jan Engelhardt <jengelh@medozas.de>,
	Netfilter Developer Mailing List
	<netfilter-devel@vger.kernel.org>, wintre <mikeacar@gmail.com>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:60684 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751873AbZEYO4z (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 25 May 2009 10:56:55 -0400
In-Reply-To: <4A18100B.1080803@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Pablo Neira Ayuso wrote:
> Jan Engelhardt wrote:
>> So just wanting to know - are people supposed to use xt_STEAL instead
>> if they really want it silently dropped?
> 
> Well, I still would like to know any application that can benefit from
> this, apart from broken applications.

I'd suggest to encode an errno code in the verdict and return that
one. Currently we're not able to propagate f.i. -EHOSTUNREACH from
ip_route_me_harder() and always return -EPERM. This could then be
used to make the errno code configurable for DROP, similar to
unreachable routes.
