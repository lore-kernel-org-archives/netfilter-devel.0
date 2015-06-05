From: Florian Westphal <fw@strlen.de>
Subject: Re: Possible bug when bridging traffic we just SNATed and sent to
 another router
Date: Fri, 5 Jun 2015 16:35:42 +0200
Message-ID: <20150605143542.GH11015@breakpoint.cc>
References: <CAOmdcgX+niENv18DKyn8BVZfwhYXmNcBCBoHVnrsEYWEJTtrhg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Daniel Collins <daniel.collins@smoothwall.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([80.244.247.6]:38525 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S964774AbbFEOfn (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 5 Jun 2015 10:35:43 -0400
Content-Disposition: inline
In-Reply-To: <CAOmdcgX+niENv18DKyn8BVZfwhYXmNcBCBoHVnrsEYWEJTtrhg@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Daniel Collins <daniel.collins@smoothwall.net> wrote:
> Hi
> 
> We have encountered problems when attempting to bridge packets that we
> just sent, then saw a second time as the receiving router forwarded
> them to another router attached to a different bridge port.

I have no idea what that means.
-v please.

> This only occurs when SNAT was used on the original connection, this
> seems to prevent the original conntrack entry from being used for the
> bridged packet,

Uhh.. what?
Not following, sorry :-/

> instead creating a new one for them, our router's

If a new conntrack is created, then the skb did not (yet) have a conntrack
entry or something has caused the conntrack to be destroyed/discarded.

The latter typically happens with veth, or other
virtualization/container use cases where skb_scrub_packet() is called.

> router then sends the replies directly to us (as you'd expect), but
> Linux only undoes the first layer of NAT and then discards the packet
> since a local socket for it doesn't exist.

again, no idea what that means.  Please explain in more detail or
provide some graph that describes what is connected where, how the
routing happens and where bridge(s) are sitting.
