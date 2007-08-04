From: "John Lumby" <johnlumby@hotmail.com>
Subject: Removal of ROUTE target - what now?
Date: Fri, 03 Aug 2007 21:28:14 -0400
Message-ID: <BAY137-F26BDAB7CC7FE589BFB7F4DA3EB0@phx.gbl>
References: <mailman.1626.1186193632.14817.netfilter-devel@lists.netfilter.org>
Mime-Version: 1.0
Content-Type: text/plain; format=flowed
To: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
In-Reply-To: <mailman.1626.1186193632.14817.netfilter-devel@lists.netfilter.org>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: </pipermail/netfilter-devel>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
Sender: netfilter-devel-bounces@lists.netfilter.org
Errors-To: netfilter-devel-bounces@lists.netfilter.org
List-Id: netfilter-devel.vger.kernel.org

I was a bit surprised to find this gone.      I have read and partially 
understood the recent discussion here about it but I would appreciate some 
help or pointer.

My use of ROUTE is very simple:

Given a P-t-P network interface , call it ppp1, with IPV4 addr a.b.c.d and 
P-t-P address p.q.r.s,
I want any packet with source address a.b.c.d to be routed via gateway 
p.q.r.s regardless of my current routing table.   (the routing table would 
send it through some other gateway).

iptables -t mangle -I POSTROUTING 1 -s a.b.c.d -j ROUTE --gw p.q.r.s

This has worked just fine on kernel 2.6.14 for about 18 months, and use of 
ROUTE target is so simple - just the one rule.

I accept what you say about the ROUTE implementation being "a hack and the 
proper solution to it is policy routing; e.g. based on fwmark."      I 
assume this requires (for my example) having multiple routing tables and so 
on.    I'm also not sure exactly how to do it.      I would really 
appreciate:

   .   if someone could either tell me fairly clearly how to do my 
application with mark and ip route or point to existing example
   .   there is some mention of someone maybe reinstating a fixed version of 
ROUTE - I'd very much like to know if that is happening, in which case I'll 
wait for it.
   ,  or - failing that, is it safe (enough)  to fall back to 
patch-o-matic-ng-20070729 and use its ROUTE?  (in iptables 1.38 and kernel 
2.6.20.9 or later)?

Thanks    John

_________________________________________________________________
Put Your Face In Your Space with Windows Live Spaces 
http://spaces.live.com/?mkt=en-ca
