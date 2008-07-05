From: Jan Engelhardt <jengelh@medozas.de>
Subject: Re: build: quote variables in release.sh
Date: Sat, 5 Jul 2008 22:36:04 +0200 (CEST)
Message-ID: <alpine.LNX.1.10.0807052235560.28765@fbirervta.pbzchgretzou.qr>
References: <alpine.LNX.1.10.0807032015430.23294@fbirervta.pbzchgretzou.qr> <486DD32C.6040903@netfilter.org> <486DD3AF.6040909@netfilter.org> <alpine.LNX.1.10.0807041227510.1890@fbirervta.pbzchgretzou.qr> <486E3025.9030106@netfilter.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: kaber@trash.net,
	Netfilter Developer Mailing List
	<netfilter-devel@vger.kernel.org>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:46571 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751363AbYGEUgH (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 5 Jul 2008 16:36:07 -0400
In-Reply-To: <486E3025.9030106@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


On Friday 2008-07-04 16:13, Pablo Neira Ayuso wrote:
>>>>>     build: quote variables in release.sh
>>>> Actually, instead of fixing release.sh, we should have the `make
>>>> distcheck' magic working. Currently it is broken.
>>> I mean the magic to build the tarball, of course.
>> 
>> make tarball
>
>That works but it is doing far less checkings that `make distcheck' in
>other packages.

What checks do we need?
