From: Sven Anders <anders@anduras.de>
Subject: Re: New API / POM modules to merge....
Date: Tue, 09 Nov 2004 22:54:00 +0100
Message-ID: <41913C78.6050109@anduras.de>
References: <20041108134743.217B817BE5@grasshopper.anduras.de>
	<418FD708.3030302@anduras.de>
	<Pine.LNX.4.61.0411082226010.21933@filer.marasystems.com>
	<4190E80C.8020106@anduras.de>
	<Pine.LNX.4.61.0411092003470.7243@filer.marasystems.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="------------040308030404020008060806"
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Henrik Nordstrom <hno@marasystems.com>
In-Reply-To: <Pine.LNX.4.61.0411092003470.7243@filer.marasystems.com>
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
--------------040308030404020008060806
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

Henrik Nordstrom wrote:

|> Some question:
|>
|> ~ 1. "TTL or HOPLIMIT: no, it's dangerous"
|> ~    Why? Don't use it, if it's dangerous - or does it crash the kernel?
|
| It (TTL) in it's current form violates fundamental aspects of IP, easily
| allowing the administrator to "accidently" create configurations which
| will crash the network.
|
| In case of the TTL match it should be sufficient to change
|
|         if (new_ttl != iph->ttl) {
| to
|         if (new_ttl < iph->ttl) {
|
| and remove the increase option to make it safe, but at the same time you
| loose a lot of the powers of this target so it may not be desireable to
| make this change..

But does a possible misconfiguration justify this?
Simply mark this match as "DANGEROUS" or make the 'Increase' optional.

You did not remove pointers from C, because you could do something wrong... :-)

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

iD8DBQFBkTx35lKZ7Feg4EcRAoRpAJ94zUx+/tTsbA37Nf7bcVrJAmrTiwCeIMvz
CeV532JzNgYKKFRK6U6CVu8=
=fU3Q
-----END PGP SIGNATURE-----

--------------040308030404020008060806--
