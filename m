From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH NF_CONNTRACK 8/9]: zero-clear union area in tuple for
 expectant
Date: Sat, 11 Jun 2005 17:36:44 +0200
Message-ID: <42AB050C.40105@trash.net>
References: <200505230623.j4N6NMVu004917@toshiba.co.jp>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Yasuyuki KOZAKAI <yasuyuki.kozakai@toshiba.co.jp>
In-Reply-To: <200505230623.j4N6NMVu004917@toshiba.co.jp>
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

Yasuyuki KOZAKAI wrote:
> This patch clears union area in tuple for expectant.

Why is this necessary? The helpers should initialize tuple and mask.

Regards
Patrick

> diff -Nur linux-2.6.12-rc4-nfct-7-nat-seq/net/netfilter/nf_conntrack_core.c linux-2.6.12-rc4-nfct-8-expect/net/netfilter/nf_conntrack_core.c
> --- linux-2.6.12-rc4-nfct-7-nat-seq/net/netfilter/nf_conntrack_core.c	2005-05-20 03:18:29.000000000 +0900
> +++ linux-2.6.12-rc4-nfct-8-expect/net/netfilter/nf_conntrack_core.c	2005-05-20 03:16:23.000000000 +0900
> @@ -987,6 +987,8 @@
>  		DEBUGP("expect_related: OOM allocating expect\n");
>  		return NULL;
>  	}
> +	NF_CT_TUPLE_U_BLANK(&new->tuple);
> +	NF_CT_TUPLE_U_BLANK(&new->mask);
>  	new->master = NULL;
>  	return new;
>  }
