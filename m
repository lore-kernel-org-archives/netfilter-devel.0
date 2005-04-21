From: Wang Jian <lark@linux.net.cn>
Subject: Re: nfnetlink/ctnetlink from pom-ng r3884
Date: Thu, 21 Apr 2005 16:21:07 +0800
Message-ID: <20050421161953.03CC.LARK@linux.net.cn>
References: <20050419212858.039E.LARK@linux.net.cn>
	<4265A895.1070406@eurodev.net>
Mime-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Pablo Neira <pablo@eurodev.net>
In-Reply-To: <4265A895.1070406@eurodev.net>
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

Hi Pablo Neira,

There is same code in expect_handler(). Should that place be fixed too?

On Wed, 20 Apr 2005 02:55:49 +0200, Pablo Neira <pablo@eurodev.net> wrote:

> Index: src/libct.c
> ===================================================================
> --- src/libct.c	(revision 3881)
> +++ src/libct.c	(working copy)
> @@ -239,7 +239,7 @@
>  			attr = NFA_NEXT(attr, attrlen);
>  		}
>  		min_len += nlh->nlmsg_len;
> -		nlh = (struct nlmsghdr *) attr;
> +		nlh = (struct nlmsghdr *) (nlh + nlh->nlmsg_len);
>  		printf("\n");
>  	}
>  	DEBUGP("exit from handler\n");



-- 
  lark
