From: Sven Anders <anders@anduras.de>
Subject: Re: Re: Unique rule ID?!
Date: Mon, 08 Nov 2004 21:28:56 +0100
Message-ID: <418FD708.3030302@anduras.de>
References: <20041108134743.217B817BE5@grasshopper.anduras.de>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="------------040203060304040205000806"
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
In-Reply-To: <20041108134743.217B817BE5@grasshopper.anduras.de>
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
--------------040203060304040205000806
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1


| From: Henrik Nordstrom <hno@marasystems.com>
| Subject: Re: Unique rule ID?!
| To: Sven Anders <anders@anduras.de>
| Cc: Netfilter Developers <netfilter-devel@lists.netfilter.org>
|
| On Mon, 8 Nov 2004, Sven Anders wrote:
|
|
|>Harald Welte and some others are breaking the compatibility every two or
|>three ip-tables/netfilter/kernel versions. :-)
|
|
| Only for patch-o-matic modules and intentionally so as there is good
| reasons why these are not (yet) in mainline. Every breakage of what is in
| mainline is a bug and gets fixed pretty quickly should it occur.

Ok, thats correct. But I need many of the POM modules and so it does occure
often.

| Using stuff from pom is a gamble on versions, much like any other use of
| experimental stuff is. Yes, it occationally happens, but frankly so quite
| rarely.
|
| Lately this has started to becoming quite a bit of hinderance for the
| iptables development as there is many changes everyone agrees needs to be
| done, but can't be done in a clean manner without breaking mainline stuff.
|
| Regards
| Henrik

You cannot think of all possibilites when designing and API. We have now a
state, which was not changed for over 2 (or more?) years.
As I read, a new iptables version (1.3?) is comming, don't you think, now
is the time to rethink the design and implement (or accept) new features
to the API?
There are so many interesting new match and target modules in the POM,
many are stable and could be taken to the mainline...

My idea is to collect all necessary changes (or wishes) and discuss them.
Which POM modules should be taken to the mainline, should be discussed too...

Any comments?!

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

iD8DBQFBj9cI5lKZ7Feg4EcRAn9IAJsHrSCTh/BH8kH09YddXF3OTt6bCACghuFp
IlWstOxgdOr+4JPVyeEao5M=
=SchT
-----END PGP SIGNATURE-----

--------------040203060304040205000806--
