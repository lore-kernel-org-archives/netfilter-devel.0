From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH resend 1/2] Adds ebt_nflog watcher to kernel.
Date: Wed, 27 Feb 2008 01:46:22 +0100
Message-ID: <47C4B2DE.4060803@netfilter.org>
References: <20080205185521.051763000@andrew.endian.com>	 <20080205185617.732255000@andrew.endian.com> <47BD86EF.7060809@trash.net>	 <47C34933.8000301@endian.com> <1203981841.2959.6.camel@localhost.localdomain> <47C37E75.2080803@trash.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: Bart De Schuymer <bdschuym@pandora.be>,
	Peter Warasin <peter@endian.com>,
	netfilter-devel@vger.kernel.org,
	ebtables-devel@lists.sourceforge.net
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:51338 "EHLO us.es"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1765357AbYB0Aqa (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 26 Feb 2008 19:46:30 -0500
In-Reply-To: <47C37E75.2080803@trash.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Patrick McHardy wrote:
> Bart De Schuymer wrote:
>> Op di, 26-02-2008 te 00:03 +0100, schreef Peter Warasin:
>>> Hi
>>>
>>> Patrick McHardy wrote:
>>>> Peter Warasin wrote:
>>>>  > This patch adds the ebtables nflog watcher to the
>>>>  > kernel
>>>> This seems mostly fine to me. A few minor comments:
>>>> If you'll resend the patch based on net-2.6.26 I'll queue it
>>>> if Bart has no objections.
>>> I re-based on net-2.6.26 and changed what you mentioned.
>>> Patch is attached
>>
>> It looks fine, I'm just wondering what the flags and the pad in struct
>> ebt_nflog_info are for...
> 
> Both have their origin in NFLOG.
> 
> The flags were intended for something I still want to add, a reliable
> log mode where packets are dropped when netlink transmission or
> memory allocation fails.

Not really related with the main thread of the discussion. I thought of
something similar for the conntrack events, however, I'd like to have
some numbers on the maximum throughput reached if we apply such reliable
netlink transmission based on packet dropping under stress situations :).

-- 
"Los honestos son inadaptados sociales" -- Les Luthiers
