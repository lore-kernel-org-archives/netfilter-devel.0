From: Maciej Soltysiak <solt@dns.toxicfilms.tv>
Subject: Re: Security flaw in Stateful filtering ??????
Date: Thu, 6 Jun 2002 19:54:50 +0200 (CEST)
Sender: netfilter-devel-admin@lists.samba.org
Message-ID: <Pine.LNX.4.21.0206061947590.19481-100000@dns.toxicfilms.tv>
References: <3CFF9A00.2070805@cs.auc.dk>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel@lists.samba.org,
	Mikkel Christiansen <mixxel@cs.auc.dk>,
	Mikkel Refsgaard Bech <mrb@cs.auc.dk>,
	Torben Vinther Schmidt <mariachi@cs.auc.dk>,
	Carsten Stiborg <stiborg@cs.auc.dk>
Return-path: <netfilter-devel-admin@lists.samba.org>
To: Emmanuel Fleury <fleury@cs.auc.dk>
In-Reply-To: <3CFF9A00.2070805@cs.auc.dk>
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

> A Solution:
> -----------
> As a temporary hack the following rule can be added as the second rule:
> 
> iptables -A FORWARD -p tcp --tcp-flags ACK ACK -j DROP
Well, i think everybody who gets to that point uses:
iptables -A FORWARD -p tcp -m state --state NEW --syn -j ACCEPT

type of rules. new + syn.

> However, this is not a solid solution and the code should be modified,
> as we see it, not to recognize ACK packets as being in the state NEW.
I belive that state NEW says: a packet never seen before. A tuple that
does not exist in currect tracked connections table.
I am no netfilter super guru/hacker, but i think connection tracking only
does its job on the information based on what is in the IP header.
So it works for all IP protocols.
But TCP, being so different, should be handled with the --syn flag option
to handle new connections.

I think that -m state NEW does its job logically, altough it would be very
useful if it did some TCP flags inspection on TCP packets.


> We were wondering if this is intentional due to some reason that we
> cannot see or if it is a flaw as suggested ?
I belive the explanation above explains it.
 

Comments, anyone?
Regards,
Maciej Soltysiak
