From: Piotr =?iso-8859-2?Q?Gasid=B3o?= <quaker@ondraszek.eu.org>
Subject: Problems with iptables 1.2.9 - iptables: Loop found in table
Date: Thu, 11 Dec 2003 17:47:49 +0100
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20031211164749.GA11985@moon.ondraszek.ds.polsl.gliwice.pl>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-2
Content-Transfer-Encoding: quoted-printable
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
Content-Disposition: inline
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

Hello,

I downloaded CVS version of patch-o-matic and iptables (20031209). I noti=
ced
strange error while trying to enter rule without target (for counting
reasons):

# iptables -I INPUT -s 1.1.1.1
iptables: Loop found in table

# iptables -N test
# iptables -I test -s 1.1.1.1
# iptables -I INPUT -j test
iptables: Loop found in table

In both examples rule is not inserted.

A applied nearly every patch from patch-o-matic, kernel 2.4.23 with
grsecurity, IMQ patch:

Already applied: submitted/01_2.4.19
                 submitted/02_2.4.20
                 submitted/03_2.4.21
                 submitted/04_2.4.22
                 submitted/05_2.4.23
                 submitted/61-remove-memsets
                 submitted/64_masquerade-sameip-noflush
                 submitted/69_amanda-helpers
                 submitted/70_expect-evict-order
                 submitted/72_recent_procfs_fix
                 submitted/74_listhelp
                 submitted/75_selective_cleanup
                 submitted/76_conntrack_bucket_sysctl
                 submitted/88_ip_queue-maxlen
                 submitted/89_ipv6_mld_netfilter
                 pending/40_nf-log
                 pending/40_nf-log-ipv6
                 pending/59_ip_nat_h-unused-var
                 base/HL-ipv6
                 base/IPV4OPTSSTRIP
                 base/NETLINK
                 base/NETMAP
                 base/REJECT-ipv6
                 base/SAME
                 base/TTL
                 base/connlimit
                 base/dstlimit
                 base/fuzzy
                 base/fuzzy6-ipv6
                 base/iprange
                 base/ipv4options
                 base/mport
                 base/nth
                 base/nth6-ipv6
                 base/osf
                 base/pool
                 base/psd
                 base/quota
                 base/random
                 base/random6-ipv6
                 base/raw
                 base/realm
                 base/time
                 base/u32
                 extra/CLASSIFY
                 extra/CONNMARK
                 extra/IPMARK
                 extra/ROUTE
                 extra/ROUTE-ipv6
                 extra/TCPLAG
                 extra/TRACE
                 extra/XOR
                 extra/addrtype
                 extra/condition
                 extra/condition6-ipv6
                 extra/connbytes
                 extra/conntrack-seqfile
                 extra/cuseeme-nat
                 extra/eggdrop-conntrack
                 extra/h323-conntrack-nat
                 extra/ipt_TARPIT
                 extra/iptables-loopcheck-speedup
                 extra/mms-conntrack-nat
                 extra/netfilter-docbook
                 extra/owner-socketlookup
                 extra/ownercmd-ipv6
                 extra/pptp-conntrack-nat
                 extra/quake3-conntrack
                 extra/rpc
                 extra/rsh
                 extra/rtsp-conntrack
                 extra/string
                 extra/talk-conntrack-nat

I didn't applied extra/iptables-loopcheck-speedup patch.

What is wrong?
=20
--=20
Piotr 'QuakeR' Gasid=B3o, just another user @ ondraszek.eu.org
##################### sending lusers to /dev/null since 1998
############ Waiting for tomorrow, for a little ray of light
########## Waiting for tomorrow just to see your smile again
