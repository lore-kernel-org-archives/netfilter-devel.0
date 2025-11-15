Received: from azazel.net (taras.nevrast.org [35.176.194.208])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1F7FC28695
	for <netfilter-devel@vger.kernel.org>; Sat, 15 Nov 2025 12:54:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=35.176.194.208
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763211285; cv=none; b=MLqQ2namcnCGY2lqIgWOPee52p0E5Ech63nLDOfLEwGaBk2lHw1K+TJd2tKVuVv0CF1ord980lHUWGrsSXf5ux4t3dSRA310lGB/bJdKd1HvX5FO/Jll+sKIYQzI5lmub322Js2okftjmS8RLu4Az9iupvxMQiZnUVSyLfXnLtk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763211285; c=relaxed/simple;
	bh=jPfRaH9cuRDZHCiwkDYnp2/z92bb7MsAS+1AxLXajpc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=BTINQYBR2EodC3yNTKHZWUtgQ03/anX3QBH67/GCMlVxm3KKQxr3PTyVljA1emjB5IllCZ8IXz9m3kyZmAgN9dvlOw2efcd6LJAxiipxo7u4JLpF00YrVoIavMAaWBvQH5YDiAPn1pOaz9x7LOGbRGNN83IZgycsIYszGu17OmY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=azazel.net; spf=pass smtp.mailfrom=azazel.net; dkim=pass (2048-bit key) header.d=azazel.net header.i=@azazel.net header.b=FMtRnoJw; arc=none smtp.client-ip=35.176.194.208
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=azazel.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=azazel.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=azazel.net header.i=@azazel.net header.b="FMtRnoJw"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=azazel.net;
	s=20220717; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=skX+yde4Owfc1AVJaGx+QMdpSfcdz80Y69JjRsA1yr8=; b=FMtRnoJwOZ/cMO6DQKCPcXLsTW
	qli7qXiRgRYWfFXkH4zAfa+Iqqbgq/0pPyEDzXbA0Q5K+Ec0c/W3x5c+lhzOq9H/5iuD6zJ8WZ5O7
	4nUKcceJtQPC2InExGpCkeb3TqojzvZP8/HTtS9cOX+aXPJG84k3ObN85DXM/QKWXrsUGai4rNlwO
	JJce+9tLVpWZsLhwepMizLXM1ky4glGfvm0min5DB1nEASBgIL681/bxXu9ryFFDg99EhA39RUfMh
	f3pH9Y712dUU+0wApsq+RbeQ3wvR8RYP5hkQeXS9iBdSq8FKWXeQ5a5WG8g8/pxalDm624RwrPKsh
	PZwajTkg==;
Received: from celephais.dreamlands.azazel.net ([2001:8b0:fb7d:d6d7:3c21:9cff:fe2f:35f] helo=celephais.dreamlands)
	by taras.nevrast.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.98.2)
	(envelope-from <jeremy@azazel.net>)
	id 1vKFnY-000000020rC-0zhB;
	Sat, 15 Nov 2025 12:54:36 +0000
Date: Sat, 15 Nov 2025 12:54:35 +0000
From: Jeremy Sowden <jeremy@azazel.net>
To: Florian Westphal <fw@strlen.de>
Cc: Netfilter Devel <netfilter-devel@vger.kernel.org>
Subject: Re: [PATCH iptables] xshared: restore legal options for combined `-L
 -Z` commands
Message-ID: <20251115125435.GC269079@celephais.dreamlands>
References: <20251114210109.1825562-1-jeremy@azazel.net>
 <20251114213718.GB269079@celephais.dreamlands>
 <aRhotOKf6VjOWX2f@strlen.de>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="1ppFsy7zPNPecfL/"
Content-Disposition: inline
In-Reply-To: <aRhotOKf6VjOWX2f@strlen.de>
X-SA-Exim-Connect-IP: 2001:8b0:fb7d:d6d7:3c21:9cff:fe2f:35f
X-SA-Exim-Mail-From: jeremy@azazel.net
X-SA-Exim-Scanned: No (on taras.nevrast.org); SAEximRunCond expanded to false


--1ppFsy7zPNPecfL/
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline

On 2025-11-15, at 12:49:24 +0100, Florian Westphal wrote:
> Jeremy Sowden <jeremy@azazel.net> wrote:
> > On 2025-11-14, at 21:01:09 +0000, Jeremy Sowden wrote:
> > > Prior to commit 9c09d28102bb ("xshared: Simplify generic_opt_check()"), if
> > > multiple commands were given, options which were legal for any of the commands
> > > were considered legal for all of them.  This allowed one to do things like:
> >
> >	# iptables -n -L -Z chain
>
> Whats wrong with it?
>
> This failed before
> 192c3a6bc18f ("xshared: Accept an option if any given command allows it"), yes.
>
> Is it still broken?  If yes, what isn't working?

