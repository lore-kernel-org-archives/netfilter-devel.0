From: Harald Welte <laforge@netfilter.org>
Subject: Re: ctnetlink questions
Date: Mon, 20 Oct 2003 08:58:24 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20031020065824.GY21521@sunbeam.de.gnumonks.org>
References: <20031019171851.GR21521@sunbeam.de.gnumonks.org> <3F92E7CD.3010607@trash.net> <20031019202814.GU21521@sunbeam.de.gnumonks.org> <3F931647.5060204@trash.net>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="RXktk6VS9YWqgSjw"
Cc: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Patrick McHardy <kaber@trash.net>
Content-Disposition: inline
In-Reply-To: <3F931647.5060204@trash.net>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


--RXktk6VS9YWqgSjw
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Oct 20, 2003 at 12:55:03AM +0200, Patrick McHardy wrote:

> Nice thing with the unique ids is that it's better than an atomic=20
> snapshot, when you're done reading you have the _current_ state, not
> the state when you began reading.

well, I don't consider this as particularly important.  As long as it is
doucumented...

> >Also, there's another problem:
> >Let's say we left at bucket 5, entry 12 - and while we are waiting for
> >the next netlink callback, entry 10 gets removed.  Then we would
> >continue at 12, which is in reality the old 13.  So we're missing one
> >conntrack. =20
> >
>=20
> With the unique id solution ? No, the id's don't represent the
> list-position

No, this problem would occur with the old (and my proposed) solution
that doesn't require an ID.

> I didn't worry too much about performance yet, in my opinion it was=20
> required for beeing useful. For the architecture, if it was only for
> table dumping I'd agree with you, but there is another important use
> for the id. When we want to manipulate/delete conntrack entries from
> userspace there is no way to make sure that we will do things the the=20
> right connection since the tuples that are used for lookup could have
> been reused.=20

Mh.  I am wondering if we can make that guarantee without adding the ID
field.  We really should be in the mindset of making ip_conntrack
smaller, not blowing it up.

> >Other approaches I can think of:
> >
> >a) making a snapshot of the whole conntrack table.
> >Large memory usage - probably easy to get OOM :(  Also, read lock on
> >ip_conntrack_lock would have to be grabbed long
> >
> >b) unique ID per hash bucket.  This means less contention, but we could
> >only save bucket id in cb->args, start iterating from the beginning and
> >only send whose ID is newer than the last one we already sent.
> >
> >c) snapshot of the current bucket
> >As with the new hash function every bucket is supposed to be short, we
> >could also make a snapshot of the current bucket, and send our messages
> >from this snapshot copy.
> >
> >what do you think?
> >
>=20
> I think we first need to agree on how important the problems I mentioned=
=20
> above are. All these solutions don't provide reliable mechanisms. Some
> comments though:

Yes.  I am aware of the non-reliability.  For me it is more important to
not interfere with the current connection tracking design, leaving
ctnetlink an addon that doesn't require deep hooks into the conntrack
implementation, and that can live without dozens of #ifdef's.

Let's say that I'm looking upon all possible solutions under that
precondition.

> a) problem is that there can be multiple parallel dumps so we=20
> potentially need many copies.
> I think memory usage is not acceptable.

we can just allow one dump at a time and make every body else either
wait or try again.

> b) I'm not sure if i understand correctly, this is basically what has=20
> been done before my changes except that we would always continue at
> the next bucket id and not just advance if the whole bucket has
> successfully dumped ?

before, the code did dump the same bucket again if it didn't fit in the
skb last time.  My proposed approach would have a unique ct_id inside a
signle bucket list.  This way we can sort-of live without the ordered
list (minus the 12/13 issue pointed out above) but don't dump the same
bucket over and over again.=20

> c) same problem as a, except memory usage is not as bad. IMO it is a=20
> basically a workaround for limited socket buffers to circumvent the
> limits. If we don't need reliability I'd say it's the users job to
> make sure socket buffer limits are set to a reasonable size.

mh.

> So in conclusion if we agree we need reliability, we probably need the
> unique ids. If we agree we don't, I'd say we use solution b.

I'm going to comment on the ID's in my next reply.

> Two last things I noted during writing the mail:
> - Table dumping is currenlty not restricted to root, this should
>   probably be done for privacy reasons.

I'm a bit undecided.  netstat -a, -r are always allowed for every user,
too.  But then, those tables don't indicate forwarded connections... ok,
let's have it require CAP_NET_ADMIN.

> - Have you got objections against s/CTA_RPLY/CTA_REPLY/ ? IMO It makes=20
>   typing and thinking more comfortable if you can actually pronounce
>   what you are thinking about ;)

question is:  are all NFA/CTA constants four letters? than the current
way is actually more consistent.  But feel free to change that, since it
might become a TLV in the future anyway ;)

> Best regards,
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

--RXktk6VS9YWqgSjw
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.3 (GNU/Linux)

iD8DBQE/k4eQXaXGVTD0i/8RAsLpAJkBKvwQ1f5ecSxnNw/+IwhMZHxF0gCgjr2s
WYBUABFpO9YtC3lGMKwV2BI=
=OKlo
-----END PGP SIGNATURE-----

--RXktk6VS9YWqgSjw--
