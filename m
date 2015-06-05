From: Daniel Collins <daniel.collins@smoothwall.net>
Subject: Re: Possible bug when bridging traffic we just SNATed and sent to
 another router
Date: Fri, 5 Jun 2015 15:49:20 +0100
Message-ID: <CAOmdcgVx6=3imz09QNW0eKU8Go=wZDHcWiKC8k2ki__af+rbAQ@mail.gmail.com>
References: <CAOmdcgX+niENv18DKyn8BVZfwhYXmNcBCBoHVnrsEYWEJTtrhg@mail.gmail.com>
	<20150605143542.GH11015@breakpoint.cc>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: netfilter-devel@vger.kernel.org
To: Florian Westphal <fw@strlen.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from exprod7og116.obsmtp.com ([64.18.2.219]:48189 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S932859AbbFEOtX (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 5 Jun 2015 10:49:23 -0400
Received: by wibut5 with SMTP id ut5so23667701wib.1
        for <netfilter-devel@vger.kernel.org>; Fri, 05 Jun 2015 07:49:21 -0700 (PDT)
In-Reply-To: <20150605143542.GH11015@breakpoint.cc>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

+----+   +----+
| R1 |   | R2 |
+----+   +----+
   |       |
+-------------+
| eth0   eth1 |
|   \     /   |
|    \   /    |
|     br0     |
+-------------+

So, the Linux box at the bottom attempts to route a packet from itself
using R1, but R1 forwards the packet on to R2, at which point Linux
creates a new conntrack and rewrites the port number as it passes over
the bridge since that particular IP/port combination was already in
use, by the first conntrack.

Does that make it clearer?

On 5 June 2015 at 15:35, Florian Westphal <fw@strlen.de> wrote:
> Daniel Collins <daniel.collins@smoothwall.net> wrote:
>> Hi
>>
>> We have encountered problems when attempting to bridge packets that we
>> just sent, then saw a second time as the receiving router forwarded
>> them to another router attached to a different bridge port.
>
> I have no idea what that means.
> -v please.
>
>> This only occurs when SNAT was used on the original connection, this
>> seems to prevent the original conntrack entry from being used for the
>> bridged packet,
>
> Uhh.. what?
> Not following, sorry :-/
>
>> instead creating a new one for them, our router's
>
> If a new conntrack is created, then the skb did not (yet) have a conntrack
> entry or something has caused the conntrack to be destroyed/discarded.
>
> The latter typically happens with veth, or other
> virtualization/container use cases where skb_scrub_packet() is called.
>
>> router then sends the replies directly to us (as you'd expect), but
>> Linux only undoes the first layer of NAT and then discards the packet
>> since a local socket for it doesn't exist.
>
> again, no idea what that means.  Please explain in more detail or
> provide some graph that describes what is connected where, how the
> routing happens and where bridge(s) are sitting.

-- 
Daniel Collins
Software Developer

smoothwall
daniel.collins@smoothwall.com
www.smoothwall.com

Head Office : 1 John Charles Way, Leeds, LS12 6QA, United Kingdom
Tech Office : Eagle Point, Little Park Farm Road, Fareham, PO15 5TD,
United Kingdom
US Office : 8008 Corporate Center Dr #410, Charlotte, NC 28226, United States

Telephone: UK: +44 870-199-9500 US: +1 800-959-3760

Smoothwall Limited is registered in England, Company Number: 4298247
and whose registered address is 1 John Charles Way, Leeds, LS12 6QA
United Kingdom.
