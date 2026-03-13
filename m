Received: from azazel.net (taras.nevrast.org [35.176.194.208])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2AB78370D5C
	for <netfilter-devel@vger.kernel.org>; Fri, 13 Mar 2026 07:56:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=35.176.194.208
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773388599; cv=none; b=cUSCRfiYzjx/WOpbLvVfaR5FP58WFZ4U5J33BUSTz1DnkNiyiO+IWzr2env0mqdgiBnvkGz7Y4FYjYGp5JOciRCPdU80PiGu/r7Khk1urjkZSLIqGx5oroonF0PAHqeBKzsSp0tZcDz9pcrtXKVZQJUYua7pD4qtl5gEpZUW8OM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773388599; c=relaxed/simple;
	bh=gRUcexK0psYN3jIYzMZjg2WiOEGoITJ6Re5Ax8SwteQ=;
	h=Date:From:To:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=fxeGf18ZfaJSbMIHO8UqeP7JtzdA9LBfrvUWoE6F/dKlKfU77symBrgVp9vF8EZsAXcmA2OxdFuHBBZhF3HVHJq6dbum6I7h04iK7dnMK8DVmwH5sMk07epYX1pApjiAHbhqw8BkKgfy4Gm/lxiT/HCL2mlb2M9dEH77z5yWxL0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=azazel.net; spf=pass smtp.mailfrom=azazel.net; dkim=pass (2048-bit key) header.d=azazel.net header.i=@azazel.net header.b=ORZ99/sj; arc=none smtp.client-ip=35.176.194.208
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=azazel.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=azazel.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=azazel.net header.i=@azazel.net header.b="ORZ99/sj"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=azazel.net;
	s=20220717; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:To:From:Date:Sender:Reply-To:Cc:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=nzdhH1r6uJh6XTKGq1KW97afPWkkGgYJV/t2RnEWsps=; b=ORZ99/sjmKgGeMtP6cU1wgsL91
	9T8Ac5BtvL9OBG1q8F4sFiHLWdw6bAxB7H/x0CUqlqfeGr0N8StzmnSJXCxxKELhKihmxTEjq9JME
	CfnWc+pJn0HG6cJWjAbg1PIZfGI1+G7srsc7jWPNGLWbzL79aNRCGQaflt/WR0vxxZv/69qQu7/TW
	okYoBM8jYlhY2iIKOd6R5SVfcUaWdzRIQ3mi+lS5yzcO2EOr9/7zr6ISlKQJ+moKeS50YqO8JLL7k
	Oa3ARf+cJNfXJesZtE1T1kVY5zvVk+o9HsIDsEQAFshyB2SoSb4tM5L4fwGu0alY1e1AmqgQPOuuP
	myy6Nntg==;
Received: from celephais.dreamlands.azazel.net ([2001:8b0:fb7d:d6d7:3c21:9cff:fe2f:35f] helo=celephais.dreamlands)
	by taras.nevrast.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.98.2)
	(envelope-from <jeremy@azazel.net>)
	id 1w0xNj-0000000FkyS-3s1X;
	Fri, 13 Mar 2026 07:56:28 +0000
Date: Fri, 13 Mar 2026 07:56:25 +0000
From: Jeremy Sowden <jeremy@azazel.net>
To: Phil Sutter <phil@nwl.cc>,
	Netfilter Devel <netfilter-devel@vger.kernel.org>
Subject: Re: [PATCH nft] tests: py: use `os.unshare` Python function
Message-ID: <20260313075625.GA6145@celephais.dreamlands>
References: <20260305175358.806280-1-jeremy@azazel.net>
 <aasRsr93TOUuH_Xb@orbyte.nwl.cc>
 <20260306183553.GA5468@celephais.dreamlands>
 <abCki9aBa8wVBvQi@orbyte.nwl.cc>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="FprYC4COxmFeb+Eh"
