From: Henrik Nordstrom <hno@marasystems.com>
Subject: Re: Security flaw in Stateful filtering ??????
Date: Thu, 6 Jun 2002 21:27:01 +0200
Sender: netfilter-devel-admin@lists.samba.org
Message-ID: <200206062127.01661.hno@marasystems.com>
References: <3CFF9A00.2070805@cs.auc.dk> <20020606195706.A21880@oknodo.bof.de> <3CFFAB1C.902@cs.auc.dk>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8bit
Return-path: <netfilter-devel-admin@lists.samba.org>
To: Emmanuel Fleury <fleury@cs.auc.dk>,
	netfilter-devel@lists.samba.org
In-Reply-To: <3CFFAB1C.902@cs.auc.dk>
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

> I wouldn't accept to have such a flaw in my firewall just because of
> an hypothetic reboot of one of my gateway !!!!

And exactly what is the flaw here? What is it that your firewall ruleset is 
trying to achieve?

Sure NEW matches more than SYN, but as demonstrated you can easily refine what 
you accept as session initiations and this is what iptables firewalling is 
about. Making a ruleset that allows exactly what you intend.

To me the connection pickup feature is highly valuable, and I never seen it as 
a problem.

> Of course, I could be wrong, but in this case this 'feature' should be
> highly documented and be disabled as default. IMHO.

For most people the feature is no or minimal security risk as they always 
combine NEW with other criteria.

Only for people reading NEW as a synonym for SYN and therefore does not use 
--syn in their rules for maching TCP session initiations is at risk.

> One of the major argument in favor of the stateful inspection is that
> it prevents from a lot of weird scans (NULL scan, X-MAS scan, ACK scan,
> ...). If you just drop this feature, I really don't see the point to
> activate this 'connection tracking thingy' and make your gateway
> sensitive to DOS attack, just for fun...

And netfilter conntrack allows you detect such scans just fine. You just need 
to refine a little bit what you accept as NEW.

These scans will all show up as NEW in the filter.

> And, even in case of reboot, what sort of connection is more important
> than preventing such scan of your network ????

One does not rule out the other.

> Actually, they are measuring the Round Trip Time (RTT) of SYN and ACK
> packets in order to minimize the time-out of a connection in the
> connection table.

Why?

conntrack already deals with DOS situations due to too many unassured 
connections quite nicely..

(unassured == have seen traffic in one direction only)

and TCP is fairly strict on the minimum CLOSE_WAIT window to avoid false RST 
(or connection hangs in precense of stateful firewalls) due to lost FIN+ACK. 

> One of their experiment was trying to figure out what is the impact of
> removing a connection too early from the connection table.

Not good, but sometimes there is no choice due to memory constraints..

> The plan was to see what was happen when the last ACK (answering to
> the FIN packet) was retransmitted because of the loss of the FIN packet.

If you drop these too often you may DOS servers/clients..

> Of course, it was expected that the firewall, as the connection has been
> pruned from the connection list, would have dropped the retransmitted
> ACK.... of course the behaviour that they get was somehow different of
> what they were expected.

Only because they assumed NEW is a synonym for SYN.

Regards
Henrik
