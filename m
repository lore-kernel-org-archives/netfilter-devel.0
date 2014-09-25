From: Vadim Kochan <vadim4j@gmail.com>
Subject: Re: [PATCH] Allow to compile for < 3.17 kernel version
Date: Thu, 25 Sep 2014 20:33:42 +0300
Message-ID: <CAMw6YJJ-y0Lp8Wq253EOw03hon172BqhnU+o6ZuggA-fO-7Qpg@mail.gmail.com>
References: <1411606624-8411-1-git-send-email-vadim4j@gmail.com>
	<20140925171257.GA13847@salvia>
	<20140925171647.GB13847@salvia>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-wi0-f173.google.com ([209.85.212.173]:54129 "EHLO
	mail-wi0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751937AbaIYRdn (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 25 Sep 2014 13:33:43 -0400
Received: by mail-wi0-f173.google.com with SMTP id r20so9428129wiv.0
        for <netfilter-devel@vger.kernel.org>; Thu, 25 Sep 2014 10:33:42 -0700 (PDT)
In-Reply-To: <20140925171647.GB13847@salvia>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Thanks for response, I agree.

On Thu, Sep 25, 2014 at 8:16 PM, Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> On Thu, Sep 25, 2014 at 07:12:57PM +0200, Pablo Neira Ayuso wrote:
>> On Thu, Sep 25, 2014 at 03:57:04AM +0300, Vadim Kochan wrote:
>> > Added declaration checking for NFT_EXPR_LOG_LEVEL enum
>> > which was added for 3.17 kernel version.
>> >
> [...]
>> > diff --git a/src/netlink_delinearize.c b/src/netlink_delinearize.c
>> > index 796b632..cf2ec00 100644
>> > --- a/src/netlink_delinearize.c
>> > +++ b/src/netlink_delinearize.c
>> > @@ -447,11 +447,13 @@ static void netlink_parse_log(struct netlink_parse_ctx *ctx,
>> >                     nft_rule_expr_get_u16(nle, NFT_EXPR_LOG_QTHRESHOLD);
>> >             stmt->log.flags |= STMT_LOG_QTHRESHOLD;
>> >     }
>> > +#if HAVE_DECL_NFT_EXPR_LOG_LEVEL
>> >     if (nft_rule_expr_is_set(nle, NFT_EXPR_LOG_LEVEL)) {
>> >             stmt->log.level =
>> >                     nft_rule_expr_get_u32(nle, NFT_EXPR_LOG_LEVEL);
>> >             stmt->log.flags |= STMT_LOG_LEVEL;
>> >     }
>> > +#endif
>> >     list_add_tail(&stmt->list, &ctx->rule->stmts);
>> >  }
>> >
>>
>> I don't want to pollute the source code with many ifdef's, sorry. And
>> if I apply this, more similar follow up patches will come in the
>> future.
>>
>> I'll make a patch to some recommended libnftnl version at configure
>> stage using PKG_CHECK_MODULES.
>
> BTW, regarding the patch title, you should be able to compile libnftnl
> and nftables with no matter kernel version since we're caching the
> header files.
>
> So the subject is innacurate. The real problem is that you cannot
> compile new nftables with old library version since
> NFT_EXPR_LOG_LEVEL, which is a different thing.
