From: Patrick McHardy <kaber@trash.net>
Subject: Re: debugging kernel during packet drops
Date: Mon, 22 Mar 2010 18:16:08 +0100
Message-ID: <4BA7A5D8.5080101@trash.net>
References: <4BA74950.6000305@infopact.nl>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: Jorrit Kronjee <j.kronjee@infopact.nl>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:39557 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752494Ab0CVRQJ (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 22 Mar 2010 13:16:09 -0400
In-Reply-To: <4BA74950.6000305@infopact.nl>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Jorrit Kronjee wrote:
> Dear list,
>
> I've asked this question on the kernelnewbies forum, but I haven't got
> any responses. I hope someone here is able to help me. I'm trying to
> build a setup that allows me to limit the amount of packets/s per
> destination IP address. The setup I use for this is as follows: 
>
> [ DoS machine ] -> [ bridging firewall ] -> [ receiving network ] 
>
> I used brctl to build the bridge. The DoS machine has a custom built
> tool that allows me to send small packets at very fast rates. I've
> discovered that bridging still works reliably at around 300 kpackets/s
> (notice the 'k' in there). However, as said before, I was trying to
> limit the amount of packets/s, so I used netfilter's hashlimit module.
> This is when packet drops started to appear. 
>
> At around 300 kpps, the amount of packet drops is 40 kpps. For me, this
> amount is too significant to ignore. I see the load average go from a
> comfortable 0.00 to 1.78, mainly caused by ksoftirqd processes. At 200
> kpps, the average amount of packet drops is 23 kpps. At 100 kpps, it's
> still 2 kpps. 
>
> When I disable the hashlimit module the packet drops disappear again.
> Now I know that hashlimit is made for more than one thing, namely
> limiting packets based on source/destination host and source/destination
> port, so it's not as efficient as it could be for my purposes. I could
> rewrite it, but before I do that, I would like to know if the module
> itself is really what's causing it, or if there's some underlying cause
> that I'm not seeing. So my question in short: how can I discover why
> it's dropping packets? 
>   

A couple of suggestions:

- try the limit module in case you don't actually need per-source/dest etc.
  limiting but just a global limit

- try using TBF or ingress policing. Both limit and hashlimit suffer of
problems
  regarding the resolution of the applied TBF. I don't remember the
exact range
  of values it is able to handle, but IIRC you should be able to find it
in the
  netfilter bugzilla.

- if you use TBF or ingress policing and don't need ip_tables specific
modules,
  disabling bridge netfilter invocation of ip_tables through /proc
should increase
  performance.

