From: Sven Anders <anders@anduras.de>
Subject: Reset conntrack...
Date: Thu, 02 Dec 2004 23:09:53 +0100
Message-ID: <41AF92B1.30802@anduras.de>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="------------050005070005060605010705"
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
--------------050005070005060605010705
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

Hello!

Is it possible to reset the conntrack list or set any entry to the state NEW to force
a recheck against new filter rules?

The problem is:

~  If I set the (new) filtering rules with the target DROP, I want old
~  (existing) connections to be dropped immediatly.
~  The global rule '--state RELATED,ESTABLISHED' I set would still allow them...

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

iD8DBQFBr5Kw5lKZ7Feg4EcRAsENAJ0XErp8VEr6vAIBUiyj9UM+Qm0gMgCdHQ4h
QzBcNjCwn8da+HnPIaGjH+M=
=cVzY
-----END PGP SIGNATURE-----

--------------050005070005060605010705--
