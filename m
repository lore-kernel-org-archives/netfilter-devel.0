From: "Peter Olsson" <aa@tbh.se>
Subject: Re: Kernel Oops with kernel 2.4.25 and iptables 1.2.9 in __unexpect_related
Date: Tue, 15 Jun 2004 22:11:25 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <008901c45314$efb3dd10$7c01a8c0@std.visionutv.se>
References: <002401c452ac$06523580$7c01a8c0@std.visionutv.se> <40CEB3DA.5070401@trash.net> <004d01c45300$768a0a40$7c01a8c0@std.visionutv.se> <40CF3A95.7060302@trash.net>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Cc: <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: "Patrick McHardy" <kaber@trash.net>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

I looked through all applied patches from pom, and it's the list below. The
kernel I'm using now is 2.4.25, and that's the one I was using when it
crashed, I applied these patches sometime in february and it was from
pom-20031219. I guess some of these patches actually were applied in the
2.4.25 kernel source.

                 submitted/61-remove-memsets
                 submitted/64_masquerade-sameip-noflush
                 submitted/69_amanda-helpers
                 submitted/70_expect-evict-order
                 submitted/72_recent_procfs_fix
                 submitted/74_listhelp
                 submitted/75_selective_cleanup
                 submitted/76_conntrack_bucket_sysctl
                 submitted/88_ip_queue-maxlen
                 submitted/90_fw_compat_local-nullbinding
                 pending/40_nf-log
                 pending/40_nf-log-ipv6
                 pending/59_ip_nat_h-unused-var
                 pending/60_ecn_raw_unclone
                 base/HL-ipv6
                 base/iprange
                 base/mport
                 base/NETLINK
                 base/REJECT-ipv6
                 base/SAME
                 base/time
                 base/TTL
                 extra/CLASSIFY
                 extra/CONNMARK
                 extra/cuseeme-nat
                 extra/IPMARK
                 extra/mms-conntrack-nat
                 extra/netfilter-docbook
                 extra/pptp-conntrack-nat
                 extra/rpc
                 extra/rsh
                 extra/string

Regards,

Peter

----- Original Message ----- 
From: "Patrick McHardy" <kaber@trash.net>
To: "Peter Olsson" <aa@tbh.se>
Cc: <netfilter-devel@lists.netfilter.org>
Sent: Tuesday, June 15, 2004 8:06 PM
Subject: Re: Kernel Oops with kernel 2.4.25 and iptables 1.2.9 in
__unexpect_related


> Peter Olsson wrote:
> > Hi Patrick,
> >
> > I meant kernel 2.4.17, not 2.4.27 :)
> >
> > About other patches... I've applied a couple of other patch-o-matic
patches,
> > but pptp_conntrack_nat
> > is the only one that seem to call anything related to the
__unexpect_related
> > function. I've only applied
> > patches that were tested ok, not the experimental ones. The
> > "__unexpect_related" has the following
> > code in my version of ip_conntrack_core.c.
>
> Well, there is at least one that won't work with pptp_conntrack_nat
> (expect-optimize), so it would really help to see a list. When did
> you patch your kernel with pom (roughly) ? You also didn't mention
> which kernel version you ran when it crashed.
>
> Regards
> Patrick
>
>
>
>
