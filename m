From: Jan Engelhardt <jengelh@inai.de>
Subject: Re: [iptables PATCH] list: fix prefetch dummy
Date: Tue, 7 Apr 2015 20:17:28 +0200 (CEST)
Message-ID: <alpine.LSU.2.20.1504072010530.17563@nerf40.vanv.qr>
References: <20150406180541.7031.97131.stgit@nfdev2.cica.es> <552326ED.9040500@gmail.com> <alpine.LSU.2.20.1504071036001.29221@nerf40.vanv.qr> <552417BC.6050807@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Cc: Alexander Duyck <alexander.duyck@gmail.com>,
	Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>,
	netfilter-devel@vger.kernel.org, kaber@trash.net,
	pablo@netfilter.org
To: Alexander Duyck <alexander.h.duyck@redhat.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from ares41.inai.de ([46.4.122.207]:55431 "EHLO ares41.inai.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752686AbbDGSRa (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 7 Apr 2015 14:17:30 -0400
In-Reply-To: <552417BC.6050807@redhat.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


On Tuesday 2015-04-07 19:45, Alexander Duyck wrote:
>>>>  -#define prefetch(x)		1
>>>> +#define prefetch(x)		((void)0)
>>>>
>>> Why not just use "do {} while (0)"?  I know that is what is used in the
>>> kernel for functions that don't do anything.
>> I may be getting the terms wrong, but:
>> do{}while(0) is not an expression, it is a (block) control statement.
>> In particular, do{}while(0) won't evaluate to an rvalue.
>
> Right.  That is the point in this case.  I am assuming what Arturo is trying to
> accomplish since you shouldn't be able to evaluate ((void)0) as an rvalue
> either.

The difference is that

	int i;
	i = 1, (void)0;

compiles, while

	i = 1, do{}while(0);

will not. Even less so with

	int i = 1, (void)0 vs
	int i = 1, do{}while(0);

[that looks so obscure that even I need to go figure out why that is
even permitted at this point].
