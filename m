From: Rolf Wuerdemann <rowue@crew-kg.de>
Subject: Target ipt_ACCOUNT
Date: Fri, 16 May 2003 22:18:54 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <200305162018.h4GKIvu02359@moonlight.crew-kg.de>
Reply-To: rowue@crew-kg.de
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Harald Welte <laforge@netfilter.org>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

Hi Harald ...

long time not heared ...

if you remember I wrote an target for iptables/netfilter last year
wo packet-based accounting - besides some "cosmetic" changes
(> 80 chars/line, c-- style comments) you've metioned that you
dislike the use of netfilter-sockets to get the data from kernel- to
user-space ...

besides the cosmetic changes (which where done very fast) I've
changed to data-transfer to the use of "/dev/accounting" via "normal"
kernel file i/o (no proc fs or so) (this takes some "spare time" which
I've gotten now)

Although I've used "dynamic-major-number-relocation" I've also heared
that someone should ask for a "real" major number if he wants to publish
code...

May you give me a hint where to ask?

Sinc.

=09Rolf W=FCrdemann
=09Wieske's Crew KG

PS: CC: netfilter-devel@lists.netfilter.org
- --=20
               Security is an illusion - Datasecurity twice
  Rolf Wuerdemann  - Privat: rowue@digitalis.org - Office: rowue@crew-kg.=
de
  GnuPG-Key fingerprint: 7383 348F 67D1 CD27 C90F DDD0 86A3 31B6 67F0 D02=
F
    RSA-Key fingerprint:      CEBB 5086 9154 E8D8 7D0E CC4F 0F5E B9CC
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.0.6 (GNU/Linux)
Comment: For info see http://www.gnupg.org

iD8DBQE+xUevhqMxtmfw0C8RAu2GAJ9q5xQfx3j4GMUzFbkvctx0ScQi2ACgwOPM
POe2iHlHlNufDiv0hFYib8k=3D
=3D4Kva
-----END PGP SIGNATURE-----
