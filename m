From: Sven Anders <anders@anduras.de>
Subject: New iptables structure (was: [PATCH 1/2] ipt_MARK extension with
 backwards compatibilty...)
Date: Sat, 27 Nov 2004 11:45:24 +0100
Message-ID: <41A85AC4.5080006@anduras.de>
References: <1101358191.5842.26.camel@localhost.localdomain>
	<41A7B514.9030703@eurodev.net>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="------------070105000300090501090404"
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
In-Reply-To: <41A7B514.9030703@eurodev.net>
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
--------------070105000300090501090404
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

Pablo Neira wrote:

| My idea, I don't know how crazy it is. Instead of using the size to
| guess the target/match version, we could steal 1 byte from char name[]
| to define a new field called version, so we could register different
| versions of a match/target.

Once again, we need a field more...
Wasn't there an suggestion to reuse the 'nfcache' field too??
Wasn't the need to an unique rule id posted?
What more???

Why not break compatibilty, if it hamper the development?

Admit it, the design has some flaws, why not eliminating them? You can not preserve the
compatibility forever! It you do it NOW (in the next 2.6 kernel release) you can rely on
the circumstance, that it will updated, because in the current kernel cycle, it will be
done more often. The longer you wait, the more difficult it will be!

To prevent further incompatibility, you can insert some reserved fields to the main
structure...

Comments welcome :-)

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

iD4DBQFBqFrD5lKZ7Feg4EcRAohvAKCD53V3uhC/b2EBWQvjSlHzKQdXrQCYu7iy
FnXEAMJ0SKVKwID2d3yUIw==
=2wlB
-----END PGP SIGNATURE-----

--------------070105000300090501090404--
