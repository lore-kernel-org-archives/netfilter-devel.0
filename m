From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Subject: Re: conntrack and RSTs received during CLOSE_WAIT
Date: Fri, 22 May 2009 13:27:20 +0200 (CEST)
Message-ID: <alpine.DEB.2.00.0905221255140.14889@blackhole.kfki.hu>
References: <4A0DE859.7000209@tigertech.com> <4A0F7FEE.3010405@tigertech.com>  <4A139222.2020505@tigertech.com>  <alpine.DEB.2.00.0905200904310.10018@blackhole.kfki.hu>  <4A1466F6.8070304@tigertech.com>  <alpine.DEB.2.00.0905202327240.11796@blackhole.kfki.hu>
  <alpine.DEB.2.00.0905211729090.13699@blackhole.kfki.hu>  <4A15A156.6030400@tigertech.com>  <38db14850905212132x3d4f4d83y6808ad89d2d79324@mail.gmail.com>  <alpine.DEB.2.00.0905220917190.14889@blackhole.kfki.hu> <38db14850905220126t55f0e754y6c65cbfaed533bc0@mail.gmail.com>
 <alpine.DEB.2.00.0905221047190.14889@blackhole.kfki.hu>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter@vger.kernel.org, netfilter-devel@vger.kernel.org
To: Robert L Mathews <lists@tigertech.com>,
	Anatoly Muliarski <x86ever@gmail.com>
Return-path: <netfilter-owner@vger.kernel.org>
In-Reply-To: <alpine.DEB.2.00.0905221047190.14889@blackhole.kfki.hu>
Sender: netfilter-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

On Fri, 22 May 2009, Jozsef Kadlecsik wrote:

> On Fri, 22 May 2009, Anatoly Muliarski wrote:
> 
> > > This is the main problem: we can never be sure the packets which are seen
> > > by firewall do really reach the destination or they order is preserved.
> 
> > We could save the LAST sequence number as a current one.
> > So we keep the connection and mark the current RST as invalid and
> > correctly react on the following ones. Unfortunately this does not
> > solve the main problem - unable to know whether the received sequence
> > number is valid or not. As an vague idea - we could track the ack
> > number from other direction and so keep the last delivered sequence
> > number. What can say about it?
> 
> Relying on the last ACK received from the other direction looks promising. 
> We record the last (highest) ACK sent by both endpoints, which makes sure 
> the packet they ack they did indeed received. And we accept a RST segment 
> only if it's in the window we calculate (wider than the destination's) AND 
> equal or higher than the saved last ACK from the other direction.
> 
> The only downside is that new fields must be added to struct ip_ct_tcp.

So here is the patch which adds checking RST segments against the highest 
ack we seen from the other direction. I tested it with your script and 
conntrack could resist receiving bogus RST segments.

diff --git a/include/linux/netfilter/nf_conntrack_tcp.h b/include/linux/netfilter/nf_conntrack_tcp.h
index 3066789..b2f384d 100644
--- a/include/linux/netfilter/nf_conntrack_tcp.h
+++ b/include/linux/netfilter/nf_conntrack_tcp.h
@@ -35,6 +35,9 @@ enum tcp_conntrack {
 /* Has unacknowledged data */
 #define IP_CT_TCP_FLAG_DATA_UNACKNOWLEDGED	0x10
 
+/* The field td_maxack has been set */
+#define IP_CT_TCP_FLAG_MAXACK_SET		0x20
+
 struct nf_ct_tcp_flags {
 	__u8 flags;
 	__u8 mask;
@@ -46,6 +49,7 @@ struct ip_ct_tcp_state {
 	u_int32_t	td_end;		/* max of seq + len */
 	u_int32_t	td_maxend;	/* max of ack + max(win, 1) */
 	u_int32_t	td_maxwin;	/* max(win) */
+	u_int32_t	td_maxack;	/* max of ack */
 	u_int8_t	td_scale;	/* window scale factor */
 	u_int8_t	flags;		/* per direction options */
 };
diff --git a/net/netfilter/nf_conntrack_proto_tcp.c b/net/netfilter/nf_conntrack_proto_tcp.c
index b5ccf2b..97a6e93 100644
--- a/net/netfilter/nf_conntrack_proto_tcp.c
+++ b/net/netfilter/nf_conntrack_proto_tcp.c
@@ -634,6 +634,14 @@ static bool tcp_in_window(const struct nf_conn *ct,
 			sender->td_end = end;
 			sender->flags |= IP_CT_TCP_FLAG_DATA_UNACKNOWLEDGED;
 		}
+		if (tcph->ack) {
+			if (!(sender->flags & IP_CT_TCP_FLAG_MAXACK_SET)) {
+				sender->td_maxack = ack;
+				sender->flags |= IP_CT_TCP_FLAG_MAXACK_SET;
+			} else if (after(ack, sender->td_maxack))
+				sender->td_maxack = ack;
+		}
+
 		/*
 		 * Update receiver data.
 		 */
@@ -919,6 +927,16 @@ static int tcp_packet(struct nf_conn *ct,
 		return -NF_ACCEPT;
 	case TCP_CONNTRACK_CLOSE:
 		if (index == TCP_RST_SET
+		    && (ct->proto.tcp.seen[!dir].flags & IP_CT_TCP_FLAG_MAXACK_SET)
+		    && before(ntohl(th->seq), ct->proto.tcp.seen[!dir].td_maxack)) {
+			/* Invalid RST  */
+			write_unlock_bh(&tcp_lock);
+			if (LOG_INVALID(net, IPPROTO_TCP))
+				nf_log_packet(pf, 0, skb, NULL, NULL, NULL,
+					  "nf_ct_tcp: invalid RST ");
+			return -NF_ACCEPT;
+		}
+		if (index == TCP_RST_SET
 		    && ((test_bit(IPS_SEEN_REPLY_BIT, &ct->status)
 			 && ct->proto.tcp.last_index == TCP_SYN_SET)
 			|| (!test_bit(IPS_ASSURED_BIT, &ct->status)

Best regards,
Jozsef
-
E-mail  : kadlec@blackhole.kfki.hu, kadlec@mail.kfki.hu
PGP key : http://www.kfki.hu/~kadlec/pgp_public_key.txt
Address : KFKI Research Institute for Particle and Nuclear Physics
          H-1525 Budapest 114, POB. 49, Hungary