The iptables man-page description of the `-L` command includes the
following:

	Please note that it is often used with the -n option, in order
	to avoid long reverse DNS lookups.  It is legal to specify the
	-Z (zero) option as well, in which case the chain(s) will be
	atomically listed and zeroed.

This works as expected in 1.8.10:

	$ schroot -r -c iptables-sid -u root -- /usr/local/sbin/iptables-nft --version
	iptables v1.8.10 (nf_tables)
	$ schroot -r -c iptables-sid -u root -- /usr/local/sbin/iptables-nft -n -L -Z INPUT
	# Warning: iptables-legacy tables present, use iptables-legacy to see them
	Chain INPUT (policy ACCEPT)
	target     prot opt source               destination
	LIBVIRT_INP  0    --  0.0.0.0/0            0.0.0.0/0

However, it does not work in 1.8.11:

	$ schroot -r -c iptables-sid -u root -- /usr/local/sbin/iptables-nft -n -L -Z INPUT
	iptables v1.8.11 (nf_tables): Illegal option `--numeric' with this command
	Try `iptables -h' or 'iptables --help' for more information.

In the old option-checking code, replaced in 9c09d28102bb, if multiple
commands are given, once an option is marked as legal in combination
with a command, it retains that status even if it would not otherwise be
legal with a later command (v1.8.10, xshared.c, ll. 927 ff.):

	/* Table of legal combinations of commands and options.  If any of the
	 * given commands make an option legal, that option is legal (applies to
	 * CMD_LIST and CMD_ZERO only).

The new code, however, makes no such allowance (v1.8.11, xshared.c,
ll. 945 ff.):

	static const unsigned int options_v_commands[NUMBER_OF_OPT] = {
	/*OPT_NUMERIC*/		CMD_LIST,
	...
	/*OPT_EXPANDED*/	CMD_LIST,
	...
	/*OPT_LINENUMBERS*/	CMD_LIST,
	...
	};

My proposed fix is just to add `CMD_ZERO` to these entries.  It's more
permissive than before, in as much as it allows `-n` &c. to be combined
with `-Z` on its own, but they will be ignored.

J.

--1ppFsy7zPNPecfL/
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

wsG7BAABCgBvBYJpGHf3CRAphqwKvfEEDUcUAAAAAAAeACBzYWx0QG5vdGF0aW9u
cy5zZXF1b2lhLXBncC5vcmevHynHFs8PXFnma0Cb1MR+viR+X6s4MXan0Y7U2IE3
IxYhBGwdtFNj70A3vVbVFymGrAq98QQNAAAYCQ//RT+v8OHBtOU978huOJi/GBd3
YQdQ5OLaDeEToAvFTWCcY9+a9deIdLHm91PnIDF9BAyuaySqhNDlb3CHuHAurBWV
hr2/x8aQ6z9cX6mWjSPzVbEX/1nnNa/iYVddUeTuUuhI7AwJ1CDxqby+/Pz/Qtng
xQBRAL4LQliy8v21HHL9BbQK6CZ4PXVRS+ca4SzOwllof37P7wDyoO1Yp6NpGOvS
KRJBv1yPPxXxsO+fvBheEinm2l/S4/psMMSjZqrKwu1E9HckiHz5oOJyMwz8unnW
+T8sP7j4dr16wXPZnMO8hZVWjUYWvNlqTzpflfYCOdlYKCXQeUlXyaFlEw9XRvMn
g3KXi98T2LR4rTf3swERDPCpyI5/j892iWcCO7wtRqBkJRwc+lQQRNszbFDIKLwh
iqzGP6jleibCbF38EOES006wdvNVlcuWgxVx0/r3m7U92/SbjV316a7qqOKXdpE6
S2H9s70rPYc6ykpU2s4jEJFPabBlCCnCpa2Y+uzPUIiDuSZR4GGgCwZbKbb8dbYp
xchHVTKuMetzKg51Fap0UCgQdHqsCyQCvpu47ERl8tscTbzihpD3EoM3FVq3GK3x
xjdP41ff1/IrdZgnm5iJwDvXY/nfw/RTLdA3GCmGV0OQKpkmiFU6EbKVuzxuw6GL
PWOzJZq/b16C+oPdEOI=
=Wcr+
-----END PGP SIGNATURE-----

--1ppFsy7zPNPecfL/--
