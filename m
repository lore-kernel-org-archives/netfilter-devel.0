From: Balazs Scheidler <bazsi@balabit.hu>
Subject: Re: conntrack and ICMP errors
Date: Fri, 11 Apr 2003 11:43:40 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20030411094340.GA32552@balabit.hu>
References: <20030410182056.GA17723@bzorp.balabit.hu> <20030410200816.GA18520@oknodo.bof.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Patrick Schaaf <bof@bof.de>
Content-Disposition: inline
In-Reply-To: <20030410200816.GA18520@oknodo.bof.de>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

On Thu, Apr 10, 2003 at 10:08:16PM +0200, Patrick Schaaf wrote:
> Balazs,
> 
> I'm skipping your UDP redirect stuff (too much for my brain now), but
> one note on the TCP part.
> 
> In the situation you allude to at the end of your mail, think about
> how the _client_ will react to the ICMP error (which you route through
> to it, don't you?) What will the client do? What effect will that have
> on the netfilter box? I can tell you: it will sit there and patiently
> wait for the other side to come back up, keeping the TCP connection
> ESTABLISHED, just like the iptables box. And, better yet: if the
> intermittent reason for the "destination unreachable" goes away,
> and we find out the server did NOT crash, but its link was flakey,
> my ssh connection STILL WORKS THE SECOND I TYPE AGAIN!
> 
> Yes, I would call that intentional.

ok. what about port unreachable messages? see below.

> 
> To summarize:
> 
> 	ICMP messages DO NOT TERMINATE TCP CONNECTIONS.
> 
> Please print that out, and eat the printout. You may add salt and pepper.

I thought the TCP example would not be very good, but I would rather not eat
printouts (not even salted ones ;).

Here's an example when an ICMP packet DOES terminate a TCP connection:

When a SYN is received on a port which is not listening the stack is free to
return either a TCP RST packet or an ICMP port unreachable packet: Windows
stacks return ICMP port unreachable, Linux returns TCP RST and our
REJECT target sends an ICMP port unreachable (by default).

The client handles these packets the same way: 'Connection refused'
error is propagated to userspace.

While TCP RST terminates the conntrack session ICMP port unreachable does
not. I would not call this consistent.

On the other hand connection tracking an UDP session is less robust than
TCP, simply because UDP has no state. Therefore we are using time based
session tracking which is blind at least compared to TCP conntrack.
Therefore it might make use of additional hints like ICMP port unreachables.

-- 
Bazsi
PGP info: KeyID 9AF8D0A9 Fingerprint CD27 CFB0 802C 0944 9CFD 804E C82C 8EB1
