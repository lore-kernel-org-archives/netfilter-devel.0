From: Harald Welte <laforge@netfilter.org>
Subject: Re: ctnetlink questions
Date: Sun, 19 Oct 2003 22:28:14 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20031019202814.GU21521@sunbeam.de.gnumonks.org>
References: <20031019171851.GR21521@sunbeam.de.gnumonks.org> <3F92E7CD.3010607@trash.net>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="JQcP/qOTM3HdZIaJ"
Cc: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Patrick McHardy <kaber@trash.net>
Content-Disposition: inline
In-Reply-To: <3F92E7CD.3010607@trash.net>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


--JQcP/qOTM3HdZIaJ
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sun, Oct 19, 2003 at 09:36:45PM +0200, Patrick McHardy wrote:

> >1) Why do we need this 'ordered list' ?  I can't remember the exact=20
> >  reason why it was added
> >
> The ordered list and the unique conntrack id was added for table=20
> dumping. Without it entries could be dumped multiple times or even
> worse a single hash chain chould be dumped over and over again if it's
> contents exceeded the size of a single skb.

ah, yes.  I remember.  but that actually is a shortcoming of the netlink
api, isn't it?  The problem is that we cannot save an exact position in
the hashtable where we stopped dumping.   So in my original ctnetlink we
just dump a whole bucket and saved the bucket number in cb->args[].  But
if we were saving bucket number + number of connection in bucket, we
could continue where we left from. =20

Of course, entries could be added before that number (or even in buckets
that we had already traversed) - but we don't guarantee an atomic
snapshot anyway.

Also, there's another problem:
Let's say we left at bucket 5, entry 12 - and while we are waiting for
the next netlink callback, entry 10 gets removed.  Then we would
continue at 12, which is in reality the old 13.  So we're missing one
conntrack. =20

The question is what to do.  I really don't like having yet another list
of conntracks (the ordered list) together with the unique id.  It is
questionable how big the impact on performance is (contention on unique
ID, bigger struct ip_conntrack, additional list_add's), but even if it
was 'cheap', I don't like the architecture.

Other approaches I can think of:

a) making a snapshot of the whole conntrack table.
Large memory usage - probably easy to get OOM :(  Also, read lock on
ip_conntrack_lock would have to be grabbed long

b) unique ID per hash bucket.  This means less contention, but we could
only save bucket id in cb->args, start iterating from the beginning and
only send whose ID is newer than the last one we already sent.

c) snapshot of the current bucket
As with the new hash function every bucket is supposed to be short, we
could also make a snapshot of the current bucket, and send our messages
=66rom this snapshot copy.

what do you think?

> >2) Why did you merge connmark and ctnetlink?  Was it just for
> >  convenience? If yes, I'd appreciate to have them seperated again.
> >
> It's just a left-over .. I started hacking on ctnetlink to change=20
> connection marks
> from userspace .. I'm going to remove it from the next patch.

As you may have noticed, I already did that with 0.13 in current cvs.

> Patrick


--=20
- Harald Welte <laforge@netfilter.org>             http://www.netfilter.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
  "Fragmentation is like classful addressing -- an interesting early
   architectural error that shows how much experimentation was going
   on while IP was being designed."                    -- Paul Vixie

--JQcP/qOTM3HdZIaJ
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.3 (GNU/Linux)

iD8DBQE/kvPeXaXGVTD0i/8RAtIpAJ42tlYTbwspUmsaxOaFNWPbo7/RHwCgh8Z2
V9l3G7p3ZL1IbKXxn5jrJ8w=
=Xzlq
-----END PGP SIGNATURE-----

--JQcP/qOTM3HdZIaJ--
