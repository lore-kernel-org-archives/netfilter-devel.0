From: Jan Engelhardt <jengelh@computergmbh.de>
Subject: Re: NF [PATCH 3/4] xt_TCPOPTSTRIP
Date: Mon, 26 Nov 2007 17:19:04 +0100 (CET)
Message-ID: <Pine.LNX.4.64.0711261718440.22369@fbirervta.pbzchgretzou.qr>
References: <Pine.LNX.4.64.0711252004220.9477@fbirervta.pbzchgretzou.qr>
 <Pine.LNX.4.64.0711252006330.9477@fbirervta.pbzchgretzou.qr>
 <474A74C5.8050609@trash.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Netfilter Developer Mailing List
	<netfilter-devel@vger.kernel.org>,
	Sven Schnelle <svens@bitebene.org>
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:33811 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756879AbXKZQTF (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 26 Nov 2007 11:19:05 -0500
In-Reply-To: <474A74C5.8050609@trash.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org


On Nov 26 2007 08:24, Patrick McHardy wrote:
> Jan Engelhardt wrote:
>> Netfilter: Import xt_TCPOPTSTRIP
>> 
>> Originally from Sven Schnelle.
>> xt_TCPOPTSTRIP can strip TCP options from TCP packets, for example,
>> to disable Selective ACK or Window scaling.
>
> I already have this queued. Will push upstream soon so you
> can work against the current tree.
>
If you quilt/stgit, just replace the patch.
