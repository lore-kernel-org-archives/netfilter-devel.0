From: Tom Eastep <teastep@shorewall.net>
Subject: Spurious newline in iptables-save output/policy match
Date: Wed, 18 Aug 2004 11:24:46 -0700
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <41239EEE.3090908@shorewall.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Patrick McHardy <kaber@trash.net>,
	netfilter-devel@lists.netfilter.org
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

There is an unwarrented "printf("\n") at the end of the static function
'save' in libipt_policy.c. This causes output from iptables-save to be
rejected by a subsequent iptables-restore.

Sample output from iptables-save:

- -A OUTPUT -o eth0 -m policy --dir out --pol ipsec
- -j fw2loc

- -Tom
- --
Tom Eastep    \ Nothing is foolproof to a sufficiently talented fool
Shoreline,     \ http://shorewall.net
Washington USA  \ teastep@shorewall.net
PGP Public Key   \ https://lists.shorewall.net/teastep.pgp.key
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.4 (GNU/Linux)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org

iD8DBQFBI57uO/MAbZfjDLIRArRhAKCc/qMdRqqo+cDSGJqEwd/iI0XP+gCcDvaa
GflrHppQVOb94NY5A9TzV+o=
=8dYn
-----END PGP SIGNATURE-----
