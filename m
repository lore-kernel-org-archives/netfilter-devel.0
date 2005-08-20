From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH] string match for iptables strike #2
Date: Sat, 20 Aug 2005 19:55:25 +0200
Message-ID: <43076E8D.2040004@trash.net>
References: <43076DB5.3080301@eurodev.net> <43076E0A.4060103@netfilter.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: Harald Welte <laforge@netfilter.org>,
	Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Pablo Neira <pablo@netfilter.org>
In-Reply-To: <43076E0A.4060103@netfilter.org>
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
> Pablo Neira wrote:
> 
>> Hi,
>>
>> Attached the iptables string match since the textsearch infrastructure
>> went into 2.6.13. It fixes the minor problem that Patrick has spotted
>> about the 64/32 bit environments.
> 
> Damn, bad patch, attached the correct one.

Thanks, looks good. I'm just about to leave, I'll test and apply it when
I get back.

> 
> +struct ipt_string_info
> +{
> +	u_int16_t from_offset;
> +	u_int16_t to_offset;
> +	char	  algo[IPT_STRING_MAX_ALGO_NAME_SIZE];
> +	char 	  pattern[IPT_STRING_MAX_PATTERN_SIZE];
> +	u_int8_t  patlen;
> +	u_int8_t  invert;
> +	struct ts_config __attribute__((aligned(8))) *config;
> +};
> +
> +#endif /*_IPT_STRING_H*/
