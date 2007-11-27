From: Jan Engelhardt <jengelh@computergmbh.de>
Subject: Re: [RFC][PATCH] Per-conntrack timeout target v3
Date: Wed, 28 Nov 2007 00:34:31 +0100 (CET)
Message-ID: <Pine.LNX.4.64.0711280033300.4181@fbirervta.pbzchgretzou.qr>
References: <20071127190745.GA2080@linuxace.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel@vger.kernel.org
To: Phil Oester <kernel@linuxace.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:36598 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756876AbXK0Xec (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 27 Nov 2007 18:34:32 -0500
In-Reply-To: <20071127190745.GA2080@linuxace.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org


On Nov 27 2007 11:07, Phil Oester wrote:
>
>I use a fairly short 2 hour established timeout on firewalls I operate,
>which works fine for most purposes.  Occasionally, however, it would
>be nice to have a longer timeout for *certain* types of traffic
>such as SSH or telnet sessions.  
>
>So, below find a TIMEOUT target to enable such per-conntrack timeouts.
>Syntax for SSH would be something like:
>
>        iptables -A foo -p tcp --dport 22 -j TIMEOUT --timeout 123456
>        iptables -A foo -p tcp --dport 22 -j ACCEPT
>
>It could of course also be used to lower the timeouts on some traffic,
>such as HTTP.
>

Considering TCP only...

If my firewall allows 'NEW' connections (-m conntrack --ctstate NEW) on
non-SYN packets, what good will xt_TIMEOUT do? If the ct entry times out,
a new one will be created once the next packet flows.
