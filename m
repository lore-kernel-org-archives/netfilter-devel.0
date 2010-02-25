From: Jiri Pirko <jpirko@redhat.com>
Subject: Re: [question] ipt_CLUSTERIP and address length
Date: Thu, 25 Feb 2010 12:37:52 +0100
Message-ID: <20100225113751.GD2667@psychotron.lab.eng.brq.redhat.com>
References: <20100225101257.GC2667@psychotron.lab.eng.brq.redhat.com>
 <4B864F9A.90207@trash.net>
 <alpine.LSU.2.01.1002251201360.4362@obet.zrqbmnf.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Patrick McHardy <kaber@trash.net>, netfilter-devel@vger.kernel.org,
	coreteam@netfilter.org, netfilter@vger.kernel.org
To: Jan Engelhardt <jengelh@medozas.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:8382 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759286Ab0BYLiL (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 25 Feb 2010 06:38:11 -0500
Content-Disposition: inline
In-Reply-To: <alpine.LSU.2.01.1002251201360.4362@obet.zrqbmnf.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Thu, Feb 25, 2010 at 12:04:23PM CET, jengelh@medozas.de wrote:
>
>On Thursday 2010-02-25 11:23, Patrick McHardy wrote:
>>Jiri Pirko wrote:
>>> Hi all.
>>> 
>>> I want to ask if there is any particular reason for ipt_CLUSTERIP
>>> to support only address length of 6 (ETH_ALEN)? It seems to me
>>> reasonable for this to work even with another types of network hw
>>> with different addr_len.
>>
>>None that I'm aware of, but the length is also used in the ABI,
>>so you presently can't supply larger addresses.
>
>The larger picture is that there seems to be quite a bit of ABI
>even outside of the kernel that uses ETH_ALEN and/or ETH_HLEN
>in many places; for example, the tcpdump cooked interface IIRC.

Hmm, thats sad :( IMHO this should be ETH independent...

>
>Is there an _actual_ use case however? Is it suddenly possible
>to use EUI-64s? Or a run on IPX? :-)

Well for example Infiniband has 20-bytes address. But I do not know much about
this kinds of hw & iptables use. I'm just looking at code and wondering :)

Jirka
