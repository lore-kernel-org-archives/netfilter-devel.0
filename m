From: Yasuyuki KOZAKAI <yasuyuki.kozakai@toshiba.co.jp>
Subject: Re: [PATCH] Conntrack targets/matches work with nfconntrack
Date: Fri, 08 Apr 2005 17:09:24 +0900 (JST)
Message-ID: <200504080809.j3889P1Y001851@toshiba.co.jp>
References: <424F0DD6.9070002@eurodev.net>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: laforge@netfilter.org, netfilter-devel@lists.netfilter.org, kaber@trash.net,
	yasuyuki.kozakai@toshiba.co.jp
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: pablo@eurodev.net
In-Reply-To: <424F0DD6.9070002@eurodev.net>
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


Hi,

From: Pablo Neira <pablo@eurodev.net>
Date: Sat, 02 Apr 2005 23:25:42 +0200

> Hi,
> 
> This patch makes work conntrack related matches and targets with both 
> ip_conntrack and nf_conntrack (ipt_state, ipt_CONNMARK, ipt_connmark, 
> ipt_NOTRACK, ipt_conntrack). Two comments about this:
> 
> o I've slighty modified the ip_conntrack structure to make it look like 
> nf_conntrack.
> 
> -               u_int32_t ip;
> +               union {
> +                       u_int32_t ip;
> +               } u3;
> 
> o This patch adds some ifdef's. I understand that this isn't the more 
> elegant way to do this but it's rather straight forward. I think that 
> this solution is not that bad since ip_conntrack will dissapear some day 
> together with those ifdef's.

This causes compatibility problem (at least, libipt_conntrack.c of iptables).
Then this patch is acceptable for me if we can easily fix it.

P.S. This is one reason why I try not to change ip_contrack as possible.

Regards,

-----------------------------------------------------------------
Yasuyuki KOZAKAI @ USAGI Project <yasuyuki.kozakai@toshiba.co.jp>
