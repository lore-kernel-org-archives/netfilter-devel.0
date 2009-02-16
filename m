From: Patrick McHardy <kaber@trash.net>
Subject: Re: Netfilter API and libiptc
Date: Mon, 16 Feb 2009 15:08:01 +0100
Message-ID: <49997341.1060907@trash.net>
References: <20090205141722.GB21417@qubit> <4990636B.9080900@trash.net> <20090209183941.GA1050@zenon.in.qult.net> <Pine.LNX.4.64.0902111408210.4822@ask.diku.dk> <4992E2B3.3030009@trash.net> <alpine.LSU.2.00.0902111656400.22845@fbirervta.pbzchgretzou.qr> <4993AFF9.9010002@trash.net> <alpine.LSU.2.00.0902120640480.32504@fbirervta.pbzchgretzou.qr> <4993BA81.8030404@trash.net> <Pine.LNX.4.64.0902161402280.27418@ask.diku.dk> <Pine.LNX.4.64.0902161425020.27721@ask.diku.dk>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Jan Engelhardt <jengelh@medozas.de>, Ignacy Gawedzki <i@lri.fr>,
	Netfilter Developers <netfilter-devel@vger.kernel.org>
To: Jesper Dangaard Brouer <hawk@diku.dk>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:59061 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757858AbZBPOIF (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 16 Feb 2009 09:08:05 -0500
In-Reply-To: <Pine.LNX.4.64.0902161425020.27721@ask.diku.dk>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Jesper Dangaard Brouer wrote:
> On Mon, 16 Feb 2009, Jesper Dangaard Brouer wrote:
> 
>> Hi Patrick,
>>
>> Would you please consider the libiptc shared library patch for inclusion?
>> I don't find the patch intrusive.  I have tested it and it works.
>>
>> See patch below...
> 
> Ups, that patch would not apply cleanly to the latest git (commit 
> 5dd19de34380).  Trivial diff conflict on Makefile.am (due to ae19604f 
> "build: remove unneeded -ldl from iptables_xml_LDADD")
> 
> There is a clean version:
> 
>> From 4a1c3f3e56a2039b87636d3d2d8517933c47b517 Mon Sep 17 00:00:00 2001
> From: Jan Engelhardt <jengelh@medozas.de>
> Date: Wed, 11 Feb 2009 16:40:29 +0100
> Subject: [PATCH 1/1] libiptc: make library available as a shared library

No objections from my side. Jan, do you consider this patch ready
for inclusion?
