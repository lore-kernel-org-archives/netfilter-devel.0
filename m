From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH 1/2] string match for iptables
Date: Sat, 20 Aug 2005 18:35:54 +0200
Message-ID: <43075BEA.1030701@trash.net>
References: <43075517.3070405@eurodev.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: Harald Welte <laforge@netfilter.org>,
	Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Pablo Neira <pablo@eurodev.net>
In-Reply-To: <43075517.3070405@eurodev.net>
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

Pablo Neira wrote:
> Here comes the iptables string match since the textsearch infrastructure
> went into 2.6.13. This adds to iptables the ability of looking for given
> patterns in packets. I'll be happy to see this stuff in Davem's 2.6.14
> tree ;)

> +struct ipt_string_info
> +{
> +	u_int16_t		from_offset;
> +	u_int16_t		to_offset;
> +	char			algo[IPT_STRING_MAX_ALGO_NAME_SIZE];
> +	char			pattern[IPT_STRING_MAX_PATTERN_SIZE];
> +	u_int8_t		patlen;
> +	u_int8_t		invert;
> +	struct ts_config	*config;
> +};

Embedding a pointer in the struct causes different alignment depending
on the wordsize and doesn't work in mixed 64/32 bit environments.
Please use __attribute__((aligned(8))) to prevent this.

Otherwise, it looks good.
