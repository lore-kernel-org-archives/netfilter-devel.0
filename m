From: Sven Anders <anders@anduras.de>
Subject: NOT in mport / multiport
Date: Mon, 08 Nov 2004 12:33:12 +0100
Message-ID: <418F5978.2010902@anduras.de>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="------------090006000209010709000404"
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
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
--------------090006000209010709000404
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

Why did the mport and multiport matches do not support inverting? Any reason?

Pablo Neira did some changes on these lately, so why didn't you implemented the negation?

I think ANY matching module should support negation of itself...

(Any if any compatibilty with the user space program will break, why not? We are useded to
it - it does break every two versions of ip-tables...)

Regards
~ Sven

- --
~ Sven Anders <anders@anduras.de>

~ ANDURAS service solutions AG
~ Innstraße 71 - 94036 Passau - Germany
~ Web: www.anduras.de - Tel: +49 (0)851-4 90 50-0 - Fax: +49 (0)851-4 90 50-55

Rechtsform: Aktiengesellschaft - Sitz: Passau - Amtsgericht Passau HRB 6032
Mitglieder des Vorstands: Sven Anders, Marcus Junker, Michael Schön
Vorsitzender des Aufsichtsrats: Dipl. Kfm. Karlheinz Antesberger
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.5 (GNU/Linux)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org

iD8DBQFBj1l45lKZ7Feg4EcRAq2fAJ9mQFA2d5V3hWNyzOvTuQz1lZOZCQCgogFG
vOhfYzj+gOIA+xr3+WM66xE=
=acxU
-----END PGP SIGNATURE-----

--------------090006000209010709000404--
