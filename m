From: Sven Anders <anders@anduras.de>
Subject: Re: GPL violation by router manufacturer Conceptronic
Date: Thu, 16 Dec 2004 23:27:37 +0100
Message-ID: <41C20BD9.10802@anduras.de>
References: <200412162130.59168.maacruz@navegalia.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="------------010709090900000801070001"
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Miguel Angel Alvarez <maacruz@navegalia.com>,
	netfilter-devel@lists.netfilter.org
In-Reply-To: <200412162130.59168.maacruz@navegalia.com>
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
--------------010709090900000801070001
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

Miguel Angel Alvarez wrote:
| Hi all!
|
|  I have found what may be (it surely seems to be) a GPL violation by
| Conceptronic (it was Tulip computers some years ago).
|  They sell a router, actual model is C100BRS4H. Their web page is
| http://www.conceptronic.net, go to products->networking and you'll find it
| here.
|
|  A friend of mine bought one today.
|  I first ran nmap against this device, and identified it as running linux
| 2.4.18-2.4.20
|  Then I asked my friend to look for GPL notices and source code on the
| documentation and he could find none.
|  So, I went to the manufacturers web to look it myself, and could find no
| reference to linux or GPL code. What I found was and actual update to the
| router's ROM.
|  The download site is
| http://download.tulip.com/support/Conceptronic/Network/C100BRS4H/
| After i downloaded it (C100BRS4H_2.97.bin) and ran the strings command i
|  found the following significative strings:
|  webpages-6104k.bin
|  vmlinux.bin

Try this:

tail -c 1717886 C100.bin > webpages-6104k.bin.gz
tail -c 1652350 C100.bin > vmlinux.bin.gz

It's an MIPS kernel:
~  (Linux version 2.4.18-MIPS-01.00 (root@betty_linux) #318 ... 18:01:58 CST 2004)

If you look at the size of the firmware file, I'm not sure, if there are only
these two file in there...

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

iD8DBQFBwgvY5lKZ7Feg4EcRAkeDAJoDv+KvtVIekPBs9PriL+FUvrzHdACeMi8K
iZqrVv+t/FZDhnkVKqmyfxc=
=0UuI
-----END PGP SIGNATURE-----

--------------010709090900000801070001--
