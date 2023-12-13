Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:237:300::1])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6F509DC
	for <netfilter-devel@vger.kernel.org>; Wed, 13 Dec 2023 12:20:38 -0800 (PST)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
	(envelope-from <fw@strlen.de>)
	id 1rDVid-00031C-Nm; Wed, 13 Dec 2023 21:20:35 +0100
Date: Wed, 13 Dec 2023 21:20:35 +0100
From: Florian Westphal <fw@strlen.de>
To: Phil Sutter <phil@nwl.cc>
Cc: Florian Westphal <fw@strlen.de>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	netfilter-devel@vger.kernel.org
Subject: Re: [libnftnl RFC 2/2] expr: Introduce struct expr_ops::attr_policy
Message-ID: <20231213202035.GA6601@breakpoint.cc>
References: <20231213190222.3681-1-phil@nwl.cc>
 <20231213190222.3681-2-phil@nwl.cc>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20231213190222.3681-2-phil@nwl.cc>
User-Agent: Mutt/1.10.1 (2018-07-13)

Phil Sutter <phil@nwl.cc> wrote:
> Similar to kernel's nla_policy, enable expressions to inform about
> restrictions on attribute use. This allows the generic expression code
> to perform sanity checks before dispatching to expression ops.
> 
> For now, this holds only the maximum data len which may be passed to
> nftnl_expr_set().
> 
> Signed-off-by: Phil Sutter <phil@nwl.cc>
> ---
>  include/expr_ops.h   |  5 +++++
>  src/expr.c           |  6 ++++++
>  src/expr/bitwise.c   | 11 +++++++++++
>  src/expr/byteorder.c |  9 +++++++++
>  src/expr/immediate.c |  9 +++++++++
>  5 files changed, 40 insertions(+)
> 
> diff --git a/include/expr_ops.h b/include/expr_ops.h
> index 51b221483552c..6c95297bfcd58 100644
> --- a/include/expr_ops.h
> +++ b/include/expr_ops.h
> @@ -8,10 +8,15 @@ struct nlattr;
>  struct nlmsghdr;
>  struct nftnl_expr;
>  
> +struct attr_policy {
> +	size_t maxlen;

I'd make this an uint32_t since that is also whats
passed to expr_set().

> +		if (expr->ops->attr_policy &&
> +		    type <= expr->ops->nftnl_max_attr &&
> +		    expr->ops->attr_policy[type].maxlen &&
> +		    expr->ops->attr_policy[type].maxlen < data_len)
> +			return -1;
> +

I'd make this more strict, is there a reason to call ops->set
if type > ->nftnl_max_attr?

Something like:

!attr_policy -> return -1;
type > nftnl_max_attr -> return -1:
data_len > maxlen -> return -1.

We could also define a minlen to disallow setting
e.g. 1 byte of something that is internally an u32.

But I admit that this might break compatibility
or otherwise leak internals into the api.
