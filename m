From: Henrik Nordstrom <hno@marasystems.com>
Subject: Re: tc filtering vs iptables
Date: Sat, 28 Aug 2004 09:08:40 +0200 (CEST)
Sender: netfilter-devel-bounces@lists.netfilter.org
Message-ID: <Pine.LNX.4.61.0408280855001.17572@filer.marasystems.com>
References: <1093614389.1068.20.camel@jzny.localdomain>
	<Pine.LNX.4.61.0408271751360.32691@filer.marasystems.com>
	<1093632324.14188.2.camel@jzny.localdomain>
	<20040827201137.GB9274@ti64.telemetry-investments.com>
	<1093638474.14190.29.camel@jzny.localdomain>
	<Pine.LNX.4.61.0408280154210.10193@filer.marasystems.com>
	<1093656940.1078.25.camel@jzny.localdomain>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: jamal <hadi@cyberus.ca>
In-Reply-To: <1093656940.1078.25.camel@jzny.localdomain>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: </pipermail/netfilter-devel>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
Errors-To: netfilter-devel-bounces@lists.netfilter.org
List-Id: netfilter-devel.vger.kernel.org

On Sat, 27 Aug 2004, jamal wrote:

> A single web server (TCP port 80) connected to by upto 64K different
> clients.
> The reason i chose this simple setup is because i can plot its lookups
> easily and write simple scripts to install rules.
> So end goal: stash many rules in both u32 and iptables and check
> results.

This test case is an exact match for using ippool/ipset. You then stash 
all the client IP addresses into the pool and use a single iptable rule 
with very good performance mostly independent on the number of IP 
addresses.

iptables -d ip.of.web.server -p tcp --dport -m pool --srcpool webserver -j ACCEPT
iptables -d ip.of.web.server -p tcp --dport -m pool -j REJECT

> In this example setup src IP and src TCP port are always looked up in
> the case of u32 and only when a match happens are the packets let
> through - by default they are dropped. In the case of iptables, only the
> src IP is looked up (didnt wanna add any overhead).

The overhead of looking up the destination ip and tcp port is minimal. Can 
easily be done at the head of your lookup tree

iptables -d ip.of.web.server -p tcp --dport 80 -j WEBSERVER

then have the match tree for the client source IP addresses in WEBSERVER. 
Remember to terminate each subchain with a REJECT/DROP in case there is no 
match.

> While all that traffic is being sent add then delete a totaly unrelated
> rule. Two metrics:
> 1) what packet rates are observed during add/del?

With iptables there should not be much difference, except that the higher 
the packet load the slower the change take.

If you use ippool then the overhead of this operation is considerably 
less.

> 2) how many times/sec can you do this? (essentially this could be used
> to simulate opening and closing peepholes maybe even in a midcom kind
> environment)
>
> I will present my results at SUCON.

Looking forward to see your results.



How do you optimize this kind of lookups using u32?


Regards
Henrik
