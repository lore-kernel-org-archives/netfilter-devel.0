From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH 08/10] nf_nat: Kills global 'destroy' operation
Date: Mon, 25 Jun 2007 20:24:16 +0200
Message-ID: <46800850.2020708@trash.net>
References: <200706251722.l5PHMPun023690@toshiba.co.jp>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
To: Yasuyuki KOZAKAI <yasuyuki.kozakai@toshiba.co.jp>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
In-Reply-To: <200706251722.l5PHMPun023690@toshiba.co.jp>
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
> This kills the global 'destroy' operation which was used by NAT.
> Instead it uses the extension infrastructure so that multiple
> extensions can register own operations.


Applied, very nice :)

>  
> +/* Noone using conntrack by the time this called. */
> +static void nf_nat_cleanup_conntrack(struct nf_conn *ct)
> +{
> +	struct nf_conn_nat *nat = nf_ct_ext_find(ct, NF_CT_EXT_NAT);
> +
> +	if (nat == NULL || nat->info.ct == NULL)
> +		return;


These conditions would actually be BUG()s, right?

> +
> +	NF_CT_ASSERT(nat->info.ct->status & IPS_NAT_DONE_MASK);
> +
> +	write_lock_bh(&nf_nat_lock);
> +	list_del(&nat->info.bysource);
> +	nat->info.ct = NULL;
> +	write_unlock_bh(&nf_nat_lock);
> +}
> +
