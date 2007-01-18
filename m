From: Jonas Berlin <xkr47@outerspace.dyndns.org>
Subject: PANIC: divide by zero in xt_connbytes
Date: Thu, 18 Jan 2007 10:59:36 +0000
Message-ID: <45AF5318.8040204@outerspace.dyndns.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Patrick McHardy <kaber@trash.net>,
	Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
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

-----BEGIN PGP SIGNED MESSAGE-----
Hash: RIPEMD160

Hi Patrick,

Hidden asked me (on irc) to bring your attention to this bug:

~  http://bugzilla.netfilter.org/bugzilla/show_bug.cgi?id=533

He also said that the fix should maybe be considered for inclusion in the -stable branch.

- --
~ "if I'd make up my own definitions, unrational would be the the end
~  result after someone unrationalized something i.e. actively worked
~  to cut down on rationality, whereas irrational would be more a
~  result of laziness or lack of skill"
~                - me, 23.11.2006
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQFFr1MNxyF48ZTvn+4RA1woAKCxAkxl0gr5aiFP49NdZ+qnA2zJFACgxXNk
CUOIgGSGWk7Nt4WODOizn+s=
=CQkC
-----END PGP SIGNATURE-----
