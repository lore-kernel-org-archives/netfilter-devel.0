From: Thomas Graf <tgraf@suug.ch>
Subject: Re: [PATCH 1/3] libnl: add netfilter support
Date: Mon, 3 Sep 2007 12:09:43 +0200
Message-ID: <20070903100943.GH18480@postel.suug.ch>
References: <46DB9716.1020400@snapgear.com> <46DB9776.8020209@snapgear.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Netfilter Developer Mailing List <netfilter-devel@lists.netfilter.org>
To: Philip Craig <philipc@snapgear.com>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
Content-Disposition: inline
In-Reply-To: <46DB9776.8020209@snapgear.com>
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

* Philip Craig <philipc@snapgear.com> 2007-09-03 15:11
> Index: libnl/lib/attr.c
> ===================================================================
> --- libnl.orig/lib/attr.c	2007-09-03 14:24:29.000000000 +1000
> +++ libnl/lib/attr.c	2007-09-03 14:24:45.000000000 +1000
> @@ -261,7 +261,8 @@ int nla_parse(struct nlattr *tb[], int m
>  	memset(tb, 0, sizeof(struct nlattr *) * (maxtype + 1));
>  
>  	nla_for_each_attr(nla, head, len, rem) {
> -		uint16_t type = nla->nla_type;
> +		/* Ignore NFNL_NFA_NEST bit, hope nothing else uses it */
> +		uint16_t type = nla->nla_type & 0x7fff;

I wonder if it is useful to make this behaviour conditional so that
the netfilter subsystem could enable this for backwards compatibility
while other subsystems won't be affected.

It will offend a few people but it's still pre 1.0 and we can break
the API. I'd rather get this right now than having to life with
side effects for a long time.
