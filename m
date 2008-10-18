From: Patrick McHardy <kaber@trash.net>
Subject: Re: netfilter: use NFPROTO_* constants in NF_HOOK callsites
Date: Sat, 18 Oct 2008 18:13:13 +0200
Message-ID: <48FA0B19.4030300@trash.net>
References: <20081016012451.6126.34071.stgit@Decadence> <alpine.LNX.1.10.0810152126380.28060@fbirervta.pbzchgretzou.qr> <48F69EF2.5000104@netfilter.org> <alpine.LNX.1.10.0810152201290.28060@fbirervta.pbzchgretzou.qr> <48F72B07.1040706@trash.net> <48F72BE8.80602@netfilter.org> <alpine.LNX.1.10.0810170948050.30268@fbirervta.pbzchgretzou.qr> <alpine.LNX.1.10.0810171043520.30268@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Pablo Neira Ayuso <pablo@netfilter.org>,
	Netfilter Developer Mailing List
	<netfilter-devel@vger.kernel.org>
To: Jan Engelhardt <jengelh@medozas.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:37420 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750824AbYJRQNT (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 18 Oct 2008 12:13:19 -0400
In-Reply-To: <alpine.LNX.1.10.0810171043520.30268@fbirervta.pbzchgretzou.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Jan Engelhardt wrote:
> commit cc3e81cbbc8a6977cfe614286de16020f9efa3c6
> Author: Jan Engelhardt <jengelh@medozas.de>
> Date:   Fri Oct 17 10:02:30 2008 -0400
> 
> netfilter: use NFPROTO_* constants in NF_HOOK callsites

This is missing arp, the only place that would qualify as bugfix.
Please resubmit and add a changelog that explains that is actually
fixes something.