Content-Disposition: inline
In-Reply-To: <abCki9aBa8wVBvQi@orbyte.nwl.cc>
X-SA-Exim-Connect-IP: 2001:8b0:fb7d:d6d7:3c21:9cff:fe2f:35f
X-SA-Exim-Mail-From: jeremy@azazel.net
X-SA-Exim-Scanned: No (on taras.nevrast.org); SAEximRunCond expanded to false


--FprYC4COxmFeb+Eh
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline

On 2026-03-11, at 00:08:59 +0100, Phil Sutter wrote:
> On Fri, Mar 06, 2026 at 06:35:53PM +0000, Jeremy Sowden wrote:
> > On 2026-03-06, at 18:41:06 +0100, Phil Sutter wrote:
> > > On Thu, Mar 05, 2026 at 05:53:58PM +0000, Jeremy Sowden wrote:
> > > > Since Python 3.12 the standard library has included an `os.unshare` function.
> > > > Use it if it is available.
> > >
> > > This patch breaks py test suite cases involving time-related
> > > matches, e.g. 'meta time "1970-05-23 21:07:14"'. It expects:
> > >
> > > | cmp eq reg 1 0x002bd503 0x43f05400
> >
> > 	$ TZ=UTC-2 perl -MPOSIX=strftime -le 'my $ns = hex $ARGV[0]; print strftime "%Y-%m-%d %H:%M:%S", localtime int $ns / 1000000000' 0x002bd50343f05400
> > 	1970-05-23 21:07:14
> >
> > > but instead the rule serializes into:
> > >
> > > | cmp eq reg 1 0x002bd849 0x74a8f400
> >
> > 	$ TZ=UTC-2 perl -MPOSIX=strftime -le 'my $ns = hex $ARGV[0]; print strftime "%Y-%m-%d %H:%M:%S", localtime int $ns / 1000000000' 0x002bd84974a8f400
> > 	1970-05-23 22:07:14
> >
> > > Do you see that too?
> >
> > Yes, e.g.:
> >
> > 	6: WARNING: line 4: 'add rule netdev test-netdev egress meta time > "2022-07-01 11:00:00" accept': '[ cmp gt reg 1 0x16fda8f3 0x1977a000 ]' mismatches '[ cmp gt reg 1 0x16fdac39 0x4a304000 ]'
> >
> > As with your example, the discrepancy is an hour:
> >
> > 	$ TZ=UTC-2 perl -MPOSIX=strftime -le 'my $ns = hex $ARGV[0]; print strftime "%Y-%m-%d %H:%M:%S", localtime int $ns / 1000000000' 0x16fda8f31977a000
> > 2022-07-01 11:00:00
> >
> > 	$ TZ=UTC-2 perl -MPOSIX=strftime -le 'my $ns = hex $ARGV[0]; print strftime "%Y-%m-%d %H:%M:%S", localtime int $ns / 1000000000' 0x16fdac394a304000
> > 2022-07-01 12:00:00
> >
> > which suggests it's time-zone related.  Didn't see anything about
> > that in the doc's.  Will take a closer look.  Apologies.
>
> Yes, it's odd. Neither unshare module nor 'unshare -n' behave like
> this, even though os.unshare is described as doing the same as unshare
> command does. It also doesn't mangle os.environ['TZ'] value, no idea
> why it messes with this.

