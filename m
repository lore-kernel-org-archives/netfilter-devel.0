From: Guillaume Morin <guillaume@morinfr.org>
Subject: Re: Security flaw in Stateful filtering ??????
Date: Fri, 7 Jun 2002 12:17:13 +0200
Sender: netfilter-devel-admin@lists.samba.org
Message-ID: <20020607101713.GB595@morinfr.org>
References: <E17G6im-0000FK-00@wagner.rustcorp.com.au> <3D006B9E.1040809@cs.auc.dk> <200206071105.42881.hno@marasystems.com> <3D007D73.9030609@cs.auc.dk> <20020607094319.GA595@morinfr.org> <3D00839F.6000103@cs.auc.dk>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Cc: netfilter-devel@lists.samba.org
Return-path: <netfilter-devel-admin@lists.samba.org>
To: Emmanuel Fleury <fleury@cs.auc.dk>
Content-Disposition: inline
In-Reply-To: <3D00839F.6000103@cs.auc.dk>
Errors-To: netfilter-devel-admin@lists.samba.org
List-Help: <mailto:netfilter-devel-request@lists.samba.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.samba.org>
List-Subscribe: <http://lists.samba.org/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.samba.org?subject=subscribe>
List-Unsubscribe: <http://lists.samba.org/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.samba.org?subject=unsubscribe>
List-Archive: <http://lists.samba.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

Dans un message du 07 jun à 11:57, Emmanuel Fleury écrivait :
> Does this means that you are mapping the packets to a state (NEW,
> ESTABLISHED, RELATED, INVALID) only based on information on their
> header and a query to the connection table ? And that you do not
> care about the previous state of the connection ?

I really do not understand what you mean. The conntrack stores the
previous state of TCP connection. So indeed when a packet arrives, it
checks the information of the TCP and IP headers and tries to see if
there is something stored about this TCP connection.

e.g

for a syn/ack packet

the conntrack says "I've seen a syn from this guy" -> the packet is
matched as ESTABLISHED.  

the conntrack says "I've never seen anything" -> the packet is matched
as INVALID

for your beloved ack packets

the conntrack knows a connection is established -> ACK is matched as
ESTABLISHED

the conntrack has seen no connection -> ACK is matched as NEW

> Moreover, is it possible to create an entry in the connection table
> just by sending an ACK ??? (somebody wrote this at some point).

Of course ! This is what is done when an ACK packet is received and if
the conntrack can't find a related established connection.

> Finally, I tried to think about this 'connection pick-up' thing and
> I really don't understand how do you can restore a connection after
> the reboot. What is the algorithm which is used for this ?

This is a firewall. Basically you let packets pass or you do not. In a
case of connection pick-up, the firewall sees the ACK and thinks "oh, it
looks like there is a established connection but I wasn't there during
establishment. I'll let this connection go on. The following ACKs
packets will be matched as ESTABLISHED"

> (My problem is that in the case of a NAT, you can receive an ACK packet
> on your FORWARD chain coming from outside and you have to translate
> it to your inner network. But you lost all the informations about it).

Of course, it does not work for a NATed connection if the ACK packet
comes from outside.

-- 
Guillaume Morin <guillaume@morinfr.org>

       Unwisely, Santa offered a teddy bear to James, unaware that he had
             been mauled by a grizzly earlier that year (T. Burton)
