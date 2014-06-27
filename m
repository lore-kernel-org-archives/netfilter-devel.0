From: Matthijs Kooijman <matthijs@stdin.nl>
Subject: Re: Unable to DNAT packets back into originating bridge port
Date: Fri, 27 Jun 2014 22:00:49 +0200
Message-ID: <20140627200049.GI1353@login.tika.stderr.nl>
References: <20140627174837.GG1353@login.tika.stderr.nl>
 <20140627185207.GA2843@breakpoint.cc>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="oPYnW2SrAqZUvu4n"
Cc: Stephen Hemminger <stephen@networkplumber.org>,
	Bart De Schuymer <bart.de.schuymer@pandora.be>,
	bridge@lists.linux-foundation.org, netfilter-devel@vger.kernel.org
To: Florian Westphal <fw@strlen.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from tika.stderr.nl ([94.142.244.14]:41247 "EHLO tika.stderr.nl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750862AbaF0UBK (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 27 Jun 2014 16:01:10 -0400
Content-Disposition: inline
In-Reply-To: <20140627185207.GA2843@breakpoint.cc>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


--oPYnW2SrAqZUvu4n
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hey Florian,

> Sounds like
> http://marc.info/?t=136627796900001&r=1&w=2
Yup, I'm pretty sure this is the same issue. I hadn't realize the need
for source mac address mangling yet. It didn't show up as a problem
in my setup, but I guess it can be needed in some setups.

Gr.

Matthijs

--oPYnW2SrAqZUvu4n
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iEYEARECAAYFAlOtzXEACgkQz0nQ5oovr7ytWQCfX3Pqn3htX0USPc8jRFfAgY7v
xg8An1s+Vdd6fOU+WRs8e44vVrHRA0xp
=s1HB
-----END PGP SIGNATURE-----

--oPYnW2SrAqZUvu4n--
