Received: from tarta.nabijaczleweli.xyz (tarta.nabijaczleweli.xyz [139.28.40.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 236341A4E85
	for <netfilter-devel@vger.kernel.org>; Thu, 26 Sep 2024 08:29:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=139.28.40.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727339346; cv=none; b=HaIelUC2Q6l8RZ8I2ebZ8Ow9HpGuECdI5TYVQXud2+huGp8CkmiWsOz6GALZlConud2/LxNP1KoBYiPIyTCzmP8CtQCa93Rz5uIvoc+/qEo21aJVv8mznb2EovdnqcvWA8aKJCKvwPRmL1eTVB0Hs/Q/mfZV9uw+/f1I74WSRqo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727339346; c=relaxed/simple;
	bh=B7UtaNMesEKHA3qpkuikxjp/SzHX8a1zyseN79LfMbw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=iHqPoLn4GRNX880E4OU+6pAGF0VN/NcpWuhwMJBN+aRW5lwImGPWzBuWHAW8TySKngRSB1G8qzDkg6Dd9bMbcqtwRmuKrEnwWyg0RCGA5j4NIzwnsDQ+qtVMLCGmt61lhjyz3zPzAH2qSEt1c6DkcSi2xYz3yrDBlowX4CHMd0s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nabijaczleweli.xyz; spf=pass smtp.mailfrom=nabijaczleweli.xyz; dkim=pass (2048-bit key) header.d=nabijaczleweli.xyz header.i=@nabijaczleweli.xyz header.b=IZnZQ2Pw; arc=none smtp.client-ip=139.28.40.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nabijaczleweli.xyz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nabijaczleweli.xyz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=nabijaczleweli.xyz header.i=@nabijaczleweli.xyz header.b="IZnZQ2Pw"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=nabijaczleweli.xyz;
	s=202405; t=1727339339;
	bh=B7UtaNMesEKHA3qpkuikxjp/SzHX8a1zyseN79LfMbw=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=IZnZQ2PwBu+VV3H6ziUdaiyFl+yT/twV6dCcja0Xe5JWvDpNMKyGHTvQAJIDSXsgD
	 Up5c7EpE2UmVL2xeTnpyC/dIJ5xtGkMJS8t1lkT8O4boXe4P0e151dpGgU0fqQOICe
	 ySGLNL+IjhAn8gQY/5JZs0MzqR2jB4+yDtDSptC42vOngosybEO5FsEQoFlTkoaLxu
	 5wHN1epBd3GvXpygReUr6ENbcBewJ9pcjWKxkbbnGMH5aO4TWndJgHD+/tHAfWyad4
	 pR3g+sSCPMlOwEb5W4CjMrkfjYkBQqy0240xNNJzlntO0eIyJkCKVWKwXMvFIhgZOk
	 AoM3yUwjI6LRQ==
Received: from tarta.nabijaczleweli.xyz (unknown [192.168.1.250])
	by tarta.nabijaczleweli.xyz (Postfix) with ESMTPSA id 32714E6C;
	Thu, 26 Sep 2024 10:28:59 +0200 (CEST)
Date: Thu, 26 Sep 2024 10:28:58 +0200
From: =?utf-8?B?0L3QsNCx?= <nabijaczleweli@nabijaczleweli.xyz>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: netfilter-devel@vger.kernel.org
Subject: Re: [PATCH] conntrack: -L doesn't take a value, so don't discard one
 (same for -IUDGEFA)
Message-ID: <2pdkunyljqasunwbqeofqdetpda2xfdqtyrqg6sqr4efwuwzlq@tarta.nabijaczleweli.xyz>
References: <hpsesrayjbjrtja3unjpw4a3tsou3vtu7yjhrcba7dfnrahwz2@tarta.nabijaczleweli.xyz>
 <ZtbHMe6STK_W6yfA@calendula>
 <bymeee6fsub6oz64xtykfru25aq6xx4k2agjbeabekzfobu4jd@tarta.nabijaczleweli.xyz>
 <ZvQj_TOKcN7A9kmz@calendula>
 <qe4cxltrompmuajfgfkedrecefkyy2eopi3erttlm7c3xigs2g@tarta.nabijaczleweli.xyz>
 <ZvRze9JEBJ28ityC@calendula>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="rmhl4kx6wum44llv"
Content-Disposition: inline
In-Reply-To: <ZvRze9JEBJ28ityC@calendula>
User-Agent: NeoMutt/20231221-2-4202cf-dirty


--rmhl4kx6wum44llv
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Sep 25, 2024 at 10:32:59PM +0200, Pablo Neira Ayuso wrote:
> On Wed, Sep 25, 2024 at 05:11:01PM +0200, Ahelenia Ziemia=C5=84ska wrote:
> > On Wed, Sep 25, 2024 at 04:53:49PM +0200, Pablo Neira Ayuso wrote:
> > > On Tue, Sep 03, 2024 at 04:53:46PM +0200, Ahelenia Ziemia=C5=84ska wr=
ote:
> > > > On Tue, Sep 03, 2024 at 10:22:09AM +0200, Pablo Neira Ayuso wrote:
> > > > > On Tue, Sep 03, 2024 at 04:16:21AM +0200, Ahelenia Ziemia=C5=84sk=
a wrote:
> > > > > > The manual says
> > > > > >    COMMANDS
> > > > > >        These options specify the particular operation to perfor=
m.
> > > > > >        Only one of them can be specified at any given time.
> > > > > >=20
> > > > > >        -L --dump
> > > > > >               List connection tracking or expectation table
> > > > > >=20
> > > > > > So, naturally, "conntrack -Lo extended" should work,
> > > > > > but it doesn't, it's equivalent to "conntrack -L",
> > > > > > and you need "conntrack -L -o extended".
> > > > > > This violates user expectations (borne of the Utility Syntax Gu=
idelines)
> > > > > > and contradicts the manual.
> > > > > >=20
> > > > > > optarg is unused, anyway. Unclear why any of these were :: at a=
ll?
> > > > > Because this supports:
> > > > >         -L
> > > > >         -L conntrack
> > > > >         -L expect
> > > > Well that's not what :: does, though; we realise this, right?
> > > >=20
> > > > "L::" means that getopt() will return
> > > >   "-L", "conntrack" -> 'L',optarg=3DNULL
> > > >   "-Lconntrack"     -> 'L',optarg=3D"conntrack"
> > > > and the parser for -L (&c.) doesn't... use optarg.
> > > Are you sure it does not use optarg?
> > >=20
> > > static unsigned int check_type(int argc, char *argv[])
> > > {
> > >         const char *table =3D get_optional_arg(argc, argv);
> > >=20
> > > and get_optional_arg() uses optarg.
> > This I've missed, but actually my diagnosis still holds:
> >   static unsigned int check_type(int argc, char *argv[])
> >   {
> >   	const char *table =3D get_optional_arg(argc, argv);
> >  =20
> >   	/* default to conntrack subsystem if nothing has been specified. */
> >   	if (table =3D=3D NULL)
> >   		return CT_TABLE_CONNTRACK;
> >=20
> >   static char *get_optional_arg(int argc, char *argv[])
> >   {
> >   	char *arg =3D NULL;
> >  =20
> >   	/* Nasty bug or feature in getopt_long ?
> >   	 * It seems that it behaves badly with optional arguments.
> >   	 * Fortunately, I just stole the fix from iptables ;) */
> >   	if (optarg)
> >   		return arg;
> >=20
> > So, if you say -Lanything, then
> >   optarg=3Danything
> >   get_optional_arg=3D(null)
> > (notice that it says "return arg;", not "return optarg;",
> >  i.e. this is "return NULL").
> >=20
> > It /doesn't/ use optarg, because it explicitly treats an optarg as no o=
ptarg.
> >=20
> > It's unclear to me what the comment is referencing,
> > but I'm assuming some sort of confusion with what :: does?
> > Anyway, that if(){ can be removed now, since it can never be taken now.
> Then, this breaks:
> # conntrack -Lexpect
> conntrack v1.4.9 (conntrack-tools): Bad parameter `xpect'
> Try `conntrack -h' or 'conntrack --help' for more information.
>=20
> Maybe your patch needs an extension to deal with this case too?

This doesn't "break", this is equivalent to conntrack -L -e xpect.
It's now correct. This was the crux of the patch, actually.

Compare the manual:
  SYNOPSIS
    conntrack -L [table] [options] [-z]
  COMMANDS
    -L --dump     List connection tracking or expectation table
  PARAMETERS
    -e, --event-mask [ALL|NEW|UPDATES|DESTROY][,...]
                  Set the bitmask of events that are to be generated by the=
 in-kernel ctnetlink event code.  Using this parameter, you can reduce the =
event messages  generated
                  by the kernel to the types that you are actually interest=
ed in.  This option can only be used in conjunction with "-E, --event".

Previously, it /was/ broken: conntrack -Lexpect was as-if --dump=3Dexpect
(also not legal since --dump doesn't take an argument),
and the "expect" was ignored, so it was equivalent to conntrack -L.
You can trivially validate this by running an older version.

(Well, --dump=3Dexpect /is/ accepted. And ignored.
 So fix that too with s/optional_argument/no_argument/ (or s/2/0/).
 I didn't actually look at the longopts before.)

> The issue that I'm observing is that
>   # conntrack -Lconntrack
> now optarg is NULL after your patch, so 'conntrack' is ignored, so it
> falls back to list the conntrack table.

What do you mean "now". That shit was always ignored.
You can read trace the calls yourself if you don't believe my analysis.
Now it behaves as-documented (-L -c onntrack).

And, per
                case 'c':
                        options |=3D opt2type[c];
                        nfct_set_attr_u32(tmpl->ct,
                                          opt2attr[c],
                                          strtoul(optarg, NULL, 0));
                        break;
-c onntrack is equivalent to -c 0.
This is also obviously wrong.

I will repeat this and you can confirm this once more
(or refer back to my analysis above):
for all of -LIUDGEFA, an optional parameter was accepted, and always discar=
ded.
It now isn't, and behaves as-expected per the USG
("the USG" is an annoying way to say "how getopt() works".

> Regarding your question, this parser is old and I shamelessly took it
> from the original iptables to make syntax similar.
So you have someone to blame it on when it turns out to be dysfunctional.
But you also have a huge parser that doesn't work.
Win some/lose some, I suppose.

--rmhl4kx6wum44llv
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEEfWlHToQCjFzAxEFjvP0LAY0mWPEFAmb1G0YACgkQvP0LAY0m
WPEUAQ//XFmDLmzrocMBhVLuyw4hvPCh1QTmYWz1nLZLbLpxF6sQwshaCFEx3ooW
A+kGxDVdQhw92nNLWnHMML8qrPne3PFeMrr3cgJ+FIzmF2mKcjUzMa8XjuttZdR+
75+eLLXN1tUUvR4Ndetol1d6zFzsK6aM9i35b+VIocRXPxgsm5cmxHWZS81xy6IY
hxENw+tZnjE9PTQ2JwJAdz6atgXWjJUJGJzbZ9dzC9gp4CYAELbUqXfghcqJkr+h
mDajTwp1RGLRreOB2HmQ097/B0UAL7BV7K7h22Fno3xNaDTKfx2zbkpn2dAZg+1p
QWMlWeymxCK53yjlS+WCqcdKQSRSRoPQQmEzJtXoeqnpGQHj3QWd6hnnl0N2Z99z
4uFmCchEtGVdIhKC6QDkz8G+ll4IH9NbValeZ1NmLgtlkyA6lwcmhsI71cuas6rD
ejZ5QWtnqaRTDjm1YBkwuqAoH62WAhH45HcO/aUXjJEQYuPIgP0llkXIF33JrwEu
pTkaqh5N48AHQgbozB5wCDJSFAM3HDN2hZpjC6qOVruot28g2x46bDJXJYtyN2zK
zafsiScbYcsvWQu/LT0MD0/urlP8r79jXH2cHIrQmlGYzXQTWagDsZrD9gilEPmk
W8/1oVijINTmjMDxnF0Jx7usGk2GB7seMIFX7yUWTmg4ZgtvGsg=
=iByF
-----END PGP SIGNATURE-----

--rmhl4kx6wum44llv--
