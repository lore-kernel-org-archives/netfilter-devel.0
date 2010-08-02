From: Jan Engelhardt <jengelh@medozas.de>
Subject: Re: TCPMSS clamp-mss-to-pmtu breaks packets that have no MSS set
 (incl. solution)
Date: Mon, 2 Aug 2010 17:16:42 +0200 (CEST)
Message-ID: <alpine.LSU.2.01.1008021714500.13406@obet.zrqbmnf.qr>
References: <4C522461.4070000@gmail.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel@vger.kernel.org
To: Daniel Gibson <metalcaedes@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from borg.medozas.de ([188.40.89.202]:56516 "EHLO borg.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753452Ab0HBPQo (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 2 Aug 2010 11:16:44 -0400
In-Reply-To: <4C522461.4070000@gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


On Friday 2010-07-30 03:01, Daniel Gibson wrote:

> Hi,
>
> clamp-mss-to-pmtu (as used in "iptables -A FORWARD -p tcp
> --tcp-flags SYN,RST SYN -j TCPMSS --clamp-mss-to-pmtu") sets a
> possibly much to high MSS (the one it got from PMTU) in packets
> that had no MSS set before.

If a packet has no MSS option, none will be added no more.
(commit v2.6.34-rc1~233^2~154^2~44)
