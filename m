From: Yasuyuki KOZAKAI <yasuyuki.kozakai@toshiba.co.jp>
Subject: Re: [PATCH] nf_conntrack: struct inet_opt now inet_sock
Date: Tue, 11 Jan 2005 17:01:09 +0900 (JST)
Message-ID: <200501110801.j0B81Ar0015639@toshiba.co.jp>
References: <20050107020136.GA26992@ti64.telemetry-investments.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org, yasuyuki.kozakai@toshiba.co.jp
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: brugolsky@telemetry-investments.com
In-Reply-To: <20050107020136.GA26992@ti64.telemetry-investments.com>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: </pipermail/netfilter-devel>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
Sender: netfilter-devel-bounces@lists.netfilter.org
Errors-To: netfilter-devel-bounces@lists.netfilter.org
List-Id: netfilter-devel.vger.kernel.org


Hi, Bill,

I'll apply your patch. Thanks a lot.

-----------------------------------------------------------------
Yasuyuki KOZAKAI @ USAGI Project <yasuyuki.kozakai@toshiba.co.jp>

From: "Bill Rugolsky Jr." <brugolsky@telemetry-investments.com>
Date: Thu, 6 Jan 2005 21:01:36 -0500

> Fixup use of struct inet_opt, which has been renamed to inet_sock in
> Linus's current tree.
> 
> Signed-off-by: Bill Rugolsky <brugolsky@telemetry-investments.com>
> 
> --- patch-o-matic-ng/nf_conntrack/linux-2.6/net/ipv6/netfilter/nf_conntrack_l3proto_ipv6.c.inet_sock	2004-11-24 10:19:38.000000000 -0500
> +++ patch-o-matic-ng/nf_conntrack/linux-2.6/net/ipv6/netfilter/nf_conntrack_l3proto_ipv6.c	2005-01-06 20:34:00.000000000 -0500
> @@ -386,7 +386,7 @@
>  static int
>  getorigdst(struct sock *sk, int optval, void *user, int *len)
>  {
> -	struct inet_opt *inet = inet_sk(sk);
> +	struct inet_sock *inet = inet_sk(sk);
>  	struct ipv6_pinfo *np = inet6_sk(sk);
>  	struct nf_conntrack_tuple_hash *h;
>  	struct nf_conntrack_tuple tuple;
> --- patch-o-matic-ng/nf_conntrack/linux-2.6/net/ipv4/netfilter/nf_conntrack_l3proto_ipv4.c.inet_sock	2004-12-27 13:39:18.000000000 -0500
> +++ patch-o-matic-ng/nf_conntrack/linux-2.6/net/ipv4/netfilter/nf_conntrack_l3proto_ipv4.c	2005-01-06 20:33:25.000000000 -0500
> @@ -334,7 +334,7 @@
>  static int
>  getorigdst(struct sock *sk, int optval, void __user *user, int *len)
>  {
> -	struct inet_opt *inet = inet_sk(sk);
> +	struct inet_sock *inet = inet_sk(sk);
>  	struct nf_conntrack_tuple_hash *h;
>  	struct nf_conntrack_tuple tuple;
>  	
> 
