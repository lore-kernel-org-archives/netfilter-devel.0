From: Jan Engelhardt <jengelh@medozas.de>
Subject: Re: [question] ipt_CLUSTERIP and address length
Date: Thu, 25 Feb 2010 12:04:23 +0100 (CET)
Message-ID: <alpine.LSU.2.01.1002251201360.4362@obet.zrqbmnf.qr>
References: <20100225101257.GC2667@psychotron.lab.eng.brq.redhat.com> <4B864F9A.90207@trash.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Jiri Pirko <jpirko@redhat.com>, netfilter-devel@vger.kernel.org,
	coreteam@netfilter.org, netfilter@vger.kernel.org
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from borg.medozas.de ([188.40.89.202]:51199 "EHLO borg.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753443Ab0BYLEZ (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 25 Feb 2010 06:04:25 -0500
In-Reply-To: <4B864F9A.90207@trash.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


On Thursday 2010-02-25 11:23, Patrick McHardy wrote:
>Jiri Pirko wrote:
>> Hi all.
>> 
>> I want to ask if there is any particular reason for ipt_CLUSTERIP
>> to support only address length of 6 (ETH_ALEN)? It seems to me
>> reasonable for this to work even with another types of network hw
>> with different addr_len.
>
>None that I'm aware of, but the length is also used in the ABI,
>so you presently can't supply larger addresses.

The larger picture is that there seems to be quite a bit of ABI
even outside of the kernel that uses ETH_ALEN and/or ETH_HLEN
in many places; for example, the tcpdump cooked interface IIRC.

Is there an _actual_ use case however? Is it suddenly possible
to use EUI-64s? Or a run on IPX? :-)
