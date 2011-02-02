From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH 02/13] IP set core support
Date: Wed, 02 Feb 2011 23:56:57 +0100
Message-ID: <4D49E139.1090403@trash.net>
References: <1296514388-20900-1-git-send-email-kadlec@blackhole.kfki.hu> <1296514388-20900-2-git-send-email-kadlec@blackhole.kfki.hu> <1296514388-20900-3-git-send-email-kadlec@blackhole.kfki.hu> <4D482817.7090407@trash.net> <alpine.DEB.2.00.1102012002430.24267@blackhole.kfki.hu> <alpine.DEB.2.00.1102012154130.24580@blackhole.kfki.hu> <alpine.DEB.2.00.1102012225080.24657@blackhole.kfki.hu> <4D48FEC6.5080701@trash.net> <alpine.DEB.2.00.1102022044440.29552@blackhole.kfki.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org,
	Pablo Neira Ayuso <pablo@netfilter.org>
To: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:44495 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755268Ab1BBW46 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 2 Feb 2011 17:56:58 -0500
In-Reply-To: <alpine.DEB.2.00.1102022044440.29552@blackhole.kfki.hu>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Am 02.02.2011 20:46, schrieb Jozsef Kadlecsik:
> netfilter: ipset: send error message manually
> 
> When a message carries multiple commands and one of them triggers
> an error, we have to report to the userspace which one was that.
> The line number of the command plays this role and there's an attribute
> reserved in the header part of the message to be filled out with the error
> line number. In order not to modify the original message received from
> the userspace, we construct a new, complete netlink error message and
> modifies the attribute there, then send it.
> Netlink is notified not to send its ACK/error message.

Applied, thanks Jozsef.
