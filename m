From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Subject: Re: TCP connection tracking timeout
Date: Tue, 29 Jul 2008 22:34:51 +0200 (CEST)
Message-ID: <Pine.LNX.4.64.0807292135290.1679@blackhole.kfki.hu>
References: <20080729030104.GA15915@gondor.apana.org.au> <488EA0F1.2050906@trash.net>
 <488EA3FE.7050503@trash.net> <20080729060105.GA16797@gondor.apana.org.au>
 <488EB4F1.60806@trash.net> <20080729090737.GA18046@gondor.apana.org.au>
 <Pine.LNX.4.64.0807291420590.1378@blackhole.kfki.hu>
 <20080729133444.GA19876@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Patrick McHardy <kaber@trash.net>,
	Netfilter Developer Mailing List
	<netfilter-devel@vger.kernel.org>
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp1.kfki.hu ([148.6.0.26]:44008 "EHLO smtp1.kfki.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752765AbYG2Uex (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 29 Jul 2008 16:34:53 -0400
In-Reply-To: <20080729133444.GA19876@gondor.apana.org.au>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Tue, 29 Jul 2008, Herbert Xu wrote:

> On Tue, Jul 29, 2008 at 02:30:14PM +0200, Jozsef Kadlecsik wrote:
> >
> > We always approximate the state of the sender from the packet it sends. As 
> > packets can be lost in transit (i.e we see a packet but it'll be lost), we 
> > cannot say for sure every time which is the actual state of *both* of the 
> > parties. Therefore we do not even attempt to track both states.
> 
> No I'm not suggesting that your state must be equal to that of each 
> side, what I'm saying is that the TCP state machine is fundamentally 
> divided into two directions. If you're going to track state at all you 
> need to track both directions separately. Otherwise the state 
> transitions are simply bogus.

Completely true - but the states in netfilter do no correspond one-to-one 
to the real TCP states. From nf_conntrack_proto_tcp.c:

 * The meaning of the states are:
 *
 * NONE:        initial state
 * SYN_SENT:    SYN-only packet seen
 * SYN_RECV:    SYN-ACK packet seen
 * ESTABLISHED: ACK packet seen
 * FIN_WAIT:    FIN packet seen
 * CLOSE_WAIT:  ACK seen (after FIN)
 * LAST_ACK:    FIN seen (after FIN)
 * TIME_WAIT:   last ACK seen
 * CLOSE:       closed connection

We try to get a general view of the connection. It is not rocket science 
what we are doing.

> For example, TIME_WAIT is a state that only makes sense if
> you look at a given direction.  The other direction may well
> still be ESTABLISHED.  As it is netfilter will lower the timeout
> when only a single direction has been shut down, thus causing
> the connection to be prematurely killed.

Hm, I might be completely outdated: how come that in one direction the 
state is TIME_WAIT and the other's ESTABLISHED? If one side is in the 
TIME_WAIT state, the other one cannot be in the ESTABLISHED state - at 
least according to RFC793, RFC1122. What do I miss here?

Best regards,
Jozsef
-
E-mail  : kadlec@blackhole.kfki.hu, kadlec@mail.kfki.hu
PGP key : http://www.kfki.hu/~kadlec/pgp_public_key.txt
Address : KFKI Research Institute for Particle and Nuclear Physics
          H-1525 Budapest 114, POB. 49, Hungary
