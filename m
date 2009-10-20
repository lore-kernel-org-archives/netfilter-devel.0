From: Jan Engelhardt <jengelh@medozas.de>
Subject: Re: DNAT and source IP
Date: Tue, 20 Oct 2009 12:13:35 +0200 (CEST)
Message-ID: <alpine.LSU.2.00.0910201212490.16728@obet.zrqbmnf.qr>
References: <4ADD71D7.7090502@tootai.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Netfilter list <netfilter-devel@vger.kernel.org>
To: Daniel Huhardeaux <tech@tootai.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from borg.medozas.de ([188.40.89.202]:44479 "EHLO borg.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750874AbZJTKNc (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 20 Oct 2009 06:13:32 -0400
In-Reply-To: <4ADD71D7.7090502@tootai.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


On Tuesday 2009-10-20 10:16, Daniel Huhardeaux wrote:
>
> I'm running few virtual machines (kvm+libvirt) on a server (Debian Lenny +
> backport kernel 2.6.30) with one public IP and having IP private range
> 10.99.0.1 for host, one for mail and web VM (10.99.0.13), another for telephony
> VM (10.99.0.11).
>
> Everything is working well (DNAT) but something is disturbing me: for instance,
> on smtp server, all incoming tcp packets are marked with 10.99.0.1 source IP
> and I would like to have "transparent DNAT" which keep the original IP.

You need tproxy then, and not NAT.

