From: Patrick McHardy <kaber@trash.net>
Subject: Re: [netfilter-core] [PATCH 2.6.7] ip_table_raw C99 initialization
Date: Thu, 17 Jun 2004 15:07:24 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <40D1978C.3040406@trash.net>
References: <20040616152818.157b28ca@dell_ss3.pdx.osdl.net> <20040616160921.2727a57c@dell_ss3.pdx.osdl.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Cc: coreteam@netfilter.org,  netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Stephen Hemminger <shemminger@osdl.org>
In-Reply-To: <20040616160921.2727a57c@dell_ss3.pdx.osdl.net>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

Stephen Hemminger wrote:
> Sparse didn't like the construct in iptables_raw
> 	{[NF_IP_XXX] 0,
> because it was an old GNU style initializer.
> So I bit the bullet and redid the initial_table as full C99.
> Builds okay, but please check it before applying.

Thanks Stephen, entry was missing from the ERROR part, I've fixed it
and will pass the patch on to Harald.

Regards
Patrick

> 
> Signed-off-by: Stephen Hemminger <shemminger@osdl.org>
> 
> diff -Nru a/net/ipv4/netfilter/iptable_raw.c b/net/ipv4/netfilter/iptable_raw.c
> --- a/net/ipv4/netfilter/iptable_raw.c	2004-06-16 16:05:40 -07:00
> +++ b/net/ipv4/netfilter/iptable_raw.c	2004-06-16 16:05:40 -07:00
> @@ -32,43 +32,60 @@
>  	struct ipt_replace repl;
>  	struct ipt_standard entries[2];
>  	struct ipt_error term;
> -} initial_table __initdata
> -= { { "raw", RAW_VALID_HOOKS, 3,
> -      sizeof(struct ipt_standard) * 2 + sizeof(struct ipt_error),
> -      { [NF_IP_PRE_ROUTING] 0,
> -	[NF_IP_LOCAL_OUT] sizeof(struct ipt_standard) },
> -      { [NF_IP_PRE_ROUTING] 0,
> -	[NF_IP_LOCAL_OUT] sizeof(struct ipt_standard) },
> -      0, NULL, { } },
> -    {
> -	    /* PRE_ROUTING */
> -	    { { { { 0 }, { 0 }, { 0 }, { 0 }, "", "", { 0 }, { 0 }, 0, 0, 0 },
> -		0,
> -		sizeof(struct ipt_entry),
> -		sizeof(struct ipt_standard),
> -		0, { 0, 0 }, { } },
> -	      { { { { IPT_ALIGN(sizeof(struct ipt_standard_target)), "" } }, { } },
> -		-NF_ACCEPT - 1 } },
> -	    /* LOCAL_OUT */
> -	    { { { { 0 }, { 0 }, { 0 }, { 0 }, "", "", { 0 }, { 0 }, 0, 0, 0 },
> -		0,
> -		sizeof(struct ipt_entry),
> -		sizeof(struct ipt_standard),
> -		0, { 0, 0 }, { } },
> -	      { { { { IPT_ALIGN(sizeof(struct ipt_standard_target)), "" } }, { } },
> -		-NF_ACCEPT - 1 } }
> -    },
> -    /* ERROR */
> -    { { { { 0 }, { 0 }, { 0 }, { 0 }, "", "", { 0 }, { 0 }, 0, 0, 0 },
> -	0,
> -	sizeof(struct ipt_entry),
> -	sizeof(struct ipt_error),
> -	0, { 0, 0 }, { } },
> -      { { { { IPT_ALIGN(sizeof(struct ipt_error_target)), IPT_ERROR_TARGET } },
> -	  { } },
> -	"ERROR"
> -      }
> -    }
> +} initial_table __initdata = {
> +	.repl = {
> +		.name = "raw", 
> +		.valid_hooks = RAW_VALID_HOOKS, 
> +		.num_entries = 3,
> +		.size = sizeof(struct ipt_standard) * 2 + sizeof(struct ipt_error),
> +		.hook_entry = { 
> +			[NF_IP_PRE_ROUTING] = 0,
> +			[NF_IP_LOCAL_OUT] = sizeof(struct ipt_standard) },
> +		.underflow = { 
> +			[NF_IP_PRE_ROUTING] = 0,
> +			[NF_IP_LOCAL_OUT]  = sizeof(struct ipt_standard) },
> +	},
> +	.entries = {
> +	     /* PRE_ROUTING */
> +	     { 
> +		     .entry = { 
> +			     .target_offset = sizeof(struct ipt_entry),
> +			     .next_offset = sizeof(struct ipt_standard),
> +		     },
> +		     .target = { 
> +			  .target = { 
> +				  .u.target_size = IPT_ALIGN(sizeof(struct ipt_standard_target)),
> +			  },
> +			  .verdict = -NF_ACCEPT - 1,
> +		     },
> +	     },
> +
> +	     /* LOCAL_OUT */
> +	     {
> +		     .entry = {
> +			     .target_offset = sizeof(struct ipt_entry),
> +			     .next_offset = sizeof(struct ipt_standard),
> +		     },
> +		     .target = {
> +			     .target = {
> +				     .u.target_size = IPT_ALIGN(sizeof(struct ipt_standard_target)),
> +			     },
> +			     .verdict = -NF_ACCEPT - 1,
> +		     },
> +	     },
> +	},
> +	/* ERROR */
> +	.term = { 
> +		.target = {
> +			.target = {
> +				.u.user = {
> +					.target_size = IPT_ALIGN(sizeof(struct ipt_error_target)), 
> +					.name = IPT_ERROR_TARGET,
> +				},
> +			},
> +			.errorname = "ERROR",
> +		},
> +	}
>  };
>  
>  static struct ipt_table packet_raw = { 
> 
