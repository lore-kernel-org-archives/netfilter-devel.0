From: KOVACS Krisztian <hidden@balabit.hu>
Subject: Re: [nf-failover] [PATCH] Numerous ct_sync updates.
Date: Mon, 18 Oct 2004 09:48:31 +0200
Sender: netfilter-devel-bounces@lists.netfilter.org
Message-ID: <1098085711.2685.39.camel@nienna.balabit>
References: <20041014191624.GH12694@obroa-skai.de.gnumonks.org>
	<1097849367.2498.107.camel@nienna.balabit>
	<20041016081240.GD29413@sunbeam.de.gnumonks.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-2
Content-Transfer-Encoding: quoted-printable
Cc: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>,
	Netfilter-failover list <netfilter-failover@lists.netfilter.org>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Harald Welte <laforge@netfilter.org>
In-Reply-To: <20041016081240.GD29413@sunbeam.de.gnumonks.org>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: </pipermail/netfilter-devel>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
Errors-To: netfilter-devel-bounces@lists.netfilter.org
List-Id: netfilter-devel.vger.kernel.org


  Hi,

2004-10-16, szo keltez=E9ssel 10:12-kor Harald Welte ezt =EDrta:
> On Fri, Oct 15, 2004 at 04:09:27PM +0200, KOVACS Krisztian wrote:
> > 2004-10-14, cs keltez=E9ssel 21:16-kor Harald Welte ezt =EDrta:
> > > - comment out INITSYNC_FOLLOWS code, it shouldn't be needed anymore
> >=20
> >   Yes, it's obsolete now that MASTER_ANNOUNCE is sent before each
> > initial resync. If the end of an initsync run would be signalled as w=
ell
> > (by always sending the empty update message for example) the followin=
g
> > code could be obsoleted as well (it is a hack, after all):
>=20
> the end is not explicitly signalled.  At the moment we just have a flag
> indicating whether the message is part ofan initsync or not.  I have to=
=20
> think about this.  Maybe another flag set in the last message (F_DONE)
> to indicate this is the last msg of a dump.

  Would be useful IMHO. Or even always sending the empty update message
would be enough, but it's too much of a hack.

> > And because the master announcement is now sent without incrementing
> > the sender's seqno (which is correct in my opinion), we really have t=
o
> > subtract 1 in the second part, don't we?
>=20
> It worked here... I spent quite some amount of time debugging sequence
> number issues and it turned out that we always announced a wrong
> sequence number, since the seqno was incremented at the time we enqueue=
d
> packets into the ring.

  Yes, that's right. However, send.ring.seqno is the sequence number of
the next packet to be sent, and recv.ring.seqno is the sequence number
of the last successfuly received packet. Thus, when you send
send.ring.seqno in the master announcement packet and it is received on
the slave and recv.ring.seqno set to that value, you will lose exactly
one packet: the one with that sequence number. It does not cause
problems, because the slave will simply drop that packet thinking that
it has already received it, but it's still a bug.

> However, at the moment I can still have the master (of a
> 2-identical-node setup) generate too many state packets for the slave t=
o
> process.  If I look on the wire, I see the messages, but the slave
> apparently doesn't get them and sends NACK). =20

  What about the socket receive queue? Do you see the packets there, or
does the UDP stack drop the packets because the receive queue is full?
What happens if you tweak threshold values in the receive thread?

  Harald, would it be possible to get some OProfile results for ct_sync
throughout your experiments?

--=20
 Regards,
   Krisztian KOVACS
