From: Harald Welte <laforge@gnumonks.org>
Subject: Re: [CRAP] Some patches
Date: Fri, 5 Jul 2002 16:08:10 +0200
Sender: netfilter-devel-admin@lists.samba.org
Message-ID: <20020705140810.GI21280@naboo.ists.dartmouth.edu>
References: <20020616200239.GI23720@stingr.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <netfilter-devel-admin@lists.samba.org>
To: netfilter-devel@lists.samba.org
Content-Disposition: inline
In-Reply-To: <20020616200239.GI23720@stingr.net>
Errors-To: netfilter-devel-admin@lists.samba.org
List-Help: <mailto:netfilter-devel-request@lists.samba.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.samba.org>
List-Subscribe: <http://lists.samba.org/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.samba.org?subject=subscribe>
List-Unsubscribe: <http://lists.samba.org/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.samba.org?subject=unsubscribe>
List-Archive: <http://lists.samba.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

On Mon, Jun 17, 2002 at 12:02:39AM +0400, Paul P Komkoff Jr wrote:
> This is the result of make allyesconfig
> 
> Actually, make allyesconfig won't link vmlinux due to netfilter p-o-m
> additions. While conntrack_egg part isn't very clean (I'll resend
> cleaner version later), and conntrack_rpc bombing out the kernel to panic,
> and needs a big rewrite just because _tcp and _udp files ARE just a
> copy&paste results (Harald, so please move it to b0rken suite for now).

ok, I'll move conntrack_rpc.

> But ipv6 stuff seems awful :( it just duplicating one function already
> present in ipv6 code :( and doing it without static keyword ...

I think kisza has dealt with this..

> diff -Nur --exclude=SCCS --exclude=BitKeeper --exclude=ChangeSet a/net/ipv4/netfilter/ip_conntrack_egg.c linux-2.4.19-pre10-ac2-s3/net/ipv4/netfilter/ip_conntrack_egg.c

ok, applied this one...

> diff -Nur --exclude=SCCS --exclude=BitKeeper --exclude=ChangeSet a/net/ipv4/netfilter/ipt_ah.c linux-2.4.19-pre10-ac2-s3/net/ipv4/netfilter/ipt_ah.c
> --- a/net/ipv4/netfilter/ipt_ah.c	Sat Jun 15 12:51:20 2002
> +++ linux-2.4.19-pre10-ac2-s3/net/ipv4/netfilter/ipt_ah.c	Fri Jun 14 12:31:05 2002
> @@ -91,12 +91,12 @@
>  static struct ipt_match ah_match
>  = { { NULL, NULL }, "ah", &match, &checkentry, NULL, THIS_MODULE };
>  
> -int __init init(void)
> +static int __init init(void)
>  {
>  	return ipt_register_match(&ah_match);
>  }
>  
> -void __exit cleanup(void)
> +static void __exit cleanup(void)
>  {
>  	ipt_unregister_match(&ah_match);
>  }

this one is now pending for kernel inclusion... (though it will be
post-2.4.19)

> Paul P 'Stingray' Komkoff 'Greatest' Jr /// (icq)23200764 /// (http)stingr.net

-- 
Live long and prosper
- Harald Welte / laforge@gnumonks.org               http://www.gnumonks.org/
============================================================================
GCS/E/IT d- s-: a-- C+++ UL++++$ P+++ L++++$ E--- W- N++ o? K- w--- O- M- 
V-- PS+ PE-- Y+ PGP++ t++ 5-- !X !R tv-- b+++ DI? !D G+ e* h+ r% y+(*)
