From: Jan Engelhardt <jengelh@medozas.de>
Subject: Re: Netfilter API and libiptc
Date: Mon, 16 Feb 2009 17:52:43 +0100 (CET)
Message-ID: <alpine.LSU.2.00.0902161749110.26651@fbirervta.pbzchgretzou.qr>
References: <20090205141722.GB21417@qubit> <4990636B.9080900@trash.net> <20090209183941.GA1050@zenon.in.qult.net> <Pine.LNX.4.64.0902111408210.4822@ask.diku.dk> <4992E2B3.3030009@trash.net> <alpine.LSU.2.00.0902111656400.22845@fbirervta.pbzchgretzou.qr>
 <4993AFF9.9010002@trash.net> <alpine.LSU.2.00.0902120640480.32504@fbirervta.pbzchgretzou.qr> <4993BA81.8030404@trash.net> <Pine.LNX.4.64.0902161402280.27418@ask.diku.dk> <Pine.LNX.4.64.0902161425020.27721@ask.diku.dk> <49997341.1060907@trash.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Jesper Dangaard Brouer <hawk@diku.dk>, Ignacy Gawedzki <i@lri.fr>,
	Netfilter Developers <netfilter-devel@vger.kernel.org>
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:40942 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752644AbZBPQwp (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 16 Feb 2009 11:52:45 -0500
In-Reply-To: <49997341.1060907@trash.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


On Monday 2009-02-16 15:08, Patrick McHardy wrote:
>>> From 4a1c3f3e56a2039b87636d3d2d8517933c47b517 Mon Sep 17 00:00:00 2001
>> From: Jan Engelhardt <jengelh@medozas.de>
>> Date: Wed, 11 Feb 2009 16:40:29 +0100
>> Subject: [PATCH 1/1] libiptc: make library available as a shared library
>
> No objections from my side. Jan, do you consider this patch ready
> for inclusion?
>
Very much so. You can just grab it from the 'iptc' branch at

	git://dev.medozas.de/iptables iptc

I added Jesper's tested-by tag and rebased (so it moved,
 + c102d69...51bc836 iptc -> iptc (forced update))
