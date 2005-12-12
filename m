From: Evgeniy Polyakov <johnpol@2ka.mipt.ru>
Subject: Re: [1/1] OSF: netlink related changes.
Date: Mon, 12 Dec 2005 15:06:37 +0300
Message-ID: <20051212120637.GA16906@2ka.mipt.ru>
References: <20051209210220.GA28195@2ka.mipt.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Harald Welte <laforge@netfilter.org>, PatriK McHardy <kaber@trash.net>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
Content-Disposition: inline
In-Reply-To: <20051209210220.GA28195@2ka.mipt.ru>
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

> +#if LINUX_VERSION_CODE < KERNEL_VERSION(2,6,14)
>  	nts->netlink_kernel_create(NETLINK_NFLOG, NULL);
> +#else
> +	nts->netlink_kernel_create(NETLINK_NFLOG, 1, NULL, THIS_MODULE);
> +#endif

Crap.
It's totally my fault: MIME type was decoded incorrectly - "=" replaced
with "->" when I downloaded this file.

Thanks, Patrik, for resolving this.

-- 
	Evgeniy Polyakov
