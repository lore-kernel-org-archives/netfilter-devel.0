Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=91.216.245.30
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794766892;
	b=EzpseB61x5IdiOvVq+N/SbHPcEjsS/e9JvdYcBixl54RWJXQ5UnqBQOclu+s9TcDitKg
	 a7sktKQyL5HWaULhpHVOA9HT5+fv4kDw5/igLhlsp7+nq0B7DjKaUFUw8DPioPxXyJLJt
	 M9M0nNhvv2jPPHC8CC1XkfqQL5POwG7Rv5L/rxLuVh6B5x0+X+VoJcdihvrRyrHCwhnQY
	 IoYGq7Y4LrL32L1DSFg6ibGErA26To10UL9j6aIlnSq632GDRa42ndBnkyNLcGkPylhzz
	 sKDrsXjFSXL9odlvrrbiWiLbrteVKBiCqC5wcsNaC7VroO8OdAgeHDDiN/eIkegmXRw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794766892;
	h=DMARC-Filter:Received:Date:From:To:Cc:Subject:Message-ID:References:
	 MIME-Version:Content-Type:Content-Disposition:
	 Content-Transfer-Encoding:In-Reply-To;
	bh=pfCoP456eSqY0ZG5/g/+tt3M/cNjnjpilUw7D+4CL5o=;
	b=Khh+H5+F4bsv+B9LCND2w/+AnSbtdQtowRBFpDG8Vb3cm42tDR9afcVJdpkPQFptgh3c
	 XIEZW1TgW9XZ3Zrh9zOsztBx6eM2AVXgf8et51KV4GkUmjVwMoHt6isBtFBIMEEMommf+
	 VG64++IYZRUxpDcjZl9ER73AHlbMDrVEowYsZhVC50IORvWx5fTkbwIK/0rtvlnShTnV6
	 b5XhirCcDZlqQ5hloweHlCSkYbXJtSzfOEH/GePBKbUecXTkjTxhcmXgTC7VYnJvG7HQg
	 jGvq8TiOaDemhUC05ToqYZzTy0qOuVPho+BXv0k358UL3XfUrR12PBxmq8RegcJPO8g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=strlen.de;
	spf=pass smtp.mailfrom=strlen.de;
	arc=none smtp.remote-ip=91.216.245.30
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F07C4606A31A
	for <netfilter-devel@vger.kernel.org>; Sun, 15 Nov 2026 18:21:31 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org F07C4606A31A
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=strlen.de
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id A08706055A; Sun, 15 Nov 2026 19:21:28 +0100 (CET)
Date: Sun, 15 Nov 2026 19:21:28 +0100
From: Florian Westphal <fw@strlen.de>
To: Jozsef Kadlecsik <kadlec@netfilter.org>
Cc: netfilter-devel@vger.kernel.org
Subject: Re: [PATCH ipset] tests: hash:net,iface.t: add test case for
 wildcard matching behaviour
Message-ID: <avn4KIth2ics2YkS@strlen.de>
References: <20261028130203.1398-1-fw@strlen.de>
 <86662718-9117-5c82-cd2e-74298a9a2c7f@netfilter.org>
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Post: <mailto:netfilter-devel@vger.kernel.org>
List-Help: <mailto:netfilter-devel+help@vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
List-Owner: <mailto:netfilter-devel+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable
In-Reply-To: <86662718-9117-5c82-cd2e-74298a9a2c7f@netfilter.org>

Jozsef Kadlecsik <kadlec@netfilter.org> wrote:
> > +# Delete the specific entry.
> > +0 ipset del test 10.0.1.0/24,eth0
> > +# The wildcard entry should still be there and match eth1 via its pref=
ix.
> > +0 ipset test test 10.0.1.0/24,eth1
>=20
> The original code does not handle the case properly and the wildcard entr=
y=20
> can be deleted instead the specific one. If it passes for you then it's=
=20
> just lucky ordering.

Yes, it passes both on main and rhashtable_v10.

> > +# eth0 is excluded by the nomatch entry; it must not match via the wil=
dcard.
> > +1 ipset test test 10.0.3.0/24,eth0
> > +0 ipset destroy test
>=20
> This part also does not handled properly with the current code: it lacks=
=20
> the ordering to match/delete first the specific and then the wildcard=20
> records.

Lucky coincidence, then?
What do we do now?  Will you make test cases that demonstrate the
expected behaviour and I respin a v11 that passes those tests?

