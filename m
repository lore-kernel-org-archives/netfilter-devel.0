From: Emmanuel Fleury <fleury@cs.auc.dk>
Subject: Re: Security flaw in Stateful filtering ??????
Date: Fri, 07 Jun 2002 13:30:25 +0200
Sender: netfilter-devel-admin@lists.samba.org
Message-ID: <3D009951.5090004@cs.auc.dk>
References: <E17G6im-0000FK-00@wagner.rustcorp.com.au> <3D006B9E.1040809@cs.auc.dk> <200206071105.42881.hno@marasystems.com> <3D007D73.9030609@cs.auc.dk> <20020607094319.GA595@morinfr.org> <3D00839F.6000103@cs.auc.dk> <20020607101713.GB595@morinfr.org>
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

Guillaume Morin wrote:
 >
 > I really do not understand what you mean. The conntrack stores the
 > previous state of TCP connection. So indeed when a packet arrives, it
 > checks the information of the TCP and IP headers and tries to see if
 > there is something stored about this TCP connection.
 >
 > e.g
 >
 > for a syn/ack packet
 >
 > the conntrack says "I've seen a syn from this guy" -> the packet is
 > matched as ESTABLISHED.

Ok, in other words:

"The connection old state was NEW" + "I receive a SYN/ACK"
    -> Connection is tagged as ESTABLISHED

So, this example answer to my question.


 > for your beloved ack packets

:-)

 > the conntrack knows a connection is established -> ACK is matched as
 > ESTABLISHED
 >
 > the conntrack has seen no connection -> ACK is matched as NEW

Actually, this is EXACTLY this behaviour which is surprising to me.
Don't miss my point, I don't want this to be changed, but just
writen in the definition of the states (eg in the packet-filtering
HOWTO):


NEW

      A packet which creates a new connection _or_a_ACK_packet_which_is
      _not_belonging_to_an_existing_connection(1).


Footnote (1): This feature has been implemented in order to keep the
connections alive after a reboot of the firewall (see: ...).


 >>Moreover, is it possible to create an entry in the connection table
 >>just by sending an ACK ??? (somebody wrote this at some point).
 >
 > Of course ! This is what is done when an ACK packet is received and if
 > the conntrack can't find a related established connection.

Are you sure ?

My students just told that they was no new connections after the ACK
scanning...

What part of the code have we to look to see this ???


 >>Finally, I tried to think about this 'connection pick-up' thing and
 >>I really don't understand how do you can restore a connection after
 >>the reboot. What is the algorithm which is used for this ?
 >
 >
 > This is a firewall. Basically you let packets pass or you do not. In a
 > case of connection pick-up, the firewall sees the ACK and thinks "oh, it
 > looks like there is a established connection but I wasn't there during
 > establishment. I'll let this connection go on. The following ACKs
 > packets will be matched as ESTABLISHED"

But, it looks like the ACK packets do not create new entry in the table
(well, according to the proc/ thing at least).

 >>(My problem is that in the case of a NAT, you can receive an ACK packet
 >>on your FORWARD chain coming from outside and you have to translate
 >>it to your inner network. But you lost all the informations about it).
 >
 > Of course, it does not work for a NATed connection if the ACK packet
 > comes from outside.

Ok.

Regards
-- 
Emmanuel

I am not young enough to know everything.
    -- Oscar Wilde
