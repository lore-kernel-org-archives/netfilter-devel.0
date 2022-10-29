Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4AC95C433FE
	for <netfilter-devel@archiver.kernel.org>; Sat, 29 Oct 2022 08:57:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229629AbiJ2I5e (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sat, 29 Oct 2022 04:57:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53644 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229441AbiJ2I5d (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sat, 29 Oct 2022 04:57:33 -0400
Received: from mx1.riseup.net (mx1.riseup.net [198.252.153.129])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9358585599
        for <netfilter-devel@vger.kernel.org>; Sat, 29 Oct 2022 01:57:32 -0700 (PDT)
Received: from fews1.riseup.net (fews1-pn.riseup.net [10.0.1.83])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256
         client-signature RSA-PSS (2048 bits) client-digest SHA256)
        (Client CN "mail.riseup.net", Issuer "R3" (not verified))
        by mx1.riseup.net (Postfix) with ESMTPS id 4MztbH6lg2zDr58;
        Sat, 29 Oct 2022 08:57:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=riseup.net; s=squak;
        t=1667033852; bh=oKd7ns86+EOrKu1HCRIatc24ri+Y/2Z1KkJtqlx5Wrs=;
        h=Date:Subject:To:References:From:In-Reply-To:From;
        b=NcYL6lFGJeq0flr8TNqTNojtyYMg8wTfh12nznOkFlVnAcyd5NQBgpL1rrfMkiJ58
         qJlHPUDJzqUnKgBOwLdWJspRln+gnJ7JJuzVIAN20zDNjFtZ8yn02HWo1EG6erbHLq
         E0kVzyYg4gOKRFspyJuOb5sTduwszZhATDGXeacc=
X-Riseup-User-ID: EDB2102B2F9F3299C93820F84F4EBA515AAEA7801FDCDD2E317C201FE0121130
Received: from [127.0.0.1] (localhost [127.0.0.1])
         by fews1.riseup.net (Postfix) with ESMTPSA id 4MztbH0G20z5vXG;
        Sat, 29 Oct 2022 08:57:30 +0000 (UTC)
Message-ID: <f2972174-ba96-f366-ce32-49cb505e932e@riseup.net>
Date:   Sat, 29 Oct 2022 10:57:29 +0200
MIME-Version: 1.0
Subject: Re: [PATCH nft v4] src: add support to command "destroy"
Content-Language: en-US
To:     Phil Sutter <phil@nwl.cc>, netfilter-devel@vger.kernel.org
References: <20221028100648.58789-1-ffmancera@riseup.net>
 <Y1weve5JsmyNLb8t@orbyte.nwl.cc>
From:   Fernando Fernandez Mancera <ffmancera@riseup.net>
In-Reply-To: <Y1weve5JsmyNLb8t@orbyte.nwl.cc>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Hi,

On 28/10/2022 20:26, Phil Sutter wrote:
> Hi Fernando,
> 
> On Fri, Oct 28, 2022 at 12:06:48PM +0200, Fernando Fernandez Mancera wrote:
> [...]
>> diff --git a/src/mnl.c b/src/mnl.c
>> index e87b0338..ab0e06c9 100644
>> --- a/src/mnl.c
>> +++ b/src/mnl.c
>> @@ -602,10 +602,16 @@ int mnl_nft_rule_del(struct netlink_ctx *ctx, struct cmd *cmd)
>>   
>>   	nftnl_rule_set_u32(nlr, NFTNL_RULE_FAMILY, h->family);
>>   
>> -	nlh = nftnl_nlmsg_build_hdr(nftnl_batch_buffer(ctx->batch),
>> -				    NFT_MSG_DELRULE,
>> -				    nftnl_rule_get_u32(nlr, NFTNL_RULE_FAMILY),
>> -				    0, ctx->seqnum);
>> +	if (cmd->op == CMD_DESTROY)
>> +		nlh = nftnl_nlmsg_build_hdr(nftnl_batch_buffer(ctx->batch),
>> +					    NFT_MSG_DESTROYRULE,
>> +					    nftnl_rule_get_u32(nlr, NFTNL_RULE_FAMILY),
>> +					    0, ctx->seqnum);
>> +	else
>> +		nlh = nftnl_nlmsg_build_hdr(nftnl_batch_buffer(ctx->batch),
>> +					    NFT_MSG_DELRULE,
>> +					    nftnl_rule_get_u32(nlr, NFTNL_RULE_FAMILY),
>> +					    0, ctx->seqnum);
>>   
>>   	cmd_add_loc(cmd, nlh->nlmsg_len, &h->table.location);
>>   	mnl_attr_put_strz(nlh, NFTA_RULE_TABLE, h->table.name);
> 
> These chunks become much simpler if you introduce a local variable
> holding NFT_MSG_DELRULE by default and set it to NFT_MSG_DESTROYRULE if
> cmd->op == CMD_DESTROY.
> 

Makes sense, thanks!

Thanks,
Fernando.

> Cheers, Phil

