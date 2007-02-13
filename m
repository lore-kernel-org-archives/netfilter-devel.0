From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH 4/7 parse attributes with nfattr_parse in
	nfnetlink_check_attribute
Date: Tue, 13 Feb 2007 12:05:30 +0100
Message-ID: <45D19B7A.5080305@trash.net>
References: <45D0EE40.4050404@netfilter.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
In-Reply-To: <45D0EE40.4050404@netfilter.org>
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

Pablo Neira Ayuso wrote:
> [PATCH] parse attributes with nfattr_parse in nfnetlink_check_attribute
> 
> Use nfattr_parse to parse attributes, this patch also modifies the default 
> behaviour since unknown attributes will be ignored instead of returning 
> EINVAL. This ensure backward compatibility: new libraries with new 
> attributes and old kernels can work.

Currently other netlink subsystems return errors for the first level
of attributes and accept unknown attributes on deeper levels. I'm
not sure which I prefer, ignoring unknown attributes makes it
impossible for userspace to know that something isn't going to have
any effect, returning an error makes it harder to support new features.

I know Thomas had intentions of increasing consistency in this area,
I'm just not sure in which direction :)

Thomas, what do you think of this patch?

> 
> Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
> 
> Index: net-2.6.git/net/netfilter/nfnetlink.c
> ===================================================================
> --- net-2.6.git.orig/net/netfilter/nfnetlink.c	2007-01-19 19:37:01.000000000 +0100
> +++ net-2.6.git/net/netfilter/nfnetlink.c	2007-01-19 19:48:18.000000000 +0100
> @@ -128,26 +128,14 @@ nfnetlink_check_attributes(struct nfnetl
>  			   struct nlmsghdr *nlh, struct nfattr *cda[])
>  {
>  	int min_len = NLMSG_SPACE(sizeof(struct nfgenmsg));
> -	u_int16_t attr_count;
>  	u_int8_t cb_id = NFNL_MSG_TYPE(nlh->nlmsg_type);
> -
> -	attr_count = subsys->cb[cb_id].attr_count;
> -	memset(cda, 0, sizeof(struct nfattr *) * attr_count);
> +	u_int16_t attr_count = subsys->cb[cb_id].attr_count;
>  
>  	/* check attribute lengths. */
>  	if (likely(nlh->nlmsg_len > min_len)) {
>  		struct nfattr *attr = NFM_NFA(NLMSG_DATA(nlh));
>  		int attrlen = nlh->nlmsg_len - NLMSG_ALIGN(min_len);
> -
> -		while (NFA_OK(attr, attrlen)) {
> -			unsigned flavor = NFA_TYPE(attr);
> -			if (flavor) {
> -				if (flavor > attr_count)
> -					return -EINVAL;
> -				cda[flavor - 1] = attr;
> -			}
> -			attr = NFA_NEXT(attr, attrlen);
> -		}
> +		nfattr_parse(cda, attr_count, attr, attrlen);
>  	}
>  
>  	/* implicit: if nlmsg_len == min_len, we return 0, and an empty
