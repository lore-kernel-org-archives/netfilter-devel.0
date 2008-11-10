From: Jan Engelhardt <jengelh@medozas.de>
Subject: Re: libiptc, arptables, ebtables plans or so - and header files
Date: Mon, 10 Nov 2008 20:09:07 +0100 (CET)
Message-ID: <alpine.LNX.1.10.0811102005590.3005@fbirervta.pbzchgretzou.qr>
References: <alpine.LNX.1.10.0811101726310.23956@fbirervta.pbzchgretzou.qr> <49187862.50306@trash.net> <49188328.8020103@hp.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Patrick McHardy <kaber@trash.net>,
	Netfilter Developer Mailing List
	<netfilter-devel@vger.kernel.org>
To: Rick Jones <rick.jones2@hp.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:53968 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750739AbYKJTJJ (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 10 Nov 2008 14:09:09 -0500
In-Reply-To: <49188328.8020103@hp.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


On Monday 2008-11-10 19:53, Rick Jones wrote:

> For some reason, perhaps only to have my daily emily litella moment, the
> discussion of abstraction is reminding me of struct sockaddr_storage vs an IPv4
> or IPv6 sockaddr.

If you have worked with sockets you probably now.
Even though there is a struct/union sockaddr_storage,
you still end up duplicating all the code:

	struct sockaddr_storage p;
	if (af == PF_INET) {
		struct sockaddr_in *q = (void *)&p;
		p->sin_family = PF_INET;
		p->sin_port = htons(1234);
		inet_pton(PF_INET, host, &p->sin_addr);
	} else {
		struct sockaddr_in6 *q = (void *)&p;
		p->sin6_family = PF_INET6;
		p->sin6_port = htons(1234);
		inet_pton(PF_INET6, host, &p->sin6_addr);
	}

it illustrates the problem with libiptc even better than libiptc itself.
