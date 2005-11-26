From: Patrick McHardy <kaber@trash.net>
Subject: Re: [RESEND] [1/1] OSF: netlink related changes.
Date: Sun, 27 Nov 2005 00:49:30 +0100
Message-ID: <4388F48A.40708@trash.net>
References: <20051125095526.GA26050@2ka.mipt.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Harald Welte <laforge@netfilter.org>, netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Evgeniy Polyakov <johnpol@2ka.mipt.ru>
In-Reply-To: <20051125095526.GA26050@2ka.mipt.ru>
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
> Hello, developers.
> Due to new interface and changed API in netlink area
> several patch-o-matic modules can not be compiled.
> Passive OS fingerprinting OSF modules is one of them. 

> @@ -821,7 +826,11 @@
>  	p->write_proc->osf_proc_write;
>  	p->read_proc->osf_proc_read;
> 
> +#if LINUX_VERSION_CODE < KERNEL_VERSION(2,6,14)
>  	nts->netlink_kernel_create(NETLINK_NFLOG, NULL);
> +#else
> +	nts->netlink_kernel_create(NETLINK_NFLOG, 1, NULL, THIS_MODULE);
> +#endif

This doesn't exist in svn and also doesn't seem to make much
sense. Why use function pointers for netlink_kernel_create?
