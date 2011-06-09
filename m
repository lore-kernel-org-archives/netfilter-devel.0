From: Jan Engelhardt <jengelh@medozas.de>
Subject: Re: FTP Packet Mangling & NAT
Date: Thu, 9 Jun 2011 09:22:46 +0200 (CEST)
Message-ID: <alpine.LNX.2.01.1106090919550.16808@frira.zrqbmnf.qr>
References: <BANLkTintTA8T_FEqF-vWe85iTonfZHGn3w@mail.gmail.com> <81c0aab748c6ad27b289055e31777945@treenet.co.nz>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Nadeem Douba <ndouba@gmail.com>, netfilter-devel@vger.kernel.org
To: Amos Jeffries <squid3@treenet.co.nz>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from seven.medozas.de ([188.40.89.202]:57115 "EHLO seven.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753619Ab1FIHWs (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 9 Jun 2011 03:22:48 -0400
In-Reply-To: <81c0aab748c6ad27b289055e31777945@treenet.co.nz>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


On Thursday 2011-06-09 05:20, Amos Jeffries wrote:
>
> A transparent proxy is equivalent to a NAT module in all respects.

Not quite. :)  nf_nat does not consume a local TCB - though it
does consume a port - whereas a classical proxy's connections
(e.g. squid) can show up in `ss -p`.
