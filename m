From: jamal <hadi@cyberus.ca>
Subject: Re: tc filtering vs iptables
Date: 28 Aug 2004 07:19:32 -0400
Sender: netfilter-devel-bounces@lists.netfilter.org
Message-ID: <1093691971.1077.56.camel@jzny.localdomain>
References: <1093614389.1068.20.camel@jzny.localdomain>
	<Pine.LNX.4.61.0408271751360.32691@filer.marasystems.com>
	<1093632324.14188.2.camel@jzny.localdomain>
	<20040827201137.GB9274@ti64.telemetry-investments.com>
	<1093638474.14190.29.camel@jzny.localdomain>
	<Pine.LNX.4.61.0408280154210.10193@filer.marasystems.com>
	<1093656940.1078.25.camel@jzny.localdomain>
	<Pine.LNX.4.61.0408280855001.17572@filer.marasystems.com>
Reply-To: hadi@cyberus.ca
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Henrik Nordstrom <hno@marasystems.com>
In-Reply-To: <Pine.LNX.4.61.0408280855001.17572@filer.marasystems.com>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: </pipermail/netfilter-devel>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
Errors-To: netfilter-devel-bounces@lists.netfilter.org
List-Id: netfilter-devel.vger.kernel.org

On Sat, 2004-08-28 at 03:08, Henrik Nordstrom wrote:
> On Sat, 27 Aug 2004, jamal wrote:
> 
> > A single web server (TCP port 80) connected to by upto 64K different
> > clients.
> > The reason i chose this simple setup is because i can plot its lookups
> > easily and write simple scripts to install rules.
> > So end goal: stash many rules in both u32 and iptables and check
> > results.
> 
> This test case is an exact match for using ippool/ipset. You then stash 
> all the client IP addresses into the pool and use a single iptable rule 
> with very good performance mostly independent on the number of IP 
> addresses.
> 
> iptables -d ip.of.web.server -p tcp --dport -m pool --srcpool webserver -j ACCEPT
> iptables -d ip.of.web.server -p tcp --dport -m pool -j REJECT

Ok, I will try this if i get the chance.
Again my point is that the above is not a proper test for what i want to
do. Primary goal is to have many many rules. 
As an example if i decided to vary something else in the header
which pool doesnt understand it will render it useless or i will have to
go and hack it to make it understand (ex offset 43 byte 1). My criteria
is not to be restricted like that. However, if this is something that
will give you really good results i would like to see the best i can get
out of iptables.

> > In this example setup src IP and src TCP port are always looked up in
> > the case of u32 and only when a match happens are the packets let
> > through - by default they are dropped. In the case of iptables, only the
> > src IP is looked up (didnt wanna add any overhead).
> 
> The overhead of looking up the destination ip and tcp port is minimal. Can 
> easily be done at the head of your lookup tree
> 
> iptables -d ip.of.web.server -p tcp --dport 80 -j WEBSERVER
> 
> then have the match tree for the client source IP addresses in WEBSERVER. 
> Remember to terminate each subchain with a REJECT/DROP in case there is no 
> match.
> 

I dont think the overhead of it will add a noticeable difference. So for
my tests i dont care. I may at some point add it when i have time later.
Theres less than 10 memory access and the computes are not the issue
since CPU is not my problem from what i gathered.

> > While all that traffic is being sent add then delete a totaly unrelated
> > rule. Two metrics:
> > 1) what packet rates are observed during add/del?
> 
> With iptables there should not be much difference, except that the higher 
> the packet load the slower the change take.

Actually its quiet noticeable.
At 4096 users (accept rules) inserted:
input 1.48Mps(eth0) --> accept rules --> 190Kpps, avg latency 12.4 ms
Start adding deleting a unused rule. 
output goes to 104Kpps, latency 23ms. And the add del/rate does not
exceed 5/sec.
Its almost unusable at 16384 rules so i didnt bother even recording
results. 

> If you use ippool then the overhead of this operation is considerably 
> less.

I hope to try this at some point.

> > 2) how many times/sec can you do this? (essentially this could be used
> > to simulate opening and closing peepholes maybe even in a midcom kind
> > environment)
> >
> > I will present my results at SUCON.
> 
> Looking forward to see your results.
> 
> 
> 
> How do you optimize this kind of lookups using u32?


u32 can have similar "chains" concept but the path selection of the next
chain is based on a hash that you define. The overall effect compared
to iptables is that even if you have similar jumps, u32 wuill end up
having less rules.
Like i said not a lot of effort was made in the case of u32 given
attempts to try and attempt to have a fair analysis. 
What would have been nice is for you guys to come up with the rules
for iptables - then i wouldnt have felt guilty optimizing u32 ;->

cheers,
jamal
