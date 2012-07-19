From: Jan Engelhardt <jengelh@inai.de>
Subject: Re: ulogd - rpm file generation
Date: Thu, 19 Jul 2012 21:23:08 +0200 (CEST)
Message-ID: <alpine.LNX.2.01.1207192122200.5668@frira.zrqbmnf.qr>
References: <CAAJpzga1LexHUgL5aqF26ukUEsGy0AojRYqLO5ONqv71nLUedg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel@vger.kernel.org
To: Gomathivinayagam Muthuvinayagam <sankarmail@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from seven.medozas.de ([5.9.24.206]:59238 "EHLO seven.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750882Ab2GSTXK (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 19 Jul 2012 15:23:10 -0400
In-Reply-To: <CAAJpzga1LexHUgL5aqF26ukUEsGy0AojRYqLO5ONqv71nLUedg@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Thursday 2012-07-19 19:57, Gomathivinayagam Muthuvinayagam wrote:

>Hi,
>
>I'm trying to build ulogd rpm file for a system x86_64 architecture.
>There is a spec file provided in ulogd tar file.
>Can I use that and build it? Is it updated one? Or still I have to go
>through Makefile and find out if anything is missing?
>
>Please bear with me, I'm trying to build rpm for the first time.

Doubtful that it is still current.
What is current though, is
http://build.opensuse.org/package/show?package=ulogd&project=security:netfilter
