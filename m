From: Willy Tarreau <willy@w.ods.org>
Subject: Re: [PATCH] patch-o-matic fixes
Date: Wed, 30 Apr 2003 18:28:35 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20030430162835.GA4546@alpha.home.local>
References: <20030430085332.GA32392@alpha.home.local> <20030430153222.GC685@sunbeam.de.gnumonks.org> <1051717921.8200.151.camel@tux.rsn.bth.se>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Harald Welte <laforge@netfilter.org>, Willy Tarreau <willy@w.ods.org>,
   Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Martin Josefsson <gandalf@wlug.westbo.se>
Content-Disposition: inline
In-Reply-To: <1051717921.8200.151.camel@tux.rsn.bth.se>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

Hello Martin,

On Wed, Apr 30, 2003 at 05:52:01PM +0200, Martin Josefsson wrote:
 
> It does apply IF you've applied pending/24_conntrack-nosysctl.patch
> Which should have been done. We've had implicit dependencies on
> submitted and pending stuff many times.

That's not my case, I disabled 24_conntrack-nosysctl because of the dependancy.
Unless I have a broken tree, or a conflict is induced by other patches,
I'm certain that tcp_window_tracking on top of 2.4.21-bk doesn't apply
cleanly. Here's what I have (in fact, what 'runme' sees) :

                 submitted/01_2.4.19
                 submitted/02_2.4.20
                 submitted/03_ip_conntrack_proto_tcp-lockfix
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
                 submitted/14_ip6t_ext_hdr-ipv6
                 submitted/15_ahesp6-ipv6
                 submitted/16_frag6-ipv6
                 submitted/17_ipv6header-ipv6
                 submitted/18_opts6-ipv6
                 submitted/19_route6-ipv6
                 submitted/21_tftp-conntrack-nat
                 submitted/22_amanda-conntrack-nat
                 submitted/23_REJECT-headroom-tcprst
                 submitted/24_conntrack-modify-after-free-fix
                 submitted/25_ip_tables-comment-fix
                 submitted/26_ipt_unclean-ubit
                 submitted/27_no_version
                 submitted/28_compat_code_removal
                 submitted/29_mangle-bogus_cast-ipv6
                 submitted/30_ip6_route_me_harder-ipv6
                 submitted/ipt_ULOG-mac_len-fix
                 submitted/ipt_multiport-invfix
                 pending/06_early_drop-backwards
                 pending/20_iptables-proc
                 pending/25_natcore-nohelper
                 pending/26_morethan32cpufix
                 pending/27_include-nfc-order
                 pending/unused_var
                 base/HL-ipv6
                 base/IPV4OPTSSTRIP
                 base/NETLINK
                 base/NETMAP
                 base/REJECT-ipv6
                 base/SAME
                 base/TTL
                 base/condition
                 base/condition6-ipv6
                 base/fuzzy
                 base/fuzzy6-ipv6
                 base/iplimit
                 base/ipv4options
                 base/mport
                 base/nth
                 base/pool
                 base/psd
                 base/quota
                 base/random
                 base/realm
                 base/time
		 base/u32
                 extra/CLASSIFY
                 extra/CONNMARK
                 extra/ROUTE
                 extra/cuseeme-nat
                 extra/eggdrop-conntrack
                 extra/h323-conntrack-nat
                 extra/ip6_tables-proc-ipv6
                 extra/ipt_TARPIT
                 extra/mms-conntrack-nat
                 extra/nfnetlink-ctnetlink-0.11
                 extra/owner-socketlookup
                 extra/ownercmd-ipv6
                 extra/pptp-conntrack-nat
                 extra/quake3-conntrack
                 extra/recent
                 extra/rpc
                 extra/rsh
                 extra/string
                 extra/talk-conntrack-nat
                 extra/tcp-window-tracking

And those I exclude because of too complicated rejects, or incompatibilities :

		pending/12_conntrack_nat_dependancy
		pending/24_conntrack-nosysctl
		extra/ip_conntrack-timeouts

> No need to make a cumulative -rc1 patch, I've managed to get it working
> for .18 .19 .20 .21-rc1 and .21-bk

Ok, thanks for the info, I'll retry on a fresh kernel when I have time, and without
all other patches.

Regards,
Willy