What makes it weirder is that setting the time-zone at the command-line
fixes it:

     $ cat tests/py/any/meta-time-test.t
     :input;type filter hook input priority 0

     *ip;test-ip4;input

     time > "2022-07-01 11:00:00" accept;ok;meta time > "2022-07-01 11:00:00" accept
     $ sudo env TZ=UTC-2 /usr/bin/python3 tests/py/nft-test.py any/meta-time-test.t
     INFO: Log will be available at /tmp/nftables-test.log
     any/meta-time-test.t: 1 unit tests, 0 error, 0 warning
     $ sudo /usr/bin/python3 tests/py/nft-test.py any/meta-time-test.t
     INFO: Log will be available at /tmp/nftables-test.log
     8: WARNING: line 4: 'add rule ip test-ip4 input time > "2022-07-01 11:00:00" accept': '[ cmp gt reg 1 0x16fda8f3 0x1977a000 ]' mismatches '[ cmp gt reg 1 0x16fdac39 0x4a304000 ]'
     meta-time-test.t.payload.got: WARNING: line 2: Wrote payload for rule t
     8: WARNING: line 4: 'add rule ip test-ip4 input meta time > "2022-07-01 11:00:00" accept': '[ cmp gt reg 1 0x16fda8f3 0x1977a000 ]' mismatches '[ cmp gt reg 1 0x16fdac39 0x4a304000 ]'
     6: WARNING: line 4: '{"nftables": [{"add": {"rule": {"family": "ip", "table": "test-ip4", "chain": "input", "expr": [{"match": {"left": {"meta": {"key": "time"}}, "op": ">", "right": "2022-07-01 11:00:00"}}, {"accept": null}]}}}]}': '[ cmp gt reg 1 0x16fda8f3 0x1977a000 ]' mismatches '[ cmp gt reg 1 0x16fdac39 0x4a304000 ]'
     meta-time-test.t.json.payload.got: WARNING: line 2: Wrote JSON payload for rule t
     any/meta-time-test.t: 1 unit tests, 3 error, 0 warning

This seems to imply that modifying `os.environ` doesn't actually modify
the environment.  I don't know Python very well, and this is the first
time I've had a rummage in the internals, and I have not yet been able
to explain it.  I think the right thing, unfortunately, is to revert the
commit until I can get to the bottom of it.

J.

--FprYC4COxmFeb+Eh
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

wsG7BAABCgBvBYJps8MSCRAphqwKvfEEDUcUAAAAAAAeACBzYWx0QG5vdGF0aW9u
cy5zZXF1b2lhLXBncC5vcmddjhqouS8HNeAsndhQwU7xdNBLxSVDZpS3CQDZ9bOu
gRYhBGwdtFNj70A3vVbVFymGrAq98QQNAADwhBAAmRQBA+b8QmJ1NL02v+IPx9Ux
L6/+WIccXs2wCLlA26fOJBqhniDP2lwwpydfi0jni7vqe2UjtHkm+Jg/5qBgFJJm
vgeWBpCf6OJmglQGnlB6j9sk3c3nrpSWslVSy6F67cMvf0pnBzmRDDbSLw93XUk5
7tia60mSJWslxK32WH+YeN7a8E8J8C1ig2Fu3Ai6sTzBnKHla9R3cAQ7xq4U5kPk
CQS9XEuYp8w4R63gwaahDBN41PTty3Idks4dWCNKcNUF6Fk877zhCc7UKna3EGQQ
O0qkyLmbf3T6E6E7C0U+2oErXM8b4m6PmdbhZgDGu0BF56s7nPKvrTGh7PDdgujS
QCobHb8uAM1Ci4gZkYegk+pvgXA2pp6KBwrbnuLWPBUSzwvS3Q6DPbbuJx7CxSCa
GFl21NpuhWNX7qkUOd+1cE/L18G1LxsEDvtS2B0XiaEQfnzsibKuuwiV8Lr3eGI6
BSw26Ou8dQUHL87+KpQlfvuQPvQzCDCgvrCPOGx17254zT+imWqjKLzEgLZZyJj2
mOMVcm79+oCEsvwS1qm1KvqySZc6G6ZnpKHrvRJ2yaV3lGwMx6uTZEjEnfTYfwox
7IbEfvILnnp6kIUU4V+q2fbsLiL+mMWBMQgMH8pZ7PQBIOzZCSYJvcKo2KIReL+L
2Efoa632c3EwELkpEXg=
=4D4g
-----END PGP SIGNATURE-----

--FprYC4COxmFeb+Eh--
