From: c0g <c0g@wp.pl>
Subject: raw patch = kernel panic :(
Date: Sun, 05 Oct 2003 18:24:19 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <3F8045B3.6000607@wp.pl>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Cc: kadlec@blackhole.kfki.hu,  laforge@netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
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

Hi!
I applied raw-patch from CVS patch-o-matic (20031003), and it appears
that loading rule in PREROUTING chain of table raw causes kernel panic.
Specifing policy for this table doesn't.

So I was forced to use older POM, which fills my logs with "Frag of
proto" messages :(

Jozsef, could you look at it?

I have vanilla 2.4.22 kernel with following POM patches applied:
submitted/01_2.4.19
submitted/02_2.4.20
submitted/03_2.4.21
submitted/04_2.4.22
submitted/44_backport_ah_esp_fixes
submitted/54_ip_nat-macro-args
submitted/58-ip_conntrack-macro-args
submitted/60_nat_tftp-remove-warning
submitted/72_recent_procfs_fix
submitted/73_ipt_MASQUERADE-oif
submitted/74_nat-range-fix
submitted/75_REJECT_localpmtu-fix
submitted/76_snmp-checksum_h-fix
submitted/77_destroy-conntrack
submitted/78_nathelper-udp-csum
submitted/79_mangle_udp-sizecheck
submitted/80_ip_conntrack-proc
submitted/81_ipt_unclean-tcp-flag-table
submitted/82_irc-conntrack-mirc-serverlookup
submitted/83_nolocalout
submitted/84_local-nullbinding
submitted/85_ipv6header
submitted/86_getorigdst-tuple-zero
pending/40_nf-log
pending/59_ip_nat_h-unused-var
pending/61-remove-memsets
pending/64_masquerade-sameip-noflush
base/mport
extra/addrtype
extra/tcp-window-tracking
userspace/ipt_REJECT-fake-source
userspace/raw

- --
c0g@wp.pl
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.1 (MingW32)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org

iD8DBQE/gEWMPqmVt5WhbA8RAr7RAJ9VQQ113DigkI3z3RQmC1O0jLLABACdG+8J
1aWGhgAe91Ftgyvq+5g5cv0=
=+2Gf
-----END PGP SIGNATURE-----
