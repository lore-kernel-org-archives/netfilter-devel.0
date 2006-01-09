From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH] x_tables, take 5 (Final Review)
Date: Mon, 09 Jan 2006 07:46:44 +0100
Message-ID: <43C206D4.6070207@trash.net>
References: <20060108212619.GE24266@sunbeam.de.gnumonks.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Harald Welte <laforge@netfilter.org>
In-Reply-To: <20060108212619.GE24266@sunbeam.de.gnumonks.org>
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

Harald Welte wrote:
> diff --git a/net/netfilter/xt_helper.c b/net/netfilter/xt_helper.c
> new file mode 100644
> index 0000000..9a19da2
> --- /dev/null
> +++ b/net/netfilter/xt_helper.c
> +static int __init init(void)
> +{
> +	int ret;
> +	need_conntrack();
> +
> +	ret = xt_register_match(AF_INET, &helper_match);
> +	ret = xt_register_match(AF_INET6, &helper6_match);
> +}
> +

This function is missing a return. I also just noticed its not
in the Makefile and has a typo: MODULE_ALIASS("ipt_helper");
