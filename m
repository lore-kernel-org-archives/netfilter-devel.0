From: jamal <hadi@cyberus.ca>
Subject: Re: tc filtering vs iptables
Date: 27 Aug 2004 21:35:40 -0400
Sender: netfilter-devel-bounces@lists.netfilter.org
Message-ID: <1093656940.1078.25.camel@jzny.localdomain>
References: <1093614389.1068.20.camel@jzny.localdomain>
	<Pine.LNX.4.61.0408271751360.32691@filer.marasystems.com>
	<1093632324.14188.2.camel@jzny.localdomain>
	<20040827201137.GB9274@ti64.telemetry-investments.com>
	<1093638474.14190.29.camel@jzny.localdomain>
	<Pine.LNX.4.61.0408280154210.10193@filer.marasystems.com>
Reply-To: hadi@cyberus.ca
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Henrik Nordstrom <hno@marasystems.com>
In-Reply-To: <Pine.LNX.4.61.0408280154210.10193@filer.marasystems.com>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: </pipermail/netfilter-devel>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
Errors-To: netfilter-devel-bounces@lists.netfilter.org
List-Id: netfilter-devel.vger.kernel.org

On Fri, 2004-08-27 at 20:00, Henrik Nordstrom wrote:
> On Fri, 27 Aug 2004, jamal wrote:
> 
> > Can you emulate a patricia tree out of chains?
> 
> Yes, sort of.
> 
> If you like chains are just nodes with a list of branches or terminal 
> leaves (the rules).
> 
> What you can't have in iptables is the prefix compression used in 
> patricia, or at least not to the same level. You can still compress if 
> your rules are based on multiple "dimensions" of the packet address space 
> (i.e. source, destination, port).

Thats what i wanted to do. I still have one more opportunity to re-run
tests before i close it for now.

> But seriously speaking, if you are looking into ruleset requiring this 
> amount of address information I stronly suspect ippool (or it's successor 
> ipset) is the best tool for the job, allowing you to quickly group similar 
> things together.  Only if you need to assign unique classification to each 
> individual flow do you need a rule for each. But then again I do not have 
> the full picture of the type of packet classification you are trying to 
> accomplish.

My goal end goal is to test a _huge_ number of rules with iptables
and u32. huge is probably an exageration here since 64K is the max i
test.

To simplify things i selected the following:
A single web server (TCP port 80) connected to by upto 64K different
clients. 
The reason i chose this simple setup is because i can plot its lookups
easily and write simple scripts to install rules.
So end goal: stash many rules in both u32 and iptables and check
results.
In this example setup src IP and src TCP port are always looked up in
the case of u32 and only when a match happens are the packets let
through - by default they are dropped. In the case of iptables, only the
src IP is looked up (didnt wanna add any overhead).
Of course these are cooked tests - so i dont bother looking up either
dst IP or dst port. So neither u32 nor iptables do that.

Does that make sense?

Next step: Since i can optimize u32 (didnt try too hard) - figured i
need to be fair to iptables hence my posting here.

Traffic runs in a sort of DOS mode. i.e for all users you send one
packet and wait until everyone has sent one before your turn again
(round robin). The overall packets are sent at wire rate 64 byte
packets. If there was one user that would be 1.48Million packets per
second. If there were 148 users each would be sending 10Kpps.
All the above is designed to test worst case scenario.

Next phase of the test:
While all that traffic is being sent add then delete a totaly unrelated
rule. Two metrics:
1) what packet rates are observed during add/del?
2) how many times/sec can you do this? (essentially this could be used
to simulate opening and closing peepholes maybe even in a midcom kind
environment)

I will present my results at SUCON.

cheers,
jamal
