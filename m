From: c0g <c0g@wp.pl>
Subject: raw patch saga continues.... kernel still panics!
Date: Sat, 11 Oct 2003 20:09:35 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <3F88475F.4070907@wp.pl>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
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

Hello,
Bad news again :(
I can force kernel to panic by using ntpdate program to synchronize
clock or by starting ntpd server on firewall box. Of course it happens
only when there are rules in raw table, PREROUTING chain which catch
packets generated/received by these program and jump to NOTRACK.
Inserting rule:
iptables -t raw -I PREROUTING -j ACCEPT
before NOTRACK rules makes kernel stable.

There is also one problem, don't know if correlated with raw patch,
because unloading netfilter modules and trying to connect to my firewall
thru PPTP causes kernel panic too. But on kernel patched with older POM
everything works fine.

Will kernel panics ever end? :(
I switched again to old-good POM with "Frag of proto" messages...
Hey, but these messages weren't that bad... Maybe we should just comment
out logging it? :-P

I'm using ntpdate 4.1.0 shipped with Debian stable.
POM which works stable is CVS snapshot 20030907.
Unstable POM and iptables are CVS snapshots - 20031009.
POM patches which I applied:
Already applied: submitted/01_2.4.19
~                 submitted/02_2.4.20
~                 submitted/03_2.4.21
~                 submitted/04_2.4.22
~                 submitted/44_backport_ah_esp_fixes
~                 submitted/54_ip_nat-macro-args
~                 submitted/58-ip_conntrack-macro-args
~                 submitted/60_nat_tftp-remove-warning
~                 submitted/72_recent_procfs_fix
~                 submitted/73_ipt_MASQUERADE-oif
~                 submitted/74_nat-range-fix
~                 submitted/75_REJECT_localpmtu-fix
~                 submitted/76_snmp-checksum_h-fix
~                 submitted/77_destroy-conntrack
~                 submitted/78_nathelper-udp-csum
~                 submitted/79_mangle_udp-sizecheck
~                 submitted/80_ip_conntrack-proc
~                 submitted/81_ipt_unclean-tcp-flag-table
~                 submitted/82_irc-conntrack-mirc-serverlookup
~                 submitted/83_nolocalout
~                 submitted/84_local-nullbinding
~                 submitted/85_ipv6header
~                 submitted/86_getorigdst-tuple-zero
~                 pending/40_nf-log
~                 pending/40_nf-log-ipv6
~                 pending/59_ip_nat_h-unused-var
~                 pending/61-remove-memsets
~                 pending/70_expect-evict-order
~                 base/IPV4OPTSSTRIP
~                 base/NETLINK
~                 base/NETMAP
~                 base/SAME
~                 base/TTL
~                 base/connlimit
~                 base/fuzzy
~                 base/iprange
~                 base/ipv4options
~                 base/mport
~                 base/nth
~                 base/quota
~                 base/random
~                 base/raw
~                 base/realm
~                 base/time
~                 base/u32
~                 extra/CLASSIFY
~                 extra/CONNMARK
~                 extra/IPMARK
~                 extra/ROUTE
~                 extra/TCPLAG
~                 extra/addrtype
~                 extra/condition
~                 extra/ipt_TARPIT
~                 extra/netfilter-docbook
~                 extra/owner-socketlookup
~                 extra/string
~                 extra/tcp-window-tracking
~                 userspace/ipt_REJECT-fake-source
~                 userspace/mark-bitwise-ops

But I use only these modules:
ipt_TCPMSS
ipt_NOTRACK
iptable_filter
iptable_raw
ipt_REJECT
ipt_multiport
ipt_state
ip_conntrack
ipt_LOG
ip_tables

- --
c0g@wp.pl
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.1 (MingW32)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org

iD8DBQE/iEdfPqmVt5WhbA8RAklDAJ0bxEUQdjSlX1F4B0rreWBID/bOKwCgkX2n
16eS1EFqDpACNHazKsSNcYY=
=oHa3
-----END PGP SIGNATURE-----
