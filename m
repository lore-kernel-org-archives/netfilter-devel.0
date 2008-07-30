From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Subject: Re: TCP connection tracking timeout
Date: Wed, 30 Jul 2008 23:18:42 +0200 (CEST)
Message-ID: <Pine.LNX.4.64.0807302208030.3210@blackhole.kfki.hu>
References: <20080729030104.GA15915@gondor.apana.org.au> <488EA0F1.2050906@trash.net>
 <488EA3FE.7050503@trash.net> <20080729060105.GA16797@gondor.apana.org.au>
 <488EB4F1.60806@trash.net> <20080729090737.GA18046@gondor.apana.org.au>
 <Pine.LNX.4.64.0807291420590.1378@blackhole.kfki.hu>
 <20080729133444.GA19876@gondor.apana.org.au> <Pine.LNX.4.64.0807292135290.1679@blackhole.kfki.hu>
 <20080730013554.GA25736@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Patrick McHardy <kaber@trash.net>,
	Netfilter Developer Mailing List
	<netfilter-devel@vger.kernel.org>
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp-in.kfki.hu ([148.6.0.28]:44193 "EHLO smtp2.kfki.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759675AbYG3VSp (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 30 Jul 2008 17:18:45 -0400
In-Reply-To: <20080730013554.GA25736@gondor.apana.org.au>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi,

On Wed, 30 Jul 2008, Herbert Xu wrote:

> All I'm trying say is that the state transition as it stands is bogus.  
> Here is why:
> 
> If you see receive a FIN in one direction but no ack in the other,
> you go from sES to sFW.  If that isn't acked and a FIN retransmit
> occurs you go from sFW to sLA.  Now if the other direction is still
> transmitting and you get an ACK in the direction being shut down,
> it goes from sLA to sTW.  However, in reality the side that's still
> transmitting may still be in ESTABLISHED because it never received
> those FINs.

Yes, absolutely right. From the comments of the state transition table:

 *      sFW -> sLA      FIN seen in both directions, waiting for
 *                      the last ACK.
 *                      Migth be a retransmitted FIN as well...

As we already handle a lot of exceptions, what do you think about the next 
(untested) patch?

diff --git a/net/netfilter/nf_conntrack_proto_tcp.c b/net/netfilter/nf_conntrack_proto_tcp.c
index 6f61261..a9b3b8f 100644
--- a/net/netfilter/nf_conntrack_proto_tcp.c
+++ b/net/netfilter/nf_conntrack_proto_tcp.c
@@ -911,6 +911,15 @@ static int tcp_packet(struct nf_conn *ct,
 			nf_log_packet(pf, 0, skb, NULL, NULL, NULL,
 				  "nf_ct_tcp: invalid state ");
 		return -NF_ACCEPT;
+	case TCP_CONNTRACK_LAST_ACK:
+	case TCP_CONNTRACK_CLOSE_WAIT:
+		/* Check and compensate retransmitted FIN or
+		 * reordered ACK packets */
+		if (old_state == TCP_CONNTRACK_FIN_WAIT
+		    && (ct->proto.tcp.seen[dir].flags
+		        & IP_CT_TCP_FLAG_CLOSE_INIT))
+		        new_state = TCP_CONNTRACK_FIN_WAIT;
+		break;
 	case TCP_CONNTRACK_CLOSE:
 		if (index == TCP_RST_SET
 		    && ((test_bit(IPS_SEEN_REPLY_BIT, &ct->status)


Best regards,
Jozsef
-
E-mail  : kadlec@blackhole.kfki.hu, kadlec@mail.kfki.hu
PGP key : http://www.kfki.hu/~kadlec/pgp_public_key.txt
Address : KFKI Research Institute for Particle and Nuclear Physics
          H-1525 Budapest 114, POB. 49, Hungary
