From: Sven Anders <anders@anduras.de>
Subject: Status of Netfilter IPSEC patches
Date: Thu, 23 Jun 2005 16:53:05 +0200
Message-ID: <42BACCD1.8030403@anduras.de>
References: <42289633.6020804@sysgo.com> <424853B8.9090607@shorewall.net>
	<42485FD2.3020508@trash.net>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="------------080709090304070305080905"
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Patrick McHardy <kaber@trash.net>
In-Reply-To: <42485FD2.3020508@trash.net>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: </pipermail/netfilter-devel>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
Sender: netfilter-devel-bounces@lists.netfilter.org
Errors-To: netfilter-devel-bounces@lists.netfilter.org
List-Id: netfilter-devel.vger.kernel.org

This is a multi-part message in MIME format.
--------------080709090304070305080905
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1


Hello!

Today I rummaged in the netfilter-devel mailing-list archive.
I found the following statement about the NETFILTER/IPSEC patches:

| Patrick McHardy wrote:
|
| Read last weeks netdev archive, turns out the whole idea of skipping
| netfilter hooks until all IPsec processing is done was wrong. I don't
| know how to solve it yet.

Any details about this?
What problems can arise?

I downloaded the latest patch-o-matic and looked at the state of the patches,
but these are out-of-date. Are these patches unmaintained due to the statement
above?
There are newer ones under:
~  http://www.saout.de/misc/linux-2.6.12-ipsec-nat/
Please update the patches in the patch-o-matic!

Regards
~ Sven

PS: please answer me directly, too. Thanks!
- --
~ Sven Anders <anders@anduras.de>                 () Ascii Ribbon Campaign
~                                                 /\ Support plain text e-mail
~ ANDURAS service solutions AG
~ Innstraße 71 - 94036 Passau - Germany
~ Web: www.anduras.de - Tel: +49 (0)851-4 90 50-0 - Fax: +49 (0)851-4 90 50-55

Rechtsform: Aktiengesellschaft - Sitz: Passau - Amtsgericht Passau HRB 6032
Mitglieder des Vorstands: Sven Anders, Marcus Junker, Michael Schön
Vorsitzender des Aufsichtsrats: Dipl. Kfm. Thomas Träger
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.5 (GNU/Linux)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org

iD8DBQFCuszR5lKZ7Feg4EcRAicdAJ0WpaIixj01UU55UjEWWjKFt/2SPwCZAS1v
oJK3R+rf3eb9wlFacM8zyt4=
=aIcB
-----END PGP SIGNATURE-----

--------------080709090304070305080905--
