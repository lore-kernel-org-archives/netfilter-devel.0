From: Peter Stamfest <peter@stamfest.at>
Subject: Re: Accessing iptables from within an application...
Date: Fri, 18 Apr 2003 18:52:16 +0200 (CEST)
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <Pine.LNX.4.44.0304181847410.10014-100000@peter.stamf.pr.at>
References: <Pine.LNX.4.44.0303261733140.25652-100000@peter.stamf.pr.at>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
In-Reply-To: <Pine.LNX.4.44.0303261733140.25652-100000@peter.stamf.pr.at>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


Hello, 

I do not like to follow up my own posts, but because there was not a 
single reaction I felt I should repeat my proposals. Maybe this time 
around I can provoke some reactions ;-)

Even a "this is complete nonsense" would count towards my "reaction 
counter".

Thus: 

Regarding an API to access iptables:

On Wed, 26 Mar 2003, Peter Stamfest wrote:
> 
> On Wed, 26 Mar 2003, Harald Welte wrote:
> 
> > no.  There is no API outside the iptables command to access this
> > information.  We've discovered this as a design mistake, but fixing this
> > requires the whole architecture to change.
> > 
> 
> FWIW, some thoughts about it and some things I changed for myself, I might 
> repeat things discussed previously - if so do not hesitate to flame me...
> 
> 1 libiptc.a, libip6tc.a plus the iptables.o and ip6tables.o files contain 
>   most of what is needed for an API
> 
> 2 the splitting of libiptc and libip6tc  using a common libiptc.c and 
>   #including it is not an example of "good" C-programming, however, the 
>   fact that it (libiptc.c) contains functions common to both libraries 
>   leads to trouble when using BOTH ipv4 and ipv6 versions.
> 
> 3 The modules and the libraries are STDOUT-centric. So many printfs all 
>   over the place. And sometimes this is the only way to get at some 
>   information.
> 
> 4 There is no proper way to query a module for its configuration settings 
>   besides the stuff that just printf's it.
> 
> Some possible solutions:
> 
> ad 1: IMHO the functionality in ip(6)tables.o useful to be in a proper API 
> should be moved into the libip(6)tc libraries. After all: libraries are 
> there to hold generally useful functionality.
> 
> ad 2: take out _common_ code from libiptc.c so that it becomes possible to 
> link with both libiptc and libip6tc
> 
> ad 3: Replace all the calls to "printf" in all the modules by some 
> "iptables_printf" function and use that function to actually put the 
> information anywhere it is needed. Provide a way to change the way 
> information is "printed". I implemented this using a "vprintf"-style 
> function to be registered with this mechanism. I ALREADY HAVE A PATCH 
> DOING THIS. (sorry for shouting). Beware: the patch (trivial as it is) has 
> an incredible size of 163k (it mostly changes printf -> iptables_printf.
> 
> ad 4: Extend the module API with a proper way to query for these
> informations. Provide a fall-back mechanism using the 
> (iptables_)printf-based if such methods aren't available (good for a 
> transition period).
> 
> What do you think? Personally, I could use this for my iptables-snmp
> project, that currently is able to actually present most settings of a
> rule via SNMP. This will finally allow tools like MRTG (or a similar toll
> I am currently developing) to be used to monitor rules. Eg. here is an
> example of the information it is able to provide for a given rule
> (incidentally the counters are 0, but be assured that they can be read):
> 
> IPTABLES-MIB::ruleIndex.1.0.1 = INTEGER: 1
> IPTABLES-MIB::chainIndexR.1.0.1 = INTEGER: 0
> IPTABLES-MIB::tableIndexR.1.0.1 = INTEGER: 1
> IPTABLES-MIB::chainNameR.1.0.1 = STRING: "INPUT"
> IPTABLES-MIB::chainTableNameR.1.0.1 = STRING: "filter"
> IPTABLES-MIB::ruleOctets.1.0.1 = Counter64: 0
> IPTABLES-MIB::rulePackets.1.0.1 = Counter64: 0
> IPTABLES-MIB::chainRule.1.0.1 = STRING: ";p 6;s 192.168.3.0/24;j ACCEPT;tcp spt:666"
> IPTABLES-MIB::sourceIP.1.0.1 = IpAddress: 192.168.3.0
> IPTABLES-MIB::sourceMask.1.0.1 = IpAddress: 255.255.255.0
> IPTABLES-MIB::destinationIP.1.0.1 = IpAddress: 0.0.0.0
> IPTABLES-MIB::destinationMask.1.0.1 = IpAddress: 0.0.0.0
> IPTABLES-MIB::matches.1.0.1 = STRING: ";tcp spt:666"
> 
> I know that the proposed changes are at the core of the iptables
> utilities, but eventually something will have to be done about it. I would
> like to compare this to eg. rpm and its librpm: did anybody think about an
> API when first inventing something like RPM?? I think the same thing 
> happened to iptables.
> 

peter
