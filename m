From: "Ian Latter" <Ian.Latter@mq.edu.au>
Subject: Re: [Cybr.rdsw] [Cy.rdsw] serious problem with 2.4.24 combined	with KVM switch (fwd)
Date: Fri, 06 Feb 2004 12:07:27 +1000
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <200402060207.i1627Ui05561@singularity.tronunltd.com>
Reply-To: "Ian Latter" <Ian.Latter@mq.edu.au>
Content-Type: text/plain; charset="us-ascii"
Cc: "Marcelo Tosatti" <marcelo.tosatti@cyclades.com>,
   "Andreas Stempfhuber" <andreas.stempfhuber@cyclades.de>,
   "Netfilter Development Mailinglist" <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: "Oliver Kurth" <oliver.kurth@cyclades.de>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


Hello Oliver,

  For tftp broadcasts to be in use, I'd assume that this is a network
bootstrapping scenario - where the TFTP RRQ is broadcast, and 
where multiple servers are permitted to respond (TFTP DATA/ACK)

  Is it possible that the Netfilter expectation is being satisfied by one
response (server sending back a TFTP DATA), then being satisfied
again, by another?


  You said below;

> The problem occurs when:
> - a client broadcasts a tftp request, with source IP 192.168.160.255
> - server in the same physical network, but logical network
> 192.168.10.0/24 replies
> - the reply is routed through the gateway (which has an alias IP
> 192.168.160.1 netmask /24 on the same physical network, if this is
> relevant)
> - gateway blocks with REJECT. This message ist still in the logs, but
> soon after that the kernel panics.


While it shouldn't crash (regardless), it should also not be activating 
the helper and REJECTing.    Is it possible the the REJECT log entry is
on an INPUT rule, while the helper is being triggered on a PREROUTING
rule, due to the architecture of the network you've described (or vice 
versa)?



Regards,






