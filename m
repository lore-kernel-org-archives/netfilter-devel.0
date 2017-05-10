From: Florian Westphal <fw@strlen.de>
Subject: Re: [nft PATCH RFC] monitor: Support printing processes which caused
 the event
Date: Wed, 10 May 2017 13:27:24 +0200
Message-ID: <20170510112724.GD16263@breakpoint.cc>
References: <20170510105510.891-1-phil@nwl.cc>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Pablo Neira Ayuso <pablo@netfilter.org>,
        netfilter-devel@vger.kernel.org, Florian Westphal <fw@strlen.de>
To: Phil Sutter <phil@nwl.cc>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([146.0.238.67]:47580 "EHLO
        Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751423AbdEJL1y (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 10 May 2017 07:27:54 -0400
Content-Disposition: inline
In-Reply-To: <20170510105510.891-1-phil@nwl.cc>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Phil Sutter <phil@nwl.cc> wrote:
> This adds support for printing the process ID and name for changes which
> 'nft monitor' reports:
> 
> | nft -a -p monitor
> | add chain ip t2 bla3 # pid 11616 (nft)

This prints something else, see below.

> diff --git a/src/netlink.c b/src/netlink.c
> index 7e7261fe1e1d4..67a2f2a901ebe 100644
> --- a/src/netlink.c
> +++ b/src/netlink.c
> @@ -2068,6 +2068,40 @@ next:
>  	nftnl_expr_iter_destroy(nlrei);
>  }
>  
> +static const char *pid2name(uint32_t pid)
> +{
> +	static char buf[512];
> +	int fd, rc;
> +	char *p;
> +
> +	snprintf(buf, sizeof(buf), "/proc/%u/cmdline", pid);
> +	fd = open(buf, O_RDONLY);
> +	if (fd == -1)
> +		return "";
> +
> +	rc = read(fd, buf, sizeof(buf));

This should do a

buf[sizeof(buf) - 1] = 0;

to be on safe side.

> +static void print_pid(const struct nlmsghdr *nlh)
> +{
> +	const char *name;
> +
> +	if (!pid_output)
> +		return;
> +	printf(" # pid %u", nlh->nlmsg_pid);

nlmsg_pid is the netlink portid.

While most programs set it to their process id there is no guarantee.
Its just a (unique) 32 bit identifier.

Afaics one has to use /proc/net/netlink to map the portid to the inode
and then walk /proc/*/fd/* to find the socket with that inode.

Perhaps there is a simpler way, maybe you can check what ss is doing
and what info can be obtained via netlink diag.
