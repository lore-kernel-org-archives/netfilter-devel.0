From: Henrik Nordstrom <hno@marasystems.com>
Subject: Re: Security flaw in Stateful filtering ??????
Date: Thu, 6 Jun 2002 23:26:49 +0200
Sender: netfilter-devel-admin@lists.samba.org
Message-ID: <200206062326.49227.hno@marasystems.com>
References: <3CFF9A00.2070805@cs.auc.dk> <200206062127.01661.hno@marasystems.com> <3CFFCB15.1050708@cs.auc.dk>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8bit
Return-path: <netfilter-devel-admin@lists.samba.org>
To: netfilter-devel@lists.samba.org,
	Emmanuel Fleury <fleury@cs.auc.dk>
In-Reply-To: <3CFFCB15.1050708@cs.auc.dk>
Errors-To: netfilter-devel-admin@lists.samba.org
List-Help: <mailto:netfilter-devel-request@lists.samba.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.samba.org>
List-Subscribe: <http://lists.samba.org/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.samba.org?subject=subscribe>
List-Unsubscribe: <http://lists.samba.org/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.samba.org?subject=unsubscribe>
List-Archive: <http://lists.samba.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

Emmanuel Fleury wrote:

> The core of the problem seems to be a conflict between two features:
>
> 1) The existing connections shouldn't be stopped when you change the
>     rules of your firewall at run time (something which occur much more
>     often than the reboot of one firewall).
>
> 2) The connection tracking / Stateful inspection

Nope. The connection pickup feature is purely about reboots and failover. 
Change of rules do not affect connection tracking in any manner. Only packets 
and actions taken by your ruleset does (DROP/REJECT kills the conntrack 
entry)

> But, I still don't understand how the data packets can go through your
> firewall if they are not matching NEW (except if you have an assymetric
> configuration as NAT)...

???

> Moreover, the fact that you match ACK packets with NEW, break part of
> the stateful inspection and force the user to make some additional rules
> in order to avoid ACK scanning of your network.

Not really, it only makes state NEW not very useful as a match as it is 
extremely broad.

A somewhat sane typical iptables rulesets looks like

-A FORWARD -m state --state INVALID -j DROP
-A FORWARD -m state --state ESTABLISHED,RELATED -j ACCEPT
-A FORWARD [definition of allowed connection] -j ACCEPT
-A FORWARD [definition of allowed connection] -j ACCEPT
-A FORWARD [definition of allowed connection] -j ACCEPT
...
-A FORWARD -j DROP

If we take the quoted example of a SMTP server, and adds a HTTP server in the 
mix this becomes

-A FORWARD -m state --state INVALID -j DROP
-A FORWARD -m state --state ESTABLISHED,RELATED -j ACCEPT
-A FORWARD -d ip.of.smtp.server -p tcp --syn --dport 25 -j ACCEPT
-A FORWARD -d ip.of.smtp.server -p tcp --syn --dport 80 -j ACCEPT
-A FORWARD -j DROP

And will properly block all those scans you are so worried about.

Another exampe config, where connection pickup is wanted..

eth0: connected to internal trusted network
eth1: connected to external untrusted network

-A FORWARD -m state --state ESTABLISHED,RELATED -j ACCEPT
# Allow for outgoing SSH sessions with connection pickup after reboot
-A FORWARD -i eth0 -p tcp --dport 22 -j ACCEPT
[more rules allowing what should be allowed...]
-A FORWARD -i eth0 -j REJECT
-A FORWARD -j DROP

which also blocks such scans if received from the outside (eth1), but allows 
some of them if received from the inside (eth0) and targeting allowed 
services.


I do have a few real life cases where -m state --state NEW is a valuable 
match, but these are too obscure for this thread.

Regards
Henrik
