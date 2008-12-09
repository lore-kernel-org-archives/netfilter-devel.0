From: Jan Engelhardt <jengelh@medozas.de>
Subject: Re: iptables-save: output ! in position according to manpage
Date: Tue, 9 Dec 2008 17:22:26 +0100 (CET)
Message-ID: <alpine.LNX.1.10.0812091720420.5803@fbirervta.pbzchgretzou.qr>
References: <alpine.LNX.1.10.0812081815510.2016@fbirervta.pbzchgretzou.qr> <493E7B80.2060504@trash.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Netfilter Developer Mailing List
	<netfilter-devel@vger.kernel.org>, max@duempel.org
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:56392 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752753AbYLIQW3 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 9 Dec 2008 11:22:29 -0500
In-Reply-To: <493E7B80.2060504@trash.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


On Tuesday 2008-12-09 15:06, Patrick McHardy wrote:
> Jan Engelhardt wrote:
>> commit 0e874f0223d047bcb2c125a701e15b9e8af39106
>> Author: Jan Engelhardt <jengelh@medozas.de>
>> Date:   Mon Dec 8 18:16:10 2008 +0100
>> 
>> iptables-save: output ! in position according to manpage
>
> Applied, thanks. Lets hope the parsing also works as specified
> in the manpage :)
>
It does. Extrapositional ! parsing is done in xtables.c
or thereabouts and has worked for years.
