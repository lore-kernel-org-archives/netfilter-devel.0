From: Martin Josefsson <gandalf@wlug.westbo.se>
Subject: Re: [PATCH] Small SMP-race found in ip_conntrack_proto_tcp.c
Date: 30 Oct 2002 13:15:24 +0100
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <1035980125.28830.2.camel@tux>
References: <1035472754.722.129.camel@tux>
	<20021030094837.Q8635@sunbeam.de.gnumonks.org>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="=-guUuGs9LHGQtVwG++dnH"
Cc: Netfilter-devel <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Harald Welte <laforge@gnumonks.org>
In-Reply-To: <20021030094837.Q8635@sunbeam.de.gnumonks.org>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


--=-guUuGs9LHGQtVwG++dnH
Content-Type: text/plain
Content-Transfer-Encoding: 7bit

On Wed, 2002-10-30 at 09:48, Harald Welte wrote:
> On Thu, Oct 24, 2002 at 05:19:14PM +0200, Martin Josefsson wrote:
> > Patch to move the unlock further down is attached, I unlock before
> > calling ip_ct_refresh as it is unfriendly to hold the lock longer than
> > neccessary.
> 
> I can't see a patch :)

Damn, I was sure I attached it... well well...
Here it is.

-- 
/Martin

Never argue with an idiot. They drag you down to their level, then beat
you with experience.

--=-guUuGs9LHGQtVwG++dnH
Content-Disposition: attachment; filename=ip_conntrack_proto_tcp-lockfix
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; name=ip_conntrack_proto_tcp-lockfix; charset=ISO-8859-15

--- linux-2.4.20-pre10/net/ipv4/netfilter/ip_conntrack_proto_tcp.c.meep	200=
2-10-24 17:05:49.000000000 +0200
+++ linux-2.4.20-pre10/net/ipv4/netfilter/ip_conntrack_proto_tcp.c	2002-10-=
24 17:11:19.000000000 +0200
@@ -186,13 +186,13 @@
 	    && tcph->syn && tcph->ack)
 		conntrack->proto.tcp.handshake_ack
 			=3D htonl(ntohl(tcph->seq) + 1);
-	WRITE_UNLOCK(&tcp_lock);
=20
 	/* If only reply is a RST, we can consider ourselves not to
 	   have an established connection: this is a fairly common
 	   problem case, so we can delete the conntrack
 	   immediately.  --RR */
 	if (!(conntrack->status & IPS_SEEN_REPLY) && tcph->rst) {
+		WRITE_UNLOCK(&tcp_lock);
 		if (del_timer(&conntrack->timeout))
 			conntrack->timeout.function((unsigned long)conntrack);
 	} else {
@@ -203,6 +203,7 @@
 		    && tcph->ack_seq =3D=3D conntrack->proto.tcp.handshake_ack)
 			set_bit(IPS_ASSURED_BIT, &conntrack->status);
=20
+		WRITE_UNLOCK(&tcp_lock);
 		ip_ct_refresh(conntrack, tcp_timeouts[newconntrack]);
 	}
=20

--=-guUuGs9LHGQtVwG++dnH--
