From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH 05/10] nf_nat: Use extension infrastructure
Date: Mon, 25 Jun 2007 12:08:35 +0200
Message-ID: <467F9423.3050503@trash.net>
References: <200706250315.l5P3F5vI009154@toshiba.co.jp>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: rusty@rustcorp.com.au, netfilter-devel@lists.netfilter.org,
	pablo@netfilter.org, kadlec@blackhole.kfki.hu
To: Yasuyuki KOZAKAI <yasuyuki.kozakai@toshiba.co.jp>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
In-Reply-To: <200706250315.l5P3F5vI009154@toshiba.co.jp>
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
> diff --git a/net/ipv4/netfilter/nf_nat_core.c b/net/ipv4/netfilter/nf_nat_core.c
> index ac7e8ab..1ce4969 100644
> --- a/net/ipv4/netfilter/nf_nat_core.c
> +++ b/net/ipv4/netfilter/nf_nat_core.c
> @@ -297,11 +297,22 @@ nf_nat_setup_info(struct nf_conn *ct,
>  		  unsigned int hooknum)
>  {
>  	struct nf_conntrack_tuple curr_tuple, new_tuple;
> -	struct nf_conn_nat *nat = nfct_nat(ct);
> -	struct nf_nat_info *info = &nat->info;
> +	struct nf_conn_nat *nat;
> +	struct nf_nat_info *info;
>  	int have_to_hash = !(ct->status & IPS_NAT_DONE_MASK);
>  	enum nf_nat_manip_type maniptype = HOOK2MANIP(hooknum);
>  
> +	/* nat helper or nfctnetlink also setup binding */
> +	nat = nfct_nat(ct);
> +	if (!nat) {
> +		nat = nf_ct_ext_add(ct, NF_CT_EXT_NAT, GFP_ATOMIC);
> +		if (unlikely(nat == NULL)) {


gcc assumes unlikely for ptr == NULL by default.

> +			DEBUGP("failed to add NAT extension\n");
> +			return NF_ACCEPT;
> +		}
> +	}
> +	info = &nat->info;
> +
>  	NF_CT_ASSERT(hooknum == NF_IP_PRE_ROUTING ||
>  		     hooknum == NF_IP_POST_ROUTING ||
>  		     hooknum == NF_IP_LOCAL_IN ||
> @@ -592,17 +603,53 @@ nf_nat_port_nfattr_to_range(struct nfattr *tb[], struct nf_nat_range *range)
>  EXPORT_SYMBOL_GPL(nf_nat_port_range_to_nfattr);
>  #endif
>  
> +static void nf_nat_move_storage(struct nf_conn *conntrack, void *old)
> +{
> +	struct nf_conn_nat *new_nat = nf_ct_ext_find(conntrack, NF_CT_EXT_NAT);
> +	struct nf_conn_nat *old_nat = (struct nf_conn_nat *)old;
> +	struct nf_conn *ct = old_nat->info.ct;
> +	unsigned int srchash;
> +
> +	if (!ct || !(ct->status & IPS_NAT_DONE_MASK))
> +		return;


Is !ct really possible? Looks like something that should be catched
on a higher level if it really is.

> +
> +	srchash = hash_by_src(&ct->tuplehash[IP_CT_DIR_ORIGINAL].tuple);
> +
> +	write_lock_bh(&nf_nat_lock);
> +	list_del(&old_nat->info.bysource);
> +	new_nat->info.ct = ct;
> +	list_add(&new_nat->info.bysource, &bysource[srchash]);

list_replace maybe?
