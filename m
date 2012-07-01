From: Neal Murphy <neal.p.murphy@alum.wpi.edu>
Subject: Re: [ANNOUNCE] ipset 6.13 released
Date: Sun, 1 Jul 2012 17:30:07 -0400
Message-ID: <201207011730.07810.neal.p.murphy@alum.wpi.edu>
References: <alpine.DEB.2.00.1206292201340.29738@blackhole.kfki.hu> <4FF04DDA.3020609@googlemail.com> <alpine.DEB.2.00.1207011646110.2749@blackhole.kfki.hu>
Reply-To: neal.p.murphy@alum.wpi.edu
Mime-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Cc: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>,
	Mr Dash Four <mr.dash.four@googlemail.com>,
	netfilter-devel@vger.kernel.org, Patrick McHardy <kaber@trash.net>
To: netfilter@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from MAIL1.WPI.EDU ([130.215.36.91]:37482 "EHLO MAIL1.WPI.EDU"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752649Ab2GAVaR (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 1 Jul 2012 17:30:17 -0400
In-Reply-To: <alpine.DEB.2.00.1207011646110.2749@blackhole.kfki.hu>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Sunday 01 July 2012 11:21:51 Jozsef Kadlecsik wrote:
> Feel free to involve anyone. Just to sum up: in the case of the
> net:hash,iface type of ipset, the manpage says
> 
> "The second direction parameter of the set match and SET target modules
> corresponds to the incoming/outgoing interface: src to the incoming one
> (similar to the -i flag of iptables), while dst to the outgoing one
> (similar to the -o flag of iptables)."
> 
> You argue that the meaning of src/dst for the interface part is
> counter-intuitieve and therefore must be reversed - regardless of the
> backward compatibility issue and the possible breaking of existing setups.

FWIW, I think the existing semantics are spot-on.
  - Where did this packet come from (what was its source)?
    It came from src IF eth0.
  - Where is this packet going (what is its destination)?
    It is going to dst IF eth3.

Picture yourself standing in the middle of a (shallow) river. By Mr. Dash 
Four's logic, upstream (where the water comes from) is the destination and 
downstream (where the water is going) is the source; it's rather non-sensical. 
A stream of packets, just like a stream of water, flows from its source toward 
its destination. (A pedant might say that to swap 'source' and 'destination' 
would be to pervert language. And language is about the only thing we can use 
to communicate.)

Perhaps it would help to view netfilter as a small wayside in the universe of 
IPv[46], rather than the center of that universe.
