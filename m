From: Tobias DiPasquale <codeslinger@gmail.com>
Subject: Re: iptables 1.2.11 and kernel 2.6.7
Date: Fri, 2 Jul 2004 10:05:47 -0400
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <876ef97a04070207051e15f80a@mail.gmail.com>
References: <20040702135147.GC11721@tik.ee.ethz.ch>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
In-Reply-To: <20040702135147.GC11721@tik.ee.ethz.ch>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

On Fri, 2 Jul 2004 15:51:47 +0200, Lukas Ruf <ruf@rawip.org> wrote:
> Has anyone experienced the same problems?  I could not find any answer
> in the archive.
> 
> If anyone would be interested in patch, please indicate and I will
> create one.

The patch in the following post fixes (at least) the DECLARE_MUTEX()
problem for me. The issue was that the system headers were being used
and not the headers in the kernel source tree:

http://lists.netfilter.org/pipermail/netfilter/2004-June/053639.html

However, the build process then fails during
extensions/libipt_recent.c in the following manner:

fearless:~/iptables-1.2.11> make KERNEL_DIR=/usr/src/linux
Extensions found: IPv4:recent IPv6:ah IPv6:esp IPv6:frag
IPv6:ipv6header IPv6:hbh IPv6:dst IPv6:rt
gcc -O2 -Wall -Wunused -Iinclude/ -DIPTABLES_VERSION=\"1.2.11\"  -fPIC
-o extensions/libipt_ah_sh.o -c extensions/libipt_ah.c
ld -shared  -o extensions/libipt_ah.so extensions/libipt_ah_sh.o
gcc -O2 -Wall -Wunused -Iinclude/ -DIPTABLES_VERSION=\"1.2.11\"  -fPIC
-o extensions/libipt_connlimit_sh.o -c extensions/libipt_connlimit.c
ld -shared  -o extensions/libipt_connlimit.so extensions/libipt_connlimit_sh.o
gcc -O2 -Wall -Wunused -Iinclude/ -DIPTABLES_VERSION=\"1.2.11\"  -fPIC
-o extensions/libipt_connmark_sh.o -c extensions/libipt_connmark.c
ld -shared  -o extensions/libipt_connmark.so extensions/libipt_connmark_sh.o
gcc -O2 -Wall -Wunused -Iinclude/ -DIPTABLES_VERSION=\"1.2.11\"  -fPIC
-o extensions/libipt_conntrack_sh.o -c extensions/libipt_conntrack.c
ld -shared  -o extensions/libipt_conntrack.so extensions/libipt_conntrack_sh.o
gcc -O2 -Wall -Wunused -Iinclude/ -DIPTABLES_VERSION=\"1.2.11\"  -fPIC
-o extensions/libipt_dscp_sh.o -c extensions/libipt_dscp.c
extensions/libipt_dscp_helper.c:69: warning: `dscp_to_name' defined but not used
ld -shared  -o extensions/libipt_dscp.so extensions/libipt_dscp_sh.o
gcc -O2 -Wall -Wunused -Iinclude/ -DIPTABLES_VERSION=\"1.2.11\"  -fPIC
-o extensions/libipt_ecn_sh.o -c extensions/libipt_ecn.c
ld -shared  -o extensions/libipt_ecn.so extensions/libipt_ecn_sh.o
gcc -O2 -Wall -Wunused -Iinclude/ -DIPTABLES_VERSION=\"1.2.11\"  -fPIC
-o extensions/libipt_esp_sh.o -c extensions/libipt_esp.c
ld -shared  -o extensions/libipt_esp.so extensions/libipt_esp_sh.o
gcc -O2 -Wall -Wunused -Iinclude/ -DIPTABLES_VERSION=\"1.2.11\"  -fPIC
-o extensions/libipt_helper_sh.o -c extensions/libipt_helper.c
ld -shared  -o extensions/libipt_helper.so extensions/libipt_helper_sh.o
gcc -O2 -Wall -Wunused -Iinclude/ -DIPTABLES_VERSION=\"1.2.11\"  -fPIC
-o extensions/libipt_icmp_sh.o -c extensions/libipt_icmp.c
ld -shared  -o extensions/libipt_icmp.so extensions/libipt_icmp_sh.o
gcc -O2 -Wall -Wunused -Iinclude/ -DIPTABLES_VERSION=\"1.2.11\"  -fPIC
-o extensions/libipt_iprange_sh.o -c extensions/libipt_iprange.c
ld -shared  -o extensions/libipt_iprange.so extensions/libipt_iprange_sh.o
gcc -O2 -Wall -Wunused -Iinclude/ -DIPTABLES_VERSION=\"1.2.11\"  -fPIC
-o extensions/libipt_length_sh.o -c extensions/libipt_length.c
ld -shared  -o extensions/libipt_length.so extensions/libipt_length_sh.o
gcc -O2 -Wall -Wunused -Iinclude/ -DIPTABLES_VERSION=\"1.2.11\"  -fPIC
-o extensions/libipt_limit_sh.o -c extensions/libipt_limit.c
ld -shared  -o extensions/libipt_limit.so extensions/libipt_limit_sh.o
gcc -O2 -Wall -Wunused -Iinclude/ -DIPTABLES_VERSION=\"1.2.11\"  -fPIC
-o extensions/libipt_mac_sh.o -c extensions/libipt_mac.c
ld -shared  -o extensions/libipt_mac.so extensions/libipt_mac_sh.o
gcc -O2 -Wall -Wunused -Iinclude/ -DIPTABLES_VERSION=\"1.2.11\"  -fPIC
-o extensions/libipt_mark_sh.o -c extensions/libipt_mark.c
ld -shared  -o extensions/libipt_mark.so extensions/libipt_mark_sh.o
gcc -O2 -Wall -Wunused -Iinclude/ -DIPTABLES_VERSION=\"1.2.11\"  -fPIC
-o extensions/libipt_multiport_sh.o -c extensions/libipt_multiport.c
ld -shared  -o extensions/libipt_multiport.so extensions/libipt_multiport_sh.o
gcc -O2 -Wall -Wunused -Iinclude/ -DIPTABLES_VERSION=\"1.2.11\"  -fPIC
-o extensions/libipt_owner_sh.o -c extensions/libipt_owner.c
ld -shared  -o extensions/libipt_owner.so extensions/libipt_owner_sh.o
gcc -O2 -Wall -Wunused -Iinclude/ -DIPTABLES_VERSION=\"1.2.11\"  -fPIC
-o extensions/libipt_physdev_sh.o -c extensions/libipt_physdev.c
ld -shared  -o extensions/libipt_physdev.so extensions/libipt_physdev_sh.o
gcc -O2 -Wall -Wunused -Iinclude/ -DIPTABLES_VERSION=\"1.2.11\"  -fPIC
-o extensions/libipt_pkttype_sh.o -c extensions/libipt_pkttype.c
ld -shared  -o extensions/libipt_pkttype.so extensions/libipt_pkttype_sh.o
gcc -O2 -Wall -Wunused -Iinclude/ -DIPTABLES_VERSION=\"1.2.11\"  -fPIC
-o extensions/libipt_realm_sh.o -c extensions/libipt_realm.c
ld -shared  -o extensions/libipt_realm.so extensions/libipt_realm_sh.o
gcc -O2 -Wall -Wunused -Iinclude/ -DIPTABLES_VERSION=\"1.2.11\"  -fPIC
-o extensions/libipt_rpc_sh.o -c extensions/libipt_rpc.c
ld -shared  -o extensions/libipt_rpc.so extensions/libipt_rpc_sh.o
gcc -O2 -Wall -Wunused -Iinclude/ -DIPTABLES_VERSION=\"1.2.11\"  -fPIC
-o extensions/libipt_sctp_sh.o -c extensions/libipt_sctp.c
ld -shared  -o extensions/libipt_sctp.so extensions/libipt_sctp_sh.o
gcc -O2 -Wall -Wunused -Iinclude/ -DIPTABLES_VERSION=\"1.2.11\"  -fPIC
-o extensions/libipt_standard_sh.o -c extensions/libipt_standard.c
ld -shared  -o extensions/libipt_standard.so extensions/libipt_standard_sh.o
gcc -O2 -Wall -Wunused -Iinclude/ -DIPTABLES_VERSION=\"1.2.11\"  -fPIC
-o extensions/libipt_state_sh.o -c extensions/libipt_state.c
ld -shared  -o extensions/libipt_state.so extensions/libipt_state_sh.o
gcc -O2 -Wall -Wunused -Iinclude/ -DIPTABLES_VERSION=\"1.2.11\"  -fPIC
-o extensions/libipt_tcp_sh.o -c extensions/libipt_tcp.c
ld -shared  -o extensions/libipt_tcp.so extensions/libipt_tcp_sh.o
gcc -O2 -Wall -Wunused -Iinclude/ -DIPTABLES_VERSION=\"1.2.11\"  -fPIC
-o extensions/libipt_tcpmss_sh.o -c extensions/libipt_tcpmss.c
ld -shared  -o extensions/libipt_tcpmss.so extensions/libipt_tcpmss_sh.o
gcc -O2 -Wall -Wunused -Iinclude/ -DIPTABLES_VERSION=\"1.2.11\"  -fPIC
-o extensions/libipt_tos_sh.o -c extensions/libipt_tos.c
ld -shared  -o extensions/libipt_tos.so extensions/libipt_tos_sh.o
gcc -O2 -Wall -Wunused -Iinclude/ -DIPTABLES_VERSION=\"1.2.11\"  -fPIC
-o extensions/libipt_ttl_sh.o -c extensions/libipt_ttl.c
ld -shared  -o extensions/libipt_ttl.so extensions/libipt_ttl_sh.o
gcc -O2 -Wall -Wunused -Iinclude/ -DIPTABLES_VERSION=\"1.2.11\"  -fPIC
-o extensions/libipt_udp_sh.o -c extensions/libipt_udp.c
ld -shared  -o extensions/libipt_udp.so extensions/libipt_udp_sh.o
gcc -O2 -Wall -Wunused -Iinclude/ -DIPTABLES_VERSION=\"1.2.11\"  -fPIC
-o extensions/libipt_unclean_sh.o -c extensions/libipt_unclean.c
ld -shared  -o extensions/libipt_unclean.so extensions/libipt_unclean_sh.o
gcc -O2 -Wall -Wunused -Iinclude/ -DIPTABLES_VERSION=\"1.2.11\"  -fPIC
-o extensions/libipt_CLASSIFY_sh.o -c extensions/libipt_CLASSIFY.c
ld -shared  -o extensions/libipt_CLASSIFY.so extensions/libipt_CLASSIFY_sh.o
gcc -O2 -Wall -Wunused -Iinclude/ -DIPTABLES_VERSION=\"1.2.11\"  -fPIC
-o extensions/libipt_CONNMARK_sh.o -c extensions/libipt_CONNMARK.c
ld -shared  -o extensions/libipt_CONNMARK.so extensions/libipt_CONNMARK_sh.o
gcc -O2 -Wall -Wunused -Iinclude/ -DIPTABLES_VERSION=\"1.2.11\"  -fPIC
-o extensions/libipt_DNAT_sh.o -c extensions/libipt_DNAT.c
ld -shared  -o extensions/libipt_DNAT.so extensions/libipt_DNAT_sh.o
gcc -O2 -Wall -Wunused -Iinclude/ -DIPTABLES_VERSION=\"1.2.11\"  -fPIC
-o extensions/libipt_DSCP_sh.o -c extensions/libipt_DSCP.c
extensions/libipt_dscp_helper.c:69: warning: `dscp_to_name' defined but not used
ld -shared  -o extensions/libipt_DSCP.so extensions/libipt_DSCP_sh.o
gcc -O2 -Wall -Wunused -Iinclude/ -DIPTABLES_VERSION=\"1.2.11\"  -fPIC
-o extensions/libipt_ECN_sh.o -c extensions/libipt_ECN.c
ld -shared  -o extensions/libipt_ECN.so extensions/libipt_ECN_sh.o
gcc -O2 -Wall -Wunused -Iinclude/ -DIPTABLES_VERSION=\"1.2.11\"  -fPIC
-o extensions/libipt_LOG_sh.o -c extensions/libipt_LOG.c
ld -shared  -o extensions/libipt_LOG.so extensions/libipt_LOG_sh.o
gcc -O2 -Wall -Wunused -Iinclude/ -DIPTABLES_VERSION=\"1.2.11\"  -fPIC
-o extensions/libipt_MARK_sh.o -c extensions/libipt_MARK.c
ld -shared  -o extensions/libipt_MARK.so extensions/libipt_MARK_sh.o
gcc -O2 -Wall -Wunused -Iinclude/ -DIPTABLES_VERSION=\"1.2.11\"  -fPIC
-o extensions/libipt_MASQUERADE_sh.o -c extensions/libipt_MASQUERADE.c
ld -shared  -o extensions/libipt_MASQUERADE.so extensions/libipt_MASQUERADE_sh.o
gcc -O2 -Wall -Wunused -Iinclude/ -DIPTABLES_VERSION=\"1.2.11\"  -fPIC
-o extensions/libipt_MIRROR_sh.o -c extensions/libipt_MIRROR.c
ld -shared  -o extensions/libipt_MIRROR.so extensions/libipt_MIRROR_sh.o
gcc -O2 -Wall -Wunused -Iinclude/ -DIPTABLES_VERSION=\"1.2.11\"  -fPIC
-o extensions/libipt_NETMAP_sh.o -c extensions/libipt_NETMAP.c
ld -shared  -o extensions/libipt_NETMAP.so extensions/libipt_NETMAP_sh.o
gcc -O2 -Wall -Wunused -Iinclude/ -DIPTABLES_VERSION=\"1.2.11\"  -fPIC
-o extensions/libipt_NOTRACK_sh.o -c extensions/libipt_NOTRACK.c
ld -shared  -o extensions/libipt_NOTRACK.so extensions/libipt_NOTRACK_sh.o
gcc -O2 -Wall -Wunused -Iinclude/ -DIPTABLES_VERSION=\"1.2.11\"  -fPIC
-o extensions/libipt_REDIRECT_sh.o -c extensions/libipt_REDIRECT.c
ld -shared  -o extensions/libipt_REDIRECT.so extensions/libipt_REDIRECT_sh.o
gcc -O2 -Wall -Wunused -Iinclude/ -DIPTABLES_VERSION=\"1.2.11\"  -fPIC
-o extensions/libipt_REJECT_sh.o -c extensions/libipt_REJECT.c
ld -shared  -o extensions/libipt_REJECT.so extensions/libipt_REJECT_sh.o
gcc -O2 -Wall -Wunused -Iinclude/ -DIPTABLES_VERSION=\"1.2.11\"  -fPIC
-o extensions/libipt_SAME_sh.o -c extensions/libipt_SAME.c
ld -shared  -o extensions/libipt_SAME.so extensions/libipt_SAME_sh.o
gcc -O2 -Wall -Wunused -Iinclude/ -DIPTABLES_VERSION=\"1.2.11\"  -fPIC
-o extensions/libipt_SNAT_sh.o -c extensions/libipt_SNAT.c
ld -shared  -o extensions/libipt_SNAT.so extensions/libipt_SNAT_sh.o
gcc -O2 -Wall -Wunused -Iinclude/ -DIPTABLES_VERSION=\"1.2.11\"  -fPIC
-o extensions/libipt_TARPIT_sh.o -c extensions/libipt_TARPIT.c
ld -shared  -o extensions/libipt_TARPIT.so extensions/libipt_TARPIT_sh.o
gcc -O2 -Wall -Wunused -Iinclude/ -DIPTABLES_VERSION=\"1.2.11\"  -fPIC
-o extensions/libipt_TCPMSS_sh.o -c extensions/libipt_TCPMSS.c
ld -shared  -o extensions/libipt_TCPMSS.so extensions/libipt_TCPMSS_sh.o
gcc -O2 -Wall -Wunused -Iinclude/ -DIPTABLES_VERSION=\"1.2.11\"  -fPIC
-o extensions/libipt_TOS_sh.o -c extensions/libipt_TOS.c
ld -shared  -o extensions/libipt_TOS.so extensions/libipt_TOS_sh.o
gcc -O2 -Wall -Wunused -Iinclude/ -DIPTABLES_VERSION=\"1.2.11\"  -fPIC
-o extensions/libipt_TRACE_sh.o -c extensions/libipt_TRACE.c
ld -shared  -o extensions/libipt_TRACE.so extensions/libipt_TRACE_sh.o
gcc -O2 -Wall -Wunused -Iinclude/ -DIPTABLES_VERSION=\"1.2.11\"  -fPIC
-o extensions/libipt_TTL_sh.o -c extensions/libipt_TTL.c
ld -shared  -o extensions/libipt_TTL.so extensions/libipt_TTL_sh.o
gcc -O2 -Wall -Wunused -Iinclude/ -DIPTABLES_VERSION=\"1.2.11\"  -fPIC
-o extensions/libipt_ULOG_sh.o -c extensions/libipt_ULOG.c
ld -shared  -o extensions/libipt_ULOG.so extensions/libipt_ULOG_sh.o
gcc -O2 -Wall -Wunused -Iinclude/ -DIPTABLES_VERSION=\"1.2.11\"  -fPIC
-o extensions/libipt_recent_sh.o -c extensions/libipt_recent.c
extensions/libipt_recent.c:9:45: linux/netfilter_ipv4/ipt_recent.h: No
such file or directory
extensions/libipt_recent.c: In function `init':
extensions/libipt_recent.c:77: error: dereferencing pointer to incomplete type
extensions/libipt_recent.c:77: error: dereferencing pointer to incomplete type
extensions/libipt_recent.c:77: error: dereferencing pointer to incomplete type
extensions/libipt_recent.c:80: error: dereferencing pointer to incomplete type
extensions/libipt_recent.c:81: error: dereferencing pointer to incomplete type
extensions/libipt_recent.c:81: error: `IPT_RECENT_SOURCE' undeclared
(first use in this function)
extensions/libipt_recent.c:81: error: (Each undeclared identifier is
reported only once
extensions/libipt_recent.c:81: error: for each function it appears in.)
extensions/libipt_recent.c: In function `parse':
extensions/libipt_recent.c:99: error: dereferencing pointer to incomplete type
extensions/libipt_recent.c:99: error: `IPT_RECENT_SET' undeclared
(first use in this function)
extensions/libipt_recent.c:100: error: dereferencing pointer to incomplete type
extensions/libipt_recent.c:109: error: dereferencing pointer to incomplete type
extensions/libipt_recent.c:109: error: `IPT_RECENT_CHECK' undeclared
(first use in this function)
extensions/libipt_recent.c:110: error: dereferencing pointer to incomplete type
extensions/libipt_recent.c:119: error: dereferencing pointer to incomplete type
extensions/libipt_recent.c:119: error: `IPT_RECENT_UPDATE' undeclared
(first use in this function)
extensions/libipt_recent.c:120: error: dereferencing pointer to incomplete type
extensions/libipt_recent.c:129: error: dereferencing pointer to incomplete type
extensions/libipt_recent.c:129: error: `IPT_RECENT_REMOVE' undeclared
(first use in this function)
extensions/libipt_recent.c:130: error: dereferencing pointer to incomplete type
extensions/libipt_recent.c:135: error: dereferencing pointer to incomplete type
extensions/libipt_recent.c:139: error: dereferencing pointer to incomplete type
extensions/libipt_recent.c:143: error: dereferencing pointer to incomplete type
extensions/libipt_recent.c:143: error: `IPT_RECENT_TTL' undeclared
(first use in this function)
extensions/libipt_recent.c:147: error: dereferencing pointer to incomplete type
extensions/libipt_recent.c:147: error: dereferencing pointer to incomplete type
extensions/libipt_recent.c:147: error: dereferencing pointer to incomplete type
extensions/libipt_recent.c:148: error: dereferencing pointer to incomplete type
extensions/libipt_recent.c:152: error: dereferencing pointer to incomplete type
extensions/libipt_recent.c:152: error: `IPT_RECENT_SOURCE' undeclared
(first use in this function)
extensions/libipt_recent.c:156: error: dereferencing pointer to incomplete type
extensions/libipt_recent.c:156: error: `IPT_RECENT_DEST' undeclared
(first use in this function)
extensions/libipt_recent.c: In function `print':
extensions/libipt_recent.c:185: error: dereferencing pointer to incomplete type
extensions/libipt_recent.c:189: error: dereferencing pointer to incomplete type
extensions/libipt_recent.c:189: error: `IPT_RECENT_SET' undeclared
(first use in this function)
extensions/libipt_recent.c:190: error: dereferencing pointer to incomplete type
extensions/libipt_recent.c:190: error: `IPT_RECENT_CHECK' undeclared
(first use in this function)
extensions/libipt_recent.c:191: error: dereferencing pointer to incomplete type
extensions/libipt_recent.c:191: error: `IPT_RECENT_UPDATE' undeclared
(first use in this function)
extensions/libipt_recent.c:192: error: dereferencing pointer to incomplete type
extensions/libipt_recent.c:192: error: `IPT_RECENT_REMOVE' undeclared
(first use in this function)
extensions/libipt_recent.c:193: error: dereferencing pointer to incomplete type
extensions/libipt_recent.c:193: error: dereferencing pointer to incomplete type
extensions/libipt_recent.c:194: error: dereferencing pointer to incomplete type
extensions/libipt_recent.c:194: error: dereferencing pointer to incomplete type
extensions/libipt_recent.c:195: error: dereferencing pointer to incomplete type
extensions/libipt_recent.c:195: error: `IPT_RECENT_TTL' undeclared
(first use in this function)
extensions/libipt_recent.c:196: error: dereferencing pointer to incomplete type
extensions/libipt_recent.c:196: error: dereferencing pointer to incomplete type
extensions/libipt_recent.c:197: error: dereferencing pointer to incomplete type
extensions/libipt_recent.c:197: error: `IPT_RECENT_SOURCE' undeclared
(first use in this function)
extensions/libipt_recent.c:198: error: dereferencing pointer to incomplete type
extensions/libipt_recent.c:198: error: `IPT_RECENT_DEST' undeclared
(first use in this function)
extensions/libipt_recent.c: In function `save':
extensions/libipt_recent.c:207: error: dereferencing pointer to incomplete type
extensions/libipt_recent.c:210: error: dereferencing pointer to incomplete type
extensions/libipt_recent.c:210: error: `IPT_RECENT_SET' undeclared
(first use in this function)
extensions/libipt_recent.c:211: error: dereferencing pointer to incomplete type
extensions/libipt_recent.c:211: error: `IPT_RECENT_CHECK' undeclared
(first use in this function)
extensions/libipt_recent.c:212: error: dereferencing pointer to incomplete type
extensions/libipt_recent.c:212: error: `IPT_RECENT_UPDATE' undeclared
(first use in this function)
extensions/libipt_recent.c:213: error: dereferencing pointer to incomplete type
extensions/libipt_recent.c:213: error: `IPT_RECENT_REMOVE' undeclared
(first use in this function)
extensions/libipt_recent.c:214: error: dereferencing pointer to incomplete type
extensions/libipt_recent.c:214: error: dereferencing pointer to incomplete type
extensions/libipt_recent.c:215: error: dereferencing pointer to incomplete type
extensions/libipt_recent.c:215: error: dereferencing pointer to incomplete type
extensions/libipt_recent.c:216: error: dereferencing pointer to incomplete type
extensions/libipt_recent.c:216: error: `IPT_RECENT_TTL' undeclared
(first use in this function)
extensions/libipt_recent.c:217: error: dereferencing pointer to incomplete type
extensions/libipt_recent.c:217: error: dereferencing pointer to incomplete type
extensions/libipt_recent.c:218: error: dereferencing pointer to incomplete type
extensions/libipt_recent.c:218: error: `IPT_RECENT_SOURCE' undeclared
(first use in this function)
extensions/libipt_recent.c:219: error: dereferencing pointer to incomplete type
extensions/libipt_recent.c:219: error: `IPT_RECENT_DEST' undeclared
(first use in this function)
extensions/libipt_recent.c: At top level:
extensions/libipt_recent.c:227: error: invalid application of `sizeof'
to an incomplete type
extensions/libipt_recent.c:228: error: invalid application of `sizeof'
to an incomplete type
make: *** [extensions/libipt_recent_sh.o] Error 1
fearless:~/iptables-1.2.11> 

I am running on Gentoo Linux with a vanilla 2.6.7 kernel. I rebuilt
the bzImage and modules in preparation for building iptables 1.2.11
and they are in /usr/src/linux. Anyone have any ideas?

P.S. Sorry if you feel I've hijacked your thread, but I think I'm
pretty on-topic. If not, I can post again outside.

-- 
[ Tobias DiPasquale ]
0x636f6465736c696e67657240676d61696c2e636f6d
