From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH] nfsim: Support more netfilter modules
Date: Thu, 15 Dec 2005 02:15:16 +0100
Message-ID: <43A0C3A4.1060703@trash.net>
References: <439ED1C5.7070103@ingate.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Harald Welte <laforge@netfilter.org>, netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Marcus Sundberg <marcus@ingate.com>
In-Reply-To: <439ED1C5.7070103@ingate.com>
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

Marcus Sundberg wrote:
> Hi,
> 
> this patch adds nfsim support for building most of the netfilter stuff
> in 2.6.15. The things still not compiling are CONFIG_IP_NF_CONNTRACK_NETLINK
> and CONFIG_IP_NF_MATCH_STRING

Looks good. Harald is currently working on nfsim so I'll leave
it to him to apply your patch.

> +/* div64.h */
> +
> +#if BITS_PER_LONG == 64
> +# define do_div(n,base) ({					\
> +	uint32_t __base = (base);				\
> +	uint32_t __rem;						\
> +	__rem = ((uint64_t)(n)) % __base;			\
> +	(n) = ((uint64_t)(n)) / __base;				\
> +	__rem;							\
> + })
> +#elif BITS_PER_LONG == 32

Just using the 64 bit version unconditionally is fine in userspace
and avoids the need for __div64_32.