----- Original Message -----
>From: "Oliver Kurth" <oliver.kurth@cyclades.de>
>To: "Harald Welte" <laforge@gnumonks.org>
>Subject:  Re: [Cybr.rdsw] [Cy.rdsw] serious problem with 2.4.24 combined	with KVM 
switch (fwd)
>Date: Wed, 04 Feb 2004 15:05:53 +0100
>
> On Tue, 2004-02-03 at 23:00, Harald Welte wrote:
> > On Tue, Feb 03, 2004 at 05:24:57PM +0100, Oliver Kurth wrote:
> > > Hi Harald,
> > > 
> > > > > We are having a problem with 2.4.24 on cyclades germany, the box
> > > > > (firewall) is crashing in the netfilter code.
> > > 
> > > Anything new about that problem? Do you need more information?
> > 
> > sorry, I lost that issue because I'm extremely overloaded at the moment.
> > 
> > It seems like it crashes in the following piece of code (from
> > ip_conntrack_core.c)
> > 
> >         /* If the expectation is dying, then this is a looser. */
> >         if (expected
> >             && expected->expectant->helper->timeout
> >             && !del_timer(&expected->timeout))
> >                 expected = NULL;
> > 
> > 
> > To be more precise, it cannot dereference helper->timeout, since helper
> > is NULL.  I am extremely puzzled how you would end up with a conntrack
> > expectation (which can only be caused by a helper) that has not assigned
> > a helper.
> 
> I looked over the code, and could not find anything either, but I am not
> familar with it at all.
> 
> > Could you please tell me, which conntrack and/or NAT helpers you were
> > using on that machine?
> 
> The problem occurs when:
> - a client broadcasts a tftp request, with source IP 192.168.160.255
> - server in the same physical network, but logical network
> 192.168.10.0/24 replies
> - the reply is routed through the gateway (which has an alias IP
> 192.168.160.1 netmask /24 on the same physical network, if this is
> relevant)
> - gateway blocks with REJECT. This message ist still in the logs, but
> soon after that the kernel panics.
> 
> So, if a helper is causing the problem, it is probably the tftp helper.
> It may also be related to the problem that the client IP is ending with
> ..255, which is the broadcast address for the gateway on that network.
> 
> I can send the firewall rules to you in a private mail, if you need it.
> 
> This is an ecxcerpt of .config:
> 
> #
> #   IP: Netfilter Configuration
> #
> CONFIG_IP_NF_CONNTRACK=y
> CONFIG_IP_NF_FTP=y
> CONFIG_IP_NF_AMANDA=y
> CONFIG_IP_NF_TFTP=y
> CONFIG_IP_NF_IRC=y
> # CONFIG_IP_NF_QUEUE is not set
> CONFIG_IP_NF_IPTABLES=y
> CONFIG_IP_NF_MATCH_LIMIT=y
> CONFIG_IP_NF_MATCH_MAC=y
> CONFIG_IP_NF_MATCH_PKTTYPE=y
> CONFIG_IP_NF_MATCH_MARK=y
> CONFIG_IP_NF_MATCH_MULTIPORT=y
> CONFIG_IP_NF_MATCH_TOS=y
> CONFIG_IP_NF_MATCH_RECENT=y
> CONFIG_IP_NF_MATCH_ECN=y
> CONFIG_IP_NF_MATCH_DSCP=y
> CONFIG_IP_NF_MATCH_AH_ESP=y
> CONFIG_IP_NF_MATCH_LENGTH=y
> CONFIG_IP_NF_MATCH_TTL=y
> CONFIG_IP_NF_MATCH_TCPMSS=y
> CONFIG_IP_NF_MATCH_HELPER=y
> CONFIG_IP_NF_MATCH_STATE=y
> CONFIG_IP_NF_MATCH_CONNTRACK=y
> # CONFIG_IP_NF_MATCH_UNCLEAN is not set
> # CONFIG_IP_NF_MATCH_OWNER is not set
> CONFIG_IP_NF_FILTER=y
> CONFIG_IP_NF_TARGET_REJECT=y
> # CONFIG_IP_NF_TARGET_MIRROR is not set
> CONFIG_IP_NF_NAT=y
> CONFIG_IP_NF_NAT_NEEDED=y
> CONFIG_IP_NF_TARGET_MASQUERADE=y
> CONFIG_IP_NF_TARGET_REDIRECT=y
> CONFIG_IP_NF_NAT_AMANDA=y
> # CONFIG_IP_NF_NAT_LOCAL is not set
> # CONFIG_IP_NF_NAT_SNMP_BASIC is not set
> CONFIG_IP_NF_NAT_IRC=y
> CONFIG_IP_NF_NAT_FTP=y
> CONFIG_IP_NF_NAT_TFTP=y
> CONFIG_IP_NF_MANGLE=y
> CONFIG_IP_NF_TARGET_TOS=y
> CONFIG_IP_NF_TARGET_ECN=y
> CONFIG_IP_NF_TARGET_DSCP=y
> CONFIG_IP_NF_TARGET_MARK=y
> CONFIG_IP_NF_TARGET_LOG=y
> CONFIG_IP_NF_TARGET_ULOG=y
> CONFIG_IP_NF_TARGET_TCPMSS=y
> # CONFIG_IP_NF_ARPTABLES is not set
> 
> > We haven't had something like this before.
> > 
> > As a workaround, you could add an additional check into that piece of
> > code.  At least it won't oops anymore, although it is still unclear how
> > you end up with this kind of situation.
> > 
> > if (expected
> >     && expected->expectant->helper
> >     && expected->expectant->helper->timeout
> >     && !del_timer(&expected->timeout))
> >         expected = NULL;
> 
> Greetings,
> Oliver
> 
> -- 
> Cyclades GmbH                       -              Everywhere with Linux
> Oliver Kurth                                               Cyclades GmbH
> Research & Development                                        Rennweg 33
> Fon/Fax: +49 (0) 8122 90999-34/-33                        D-85435 Erding
> 
> 

--
Ian Latter
Internet and Networking Security Officer
Macquarie University

 Meet me at the Australian Unix and open systems
   User Group (AUUG) Security Symposium; 2004
  http://www.auug.org.au/events/2004/security/
