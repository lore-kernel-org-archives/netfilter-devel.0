From: Pablo Neira <pablo@netfilter.org>
Subject: Re: [PATCH 3/3] CLUSTERIP: use a bitmap to store node responsibility
 data
Date: Tue, 30 Aug 2005 15:29:31 +0200
Message-ID: <43145F3B.4050706@netfilter.org>
References: <20050830121535.985929000@nienna.balabit>
	<20050830121550.543376000@nienna.balabit>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Harald Welte <laforge@netfilter.org>, netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: KOVACS Krisztian <hidden@balabit.hu>
In-Reply-To: <20050830121550.543376000@nienna.balabit>
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

Hi Krisztian,

KOVACS Krisztian wrote:
> @@ -55,8 +56,7 @@
>  	u_int8_t clustermac[ETH_ALEN];		/* the MAC address */
>  	struct net_device *dev;			/* device */
>  	u_int16_t num_total_nodes;		/* total number of nodes */
> -	u_int16_t num_local_nodes;		/* number of local nodes */
> -	u_int16_t local_nodes[CLUSTERIP_MAX_NODES];	/* node number array */
> +	unsigned long local_nodes;		/* node number array */

I'm afraid that this breaks backward compatibility. Although CLUSTERIP 
is marked as experimental.

@Harald: Should we respect backward compatibility in this case?

--
Pablo
