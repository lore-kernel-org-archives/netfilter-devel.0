From: Guillaume Morin <guillaume@morinfr.org>
Subject: Re: Security flaw in Stateful filtering ??????
Date: Fri, 7 Jun 2002 15:33:00 +0200
Sender: netfilter-devel-admin@lists.samba.org
Message-ID: <20020607133300.GD595@morinfr.org>
References: <E17G6im-0000FK-00@wagner.rustcorp.com.au> <3D006B9E.1040809@cs.auc.dk> <200206071105.42881.hno@marasystems.com> <3D007D73.9030609@cs.auc.dk> <20020607094319.GA595@morinfr.org> <3D00839F.6000103@cs.auc.dk> <20020607101713.GB595@morinfr.org> <3D009951.5090004@cs.auc.dk>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Cc: netfilter-devel@lists.samba.org
Return-path: <netfilter-devel-admin@lists.samba.org>
To: Emmanuel Fleury <fleury@cs.auc.dk>
Content-Disposition: inline
In-Reply-To: <3D009951.5090004@cs.auc.dk>
Errors-To: netfilter-devel-admin@lists.samba.org
List-Help: <mailto:netfilter-devel-request@lists.samba.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.samba.org>
List-Subscribe: <http://lists.samba.org/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.samba.org?subject=subscribe>
List-Unsubscribe: <http://lists.samba.org/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.samba.org?subject=unsubscribe>
List-Archive: <http://lists.samba.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

Hi Emmanuel,

Dans un message du 07 jun à 13:30, Emmanuel Fleury écrivait :
> > the conntrack knows a connection is established -> ACK is matched as
> > ESTABLISHED
> >
> > the conntrack has seen no connection -> ACK is matched as NEW
> 
> Actually, this is EXACTLY this behaviour which is surprising to me.
> Don't miss my point, I don't want this to be changed, but just
> writen in the definition of the states (eg in the packet-filtering
> HOWTO):
> 
> NEW
> 
>      A packet which creates a new connection _or_a_ACK_packet_which_is
>      _not_belonging_to_an_existing_connection(1).
> 

Well, I understand your point. I know this is surprising. I really
thought it was in the FAQ or something. 

I looked at the code and I was kind of wrong. Every untracked packets
are considered as NEW. That means that a syn/ack packet, a rst packet
will be matched as NEW. The documentation is correct because it means
the connection in the conntrack sense NOT in the TCP sense.

This is not a security flaw itself since when you allow NEW you always
allow the peer to scan you (syn, syn/ack, ack, whatever)

> > Of course ! This is what is done when an ACK packet is received and if
> > the conntrack can't find a related established connection.
> 
> Are you sure ?

Yes.

> My students just told that they was no new connections after the ACK
> scanning...

That is logical. The scanner sends the ACK packet to the target machine.
The firewall let the packet pass. The target receives the bogus ACK
packet and sends back a RST packet. The firewall sees that and swith the
CONNECTION_CLOSE state which will be ripped off the connection table 10
seconds after that.

> What part of the code have we to look to see this ???@

see net/ipv4/netfilter/ip_conntrack_proto_tcp.c

> But, it looks like the ACK packets do not create new entry in the table
> (well, according to the proc/ thing at least).

It does create an entry.

HTH.

-- 
Guillaume Morin <guillaume@morinfr.org>

                       Sauvez un arbre, mangez un castor
