From: Sven Anders <anders@anduras.de>
Subject: Unique rule ID?!
Date: Mon, 08 Nov 2004 12:04:05 +0100
Message-ID: <418F52A5.7010700@anduras.de>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="------------090102050903000804040800"
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
--------------090102050903000804040800
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

Hello!

I've wrote my own litte tool so set the ip-tables rule in the kernel. It works
nicely, but now I have some trouble with the byte and packet counters and need
some ideas...

Instead of manipulating the existing kernel tables (by reading the current
table from the kernel, changing it and writing it back - like the iptables tool.)
it reads the complete table definitions from config file and commits it to the
kernel. Unfortunatly it currently zeros out all counters.

Because I cannot be sure, what changes are made to the config file (from one commit
to the next), I have to identify each rule for sure. If I could mark any rule I
set with an unique id, it would be easy. Sadly, I did not found any field in the
netfilter rules structure to do this... I found an 'comment' match extension, which
I could misuse for it, but this would be an hack.

Or are there any unique identifiers to each rule (which would not change from one
kernel commit to the next) that I missed?

If I decide to add an ID field to the kernel's rule structure (and implement the
code for giving each new rule an unique ID), would you be interested to accept
these patch to the offical netfilter tree? If you argue against it with the
used memory, do you really think 2-4 bytes per rule is too much? What is the biggest
useful size of an netfilter table? 1000 rules (= 4 Kbytes for IDs),
10000 rules (= 40KB)? If so much rules are in place, don't you think you have to
use chains? ;-)

Additionaly this unique ID, once it's implemented, could be used for a better
identification of matching rules in the LOG/ULOG targets. You didn't have to
wonder which rule matched and could use the prefix field for other things.
Maybe this ID could be useful for synchronizing kernel tables when playing
with high-availablity...

What do you think about this ideas
Any other ideas?!

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

iD4DBQFBj1Kl5lKZ7Feg4EcRAoRqAJiU5J4cMkt5nCNTL3CV/00byYu6AJ4zR+ZR
cnS0tI9dKMFBUEXGeVrj/Q==
=URiF
-----END PGP SIGNATURE-----

--------------090102050903000804040800--
