From: Sven Anders <anders@anduras.de>
Subject: Missing "ip6t_REJECT.h"
Date: Wed, 16 Feb 2005 16:21:32 +0100
Message-ID: <421364FC.1030907@anduras.de>
References: <1104894357.20582.5.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="------------060000010803030305060006"
To: netfilter-devel@lists.netfilter.org
In-Reply-To: <1104894357.20582.5.camel@localhost.localdomain>
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
--------------060000010803030305060006
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

Hello!

I'm using the kernel 2.6.10 and I'm missing the "ip6t_REJECT.h" header file.
It's gone since 2.6.9:

- --- a/include/linux/netfilter_ipv6/ip6t_REJECT.h 2004-10-18 14:55:53 -07:00
+++ /dev/null Wed Dec 31 16:00:00 196900

(From: http://www.kernel.org/diff/diffview.cgi?file=%2Fpub%2Flinux%2Fkernel%2Fv2.6%2Fpatch-2.6.9.bz2;z=3839)

I tried to add the target from the latest patch-o-matic, but it failed (because the header file is not there).
Is the target broken (only under 2.6.x) ??

Please update the "info" or "help" file, if so...

With regards
~ Sven

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

iD8DBQFCE2T75lKZ7Feg4EcRAhh8AKCkPvsYqSAnhXFcG+sBnj2JyYBtswCfcw/A
rNAsbGa+fvVdK1HtMABq3CM=
=bBV8
-----END PGP SIGNATURE-----

--------------060000010803030305060006--
