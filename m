From: "David S. Miller" <davem@davemloft.net>
Subject: Re: [PATCH 1/2] New ipt_TTL target
Date: Fri, 26 Aug 2005 12:30:18 -0700 (PDT)
Message-ID: <20050826.123018.21840974.davem@davemloft.net>
References: <20050826183151.GD4226@rama.de.gnumonks.org>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: laforge@netfilter.org
In-Reply-To: <20050826183151.GD4226@rama.de.gnumonks.org>
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

From: Harald Welte <laforge@netfilter.org>
Date: Fri, 26 Aug 2005 20:31:51 +0200

> +config IP_NF_TARGET_TTL_INC
> +	bool  'TTL incrementing support (DANGEROUS)'
> +	depends on IP_NF_TARGET_TTL
> +	help
> +	  This option enables functionality to increment and set the TTL
> +	  value of the IP header to arbitrary values.  This is EXTREMELY
> +	  DANGEROUS since you can easily create immortal packets that loop
> +	  forever on the network.  Please only enable if you really know
> +	  that you will need it.
> +

I think it's best to kill this option.  Just put the "this is
DANGEROUS" comment into the help text for IP_NF_TARGET_TTL, ok?

Similarly for the ipv6 hoplimit target too.

Thanks.
