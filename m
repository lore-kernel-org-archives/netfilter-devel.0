From: Jan Srzednicki <winfried@expro.pl>
Subject: ip_nat_amanda unresolved symbol
Date: Wed, 16 Oct 2002 22:18:23 +0200 (CEST)
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <Pine.LNX.4.21.0210162202060.26098-100000@saturn.expro.pl>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
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


Hello there,

I've just cvsupped new version of netfilter stuff (16/10/2002). I wanted
to try some of the new modules in patch-o-matic, one of which is the
Amanda connection tracking helper. However, this module contains an
unresolved symbol:

find kernel -path '*/pcmcia/*' -name '*.o' | xargs -i -r ln -sf ../{} pcmcia
if [ -r System.map ]; then /sbin/depmod -ae -F System.map 2.4.19; fi
depmod: *** Unresolved symbols in
/lib/modules/2.4.19/kernel/net/ipv4/netfilter/ip_nat_amanda.o
depmod:         ip_nat_mangle_udp_packet

I grepped all kernel sources and netfilter patches -
ip_nat_mangle_udp_packet is not defined anywhere! I looked on the code of
similar function - ip_nat_mangle_tcp_packet(); it is defined and exported
correctly. Yet, ip_nat_mangle_udp_packet() clearly is missing. I use the
"new" nat headers and schemes, if that matters in any way.

Here's the list of patches I have installed:

Already applied: submitted/2.4.18
                 submitted/DSCP
                 submitted/ECN
                 submitted/REJECT-dont_fragment
                 submitted/REJECT_mark
                 submitted/TOS-oops-fix
                 submitted/ahesp-static
                 submitted/arptables
                 submitted/conntrack+nat-helper-unregister
                 submitted/conntrack
                 submitted/dscp
                 submitted/ecn
                 submitted/helper
                 submitted/ip6tables-export-symbols
                 submitted/ip_nat_irc-srcaddr-fix
                 submitted/ipt_MIRROR-ttl
                 submitted/ipt_REJECT-checkentry
                 submitted/ipt_unclean-ecn
                 submitted/irc-dcc-mask
                 submitted/length-ipv6
                 submitted/local-nat
                 submitted/macro-trailing-semicolon-fix
                 submitted/mangle5hooks
                 submitted/nat-export_symbols
                 submitted/nat-memoryleak-fix
                 submitted/netfilter-arp
                 submitted/skb_clone_copy
                 submitted/ulog-module-unload
                 submitted/ulog-nlgroup-shift-fix
                 submitted/unclean-udpchecksum
                 submitted/z-newnat16
                 base/IPV4OPTSSTRIP
                 base/NETMAP
                 base/TTL
                 base/fuzzy
                 base/iplimit
                 base/ipt_unclean-ubit
                 base/ipv4options
                 base/mport
                 base/nth
                 base/quota
                 base/random
                 base/time
                 extra/CONNMARK
                 extra/amanda-conntrack-nat
                 extra/h323-conntrack-nat
                 extra/ip_tables-proc
                 extra/pptp-conntrack-nat
                 extra/recent
                 extra/string
                 extra/tcp-window-tracking
                 userspace/ipt_REJECT-fake-source


greetz,
-- 
Jan 'Winfried' Srzednicki
w@expro.pl
