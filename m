From: Marek Kierdelewicz <marek@piasta.pl>
Subject: Re: xtables-addons - problem including nf_nat.h in userspace plugin
Date: Mon, 22 Nov 2010 22:52:13 +0100
Message-ID: <20101122225213.0afd1843@catus>
References: <20101121224731.22fced2b@catus>
	<alpine.LNX.2.01.1011221447001.18089@obet.zrqbmnf.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: Netfilter Developer Mailing List
	<netfilter-devel@vger.kernel.org>,
	Patrick McHardy <kaber@trash.net>
To: Jan Engelhardt <jengelh@medozas.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from psyche.piasta.pl ([83.175.144.5]:41026 "EHLO psyche.piasta.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757110Ab0KVVwS (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 22 Nov 2010 16:52:18 -0500
In-Reply-To: <alpine.LNX.2.01.1011221447001.18089@obet.zrqbmnf.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi,

>As for xt-a, preferable location is
>linux-src/include/net/netfilter/nf_nat.h ->
>xtables-addons/include/net/netfilter/nf_nat.h
>Then #include <net/...> should work.

Thx! That worked great.

Best regards,
Marek
