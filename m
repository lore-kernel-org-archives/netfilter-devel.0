From: Yasuyuki KOZAKAI <yasuyuki.kozakai@toshiba.co.jp>
Subject: Re: [PATCH] Make hashsize ip_conntrack parameter writable
Date: Fri, 07 Oct 2005 21:27:52 +0900 (JST)
Message-ID: <200510071227.j97CRrkG027930@toshiba.co.jp>
References: <1128536584.9868.1.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: laforge@netfilter.org, netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: rusty@rustcorp.com.au
In-Reply-To: <1128536584.9868.1.camel@localhost.localdomain>
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


From: Rusty Russell <rusty@rustcorp.com.au>
Date: Thu, 06 Oct 2005 04:23:03 +1000

> +static u_int32_t
> +hash_conntrack(const struct ip_conntrack_tuple *tuple)
> +{
> +	return __hash_conntrack(tuple, ip_conntrack_htable_size);
>  }

Why don't we use inline ?

-----------------------------------------------------------------
Yasuyuki Kozakai @ USAGI Project <yasuyuki.kozakai@toshiba.co.jp>
