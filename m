From: Sven Anders <anders@anduras.de>
Subject: Re: New API / POM modules to merge.... (was: Unique rule ID?!)
Date: Tue, 09 Nov 2004 16:53:48 +0100
Message-ID: <4190E80C.8020106@anduras.de>
References: <20041108134743.217B817BE5@grasshopper.anduras.de>
	<418FD708.3030302@anduras.de>
	<Pine.LNX.4.61.0411082226010.21933@filer.marasystems.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="------------050108000608060906040406"
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Henrik Nordstrom <hno@marasystems.com>, netfilter-devel@lists.netfilter.org
In-Reply-To: <Pine.LNX.4.61.0411082226010.21933@filer.marasystems.com>
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
--------------050108000608060906040406
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

Henrik Nordstrom wrote:
|
|> As I read, a new iptables version (1.3?) is comming, don't you think, now
|> is the time to rethink the design and implement (or accept) new features
|> to the API?
|
|
| The API is being redesigned in pkttables.

Is there documentation for the new API available?

|> There are so many interesting new match and target modules in the POM,
|> many are stable and could be taken to the mainline...
|
| Please note that the pom inventory was quite recently discussed on the
| netfilter developer workshop, deciding which of the additions should go
| mainline and which not, with some motivations on each. The summary can
| be found in the workshop notes available in the documentation section of
| the web site.

Interesting list. Nice to see many that useful matches will be merged...

Some question:

~ 1. "TTL or HOPLIMIT: no, it's dangerous"

~    Why? Don't use it, if it's dangerous - or does it crash the kernel?

~ 2. "ipp2p: like string matching, stays in POM"

~    Did not found the "string" match comment. Does it stay here forever?


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

iD8DBQFBkOgL5lKZ7Feg4EcRAss3AJ9JC7F4bicJ8glSU6s0YQUJiiqJbQCffVDe
CQem8J0GGmd4Dkpb1BBessk=
=HDYh
-----END PGP SIGNATURE-----

--------------050108000608060906040406--
