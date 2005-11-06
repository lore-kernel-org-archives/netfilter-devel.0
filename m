From: Pablo Neira <pablo@eurodev.net>
Subject: Re: Unable to handle kernel NULL pointer dereference at virtual
 address 00000000 after conntrack -I
Date: Sun, 06 Nov 2005 03:57:42 +0100
Message-ID: <436D7126.9050900@eurodev.net>
References: <Pine.LNX.4.63.0511031408370.32626@bizon.gios.gov.pl>
	<436A6B39.3080508@eurodev.net>
	<Pine.LNX.4.63.0511060103230.27498@bizon.gios.gov.pl>
	<Pine.LNX.4.63.0511060256410.29836@bizon.gios.gov.pl>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Krzysztof Oledzki <olenf@ans.pl>
In-Reply-To: <Pine.LNX.4.63.0511060256410.29836@bizon.gios.gov.pl>
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

Krzysztof Oledzki wrote:
> [NETFILTER] Check for ICMP_ID in icmp_nfattr_to_tuple
> 
> This patch fixes an userspace triggered oops. If there is no ICMP_ID
> info the reference to attr will be NULL.
> 
> Signed-out-by: Krzysztof Piotr Oledzki <ole@ans.pl>
> 
> --- a/net/ipv4/netfilter/ip_conntrack_proto_icmp.c    2005-11-06
> 02:17:29.000000000 +0100
> +++ b/net/ipv4/netfilter/ip_conntrack_proto_icmp.c    2005-11-06
> 02:18:45.000000000 +0100
> @@ -296,7 +296,8 @@
>                  struct ip_conntrack_tuple *tuple)
>  {
>      if (!tb[CTA_PROTO_ICMP_TYPE-1]
> -        || !tb[CTA_PROTO_ICMP_CODE-1])
> +        || !tb[CTA_PROTO_ICMP_CODE-1]
> +        || !tb[CTA_PROTO_ICMP_ID-1])
>          return -1;
> 
>      tuple->dst.u.icmp.type =
> 
> Anyway, libnetfilter_conntrack_icmp.c should also be fixed. Currently
> ICMP_ID is not addedd if TYPE is not 8 (ICMP ECHO). I beleve we should
> simply skip this check (libnetfilter_conntrack_icmp-icmpid.patch):

The patch looks fine. I'll pass this patch to Harald, I don't want to
get it lost.

> Index: extensions/libnetfilter_conntrack_icmp.c
> ===================================================================
> --- extensions/libnetfilter_conntrack_icmp.c    (revision 4480)
> +++ extensions/libnetfilter_conntrack_icmp.c    (working copy)
> @@ -38,10 +38,12 @@
>                 &t->l4dst.icmp.code, sizeof(u_int8_t));
>      nfnl_addattr_l(&req->nlh, size, CTA_PROTO_ICMP_TYPE,
>                 &t->l4dst.icmp.type, sizeof(u_int8_t));
> -    /* This is an ICMP echo */
> -    if (t->l4dst.icmp.type == 8)
> -        nfnl_addattr_l(&req->nlh, size, CTA_PROTO_ICMP_ID,
> -                   &t->l4src.icmp.id, sizeof(u_int16_t));
> +
> +    /* The ID only makes sense for type=8 (ECHO) but we always
> +     * want to set it or else kernel will reject such messages.
> +     */

I removed this comment, I inserted by myself and it's bogus. The ID
makes sense for *some* ICMP messages, not just for type=8.

> +    nfnl_addattr_l(&req->nlh, size, CTA_PROTO_ICMP_ID,
> +               &t->l4src.icmp.id, sizeof(u_int16_t));
>  }
> 

I'm going to apply it now. Thanks.

-- 
Pablo
