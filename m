From: "Ian Latter" <Ian.Latter@mq.edu.au>
Subject: Re: [Cybr.rdsw] [Cy.rdsw] serious problem with 2.4.24	combined	with KVM switch (fwd)
Date: Wed, 11 Feb 2004 17:57:53 +1000
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <200402110757.i1B7vt909860@singularity.tronunltd.com>
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


> > While it shouldn't crash (regardless), it should also not be activating 
> > the helper and REJECTing.    Is it possible the the REJECT log entry is
> > on an INPUT rule, while the helper is being triggered on a PREROUTING
> > rule, due to the architecture of the network you've described (or vice 
> > versa)?
> 
> The REJECT is in an INPUT rule. But I do not think that a PREROUTING
> rule is involved. I just looked at the rules, and PREROUTING is only
> done for other physical networks.

Ok - You said originally that;

> > > The problem occurs when:
> > > - a client broadcasts a tftp request, with source IP 192.168.160.255
> > > - server in the same physical network, but logical network
> > > 192.168.10.0/24 replies
> > > - the reply is routed through the gateway (which has an alias IP
> > > 192.168.160.1 netmask /24 on the same physical network, if this is
> > > relevant)
> > > - gateway blocks with REJECT. This message ist still in the logs, but
> > > soon after that the kernel panics.

So, I'm assuming that you have something like this on your gateway;

  eth0    192.168.10.1/255.255.255.0
  eth0:1 192.168.160.1/255.255.255.0

.. and that you're forwarding.  In which direction is the INPUT
packet REJECTed ?  Ie;

    a) RRQ:  broadcaster -> tftp server/broadcast
    b) ACK/DATA:  tftp server -> broadcaster/booting host


  Additional places to look are going to come from how your
rules are structured.  For example, I'd probably expect to see a
REJECT on INPUT at "a" and then a some interesting stuff with 
"b".  Depending on your ruleset, "b" may REJECT on PREROUTING,
FORWARD or POSTROUTING.  And, IIRC there is a /proc security 
option for restricting directed broadcasts, though I don't know if 
this affects forwarded (non-locally generated) traffic.  It may also
be possible that once the "b" traffic has made it through your
gateway, that the ACK is received by the INPUT of the eth0
interface at the gateway again (as the original RRQ source was
a broadcast address) -- this may also be part of the problem.

  Maybe a tcpdump/ethereal capture at the gateway would reveal
more?



--
Ian Latter
Internet and Networking Security Officer
Macquarie University

 Meet me at the Australian Unix and open systems
   User Group (AUUG) Security Symposium; 2004
  http://www.auug.org.au/events/2004/security/
