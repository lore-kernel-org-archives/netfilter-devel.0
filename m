Received: from smtp.gentoo.org (woodpecker.gentoo.org [140.211.166.183])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5EA1FE55A;
	Wed,  4 Mar 2026 01:54:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=140.211.166.183
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772589244; cv=none; b=R+cTjG9VgGfC2ihZPG5uZQ0fnsKzqTfYsrvYoBNir/L2x4U+Qv64weh6y9D9m6D3BH6d3/LqbDE5WioOC9O7cGJCfxshg4ecYtFqfIg+9n31MqXKBl+vG3CkXIRWrqcZQcH94D928Lne8lQwVbVBdUegnzwCVmcaSDEYn3jXbbQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772589244; c=relaxed/simple;
	bh=wf+9WYI4wz+u51rXJN5W21h2IU7JZQleKEyPyJdCCGc=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=M8flhAjUDegLPAaPXjxc1X30uEsTz9/fY/sCxwRPQsa/SyOvp9GpU4a6JFmNyzcLYRuvbjm2DTzRSkevH7aMpvwI+elSmINBFHCAVRyNVOpeodyvVUJjB8I9UXyRRyHSuf3CYNXkzLIplV2XljmtStouKvD+EvQEI7uXWhHM19k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gentoo.org; spf=pass smtp.mailfrom=gentoo.org; arc=none smtp.client-ip=140.211.166.183
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gentoo.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gentoo.org
Received: from mop.sam.mop (2.8.3.0.0.0.0.0.0.0.0.0.0.0.0.0.a.5.c.d.c.d.9.1.0.b.8.0.1.0.0.2.ip6.arpa [IPv6:2001:8b0:19dc:dc5a::382])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: sam)
	by smtp.gentoo.org (Postfix) with ESMTPSA id 6F7C6341620;
	Wed, 04 Mar 2026 01:53:59 +0000 (UTC)
From: Sam James <sam@gentoo.org>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: netfilter-devel@vger.kernel.org,  netfilter@vger.kernel.org,
 netdev@vger.kernel.org
Subject: Re: [ANNOUNCE] iptables 1.8.13 release
In-Reply-To: <aaeMFWURL-6YWIkz@chamomile>
Organization: Gentoo
References: <aaeMFWURL-6YWIkz@chamomile>
User-Agent: mu4e 1.12.15; emacs 31.0.50
Date: Wed, 04 Mar 2026 01:53:55 +0000
Message-ID: <87h5qwgy18.fsf@gentoo.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
	micalg=pgp-sha512; protocol="application/pgp-signature"

--=-=-=
Content-Type: text/plain

Pablo Neira Ayuso <pablo@netfilter.org> writes:

> Hi!
>
> The Netfilter project proudly presents:
>
>         iptables 1.8.13

Thanks! BTW, tag seems to be missing?

> [...]

sam

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEBBAEWCgCpFiEEJaa7iN2bdkxrVUHCc4QJ9SDfkZAFAmmnkLMbFIAAAAAABAAO
bWFudTIsMi41KzEuMTIsMiwyXxSAAAAAAC4AKGlzc3Vlci1mcHJAbm90YXRpb25z
Lm9wZW5wZ3AuZmlmdGhob3JzZW1hbi5uZXQyNUE2QkI4OEREOUI3NjRDNkI1NTQx
QzI3Mzg0MDlGNTIwREY5MTkwDxxzYW1AZ2VudG9vLm9yZwAKCRBzhAn1IN+RkDWm
AQDG1itKhDBKp8TtTm03507mTqkb36bB+qO7PjkNjrkyngD9EACNce97xukbTvI7
bShwGO8BJkI+4PlNFmiCie9nXgQ=
=cm49
-----END PGP SIGNATURE-----
--=-=-=--
