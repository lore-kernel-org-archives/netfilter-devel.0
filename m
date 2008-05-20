From: Jan Engelhardt <jengelh@medozas.de>
Subject: Re: netfilter moving to git
Date: Wed, 21 May 2008 00:39:15 +0200 (CEST)
Message-ID: <alpine.LNX.1.10.0805210031520.15136@fbirervta.pbzchgretzou.qr>
References: <48299680.7020808@trash.net> <alpine.LNX.1.10.0805131614570.448@fbirervta.pbzchgretzou.qr> <4829A316.2080402@trash.net> <alpine.LNX.1.10.0805170930120.15590@fbirervta.pbzchgretzou.qr> <482F938D.3060405@trash.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Netfilter Development Mailinglist
	<netfilter-devel@vger.kernel.org>
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:39494 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935114AbYETWjR (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 20 May 2008 18:39:17 -0400
In-Reply-To: <482F938D.3060405@trash.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


On Sunday 2008-05-18 04:25, Patrick McHardy wrote:
> Jan Engelhardt wrote:
>> And the log difference you can see in
>> http://dev.medozas.de/files/.iptables-xtables.txt
>> I suggest you take a look.
>
> The committer and author name fixups certainly look nicer,

well would you accept a script that filters the repository
to put proper committer/author in place?

> things like:
>
> -    Installs libxt_*.so to DEST_IPT_LIBIDR and link libip[6]t_*.so to it.
> +    Install libxt_*.so to DEST_IPT_LIBIDR and link libip[6]t_*.so to it
>
> are not good because they make it harder to find discussions that
> happend before a patch was committed.

If you could pick another log message to demonstrate that it's bad--
here, it's just an "s", for a patch that afaicr was not really
posted anyway.
Also, [patch N/M] is stripped from subjects for good practice,
because that is how lkml does it. In nf-land, that seems to have
slipped in again and again :(
