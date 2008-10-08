From: Eric Leblond <eric@inl.fr>
Subject: Re: [PATCH] Don't call nf_log_packet in NFLOG module.
Date: Wed, 8 Oct 2008 16:15:23 +0200
Message-ID: <20081008141523.GN7518@khasse.inl.fr>
References: <1223322024-20336-1-git-send-email-eric@inl.fr> <48ECAF7E.30502@trash.net>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="mvpLiMfbWzRoNl4x"
Cc: netfilter-devel@vger.kernel.org
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from 141-53.206-83.static-ip.oleane.fr ([83.206.53.141]:53995 "EHLO
	fydelkass.inl.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753381AbYJHPGR (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 8 Oct 2008 11:06:17 -0400
Content-Disposition: inline
In-Reply-To: <48ECAF7E.30502@trash.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


--mvpLiMfbWzRoNl4x
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Wednesday, 2008 October  8 at 15:02:54 +0200, Patrick McHardy wrote:
> Eric Leblond wrote:
>> This patch modifies xt_NFLOG to suppress the call to nf_log_packet()
>> function. The call of this wrapper in xt_NFLOG was causing NFLOG to
>> use the first initialized module. Thus, if ipt_ULOG is loaded before
>> nfnetlink_log all NFLOG rules are treated as plain LOG rules.
>
> Oops, this slipped through somehow. It has been an intentional
> decision to use the registered logging backends though, just changing
> it to unconditionally use nfnetlink_log only solves the problem
> partially.

Hmm, looks like my explanation is not correct. This patch fixes the
following bug :

modprobe ipt_LOG
modprobe nfnetlink_log
iptables -A OUTPUT -j NFLOG
Then : logged packet are treated as packet reaching the LOG target.

> The main problem is that the policy which backend to use is defined
> by module load order, which is obviously a pretty bad idea. This does
> not only affect xt_NFLOG, but also internal conntrack logging and
> anything else we might want to use this for in the future.
>
> So I think what we should do instead is introduce a proper way to
> select among the logging backends. We could introduce a global
> policy, or split by subsystem, which would currently be just
> "conntrack" and "NFLOG".

Yes, I currently working on doing that. I plan to send it in an other
patch. I've send the following patch alone to fix this weird NFLOG
target working as LOG target problem.

BR,
--=20
Eric Leblond
INL: http://www.inl.fr/
NuFW: http://www.nufw.org/

--mvpLiMfbWzRoNl4x
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAkjswHoACgkQnxA7CdMWjzKHLQCeP0KF9Yo4xCN4NMkaAL8+kNpL
vmIAoJEbdEn6w3NwuXQdkYXI3oIulZyk
=FlEZ
-----END PGP SIGNATURE-----

--mvpLiMfbWzRoNl4x--
