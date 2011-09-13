From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Subject: Re: conntrack: ICMP type 3 code 3 responses should break TCP
 connections
Date: Tue, 13 Sep 2011 13:49:55 +0200 (CEST)
Message-ID: <alpine.DEB.2.00.1109131327230.502@blackhole.kfki.hu>
References: <4E6E67FA.2040800@lugosys.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel@vger.kernel.org
To: "Israel G. Lugo" <israel.lugo@lugosys.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp2.kfki.hu ([148.6.0.28]:47764 "EHLO smtp2.kfki.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753119Ab1IMLt7 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 13 Sep 2011 07:49:59 -0400
In-Reply-To: <4E6E67FA.2040800@lugosys.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi,

On Mon, 12 Sep 2011, Israel G. Lugo wrote:

> I'm setting up a small embedded router. One of my hosts is running its
> own local firewall, using -j REJECT for unwanted traffic (reject the
> connection with ICMP destination unreachable, port unreachable). The
> router is still keeping track of these connections, though. It will see
> the connection as state SYN_SENT, UNREPLIED.
> 
> tcpdump on the connecting side (10.0.50.128) shows the ICMP error is
> sent and received (goes through the router):
> > IP 10.0.50.128.53008 > 10.0.0.18.6666: Flags [S], seq 866150038, win
> > 14600, options [mss 1460,sackOK,TS val 987769 ecr 0,nop,wscale 6],
> > length 0
> > IP 10.0.0.18 > 10.0.50.128: ICMP 10.0.0.18 tcp port 6666 unreachable,
> > length 68
> 
> The client software (in this case netcat) reports connection refused, as
> expected. However, on the router the connection stays there:
> 
> > # grep 6666 /proc/net/nf_conntrack
> > ipv4     2 tcp      6 110 SYN_SENT src=10.0.50.128 dst=10.0.0.18
> > sport=53008 dport=6666 [UNREPLIED] src=10.0.0.18 dst=10.0.50.128
> > sport=6666 dport=53008 mark=0 use=2
>  
> If I modify the 10.0.0.18 host to reject with a TCP RST instead, the
> router's conntrack will drop the connection from its table, as expected.
> I believe the same should happen with the hard ICMP error message.
> 
> A similar subject has already been covered in a recent thread, although
> at the time the focus was on traffic accounting:
> 
> http://marc.info/?t=131073077400006&r=1&w=2
> 
> I'm more worried about the actual connection table entry remaining
> there. It will stay in SYN_SENT for the default time of 120 seconds,
> where in my opinion the connection should in fact be forgotten
> (connection table size, resource exhaustion, etc.) -- it is my
> interpretation that a hard ICMP Destination Unreachable message is
> equivalent in this context to a TCP RST.
> 
> Quoting RFC1122 (Requirements for Internet Hosts) section 3.2.2.1:
> 
> > A Destination Unreachable message that is received MUST be
> > reported to the transport layer.  The transport layer SHOULD
> > use the information appropriately; for example, see Sections
> > 4.1.3.3, 4.2.3.9, and 4.2.4 below.  A transport protocol
> > that has its own mechanism for notifying the sender that a
> > port is unreachable (e.g., TCP, which sends RST segments)
> > MUST nevertheless accept an ICMP Port Unreachable for the
> > same purpose.
> 
> and section 4.2.3.9:
> 
> > TCP MUST act on an ICMP error message passed up from the IP
> > layer, directing it to the connection that created the
> > error.  The necessary demultiplexing information can be
> > found in the IP header contained within the ICMP message.
> > [...]
> >
> > o    Destination Unreachable -- codes 2-4
> >
> >      These are hard error conditions, so TCP SHOULD abort
> >      the connection.
> 
> Codes 2-4 correspond to protocol unreachable, port unreachable and
> datagram too big, and are described as hard errors which should abort
> the connection. The RFC does not mention what should be done with a code
> 10 (host administratively prohibited) or code 13 (communication
> administratively prohibited, defined in RFC1812), but I would interpret
> those as hard errors as well.
> 
> I propose that conntrack should drop a connection once it sees a related
> ICMP type 3, code {2,3,4,10,13} message. What does everyone else think?

Yes, at present ICMP(v6) error codes does not terminate TCP connections in 
conntrack. The problem with acting at receiving ICMP error codes is that 
it's easier to fake an ICMP error packet than a TCP RST one, because the 
latter must be acceptable according to the receiver's window too.

Maybe the best were to add the code default disabled.

Best regards,
Jozsef
-
E-mail  : kadlec@blackhole.kfki.hu, kadlec@mail.kfki.hu
PGP key : http://www.kfki.hu/~kadlec/pgp_public_key.txt
Address : KFKI Research Institute for Particle and Nuclear Physics
          H-1525 Budapest 114, POB. 49, Hungary
