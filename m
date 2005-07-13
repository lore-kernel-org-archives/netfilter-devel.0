From: Amin Azez <azez@ufomechanic.net>
Subject: Re: [PATCH 1/2] flow match feedback
Date: Wed, 13 Jul 2005 10:23:31 +0100
Message-ID: <42D4DD93.5070700@ufomechanic.net>
References: <20050628234912.GB23662@wsc.edu> <42D3B9C7.1070507@ufomechanic.net>
	<20050712221137.GB8298@wsc.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Josh Samuelson <josamue1@wsc.edu>
In-Reply-To: <20050712221137.GB8298@wsc.edu>
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

Josh Samuelson wrote:

>Hi Amin,
>
>On Tue, Jul 12, 2005 at 01:38:31PM +0100, Amin Azez wrote:
>  
>
>>iptables -t filter -A INPUT -p tcp --dport 22 -m flow --orig-tcp-n 3 -j DROP
>>
>>I imagined that the -n in --orig-tcp-n would mean that the rule
>>condition is only true when being matched against a new connection,
>>howewever when I created my 3rd connection all packets on all
>>connections were dropped.
>>    
>>
>
>Hmm, I can't recreate this scenario.  Is that all the rules you had?
>  
>
Yes.

>How were you connecting to the machine, ie loopback or another external
>host?  
>
The machine is a bridge, but I am making direct connections to it from
another machine

>Before you make your 3rd connection, what does
>/proc/net/ip_conntrack_flow_orig list for your orig-tcp-n IP address?
>  
>
192.168.0.181 IP: 2/2/0 ICMP: 0/0/0 TCP: 2/2/0 UDP: 0/0/0

>The format is:
>x.x.x.x IP: T/N/E ICMP: T/N/E TCP: T/N/E UDP: T/N/E
>
>x.x.x.x -- IPv4 address
>T       -- Total connection count
>N       -- New connection count, only seen traffic in one direction
>E       -- Established connection count, seen reply
>
>The listed rule would match when the number of new connections from
>some original TCP source >= 3 and the destination port of the connection
>is port 22.  Perhaps it's not clear, but the TCP flow count could
>include other traffic that isn't destined to port 22 or for that matter
>the machine itself if it's acting as a router, but is also
>in the NEW state.  NEW state connections have only seen traffic in
>one direction "[UNREPLIED]" according to the conntrack core.
>  
>
I realise then that this is just an "all connections" count and not a
"count of connections that matches this rule"

I can see that adding ports and other such things would over-complicate
things and the ultimate limit would be adding to your module all the
rule handling capabilities that iptables already has. It would be
desirable from a user point of view to approach the limit, but to do the
work would clearly be mad.

I was just about to write such a module when you came along and hoped
you had done most of it for me.

My plan was that each such iptables rule would allocate a reference
counted counter struct, and set its reference count to 1.
This struct holds counters for all conntracks for connections whose
packets match the rule, and maybe subcounters for the different ctstates

When the rule matches, the counter is incremented and added to a list
whose head is held in a new hash under the conntracks originating tuple.
Thus it is a simple matter to decrement all these counters when the
conntrack is destroyed, as prevent the connection from being double-counted.

Because the counter is a freely allocated reference counted struct, the
conntrack is able to decrease the counter, decrease the reference count
and destroy it if needed, as might be the case if iptables has since
been unloaded. (Or does IP tables already have such a mechanism that can
cause rules to stick around till references to them are freed?)

Obscurely hidden here is that the only clauses of the rule which would
affect the counting are those which come before the counting clause.
It's nice, but obscure so that I missed it til now.


I can see it might be nice for other rules to remove a connection from a
count even though the connection exists, this would imply named
counters, rather than counters being associated with a rule.

Maybe we should just extend (or duplicate) connmark so that it also
counts how many connections have a given mark? (Although I have also
modified connmark so that the flow in each direction can have its own
mark set by connmark, I need to submit that patch but its mixed up with
some other statistics stuff at the moment)

What do you think?

Amin


>Patrick has already commented on the complexity of the current code but
>I've been toying with the idea of adding port number counts per each
>flow, which may allow for what you were intending with the above rule,
>but with yeah... more complexity.
>
>  
>
>>I can get what I expected doing this:
>>iptables -t filter -A INPUT -p tcp --dport 22 -m conntrack --ctstate NEW
>>-m flow --orig-tcp-n 3 -j DROP
>>    
>>
>
>Yup, with that rule the non-NEW packets can now slip through even when there
>are >= 3 original TCP source connections.  You could also do:
>
>iptables -A INPUT -m conntrack --ctstate ESTABLISHED -j ACCEPT
>iptables -A INPUT -p tcp --dport 22 -m flow --orig-tcp-n 3 -j DROP
>
>But again, rule 2 isn't doing what you probably think it's doing with
>regards to destination port 22.
>
>  
>
>>openBut I am then not sure what the -n was signifying.
>>
>>    
>>
>
>Has my explanation cleared that up?
>
>  
>
>>By using the second rule with ctstate, I get 4 entries in
>>/proc/net/ip_conntrack dport=22 and one of them is stuck on "unreplied",
>>other new connections do not even enter the conntrack table.
>>
>>    
>>
>
>Well if that is the case, you should have 3 established connections
>and 1 new connection which shouldn't cause that rule to match.  Again,
>I'll need to know more about your setup and what the contents of
>/proc/net/ip_conntrack_flow_orig says for your original source
>TCP address.
>
>  
>
>>However, I notice that when the conneciton is closopened and in TIME_WAIT it
>>still counts towards the limit.  While there may be no way around this
>>for UDP where there is no explicit close event, I feel for TCP
>>connections this new module ought to count the connection as closed
>>before the conntrack is destroyed, for whatever happens we expect only a
>>few more packets on the connection and it is a shame to hold up any new
>>connections because of that. Proper close conntracks are perhaps brief
>>enough, but only perhaps.
>>
>>Amin
>>
>>    
>>
>
>The flow counts are based off of conntrack entries being created or
>destroyed, ie IPCT_NEW/IPCT_RELATED and IPCT_DESTROY events.
>The number of lines you see in /proc/net/ip_conntrack for some IP
>all tallied up should match what
>/proc/net/ip_conntrack_flow_{orig,repl} say for the same IP address.
>This was pretty much by design to keep the code as streamlined as
>possible.  As you probably know, the TIME_WAIT timeout value can
>be changed via the sysctl proc file ip_conntrack_tcp_timeout_close_wait.
>What you bring up can probably be done with the IPCT_PROTOINFO event
>and keeping yet more state in this module if the connection happens
>to be a TCP connection.  This unfortunately will deviate TCP from
>the other three protocols in how the flow counts are handled, adding
>more complexity; I've already had the "too complex" stick shaken at
>me with this module as it is.  doh O_o
>
>Amin, I do appreciate the feedback.  Let me know if I've cleared some
>things up for you.
>
>Cheers,
>Josh
>  
>
