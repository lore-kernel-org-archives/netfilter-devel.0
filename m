From: Sven Anders <anders@anduras.de>
Subject: Status of 'pptp-conntrack-nat' ?!
Date: Mon, 20 Jun 2005 12:10:36 +0200
Message-ID: <42B6961C.7070604@anduras.de>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="------------080206080804040804000609"
Cc: laforge@netfilter.org
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
--------------080206080804040804000609
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

Hello!

What is the status of the PPTP Connection-Tracking module?

Sorry if I ask this question again, but I the last state I found on this
mailing list was:

| There is no pptp/gre conntrack and nat helper for 2.6.11+, since this
| kernel version contains a redesigned infrastructure for such helpers.
|
| At this time, I see very limited chance that this new infrastructure is
| sufficient enough to actually implement the same functionality.  A
| straight 1:1 port ist definitely not possible.

...but in the latest patch-o-matic I found an special sub-directory
for linux 2.6.11.


What makes me confused is that the 'help' files says:

~ - does NOT work with kernels > 2.6.10

and the 'info' file:

~ Requires: linux < 2.6.11
~ Requires: linux-2.6 < 2.6.11


Is this a special development version which is worth testing or do I have
to wait? Does it work with 2.6.12 too?

Regards
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

iD8DBQFCtpYb5lKZ7Feg4EcRArnJAJ9aLYYmqt0Jj1SoDPATPmhqTq0pFQCfdY3M
DQGiGQQ4GaI7yTxOvjTGXlg=
=6H4B
-----END PGP SIGNATURE-----

--------------080206080804040804000609--
