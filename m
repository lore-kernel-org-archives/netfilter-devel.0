From: "David S. Miller" <davem@davemloft.net>
Subject: Re: [PATCH 3/11] Netfilter:  Fix Up IRC, AMANDA, TFTP and SNMP
 Helpers
Date: Mon, 17 Jan 2005 14:22:43 -0800
Message-ID: <20050117142243.694a9442.davem@davemloft.net>
References: <1105940716.3954.25.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Rusty Russell <rusty@rustcorp.com.au>
In-Reply-To: <1105940716.3954.25.camel@localhost.localdomain>
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

On Mon, 17 Jan 2005 16:45:16 +1100
Rusty Russell <rusty@rustcorp.com.au> wrote:

> Name: Fix Up IRC, AMANDA, TFTP and SNMP Helpers
> Status: Compiled on 2.6.10-rc2-bk6
> Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
> 
> Fixes up the other helpers for direct conntrack->NAT helper calling.
> SNMP doesn't really need a conntrack helper, but under this new model,
> the NAT helper will register at that point anyway: NAT helpers
> themselves are removed.

I think you did a bit of an overzealous search and
replace on this patch :-)  Check out this hunk:

> @@ -43,6 +43,14 @@
>  static char irc_buffer[65536];
>  static DECLARE_LOCK(irc_buffer_lock);
>  
> +unsigned int (*ip_nat_irc_hook)(struct sk_buff **pskb,
> +				struct ip_conntrack *ct,
> +				enum ip_conntrack_info ctinfo,
> +				unsigned int matchoff,
> +				unsigned int matchlen,
> +				struct ip_conntrack_expect *exp);
> +EXPORT_SYMBOL_GPL(ip_nat_irc_hook);
> +
>  MODULE_AUTHOR("Harald Welte <davem@davemloft.net>");
>  MODULE_DESCRIPTION("IRC (DCC) connection tracking helper");
>  MODULE_LICENSE("GPL");

Your search and replace mangled Harald's email address
into mine.

Anyways, I fixed this up while applying so don't worry
about it.
