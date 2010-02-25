From: Jan Engelhardt <jengelh@medozas.de>
Subject: Re: [question] ipt_CLUSTERIP and address length
Date: Thu, 25 Feb 2010 13:05:06 +0100 (CET)
Message-ID: <alpine.LSU.2.01.1002251301500.11377@obet.zrqbmnf.qr>
References: <20100225101257.GC2667@psychotron.lab.eng.brq.redhat.com> <4B864F9A.90207@trash.net> <alpine.LSU.2.01.1002251201360.4362@obet.zrqbmnf.qr> <20100225113751.GD2667@psychotron.lab.eng.brq.redhat.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Patrick McHardy <kaber@trash.net>, netfilter-devel@vger.kernel.org,
	coreteam@netfilter.org, netfilter@vger.kernel.org
To: Jiri Pirko <jpirko@redhat.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from borg.medozas.de ([188.40.89.202]:36248 "EHLO borg.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758977Ab0BYMFH (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 25 Feb 2010 07:05:07 -0500
In-Reply-To: <20100225113751.GD2667@psychotron.lab.eng.brq.redhat.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


On Thursday 2010-02-25 12:37, Jiri Pirko wrote:
>>
>>Is there an _actual_ use case however? Is it suddenly possible
>>to use EUI-64s? Or a run on IPX? :-)
>
>Well for example Infiniband has 20-bytes address. But I do not know much about
>this kinds of hw & iptables use. I'm just looking at code and wondering :)

First have IPv4/v6 running over InfiniBand, then we can talk ;-)

I did something like that once, but what it came down to was that
an Ethernet layer was inserted between Myrinet and IPv4.
(`ip link` will show.)
