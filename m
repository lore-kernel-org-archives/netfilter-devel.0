From: Patrick Schaaf <bof@bof.de>
Subject: Re: Security flaw in Stateful filtering ??????
Date: Thu, 6 Jun 2002 19:57:06 +0200
Sender: netfilter-devel-admin@lists.samba.org
Message-ID: <20020606195706.A21880@oknodo.bof.de>
References: <3CFF9A00.2070805@cs.auc.dk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@lists.samba.org,
	Mikkel Christiansen <mixxel@cs.auc.dk>,
	Mikkel Refsgaard Bech <mrb@cs.auc.dk>,
	Torben Vinther Schmidt <mariachi@cs.auc.dk>,
	Carsten Stiborg <stiborg@cs.auc.dk>
Return-path: <netfilter-devel-admin@lists.samba.org>
To: Emmanuel Fleury <fleury@cs.auc.dk>
Content-Disposition: inline
In-Reply-To: <3CFF9A00.2070805@cs.auc.dk>; from fleury@cs.auc.dk on Thu, Jun 06, 2002 at 07:21:04PM +0200
Errors-To: netfilter-devel-admin@lists.samba.org
List-Help: <mailto:netfilter-devel-request@lists.samba.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.samba.org>
List-Subscribe: <http://lists.samba.org/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.samba.org?subject=subscribe>
List-Unsubscribe: <http://lists.samba.org/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.samba.org?subject=unsubscribe>
List-Archive: <http://lists.samba.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

Hello,

> iptables -A FORWARD -p tcp -m state --state NEW -j ACCEPT
>
> The Problem:
> ------------
> When sending an ACK packet, the packet is allowed through the filter.
> Due to the second rule. This means that ACK packets are accepted as
> being in the state NEW and does not create an entry in the state table.
> So if any rule state that we allow NEW connections, this rule can be
> used for port scanning.

The "problem" has been reported here several times, already.

> We were wondering if this is intentional due to some reason that we
> cannot see or if it is a flaw as suggested ?

The behaviour is intentional. The reason is "connection pickup". Imagine
a situation where the firewall reboots. All active conntracking information
will be lost. With the observed behaviour, connections are "relearned"
on the fly as they create new traffic.

> A Solution:
> -----------
> As a temporary hack the following rule can be added as the second rule:
> 
> iptables -A FORWARD -p tcp --tcp-flags ACK ACK -j DROP

This is indeed only an ugly hack. Make your students think about what
exactly they want. Somehow, new connections need to be accepted, or
you wouldn't have anything to match the ESTABLISHED rule. The thing
you want to at least accept, are packets with SYN set, and the SYN/ACK
in the opposite direction. A real forwarding table will additionally
match on certain ports, to make sure even the SYN is only accepted
for permitted protocols.

Thus, you want a ruleset like this to properly do "no connection pickup".
I assume we are talking about tcp, only:

1) permit ESTABLISHED
2) deny INVALID
(now only state NEW should be left, right?)
3) deny packets which are neither SYN nor SYN/ACK
4-N) specifically permit the desired protocols, using port based matches.

> We have found something about it in the Iptables tutorial (1.1.8),
> page 54 (Appendix B, "State NEW packets but no SYN bit set").
> But, this is not really convincing.

I hope I could explain the rationale, and how to cope if your policy
demands it, a bit better.

best regards
  Patrick
