From: Jan Engelhardt <jengelh@medozas.de>
Subject: Re: register an hook
Date: Fri, 23 Apr 2010 14:25:34 +0200 (CEST)
Message-ID: <alpine.LSU.2.01.1004231423530.11467@obet.zrqbmnf.qr>
References: <z2uede9a9eb1004230155oe674c584m2ca2d0b4ba3490c0@mail.gmail.com>  <alpine.LSU.2.01.1004231227410.30678@obet.zrqbmnf.qr> <i2iede9a9eb1004230350gfa9279bej12902ff2b6522664@mail.gmail.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel <netfilter-devel@vger.kernel.org>
To: Nicola Padovano <nicola.padovano@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from borg.medozas.de ([188.40.89.202]:42644 "EHLO borg.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754464Ab0DWMZf (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 23 Apr 2010 08:25:35 -0400
In-Reply-To: <i2iede9a9eb1004230350gfa9279bej12902ff2b6522664@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Friday 2010-04-23 12:50, Nicola Padovano wrote:

>what's the difference? what is a target?
>I'm analyzing the tarpit patch
>(http://enterprise.bih.harvard.edu/pub/tarpit-updates/tarpit-2.6.29.patch)
>and i've found only the registration of that target. and so, how it
>works, if there isn't an hook registration?
>
>help me, please :(

Targets are invoked via Xtables which is a hook user.

targets: http://en.wikipedia.org/wiki/Iptables
tarpit: http://xtables-addons.sf.net/
and subsequently: http://jengelh.medozas.de/documents/Netfilter_Modules.pdf
