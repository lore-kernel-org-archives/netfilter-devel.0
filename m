From: Jan Engelhardt <jengelh@medozas.de>
Subject: Re: uisng L7 filter in ebtables commands
Date: Thu, 1 Apr 2010 10:00:40 +0200 (CEST)
Message-ID: <alpine.LSU.2.01.1004010958390.18225@obet.zrqbmnf.qr>
References: <x2v861e3bca1003311124sa0aa2ab6y94fa42c650ef16f8@mail.gmail.com>  <4BB4427A.3020706@pandora.be> <n2z861e3bca1004010050j7063cee8ya8c27ac73458b8bf@mail.gmail.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Bart De Schuymer <bdschuym@pandora.be>,
	netfilter-devel@vger.kernel.org, netfilter@vger.kernel.org
To: agashi shipora <gashipo@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from borg.medozas.de ([188.40.89.202]:55708 "EHLO borg.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750796Ab0DAIAl (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 1 Apr 2010 04:00:41 -0400
In-Reply-To: <n2z861e3bca1004010050j7063cee8ya8c27ac73458b8bf@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


On Thursday 2010-04-01 09:50, agashi shipora wrote:
>
>Whereas in the linux kernel source I am working with (which is also
>2.6.30 but customized) CONFIG_BRIDGE_NETFILTER option , though present
>in the "make menuconfig" for selection is not compatible with the
>customizations , hence results in crash.

So the crash is a result of your own modification, so as far as I
can see, you should fix that, given it's working in a standard kernel.
