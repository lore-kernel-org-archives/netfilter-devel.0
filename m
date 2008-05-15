From: Patrick McHardy <kaber@trash.net>
Subject: Re: iptables performance and alternatives
Date: Thu, 15 May 2008 15:46:36 +0200
Message-ID: <482C3EBC.8090301@trash.net>
References: <200805151421.23862.anton.vazir@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel <netfilter-devel@vger.kernel.org>
To: Anton <anton.vazir@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:41976 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752396AbYEONrn (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 15 May 2008 09:47:43 -0400
In-Reply-To: <200805151421.23862.anton.vazir@gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Anton wrote:
> Regarding the performance of the lookup of the iptables 
> rules for match inside the kernel, is there any plans to 
> improve the behaviour or no plans in this area yet?
>
> For example on the transit gateway I have ~500 rules which 
> mark the packet, according to the client source IP - with 
> unique mark per client IP - so I have 500 unique marks 
> there, and so cannot use IPSET, and only IPTABLES - but 
> it's known that iptables insert/lookup is very slow on huge 
> rulesets (atleat with iptables 1.3.x) and slowness 
> progresses approximatelly exponentially on growth of rules 
> number.
>
> Do I miss anything?

Use conntrack to avoid doing the full lookup for every packet.

I'm working on improving things, its slowly progressing.
The successor of iptablse will use netlink, so it will be
able to insert and delete single rules without having to
transfer the entire ruleset again and again. Additionally
it natively supports sets, bitmaps and hashes, so your
500 source IP rules can be represented as a single rule
with, depending on how the IPs are distributed, either
O(1) or O(n) lookup time.

Its unfortunately still not in a publishable state, my
current plan is to have something for other people to
play with and work on by the next workshop. Maybe even
sooner.


