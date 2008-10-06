From: "Martin Schwenke" <martin@meltin.net>
Subject: Re: iptables not working with monolithic 2.6.26.5 kernel on ARM
Date: Mon, 6 Oct 2008 14:02:50 +1100
Message-ID: <18665.32730.50644.705435@martins.ozlabs.org>
References: <18661.41641.113458.932029@martins.ozlabs.org>
	<48E6166F.40607@trash.net>
	<alpine.LNX.1.10.0810031006260.3893@fbirervta.pbzchgretzou.qr>
	<18662.61266.69230.675687@martins.ozlabs.org>
	<alpine.LNX.1.10.0810040724110.19954@fbirervta.pbzchgretzou.qr>
	<18665.27407.93703.212846@martins.ozlabs.org>
	<alpine.LNX.1.10.0810052139230.3354@fbirervta.pbzchgretzou.qr>
Reply-To: "Martin Schwenke" <martin@meltin.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: Patrick McHardy <kaber@trash.net>, netfilter-devel@vger.kernel.org
To: Jan Engelhardt <jengelh@medozas.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from ozlabs.org ([203.10.76.45]:51704 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752423AbYJFDEx (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 5 Oct 2008 23:04:53 -0400
In-Reply-To: <alpine.LNX.1.10.0810052139230.3354@fbirervta.pbzchgretzou.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

>>>>> "Jan" == Jan Engelhardt <jengelh@medozas.de> writes:

    Jan> Hey, does your kernel's .config even have a CONFIG_COMPAT?

Nope.

I spent some time the other day looking at what setting CONFIG_COMPAT
means for netfilter.  I then tried to work out how to get it set on
the off chance that it might fix my problems... but I can't find any
info about it...  :-(

What does CONFIG_COMPAT mean?

peace & happiness,
martin

