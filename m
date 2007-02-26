From: Chuck Ebbert <cebbert@redhat.com>
Subject: Re: Soft lockup on shutdown in nf_ct_iterate_cleanup()
Date: Mon, 26 Feb 2007 12:14:26 -0500
Message-ID: <45E31572.4040108@redhat.com>
References: <45DB9C1F.1080605@redhat.com> <45DCEA47.5080100@redhat.com> <45E04468.7020001@trash.net> <45E06546.504@redhat.com> <45E1C7E0.9070102@trash.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org,
	linux-kernel <linux-kernel@vger.kernel.org>
To: Patrick McHardy <kaber@trash.net>
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1030347AbXBZROh@vger.kernel.org>
In-Reply-To: <45E1C7E0.9070102@trash.net>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

Patrick McHardy wrote:
> Chuck Ebbert wrote:
> 
> Can you try this patch please?
> ------------------------------------------------------------------------
> 
> [NETFILTER]: conntrack: fix {nf,ip}_ct_iterate_cleanup endless loops
> 

>  include/linux/netfilter_ipv4/ip_conntrack.h  |    5 ++--
>  include/net/netfilter/nf_conntrack.h         |    5 +++-
>  include/net/netfilter/nf_nat_rule.h          |    3 ++
>  net/ipv4/netfilter/ip_conntrack_core.c       |   30 ++++++++++++++++++------
>  net/ipv4/netfilter/ip_conntrack_standalone.c |    5 ++--
>  net/ipv4/netfilter/ip_nat_core.c             |    5 ++--
>  net/ipv4/netfilter/ipt_MASQUERADE.c          |    4 ++-
>  net/ipv4/netfilter/nf_nat_core.c             |    7 ++----
>  net/netfilter/nf_conntrack_core.c            |   33 ++++++++++++++++++++------
>  net/netfilter/nf_conntrack_proto.c           |    4 ++-
>  10 files changed, 69 insertions(+), 32 deletions(-)
> 

Changes to nf_nat_core.c, ip_nat_core.c and nf_conntrack_proto.c
do not apply, and nf_conntrack_core.c changes are already there.

This is vanilla 2.6.20; looks like there have been a bunch
of changes since then.  I tried adding all of the RCU patches
but even they won't apply.
