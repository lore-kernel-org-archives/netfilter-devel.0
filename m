From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH 2/3][CTNETLINK] Atomically set/unset status bits
Date: Tue, 28 Nov 2006 23:31:09 +0100
Message-ID: <456CB8AD.8090809@trash.net>
References: <456C7606.4020504@netfilter.org> <456C806B.9060806@netfilter.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: Harald Welte <laforge@netfilter.org>,
	Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Pablo Neira Ayuso <pablo@netfilter.org>
In-Reply-To: <456C806B.9060806@netfilter.org>
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

Pablo Neira Ayuso wrote:
> [CTNETLINK] Atomically set/unset status bits
> 
> This patch guarantees that status bits are atomically set/unset. A minor
> cleanup to save one extra useless line in the code is introduced.
> 
> -	ct->status |= status & ~(IPS_NAT_DONE_MASK | IPS_NAT_MASK);
> +	d &= ~(IPS_NAT_DONE_MASK | IPS_NAT_MASK);
> +
> +	for (i = 0; i < sizeof(ct->status); i++)
> +		if (d & (1 << i)) {
> +			if (status & (1 << i))
> +				set_bit(i, &ct->status);
> +			else
> +				clear_bit(i, &ct->status);
> +		}
> +
>  	return 0;

We already hold the lock, what is the purpose of this change?

It also changes the API, so far bits can only be set. I wonder
where this comes from, I'm pretty sure my original code allowed
to unset specific bits and the checks at the top of that function
indicate that unsetting is possible as well.
