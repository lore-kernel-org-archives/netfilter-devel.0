From: =?gb2312?B?uN+35Q==?= <fgao@ikuai8.com>
Subject: RE: [PATCH nf] netfilter: expect: fix crash when putting uninited expectation
Date: Tue, 11 Jul 2017 08:40:26 +0800
Message-ID: <000401d2f9de$4a910680$dfb31380$@ikuai8.com>
References: <20170710115353.17226-1-fw@strlen.de>
Mime-Version: 1.0
Content-Type: text/plain;
        charset="gb2312"
Content-Transfer-Encoding: 7bit
To: "'Florian Westphal'" <fw@strlen.de>,
        <netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from [103.7.28.233] ([103.7.28.233]:15486 "EHLO smtpbg65.qq.com"
        rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org with ESMTP
        id S1751069AbdGKAlU (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 10 Jul 2017 20:41:20 -0400
In-Reply-To: <20170710115353.17226-1-fw@strlen.de>
Content-Language: zh-cn
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

> From: Florian Westphal [mailto:fw@strlen.de]
> Subject: [PATCH nf] netfilter: expect: fix crash when putting uninited
> expectation
> 
> We crash in __nf_ct_expect_check, it calls nf_ct_remove_expect on the
> uninitialised expectation instead of existing one, so del_timer chokes on
> random memory address.
> 
> Fixes: ec0e3f01114ad32711243 ("netfilter: nf_ct_expect: Add
> nf_ct_remove_expect()")
> Reported-by: Sergey Kvachonok <ravenexp@gmail.com>
> Tested-by: Sergey Kvachonok <ravenexp@gmail.com>
> Cc: Gao Feng <fgao@ikuai8.com>
> Signed-off-by: Florian Westphal <fw@strlen.de>
> ---
>  net/netfilter/nf_conntrack_expect.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/net/netfilter/nf_conntrack_expect.c
> b/net/netfilter/nf_conntrack_expect.c
> index e03d16ed550d..899c2c36da13 100644
> --- a/net/netfilter/nf_conntrack_expect.c
> +++ b/net/netfilter/nf_conntrack_expect.c
> @@ -422,7 +422,7 @@ static inline int __nf_ct_expect_check(struct
> nf_conntrack_expect *expect)
>  	h = nf_ct_expect_dst_hash(net, &expect->tuple);
>  	hlist_for_each_entry_safe(i, next, &nf_ct_expect_hash[h], hnode) {
>  		if (expect_matches(i, expect)) {
> -			if (nf_ct_remove_expect(expect))
> +			if (nf_ct_remove_expect(i))

Thanks your fix. It's a typo indeed.

Best Regards
Feng

>  				break;
>  		} else if (expect_clash(i, expect)) {
>  			ret = -EBUSY;
> --
> 2.13.0



