From: Daniel Gibson <metalcaedes@gmail.com>
Subject: Re: TCPMSS clamp-mss-to-pmtu breaks packets that have no MSS set
 (incl. solution)
Date: Mon, 23 Aug 2010 03:45:02 +0200
Message-ID: <4C71D29E.9010404@gmail.com>
References: <4C522461.4070000@gmail.com>	<alpine.LSU.2.01.1008021714500.13406@obet.zrqbmnf.qr> <AANLkTim=BLAwLo_VXG1OJ=4ewL2joS_HyGh3SbW6KutC@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Nepenthes Development Team <nepenthesdev@gmail.com>,
	Jan Engelhardt <jengelh@medozas.de>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-ey0-f174.google.com ([209.85.215.174]:42827 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751488Ab0HWBpG (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 22 Aug 2010 21:45:06 -0400
Received: by eyg5 with SMTP id 5so2989962eyg.19
        for <netfilter-devel@vger.kernel.org>; Sun, 22 Aug 2010 18:45:05 -0700 (PDT)
In-Reply-To: <AANLkTim=BLAwLo_VXG1OJ=4ewL2joS_HyGh3SbW6KutC@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Nepenthes Development Team schrieb:
> Hi,
> 
> On Mon, Aug 2, 2010 at 5:16 PM, Jan Engelhardt <jengelh@medozas.de> wrote:
>> If a packet has no MSS option, none will be added no more.
>> (commit v2.6.34-rc1~233^2~154^2~44)
> 
> git log -1 -p v2.6.34-rc1~233^2~154^2~44
> 
> I found some changes to prevent setting an MSS if the SYN packet has a
> payload already, and to prevent it from increasing the MSS, but
> nothing to prevent if from setting the MSS if there was no MSS set
> before.
> 
> The code to add an MSS option if none exists still exists,
> http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=blob;f=net/netfilter/xt_TCPMSS.c;h=62ec021fbd50ddd278da5f9f53756587d83fb786;hb=HEAD#l116
> 
> 
> Markus
> --

Hi,

any news on this?

- Daniel
