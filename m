From: Emmanuel Fleury <fleury@cs.auc.dk>
Subject: Re: Security flaw in Stateful filtering ??????
Date: Thu, 06 Jun 2002 20:34:04 +0200
Sender: netfilter-devel-admin@lists.samba.org
Message-ID: <3CFFAB1C.902@cs.auc.dk>
References: <3CFF9A00.2070805@cs.auc.dk> <20020606195706.A21880@oknodo.bof.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <netfilter-devel-admin@lists.samba.org>
To: netfilter-devel@lists.samba.org
Errors-To: netfilter-devel-admin@lists.samba.org
List-Help: <mailto:netfilter-devel-request@lists.samba.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.samba.org>
List-Subscribe: <http://lists.samba.org/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.samba.org?subject=subscribe>
List-Unsubscribe: <http://lists.samba.org/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.samba.org?subject=unsubscribe>
List-Archive: <http://lists.samba.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

Hi,

Patrick Schaaf wrote:
> 
> The "problem" has been reported here several times, already.

Sorry, I should have browse the archive more carefully.

> The behaviour is intentional. The reason is "connection pickup". Imagine
> a situation where the firewall reboots. All active conntracking information
> will be lost. With the observed behaviour, connections are "relearned"
> on the fly as they create new traffic.

I simply disagree with you on this point (sorry :-/).

I wouldn't accept to have such a flaw in my firewall just because of
an hypothetic reboot of one of my gateway !!!!

Of course, I could be wrong, but in this case this 'feature' should be
highly documented and be disabled as default. IMHO.

One of the major argument in favor of the stateful inspection is that
it prevents from a lot of weird scans (NULL scan, X-MAS scan, ACK scan,
...). If you just drop this feature, I really don't see the point to
activate this 'connection tracking thingy' and make your gateway
sensitiv to DOS attack, just for fun...

Ok, I am pretty newbie in this topic, so I don't have any idea of:
'How often a gateway has to reboot'. But, somehow, I heard that
Linux boxes had pretty good uptimes (well, at least, mine have).

And, even in case of reboot, what sort of connection is more important
than preventing such scan of your network ????

Anyway, I should browse the archive of the mailing-list and try to
convinced myself how foolish I am. :-)

> This is indeed only an ugly hack. Make your students think about what
> exactly they want. Somehow, new connections need to be accepted, or
> you wouldn't have anything to match the ESTABLISHED rule. The thing
> you want to at least accept, are packets with SYN set, and the SYN/ACK
> in the opposite direction. A real forwarding table will additionally
> match on certain ports, to make sure even the SYN is only accepted
> for permitted protocols.
 >
> Thus, you want a ruleset like this to properly do "no connection pickup".
> I assume we are talking about tcp, only:
> 
> 1) permit ESTABLISHED
> 2) deny INVALID
> (now only state NEW should be left, right?)
> 3) deny packets which are neither SYN nor SYN/ACK
> 4-N) specifically permit the desired protocols, using port based matches.
> 
> 
>>We have found something about it in the Iptables tutorial (1.1.8),
>>page 54 (Appendix B, "State NEW packets but no SYN bit set").
>>But, this is not really convincing.
> 
> 
> I hope I could explain the rationale, and how to cope if your policy
> demands it, a bit better.

Actually, they are measuring the Round Trip Time (RTT) of SYN and ACK
packets in order to minimize the time-out of a connection in the
connection table.

One of their experiment was trying to figure out what is the impact of
removing a connection too early from the connection table.

The plan was to see what was happen when the last ACK (answering to
the FIN packet) was retransmitted because of the loss of the FIN packet.

Of course, it was expected that the firewall, as the connection has been
pruned from the connection list, would have dropped the retransmitted
ACK.... of course the behaviour that they get was somehow different of
what they were expected.


Regards
-- 
Emmanuel

What happens if a big asteroid hits the Earth?
Judging from realistic simulations involving a sledge hammer and
a common laboratory frog, we can assume it will be pretty bad.
   -- Dave Barry
