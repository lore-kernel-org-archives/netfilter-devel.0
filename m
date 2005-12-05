From: Pablo Neira Ayuso <pablo@eurodev.net>
Subject: Re: [NETFILTER 6/9]: Mark ctnetlink as EXPERIMENTAL
Date: Mon, 05 Dec 2005 11:06:45 +0100
Message-ID: <43941135.2060300@eurodev.net>
References: <20051204210116.24032.9802.sendpatchset@localhost.localdomain>
	<20051204210123.24032.2569.sendpatchset@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org, "David S.Miller" <davem@davemloft.net>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Patrick McHardy <kaber@trash.net>
In-Reply-To: <20051204210123.24032.2569.sendpatchset@localhost.localdomain>
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

Hi Patrick,

Patrick McHardy wrote:
> [NETFILTER]: Mark ctnetlink as EXPERIMENTAL
> 
> Should have been marked EXPERIMENTAL from the beginning, as the current
> bunch of fixes show.
> 
> diff --git a/net/ipv4/netfilter/Kconfig b/net/ipv4/netfilter/Kconfig
> index 0bc0052..88a6065 100644
> --- a/net/ipv4/netfilter/Kconfig
> +++ b/net/ipv4/netfilter/Kconfig
> @@ -56,8 +56,8 @@ config IP_NF_CONNTRACK_MARK
>  	  instead of the individual packets.
>  	
>  config IP_NF_CONNTRACK_EVENTS
> -	bool "Connection tracking events"
> -	depends on IP_NF_CONNTRACK
> +	bool "Connection tracking events (EXPERIMENTAL)"
> +	depends on EXPERIMENTAL && IP_NF_CONNTRACK

The patch is imcomplete, NF_CONNTRACK_EVENTS must be set as EXPERIMENTAL
as well (see net/netfilter/Kconfig).

-- 
Pablo
