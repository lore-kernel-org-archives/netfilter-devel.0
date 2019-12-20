Return-Path: <SRS0=tkBW=2K=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 21213C43603
	for <netfilter-devel@archiver.kernel.org>; Fri, 20 Dec 2019 03:42:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E6AD9206EF
	for <netfilter-devel@archiver.kernel.org>; Fri, 20 Dec 2019 03:42:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727071AbfLTDmf (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 19 Dec 2019 22:42:35 -0500
Received: from m9785.mail.qiye.163.com ([220.181.97.85]:19730 "EHLO
        m9785.mail.qiye.163.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727020AbfLTDmf (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 19 Dec 2019 22:42:35 -0500
Received: from [192.168.188.14] (unknown [120.132.1.226])
        by m9785.mail.qiye.163.com (Hmail) with ESMTPA id 68B515C194E;
        Fri, 20 Dec 2019 11:42:29 +0800 (CST)
Subject: Re: [PATCH nf 2/3] netfilter: nf_tables: fix miss activate operation
 in the
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org
References: <1576681153-10578-1-git-send-email-wenxu@ucloud.cn>
 <1576681153-10578-3-git-send-email-wenxu@ucloud.cn>
 <20191219235517.nbdbbdppfxanozba@salvia>
From:   wenxu <wenxu@ucloud.cn>
Message-ID: <3ba46281-5d95-607e-8215-d61a0919d4ad@ucloud.cn>
Date:   Fri, 20 Dec 2019 11:42:27 +0800
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <20191219235517.nbdbbdppfxanozba@salvia>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-HM-Spam-Status: e1kfGhgUHx5ZQUtXWQgYFAkeWUFZVkpVSEJKS0tLSk5KTUhPSUlZV1koWU
        FJQjdXWS1ZQUlXWQkOFx4IWUFZNTQpNjo3JCkuNz5ZBg++
X-HM-Sender-Digest: e1kMHhlZQR0aFwgeV1kSHx4VD1lBWUc6Ok06Hzo5Tzg3Vkw1HxEiES1D
        CzgaCkpVSlVKTkxNQ0pISE9CTU9LVTMWGhIXVQweFQMOOw4YFxQOH1UYFUVZV1kSC1lBWUpJS1VK
        SElVSlVJSU1ZV1kIAVlBT0lOTDcG
X-HM-Tid: 0a6f21664a812087kuqy68b515c194e
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org


On 12/20/2019 7:55 AM, Pablo Neira Ayuso wrote:
> On Wed, Dec 18, 2019 at 10:59:12PM +0800, wenxu@ucloud.cn wrote:
>> From: wenxu <wenxu@ucloud.cn>
>>
>> nf_tables_commit for NFT_MSG_NEWRULE
>>
>> The new create rule should be activated in the nf_tables_commit.
>>
>> create a flowtable:
>> nft add table firewall
>> nft add flowtable firewall fb1 { hook ingress priority 2 \; devices = { tun1, mlx_pf0vf0 } \; }
>> nft add chain firewall ftb-all {type filter hook forward priority 0 \; policy accept \; }
>> nft add rule firewall ftb-all ct zone 1 ip protocol tcp flow offload @fb1
>> nft add rule firewall ftb-all ct zone 1 ip protocol udp flow offload @fb1
>>
>> delete the related rule:
>> nft delete chain firewall ftb-all
>>
>> The flowtable can be deleted
>> nft delete flowtable firewall fb1
>>
>> But failed with: Device is busy
>>
>> The nf_flowtable->use is not zero for no activated operation.
> This is correct.
>
>> Signed-off-by: wenxu <wenxu@ucloud.cn>
>> ---
>>  net/netfilter/nf_tables_api.c | 1 +
>>  1 file changed, 1 insertion(+)
>>
>> diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
>> index 27e6a6f..174b362 100644
>> --- a/net/netfilter/nf_tables_api.c
>> +++ b/net/netfilter/nf_tables_api.c
>> @@ -7101,6 +7101,7 @@ static int nf_tables_commit(struct net *net, struct sk_buff *skb)
>>  			nf_tables_rule_notify(&trans->ctx,
>>  					      nft_trans_rule(trans),
>>  					      NFT_MSG_NEWRULE);
>> +			nft_rule_expr_activate(&trans->ctx, nft_trans_rule(trans));
> I don't think this fix is correct, probably this patch?


Maybe your patch is also not correct.    The  nf_tables_deactivate_flowtable already ignore

the NFT_TRANS_COMMIT.

void nf_tables_deactivate_flowtable(const struct nft_ctx *ctx,
                                    struct nft_flowtable *flowtable,
                                    enum nft_trans_phase phase)
{
        switch (phase) {
        case NFT_TRANS_PREPARE:
        case NFT_TRANS_ABORT:
        case NFT_TRANS_RELEASE:
                flowtable->use--;
                /* fall through */
        default:
                return;
        }   
}


Nft_flow_offload  inc the use counter , when delete the rule and dec it in deactivate with phase NFT_TRANS_PREPARE.

So the nft_flow_offload_destroy should not dec the use?

So the patch should be as following.

static void nft_flow_offload_destroy(const struct nft_ctx *ctx,
                                     const struct nft_expr *expr)
{
        struct nft_flow_offload *priv = nft_expr_priv(expr);

-        priv->flowtable->use--;
        nf_ct_netns_put(ctx->net, ctx->family);
}


The rule should be like the following?


Create rule nft_xx_init   inc the use counter,  If the rule create failed just deactivate it

Delete the rule  deactivate dec the use counter, If the rule delete failed just activate it


BR

wenxu




