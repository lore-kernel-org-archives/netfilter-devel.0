Received: from tarta.nabijaczleweli.xyz (tarta.nabijaczleweli.xyz [139.28.40.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3B8AA1AD402
	for <netfilter-devel@vger.kernel.org>; Thu, 26 Sep 2024 11:05:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=139.28.40.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727348726; cv=none; b=g7LfLU+mUg04ffHBWybTCH7VzYCLou05NbcGT/BzZgstYhDLt1R1rzIXhmQzXfkQKftU8eCsHiDp0ZiYua4UvHoGyPdf25CqWnfUe40F1ri6d9izqF8zMJtpCtsulTGgFuKJFtoORWv0O+Z1bAfO1TyXoh6wp/1y0jrt+ZaDauU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727348726; c=relaxed/simple;
	bh=nhZpuYhqR8XgLXDJoMaH7uKXAnPizdIax5I3ZZUM4aw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ueJTYYzEDkheqv6K10xxuf3aEzO4q1xfpqmVEEEihWyjmMxdkjlfrgN39H55gJ92hgBNiHdSyIBdvECxCncO00FmFvVnk+iJ8h9ljFKhmcwY3XZ8/8VVbt5C4/fvhbiz3BOwF4FGfu3gCw7Jv+qTCCWsL4CNhHU9kPy4BJfsA3o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nabijaczleweli.xyz; spf=pass smtp.mailfrom=nabijaczleweli.xyz; dkim=pass (2048-bit key) header.d=nabijaczleweli.xyz header.i=@nabijaczleweli.xyz header.b=OoCxVQzf; arc=none smtp.client-ip=139.28.40.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nabijaczleweli.xyz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nabijaczleweli.xyz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nabijaczleweli.xyz header.i=@nabijaczleweli.xyz header.b="OoCxVQzf"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=nabijaczleweli.xyz;
	s=202405; t=1727348718;
	bh=nhZpuYhqR8XgLXDJoMaH7uKXAnPizdIax5I3ZZUM4aw=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=OoCxVQzfBlh0mS2KXrEFi1PzucwqCT6JktbmUVIXxyYSo1u3GBzBi+X8velxcqAEs
	 J7zOOuXei8aK7UDF9iisFl9wslCIkgxIDail9bhp5XB13oQEq2WdBX3XBPXihTHLy0
	 nPa6bdHF77cGD/Mhol6g0Tl2j+S8Tx0rdGVUEQqa0cGaFTlaQjWyf369mUcRNOgEad
	 BBw4IWWfNXjBqd3i3P9xkK9NzwBl+fPzVWqdnJ17qy+NBj32cPr9SXMPxlh2R4AxRO
	 1A4Q4vWdLcFE/45PJvbpiNRL9DfAeRkEskjNJvcXgAvtykwXGM7+fnHjJ/n54H05wp
	 N80/zUwAb8m+g==
Received: from tarta.nabijaczleweli.xyz (unknown [192.168.1.250])
	by tarta.nabijaczleweli.xyz (Postfix) with ESMTPSA id 9DB7C111C;
	Thu, 26 Sep 2024 13:05:18 +0200 (CEST)
Date: Thu, 26 Sep 2024 13:05:18 +0200
From: =?utf-8?B?0L3QsNCx?= <nabijaczleweli@nabijaczleweli.xyz>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: netfilter-devel@vger.kernel.org
Subject: Re: [PATCH] conntrack: -L doesn't take a value, so don't discard one
 (same for -IUDGEFA)
Message-ID: <rve43sboukvu3bzywntk6gidhqut4hi5yq2c65ze7xti4ctjgz@tarta.nabijaczleweli.xyz>
References: <hpsesrayjbjrtja3unjpw4a3tsou3vtu7yjhrcba7dfnrahwz2@tarta.nabijaczleweli.xyz>
 <ZtbHMe6STK_W6yfA@calendula>
 <bymeee6fsub6oz64xtykfru25aq6xx4k2agjbeabekzfobu4jd@tarta.nabijaczleweli.xyz>
 <ZvQj_TOKcN7A9kmz@calendula>
 <qe4cxltrompmuajfgfkedrecefkyy2eopi3erttlm7c3xigs2g@tarta.nabijaczleweli.xyz>
 <ZvRze9JEBJ28ityC@calendula>
 <2pdkunyljqasunwbqeofqdetpda2xfdqtyrqg6sqr4efwuwzlq@tarta.nabijaczleweli.xyz>
 <ZvU4WBNuXWQ-wEuL@calendula>
 <ZvU5kFP-523XCzqU@calendula>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="6j7r4cxogbeaiekd"
Content-Disposition: inline
In-Reply-To: <ZvU5kFP-523XCzqU@calendula>
User-Agent: NeoMutt/20231221-2-4202cf-dirty


--6j7r4cxogbeaiekd
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Sep 26, 2024 at 12:38:08PM +0200, Pablo Neira Ayuso wrote:
> On Thu, Sep 26, 2024 at 12:33:00PM +0200, Pablo Neira Ayuso wrote:
> > On Thu, Sep 26, 2024 at 10:28:58AM +0200, =D0=BD=D0=B0=D0=B1 wrote:
> > > On Wed, Sep 25, 2024 at 10:32:59PM +0200, Pablo Neira Ayuso wrote:
> > > > On Wed, Sep 25, 2024 at 05:11:01PM +0200, Ahelenia Ziemia=C5=84ska =
wrote:
> > > > > On Wed, Sep 25, 2024 at 04:53:49PM +0200, Pablo Neira Ayuso wrote:
> > > > > > On Tue, Sep 03, 2024 at 04:53:46PM +0200, Ahelenia Ziemia=C5=84=
ska wrote:
> > > > > > > On Tue, Sep 03, 2024 at 10:22:09AM +0200, Pablo Neira Ayuso w=
rote:
> > > > > > > > On Tue, Sep 03, 2024 at 04:16:21AM +0200, Ahelenia Ziemia=
=C5=84ska wrote:
> > > > > > > > > The manual says
> > > > > > > > >    COMMANDS
> > > > > > > > >        These options specify the particular operation to =
perform.
> > > > > > > > >        Only one of them can be specified at any given tim=
e.
> > > > > > > > >=20
> > > > > > > > >        -L --dump
> > > > > > > > >               List connection tracking or expectation tab=
le
> > > > > > > > >=20
> > > > > > > > > So, naturally, "conntrack -Lo extended" should work,
> > > > > > > > > but it doesn't, it's equivalent to "conntrack -L",
> > > > > > > > > and you need "conntrack -L -o extended".
> > > > > > > > > This violates user expectations (borne of the Utility Syn=
tax Guidelines)
> > > > > > > > > and contradicts the manual.
> > > > > > > > >=20
> > > > > > > > > optarg is unused, anyway. Unclear why any of these were :=
: at all?
> > > > > > > > Because this supports:
> > > > > > > >         -L
> > > > > > > >         -L conntrack
> > > > > > > >         -L expect
> > > > > > > Well that's not what :: does, though; we realise this, right?
> > > > > > >=20
> > > > > > > "L::" means that getopt() will return
> > > > > > >   "-L", "conntrack" -> 'L',optarg=3DNULL
> > > > > > >   "-Lconntrack"     -> 'L',optarg=3D"conntrack"
> > > > > > > and the parser for -L (&c.) doesn't... use optarg.
> > > > > > Are you sure it does not use optarg?
> > > > > >=20
> > > > > > static unsigned int check_type(int argc, char *argv[])
> > > > > > {
> > > > > >         const char *table =3D get_optional_arg(argc, argv);
> > > > > >=20
> > > > > > and get_optional_arg() uses optarg.
> > > > > This I've missed, but actually my diagnosis still holds:
> > > > >   static unsigned int check_type(int argc, char *argv[])
> > > > >   {
> > > > >   	const char *table =3D get_optional_arg(argc, argv);
> > > > >  =20
> > > > >   	/* default to conntrack subsystem if nothing has been specifie=
d. */
> > > > >   	if (table =3D=3D NULL)
> > > > >   		return CT_TABLE_CONNTRACK;
> > > > >=20
> > > > >   static char *get_optional_arg(int argc, char *argv[])
> > > > >   {
> > > > >   	char *arg =3D NULL;
> > > > >  =20
> > > > >   	/* Nasty bug or feature in getopt_long ?
> > > > >   	 * It seems that it behaves badly with optional arguments.
> > > > >   	 * Fortunately, I just stole the fix from iptables ;) */
> > > > >   	if (optarg)
> > > > >   		return arg;
> > > > >=20
> > > > > So, if you say -Lanything, then
> > > > >   optarg=3Danything
> > > > >   get_optional_arg=3D(null)
> > > > > (notice that it says "return arg;", not "return optarg;",
> > > > >  i.e. this is "return NULL").
> > > > >=20
> > > > > It /doesn't/ use optarg, because it explicitly treats an optarg a=
s no optarg.
> > > > >=20
> > > > > It's unclear to me what the comment is referencing,
> > > > > but I'm assuming some sort of confusion with what :: does?
> > > > > Anyway, that if(){ can be removed now, since it can never be take=
n now.
> > > > Then, this breaks:
> > > > # conntrack -Lexpect
> > > > conntrack v1.4.9 (conntrack-tools): Bad parameter `xpect'
> > > > Try `conntrack -h' or 'conntrack --help' for more information.
> > > >=20
> > > > Maybe your patch needs an extension to deal with this case too?
> > > This doesn't "break", this is equivalent to conntrack -L -e xpect.
> > > It's now correct. This was the crux of the patch, actually.
> > >=20
> > > Compare the manual:
> > >   SYNOPSIS
> > >     conntrack -L [table] [options] [-z]
> > >   COMMANDS
> > >     -L --dump     List connection tracking or expectation table
> > >   PARAMETERS
> > >     -e, --event-mask [ALL|NEW|UPDATES|DESTROY][,...]
> > >                   Set the bitmask of events that are to be generated =
by the in-kernel ctnetlink event code.  Using this parameter, you can reduc=
e the event messages  generated
> > >                   by the kernel to the types that you are actually in=
terested in.  This option can only be used in conjunction with "-E, --event=
".
> > >=20
> > > Previously, it /was/ broken: conntrack -Lexpect was as-if --dump=3Dex=
pect
> > > (also not legal since --dump doesn't take an argument),
> > > and the "expect" was ignored, so it was equivalent to conntrack -L.
> > > You can trivially validate this by running an older version.
> > >=20
> > > (Well, --dump=3Dexpect /is/ accepted. And ignored.
> > >  So fix that too with s/optional_argument/no_argument/ (or s/2/0/).
> > >  I didn't actually look at the longopts before.)
> > >=20
> > > > The issue that I'm observing is that
> > > >   # conntrack -Lconntrack
> > > > now optarg is NULL after your patch, so 'conntrack' is ignored, so =
it
> > > > falls back to list the conntrack table.
> > >=20
> > > What do you mean "now". That shit was always ignored.
> > > You can read trace the calls yourself if you don't believe my analysi=
s.
> > > Now it behaves as-documented (-L -c onntrack).
> > >=20
> > > And, per
> > >                 case 'c':
> > >                         options |=3D opt2type[c];
> > >                         nfct_set_attr_u32(tmpl->ct,
> > >                                           opt2attr[c],
> > >                                           strtoul(optarg, NULL, 0));
> > >                         break;
> > > -c onntrack is equivalent to -c 0.
> > > This is also obviously wrong.
> > >=20
> > > I will repeat this and you can confirm this once more
> > > (or refer back to my analysis above):
> > > for all of -LIUDGEFA, an optional parameter was accepted, and always =
discarded.
> > > It now isn't, and behaves as-expected per the USG
> > > ("the USG" is an annoying way to say "how getopt() works".
> > >=20
> > > > Regarding your question, this parser is old and I shamelessly took =
it
> > > > from the original iptables to make syntax similar.
> > > So you have someone to blame it on when it turns out to be dysfunctio=
nal.
> > > But you also have a huge parser that doesn't work.
> > > Win some/lose some, I suppose.
> > Your stuff breaks existing behaviour. I will revert and leave it as is.
> >=20
> > There is a risk of breaking existing applications.
Hardly, since the behaviour you're trying to preserve is undocumented
(well, actually runs counter to your documentation)
and currently does nothing.

> > You can use the word shit, dysfunctional, and keep augment your
> > wording as many times as you want, but that does not change my point.
AFAICT so far your point was never that you believe that the current
behaviour is correct, and I thought it impossible to argue this.

> So either fix it is a backward compatible way or there will be no fix.
If you don't intend to fix this parser
(defined as "don't intend to make it behave like you document it")
then ship documentation that accurately describes it.
That should be simple enough,
provided you know what it does and what behaviour you're preserving.

--6j7r4cxogbeaiekd
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEEfWlHToQCjFzAxEFjvP0LAY0mWPEFAmb1P+wACgkQvP0LAY0m
WPG82w//S9CHKIdoFrprqw+o4xiH+75+hMWBcdysAIgYpbrlJKodrtO3WnZupIO6
S3ELc7Zaxt4S9TjEQgwb9ROOXWHZdnJla0rx5ehcS/0cMWhtdH4Jcsy1h/Vi/HQ4
L/omCqf8qH0DN47BbUHkij+LsNuFI75yTbgGOC47hbqrOxTI66lSCxzoDsQcQmN/
wihWM88f1HvyOHZFHBAGk0IeaBQojHbzOjV1BA8Dh2j1db96yO81lo9Gl+oNmFH7
C23YbcK844zopB6Hf13LymmqgLOvWixvjkuUYvuALUjPBhRF8mLSS1YewLnZRQKL
EAc66OLPIARU8H+wqhb280XK+wtm90GiMXytD3xONDU5EfFRNSpCigx3d4RjpqyM
JBWYoAGyRTquvehtSTGHz9Lc4zg0lnxcHTIU1WVyo9HF6yBRUmh6HR8LAMSNx9/A
OVPv56j32t5gsBD5L/BjSEOBxzNZWRDkG/R6hjEIYxFf8+ijs7n+r6vRRtNrce5F
r0oRsS3jqreHHw/5QUTnZGWIRS2SSwxXXP/h0SOMUAt+XmPAA7cuVZDYwtPKueZE
rLzuyujYQdHDdWng00U35Ppw5Bvb7I/byYrbUZrLSRkJ0Om6Dpy+PKbsZyi7ALej
tShm75eIKolhsAsZ95H5CC1LBPf0zzSXU1JwVN2pU8oqyvW89AE=
=+tX/
-----END PGP SIGNATURE-----

--6j7r4cxogbeaiekd--
