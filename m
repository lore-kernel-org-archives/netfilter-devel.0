From: Maciej Soltysiak <solt@dns.toxicfilms.tv>
Subject: BUG somewhere in NAT mechanism [was: my linux box does not learn
 from redirects]
Date: Sat, 12 Apr 2003 15:40:30 +0200 (CEST)
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <Pine.LNX.4.51.0304121406180.24111@dns.toxicfilms.tv>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: linux-kernel@vger.kernel.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: netfilter-devel@lists.samba.org
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

Hi,

I was posting linux-kernel about my linux box not learning from icmp
redirects and i was advised to see into my configuration, but today
i found that the problem is within netfilter code.
Here is the scoop:

In a nutshell:
- iptable_nat, _may_ cause the box to ignore icmp redirects (maybe other
  things too)

Host A is in a network where there is router B and router C.
Router B routes to other networks.
Router C routes to the Internet.

Host A's routing entries:
- to its network
- default via router B

When host A with this module loaded communicates with the world,
after some time the rate of icmp redirects from router A for packets to
the Internet rises enormously. Normally the host should react to the first
packet and then send all the packet through the advised router, ie. B.

The way i reproduce this bug:
# insmod ip_tables
# insmod ip_conntrack
# insmod iptable_nat

Now wait some time. After a few minutes i see in iptraf
that ICMP rate is rising, the icmp i get is about 30% of all the TCP
packets sent.

Now i remove the iptable_nat
# rmmod iptable_nat

The rate of icmp suddenly drops, as seen on iptraf stats. The rate is
less than 0.1% of all tcp traffic.

This is a 2.4.20-xfs kernel with the following patch-o-matic patches:
Already applied: submitted/01_2.4.19
                 submitted/02_2.4.20
                 submitted/04_newnat-udp-helper
                 submitted/05_REJECT-fwspotting-phrack60-fix
                 submitted/06_ftp-conntrack-msg-fix
                 submitted/07_ECN-tcpchecksum-littleendian-fix
                 submitted/08_ftp-conntrack-debugftp
                 submitted/08_mangle_input_noroutemeharder
                 submitted/09_icmp-match-all
                 submitted/10_confirm_fix
                 submitted/10_local-nat-expectfn
                 submitted/11_inner-icmp-translation-fix
                 submitted/13_ftp-conntrack-epsv-typo
                 submitted/14_hl-ipv6
                 submitted/15_ahesp6-ipv6
                 submitted/16_frag6-ipv6
                 submitted/17_ipv6header-ipv6
                 submitted/18_opts6-ipv6
                 submitted/19_route6-ipv6
                 submitted/23_REJECT-headroom-tcprst
                 submitted/ipt_ULOG-mac_len-fix
                 submitted/ipt_multiport-invfix
                 pending/06_early_drop-backwards
                 pending/24_conntrack-nosysctl
                 pending/25_natcore-nohelper
                 pending/unused_var
                 base/IPV4OPTSSTRIP
                 base/REJECT-ipv6
                 base/TTL
                 base/fuzzy
                 base/fuzzy6-ipv6
                 base/iplimit
                 base/ipt_unclean-ubit
                 base/ipv4options
                 base/mport
                 base/psd
                 base/quota
                 extra/admin-prohib
                 extra/cuseeme-nat
                 extra/ip_conntrack-timeouts
                 extra/netfilter-docbook
                 extra/string

I can supply any information required to pursue this problem.

Regards,
Maciej Soltysiak
