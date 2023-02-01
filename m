Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DC221C636D4
	for <netfilter-devel@archiver.kernel.org>; Wed,  1 Feb 2023 11:17:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232390AbjBALRb (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 1 Feb 2023 06:17:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40572 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232430AbjBALR1 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 1 Feb 2023 06:17:27 -0500
Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 693D85CE65;
        Wed,  1 Feb 2023 03:17:25 -0800 (PST)
Date:   Wed, 1 Feb 2023 12:17:20 +0100
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     "Fernando F. Mancera" <ffmancera@riseup.net>
Cc:     Yang Yingliang <yangyingliang@huawei.com>,
        netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
        netdev@vger.kernel.org, kadlec@netfilter.org, fw@strlen.de,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com
Subject: Re: [PATCH net-next] netfilter: nf_tables: fix wrong pointer passed
 to PTR_ERR()
Message-ID: <Y9pKQO3E3K6tD0bI@salvia>
References: <20230119075125.3598627-1-yangyingliang@huawei.com>
 <f9e39f74-e204-dcba-03ce-dfce7fe37a6d@riseup.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <f9e39f74-e204-dcba-03ce-dfce7fe37a6d@riseup.net>
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Tue, Jan 24, 2023 at 02:16:55PM +0100, Fernando F. Mancera wrote:
> 
> 
> On 19/01/2023 08:51, Yang Yingliang wrote:
> > It should be 'chain' passed to PTR_ERR() in the error path
> > after calling nft_chain_lookup() in nf_tables_delrule().
> > 
> > Fixes: f80a612dd77c ("netfilter: nf_tables: add support to destroy operation")
> > Signed-off-by: Yang Yingliang <yangyingliang@huawei.com>
> > ---
> >   net/netfilter/nf_tables_api.c | 2 +-
> >   1 file changed, 1 insertion(+), 1 deletion(-)
> > 
> > diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
> > index 974b95dece1d..10264e98978b 100644
> > --- a/net/netfilter/nf_tables_api.c
> > +++ b/net/netfilter/nf_tables_api.c
> > @@ -3724,7 +3724,7 @@ static int nf_tables_delrule(struct sk_buff *skb, const struct nfnl_info *info,
> >   		chain = nft_chain_lookup(net, table, nla[NFTA_RULE_CHAIN],
> >   					 genmask);
> >   		if (IS_ERR(chain)) {
> > -			if (PTR_ERR(rule) == -ENOENT &&
> > +			if (PTR_ERR(chain) == -ENOENT &&
> >   			    NFNL_MSG_TYPE(info->nlh->nlmsg_type) == NFT_MSG_DESTROYRULE)
> >   				return 0;
> 
> Acked-by: Fernando Fernandez Mancera <ffmancera@riseup.net>

Applied, thanks

