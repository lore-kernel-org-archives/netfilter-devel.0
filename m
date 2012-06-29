From: "Hans Schillstrom" <hans@schillstrom.com>
Subject: Re: IPv6 fragment packet handling
Date: Fri, 29 Jun 2012 07:39:33 +0200 (CEST)
Message-ID: <mdaatbj.bdeb64c148150d7fd1aaac58d00da780@obelix.schillstrom.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="utf-8"
Content-Transfer-Encoding: 8BIT
Cc: netfilter-devel@vger.kernel.org
To: "Kristof Provost" <kristof@sigsegv.be>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp-gw21.han.skanova.net ([81.236.55.21]:56289 "EHLO
	smtp-gw21.han.skanova.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750840Ab2F2Fjg convert rfc822-to-8bit (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 29 Jun 2012 01:39:36 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

>
>I've noticed an annoying difference between IPv4 and IPv6 regarding
>fragmented packet handling.
>The IPv4 netfilter code defragments packets before the hit the filter
>table, but the IPv6 code does not.
>
>As a result the following means that the host won't receive fragmented 
>ICMPv6 echo packets (for example ping6 -s 3000 <host>):
>
>ip6tables -F INPUT
>ip6tables -I INPUT -p icmpv6 -m icmp6 --icmpv6-type 128 -j ACCEPT
>ip6tables -P INPUT DROP
>
>The first fragment makes it through (hitting the icmpv6 rule), but
>subsequent fragments are dropped.
>In the IPv4 case the packet does make it through. 'iptables -L INPUT
>-vn' then shows that the ICMP rule hit one packet for about 3000 bytes.
>
>Am I missing something obvious? Is there a reason for this difference?

There is a big difference between IPv4 & IPv6 
RFC2460 ch 4.5
"(Note: unlike IPv4, fragmentation in IPv6 is performed only by source nodes, 
   not by routers along a packet's delivery path -- see section 5.)"

This creates some limitations of what we can do...

I have played around with this for a while by using nfct_reasm.
ex in ipvs for handling frag (not ready yet)

I have made some patches (not submitted yet) for tcp & udp that
looks for "nfct_reasm" and if it's there use it.

Maybe it's time for a  RFC ...
In general:
Fragments and ip6tables don't do what people think it does.



