From: Emmanuel Fleury <fleury@cs.auc.dk>
Subject: Re: Security flaw in Stateful filtering ??????
Date: Thu, 06 Jun 2002 22:50:29 +0200
Sender: netfilter-devel-admin@lists.samba.org
Message-ID: <3CFFCB15.1050708@cs.auc.dk>
References: <3CFF9A00.2070805@cs.auc.dk> <20020606195706.A21880@oknodo.bof.de> <3CFFAB1C.902@cs.auc.dk> <200206062127.01661.hno@marasystems.com>
Reply-To: netfilter-devel@lists.samba.org
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

Henrik Nordstrom wrote:
> 
> And exactly what is the flaw here? What is it that your firewall ruleset is 
> trying to achieve?

Ok, a 'flaw' is not exactly matching with this. Now that I am more
awared of the problem, I can describe this as: "an under-specified
feature which can lead the user to have a flaw in his firewall without
be awared of it".

Let me express my understanding of the problem:

The core of the problem seems to be a conflict between two features:

1) The existing connections shouldn't be stopped when you change the
    rules of your firewall at run time (something which occur much more
    often than the reboot of one firewall).

2) The connection tracking / Stateful inspection


Somehow the stateful inspection is probably flushing the connection
table when the rules are updated (is it right ?).

And therefore, all the connections are cuted when you change your
ruleset...

The solution which have been implemented is to consider the ACK packets
as beeing part of the NEW state (in place of the ESTABLISHED state as
one would expect, well, at least me).

But, I still don't understand how the data packets can go through your
firewall if they are not matching NEW (except if you have an assymetric
configuration as NAT)...

Moreover, the fact that you match ACK packets with NEW, break part of
the stateful inspection and force the user to make some additional rules
in order to avoid ACK scanning of your network.


Is it right ?????

This is no critics ! My point is just to try to understand the thing !


> Sure NEW matches more than SYN, but as demonstrated you can easily refine what 
> you accept as session initiations and this is what iptables firewalling is 
> about. Making a ruleset that allows exactly what you intend.

Yes, but the point is that you leave up to the user to fix something
which is obviously wrong in Netfilter. Somehow this should be
definitely be considered as a bad thing. IMHO.

> To me the connection pickup feature is highly valuable, and I never seen it as 
> a problem.

I can perfectly understand this if in place of speaking about reboot,
you speak about ruleset update. This feature make perfect sense for me.


> For most people the feature is no or minimal security risk as they always 
> combine NEW with other criteria.
> 
> Only for people reading NEW as a synonym for SYN and therefore does not use 
> --syn in their rules for maching TCP session initiations is at risk.

Well, somehow, you are speaking about the people who are just trusting
the documentation (eg packet-filtering-HOWTO).


>>Actually, they are measuring the Round Trip Time (RTT) of SYN and ACK
>>packets in order to minimize the time-out of a connection in the
>>connection table.
> 
> Why?
> 
> conntrack already deals with DOS situations due to too many unassured 
> connections quite nicely..
> 
> (unassured == have seen traffic in one direction only)

Ok, but this is preventing SYN-flooding only.

What about attacks (or just normal use after all) which are establishing
normal connection: three way handshake + exchange of data + closing the
connection.

After the last packet, and according to the few I know from Netfilter,
you will have to wait 2 minutes before removing the connection from
the connection table (these 2 minutes are specified in the RFC).

Therefore, if you can fill up your table in less than 2 minutes all the
new connections will be stopped.

Well, at least, this is what I understood of my students explanations...

> and TCP is fairly strict on the minimum CLOSE_WAIT window to avoid false RST 
> (or connection hangs in precense of stateful firewalls) due to lost FIN+ACK. 

Yes. The problem is as being the "man in the middle", you cannot be
awared if the final FIN has been received or not, so you have to wait
for the time-out.... in theory.

Because in practice, if you can guess the Round Trip Time, you can just
adapt your time out for this connection...

Well, at least, that's what the students claim and they are doing a lot
of experiments in the lab about it... ;-)

>>The plan was to see what was happen when the last ACK (answering to
>>the FIN packet) was retransmitted because of the loss of the FIN packet.
> 
> If you drop these too often you may DOS servers/clients...

Well, will see on the experiments. There is one experiment planed on
very fluctuating Round Trip Time (they are using the delay box from
the FreeBSD firewall in order to simulate random Round Trip Time).

Regards
-- 
Emmanuel

A child of five could understand this. Fetch me a child of five.
   -- Groucho Marx
