From: Joshua Goodall <joshua@myinternet.com.au>
Subject: Re: [RFC] updated ctnetlink patches: ctnetlink-0.12.diff
Date: Fri, 5 Dec 2003 13:55:03 +1100
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20031205025503.GA11243@myinternet.com.au>
References: <3ED4BD8D.1070500@trash.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Patrick McHardy <kaber@trash.net>
Content-Disposition: inline
In-Reply-To: <3ED4BD8D.1070500@trash.net>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

On Wed, May 28, 2003 at 03:45:49PM +0200, Patrick McHardy wrote:
> # import ctnetlink 0.12 changes
> # --------------------------------------------
[snip]

> diff -Nru a/net/ipv4/netfilter/nfnetlink.c b/net/ipv4/netfilter/nfnetlink.c
> --- /dev/null	Wed Dec 31 16:00:00 1969
> +++ b/net/ipv4/netfilter/nfnetlink.c	Tue May 27 19:26:26 2003
[snip]
> +#define nf_debug(level, format, arg...)					       \
> +	do {								       \
> +		if (nf_debug_level > level)				       \
> +			printk(KERN_DEBUG "%s: " format, __FUNCTION__, ## arg);\
> +	} while(0)

This triggers a bug in GCC 2.95.4 (Debian stable and others) and breaks
the build.

Please use
printk(KERN_DEBUG "%s: " format, __FUNCTION__ , ## arg);
- note the space after __FUNCTION__.

Also occurs later in nfnetlink_conntrack.c.

Thanks!
Joshua.
