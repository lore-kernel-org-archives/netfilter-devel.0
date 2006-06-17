From: Eric Leblond <eric@inl.fr>
Subject: Re: [PATCH 1/2] Specify nf_queue max length from userspace
Date: Sat, 17 Jun 2006 23:24:41 +0200
Message-ID: <1150579481.20920.15.camel@porky>
References: <1150217788.7164.4.camel@porky> <1150218404.5386.2.camel@porky>
	<4492A5E5.1020308@netfilter.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature";
	boundary="=-5kl77Dc0IyXFzER20RWr"
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Pablo Neira Ayuso <pablo@netfilter.org>
In-Reply-To: <4492A5E5.1020308@netfilter.org>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: </pipermail/netfilter-devel>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
Sender: netfilter-devel-bounces@lists.netfilter.org
Errors-To: netfilter-devel-bounces@lists.netfilter.org
List-Id: netfilter-devel.vger.kernel.org


--=-5kl77Dc0IyXFzER20RWr
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

Hi Pablo,

On Fri, 2006-06-16 at 14:36 +0200, Pablo Neira Ayuso wrote:
> Hi Eric,
> >  enum nfqnl_config_mode {
> > +	NFQNL_COPY_UNSPEC,
> >  	NFQNL_COPY_NONE,
> >  	NFQNL_COPY_META,
> >  	NFQNL_COPY_PACKET,
>=20
> If you have to add new attributes, do it always at the end, in other=20
> words, just before NFQNL_COPY_MAX. Otherwise you're breaking backward=20
> compatibility. See that old binaries use COPY_NONE set to 0, but after=20
> applying your patch COPY_NONE is set to 1. Result: old binaries will no=20
> work with nfnetlink_queue anymore.

I agree with you on this point. But, as I know that second point was
also breaking compatibility, I've made the choice to put less
significant value first. It looks cleaner to me.

> > @@ -75,6 +76,7 @@ enum nfqnl_config_mode {
> >  struct nfqnl_msg_config_params {
> >  	u_int32_t	copy_range;
> >  	u_int8_t	copy_mode;	/* enum nfqnl_config_mode */
> > +	u_int32_t   queue_maxlen;
> >  } __attribute__ ((packed));
>=20
> Same thing here. If you have to modify this structure, you need to=20
> create a new one called struct nfqnl_msg_config_params2. Since I don't=20
> like this option, I think that the best solution is to add a new=20
> attribute called NFQNL_CFG_QUEUE_MAXLEN.

I also think this is the cleanest way not to loose binary compatibility.
But, as you notice it, it's ugly as queue max length is a param. The
user-basis of libnetfilter_queue is really small for the moment: Only
about two projects use it. There may be also some unpublished project
but it should hurt too much to break binary compatibility to have a
cleaner code.

In fact, I think that having only one attribute and one structure could
be used in the future to have a function that will be able to set copy
mode and queue length in one call and one message.

BR,
--=20
Eric Leblond <eric@inl.fr>
INL

--=-5kl77Dc0IyXFzER20RWr
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.3 (GNU/Linux)

iD8DBQBElHMZnxA7CdMWjzIRAnBWAKCHvK6jI1pOpYiAtNOFUIVHW9B/yACePPh7
05GGdDigXRp0d0Ux4jisikY=
=FHWf
-----END PGP SIGNATURE-----

--=-5kl77Dc0IyXFzER20RWr--
