From: Patrick Schaaf <bof@bof.de>
Subject: Re: conntrack and ICMP errors
Date: Fri, 11 Apr 2003 11:49:56 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20030411094956.GC18520@oknodo.bof.de>
References: <20030410182056.GA17723@bzorp.balabit.hu> <20030410200816.GA18520@oknodo.bof.de> <20030411094340.GA32552@balabit.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Patrick Schaaf <bof@bof.de>, netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Balazs Scheidler <bazsi@balabit.hu>
Content-Disposition: inline
In-Reply-To: <20030411094340.GA32552@balabit.hu>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

> > To summarize:
> > 
> > 	ICMP messages DO NOT TERMINATE TCP CONNECTIONS.
> > 
> > Please print that out, and eat the printout. You may add salt and pepper.
> 
> I thought the TCP example would not be very good, but I would rather not eat
> printouts (not even salted ones ;).
> 
> Here's an example when an ICMP packet DOES terminate a TCP connection:
> 
> When a SYN is received on a port which is not listening the stack is free to
> return either a TCP RST packet or an ICMP port unreachable packet: Windows
> stacks return ICMP port unreachable, Linux returns TCP RST and our
> REJECT target sends an ICMP port unreachable (by default).

Sorry, but that's not a valid argument against my point. When a SYN is
received, there IS no TCP connection to terminate, yet. Do you see
conntracking keeping an ESTABLISHED connection, in this case? I don't
think so.

Does Windows return ICMP port unreachable for non-SYN frames, too?
And, does it accept port unreachable messages and terminates local
sockets? Same questions regarding Linux and non-SYN frames?

> While TCP RST terminates the conntrack session ICMP port unreachable does
> not. I would not call this consistent.

Depends on your answers to my previous paragraph. If normal behaviour
for non-SYN packet is receiving back port unreachables, AND this makes
an endpoint terminate an already established TCP connection, then you
have a point, and I have learned something new. In that case, I could
agree that conntracking may also need to learn something new.

> On the other hand connection tracking an UDP session is less robust than
> TCP, simply because UDP has no state. Therefore we are using time based
> session tracking which is blind at least compared to TCP conntrack.
> Therefore it might make use of additional hints like ICMP port unreachables.

That may make sense. I'm not very familiar with the requirements of UDP
based protocols.

best regards
  Patrick
