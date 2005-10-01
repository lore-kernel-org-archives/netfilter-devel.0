From: Radoslaw Szkodzinski <astralstorm@gorzow.mm.pl>
Subject: Re: 2.6.13-rc2+ - problem with DHCP
Date: Sat, 01 Oct 2005 23:39:52 +0200
Message-ID: <433F0228.6000304@gorzow.mm.pl>
References: <433EBBEC.4050203@gorzow.mm.pl> <433ECE42.2070400@trash.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Cc: linux-kernel@vger.kernel.org,
	Netfilter Development Mailinglist
	<netfilter-devel@lists.netfilter.org>
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1750867AbVJAVkF@vger.kernel.org>
To: Patrick McHardy <kaber@trash.net>
In-Reply-To: <433ECE42.2070400@trash.net>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

Patrick McHardy wrote:
|
| Are you sure? The patch was supposed to fix problems with DHCP clients
| using regular UDP sockets for sending DHCP requests. Which client are
| you using?
|

udhcpcd, version 0.9.9-pre (Gentoo ebuild
net-misc/udhcp-0.9.9_pre20041216-r1, no crazy optimisations, stock init
script, IP release disabled)

2.6.13, 2.6.14-rc1 (up to the patch) both work fine.
2.6.14-rc2 and 2.6.14-rc3 do not. (they can't discover IP address)
The window is between that commit and rc2.
(about 180 changesets)

I only suspect that patch, it could be something else but I highly doubt
it. I'll check the current kernel with the patch backed out when I have
to restart.

- --
GPG Key id:  0xD1F10BA2
Fingerprint: 96E2 304A B9C4 949A 10A0  9105 9543 0453 D1F1 0BA2

AstralStorm
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.2 (GNU/Linux)

iD8DBQFDPwIolUMEU9HxC6IRAit8AJ0TXQv+BO3rn0L39JsCad7UqyUMRACeIf+U
cvzDCU1x9oTP2V4AjELJUvY=
=hp5I
-----END PGP SIGNATURE-----
