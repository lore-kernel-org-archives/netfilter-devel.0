From: =?UTF-8?B?SsO2cmc=?= Thalheim <joerg@higgsboson.tk>
Subject: Re: [PATCH] add systemd service file
Date: Wed, 17 Dec 2014 21:40:32 +0100
Message-ID: <20141217214032.569fbfac@turingmachine>
References: <20141217205407.06558f65@turingmachine>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 boundary="Sig_/PlPbvS14HbUS0FjFMZ9DRqG"; protocol="application/pgp-signature"
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.higgsboson.tk ([148.251.132.243]:33386 "EHLO
	mail.higgsboson.tk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750995AbaLQUkg (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 17 Dec 2014 15:40:36 -0500
Received: from turingmachine (unknown [IPv6:2001:4dd0:fb82:c3d2:5e51:4fff:fe58:e70b])
	by mail.higgsboson.tk (Postfix) with ESMTPSA id A90AC72D3
	for <netfilter-devel@vger.kernel.org>; Wed, 17 Dec 2014 21:40:34 +0100 (CET)
In-Reply-To: <20141217205407.06558f65@turingmachine>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

--Sig_/PlPbvS14HbUS0FjFMZ9DRqG
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi netfilter community,
Patrick McHardy ask me to submit our work on systemd support for
nftables (https://github.com/devkid/nftables-systemd)

It currently consists of a service file for systemd and a script to
load/remove nftables rules. The script does more than actually needed
for fundamental systemd support.=20

It allows to test rules:

$ nftablesctl start --confirm

which resets after 20s if you accidentally kill your ssh connection.

It allows to list all rules with one command:

$ nftables list

Instead of storing all rules in a single file (/etc/nftables.conf), it
applys all files ending with .rules from directory /etc/nftables/ in
lexical order, which make it more useful for configuration management
like chef/puppet/ansible, where generating a single file from multiple
modules is a pain.

So the question is the nftables project wants such a script. If you are
just looking for a systemd service the following approach would be
much easier:

[Unit]
Description=3DNetfilter Tables
Documentation=3Dman:nft(8)
Wants=3Dnetwork-pre.target
Before=3Dnetwork-pre.target

[Service]
Type=3Doneshot
ExecStart=3D/usr/bin/nft -f /etc/nftables.conf
ExecStop=3D/usr/lib/systemd/scripts/nftables-flush
RemainAfterExit=3Dyes

[Install]
WantedBy=3Dmulti-user.target

where /usr/lib/systemd/scripts/nftables-flush would just drop all rules

--Sig_/PlPbvS14HbUS0FjFMZ9DRqG
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQEcBAEBCAAGBQJUkepAAAoJEMpBBrjXzHn6VzcH/0n1DJ5k91sxpDzOBbsCgq8A
E9ExWhB45pmJbuTIfNxmqjptTn5XkBIe6U5Hcac2pVbqd64KGXeAD9iQSb9+SQUT
zRbQ5Zb9JzSdqoYCfVM6y71d2TtoPHqiJ0qTZY2+Kb6TK2DLbsoz7p9zwcSMXXTU
tm5Jxj2qyIai4mvrXDnKQh9DTrzOI8B60qMMCuEyPU00jaBbSNi7YYJgPZKFIY6S
GkFLcHFDcsQxBBE3IyNuTQNJQFGmS1WzC/qfpOHTAqOLAGduVsY5Kyrug8uygAsj
EnNxh6L9NRJIt09Ko1ryZQ3gCjR86kT5AsxAVjC4pt1riw+jNMSWaifBqgZRikM=
=TswB
-----END PGP SIGNATURE-----

--Sig_/PlPbvS14HbUS0FjFMZ9DRqG--
