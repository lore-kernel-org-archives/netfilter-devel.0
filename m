From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH] fix nf_conntrack_netlink expectation dumping/event
	notification
Date: Fri, 13 Jan 2006 12:17:16 +0100
Message-ID: <43C78C3C.6080707@netfilter.org>
References: <43C76BA7.9080204@trash.net>	<200601130902.k0D92fVM026246@toshiba.co.jp>	<43C76D22.8050805@trash.net>
	<200601130938.k0D9c6ud007984@toshiba.co.jp>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org, kaber@trash.net
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Yasuyuki KOZAKAI <yasuyuki.kozakai@toshiba.co.jp>
In-Reply-To: <200601130938.k0D9c6ud007984@toshiba.co.jp>
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
> diff --git a/net/netfilter/nf_conntrack_core.c b/net/netfilter/nf_conntrack_core.c
> index 62bb509..9a147dd 100644
> --- a/net/netfilter/nf_conntrack_core.c
> +++ b/net/netfilter/nf_conntrack_core.c
> @@ -188,7 +188,7 @@ extern struct nf_conntrack_protocol nf_c
>  struct nf_conntrack_protocol *
>  __nf_ct_proto_find(u_int16_t l3proto, u_int8_t protocol)
>  {
> -	if (unlikely(nf_ct_protos[l3proto] == NULL))
> +	if (unlikely(l3proto > AF_MAX || nf_ct_protos[l3proto] == NULL))

Could the unlikely statement be bad at expectation dumping?

cheers,
Pablo

-- 
The dawn of the fourth age of Linux firewalling is coming; a time of
great struggle and heroic deeds -- J.Kadlecsik got inspired by J.Morris
