From: Patrick McHardy <kaber@trash.net>
Subject: Re: [1/1] OSF: netlink related changes.
Date: Mon, 12 Dec 2005 08:20:22 +0100
Message-ID: <439D24B6.6080504@trash.net>
References: <20051209210220.GA28195@2ka.mipt.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Harald Welte <laforge@netfilter.org>, netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Evgeniy Polyakov <johnpol@2ka.mipt.ru>
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

Evgeniy Polyakov wrote:
> This patch has been done against just downloaded ipt_osf.c file from
> cvs.netfilter.org.
> I only read list archive and did not receive your feedback, sorry for
> not answering.

Well it still didn't apply. I finally fixed it up manually, but the
reason is that there is no such line "nts->netlink_kernel_create"
in SVN, and I don't see how this ever could have compiled, since
nts is a struct sock, which doesn't have a netlink_kernel_create
member. I also noticed that you're reusing NETLINK_NFLOG. You can't
do that. We can reserve a nfnetlink group if you need.

> +#if LINUX_VERSION_CODE < KERNEL_VERSION(2,6,14)
>  	nts->netlink_kernel_create(NETLINK_NFLOG, NULL);
> +#else
> +	nts->netlink_kernel_create(NETLINK_NFLOG, 1, NULL, THIS_MODULE);
> +#endif
>  	if (!nts) {
>  		log("netlink_kernel_create() failed\n");
>  	}
> 
> 
