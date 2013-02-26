From: Michael Zintakis <michael.zintakis@googlemail.com>
Subject: Re: iptables nfacct match question
Date: Tue, 26 Feb 2013 19:23:16 +0000
Message-ID: <512D0BA4.7060809@googlemail.com>
References: <51292D41.8000703@googlemail.com> <20130225154848.GA20609@localhost> <512BC79F.1070708@googlemail.com> <20130226135529.GA9526@localhost>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-la0-f52.google.com ([209.85.215.52]:34520 "EHLO
	mail-la0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932566Ab3BZTX5 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 26 Feb 2013 14:23:57 -0500
Received: by mail-la0-f52.google.com with SMTP id fs12so4203797lab.25
        for <netfilter-devel@vger.kernel.org>; Tue, 26 Feb 2013 11:23:56 -0800 (PST)
In-Reply-To: <20130226135529.GA9526@localhost>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>



Pablo Neira Ayuso wrote:
> Thanks for the explanation.
No problem.

> I think that, for most users, something
> like:
> 
>         nfacct list MiB
I can't speak for other people (it would be very foolish of me to do so on this occasion), but judging this from our own needs/experience, the traffic - both by type and volume - is quite different. One cannot simply shoe-horn all traffic under a single denominator and say "that's it" - it doesn't work like that.

> I'm still missing why different formatting according to the accounting
> object can be useful.
OK, I tried to explain this in my previous post, but if it wasn't clear I'll expand a bit further. 

Different types of traffic, by their very nature, have different volume requirements. At the "low" end, we have DNS and authentication-type traffic (think RADIUS for example), where the denomination needs to be pretty "low" - in KiB or even "plain bytes" range.

At the other end of that scale you have much higher volume of traffic (think HD video streaming for example or private customers running their own PBXs, taking video/voice calls in their thousands), where the denomination needs to be much higher - in the GiB or even TiB range in some circumstances.

Not to mention that we have our own internal measurements, where we combine the total traffic counters of whole subnets where that denomination goes much much higher that "GiB".

On top of all that, you have the traffic which could be quite unpredictable (think someone running, or connecting to, a private VPN server for example), hence the need for a "dynamic" denomination, depending on the volume of that traffic, which is what I implemented with the "iec" and "si" options.

Not to mention that in your example above, the chosen measurement (MiB) would also apply to packet counters - that isn't very appropriate, since packet counters are much lower (by order of magnitude!) compared to the packet length.

One cannot simply brush it aside and design a one-size-fits-all measurement and apply it. 

We've had this problem with the "old" iptables accounting and it is one of the reasons we moved on from that, because it simply wasn't flexible enough. What I did with nfacct provides for flexibility - it can be configured to fit quite a variety of scenarios and individual needs. I hope I've explained myself a bit better this time.


MZ
