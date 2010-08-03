From: Nepenthes Development Team <nepenthesdev@gmail.com>
Subject: Re: TCPMSS clamp-mss-to-pmtu breaks packets that have no MSS set
	(incl. solution)
Date: Tue, 3 Aug 2010 09:29:10 +0200
Message-ID: <AANLkTim=BLAwLo_VXG1OJ=4ewL2joS_HyGh3SbW6KutC@mail.gmail.com>
References: <4C522461.4070000@gmail.com>
	<alpine.LSU.2.01.1008021714500.13406@obet.zrqbmnf.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: netfilter-devel@vger.kernel.org
To: Jan Engelhardt <jengelh@medozas.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-ww0-f44.google.com ([74.125.82.44]:52116 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750879Ab0HCH3L (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 3 Aug 2010 03:29:11 -0400
Received: by wwj40 with SMTP id 40so4810282wwj.1
        for <netfilter-devel@vger.kernel.org>; Tue, 03 Aug 2010 00:29:10 -0700 (PDT)
In-Reply-To: <alpine.LSU.2.01.1008021714500.13406@obet.zrqbmnf.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi,

On Mon, Aug 2, 2010 at 5:16 PM, Jan Engelhardt <jengelh@medozas.de> wrote:
> If a packet has no MSS option, none will be added no more.
> (commit v2.6.34-rc1~233^2~154^2~44)

git log -1 -p v2.6.34-rc1~233^2~154^2~44

I found some changes to prevent setting an MSS if the SYN packet has a
payload already, and to prevent it from increasing the MSS, but
nothing to prevent if from setting the MSS if there was no MSS set
before.

The code to add an MSS option if none exists still exists,
http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=blob;f=net/netfilter/xt_TCPMSS.c;h=62ec021fbd50ddd278da5f9f53756587d83fb786;hb=HEAD#l116


Markus
