From: Shyam Saini <mayhs11saini@gmail.com>
Subject: Re: [RFC PATCH nft V2] src: Add import command for json
Date: Mon, 11 Sep 2017 15:05:47 +0530
Message-ID: <CAOfkYf6B-mqK69xnq6ShP4Am6O5fSjYyUWd1JHJtPuCTRk4Rwg@mail.gmail.com>
References: <1505046662-21629-1-git-send-email-mayhs11saini@gmail.com> <CAOkSjBhKCQ5i3KGJg3gFzCmOcXyugNrn4_ynXK95zTPboSD7ew@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Cc: Netfilter Development Mailing list
        <netfilter-devel@vger.kernel.org>
To: Arturo Borrero Gonzalez <arturo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-io0-f193.google.com ([209.85.223.193]:35216 "EHLO
        mail-io0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751111AbdIKJfs (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 11 Sep 2017 05:35:48 -0400
Received: by mail-io0-f193.google.com with SMTP id d16so3161394ioj.2
        for <netfilter-devel@vger.kernel.org>; Mon, 11 Sep 2017 02:35:48 -0700 (PDT)
In-Reply-To: <CAOkSjBhKCQ5i3KGJg3gFzCmOcXyugNrn4_ynXK95zTPboSD7ew@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

>> This new operation allows to import ruleset in json to make
>> incremental changes using the parse functions of libnftnl.
>>
>> A basic way to test this new functionality is:
>>
>>  % cat file.json | nft import json
>>
>> where the file.json is a ruleset exported in json format.
>>
>> Highly based on work from  Alvaro Neira <alvaroneay@gmail.com>
>> and Arturo Borrero <arturo@netfilter.org>.
>>
>> Signed-off-by: Shyam Saini <mayhs11saini@gmail.com>
>> ---
>> V2:
>>   Build Patch over updated repository.
>
>
> Hi Shyam,

Hi Arturo,

> I was able to test this with the testcase you provided in the other
> patch! great! :-)
>

Thank You Arturo,

> One last thing, the coding style should be fixed before we can merge
> this into master. Examples below.
> We follow linux kernel coding style [0]. There is a script to check
> coding style [1], but beware of some false positives (regarding the
> commit message).
>
> Other than that, the patch looks fine. Please, address the coding
> style issues, and resend with:
>
> Acked-by: Arturo Borrero Gonzalez <arturo@netfilter.org>



I'll send the new  version of this patch

>
>> +
>> +static int netlink_markup_build_rule(const struct nftnl_parse_ctx *ctx,
>> +                                                       uint32_t cmd, struct nftnl_rule *rule)
>> +{
>
> ^^^
> bad alignment, indentation, produces long lines.
>
>> +
>> +static int netlink_markup_chain(const struct nftnl_parse_ctx *ctx)
>> +{
>> +       const struct ruleset_parse *rp;
>> +       struct nftnl_chain *chain;
>> +       uint32_t cmd;
>> +       int ret = -1;
>> +
>> +       chain = nftnl_ruleset_ctx_get(ctx, NFTNL_RULESET_CTX_CHAIN);
>> +       rp = nftnl_ruleset_ctx_get(ctx, NFTNL_RULESET_CTX_DATA);
>> +
>> +       nftnl_chain_unset(chain, NFTNL_CHAIN_HANDLE);
>> +
>> +       cmd = nftnl_ruleset_ctx_get_u32(ctx, NFTNL_RULESET_CTX_CMD);
>> +       switch (cmd) {
>> +       case NFTNL_CMD_ADD:
>> +               ret = mnl_nft_chain_batch_add(chain, rp->nl_ctx->batch, 0, rp->nl_ctx->seqnum);
>> +               break;
>> +       case NFTNL_CMD_DELETE:
>> +               ret = mnl_nft_chain_batch_del(chain, rp->nl_ctx->batch, 0, rp->nl_ctx->seqnum);
> ^^
> too long lines
>
>
> [0] https://www.kernel.org/doc/html/v4.10/process/coding-style.html
> [1] https://github.com/torvalds/linux/blob/master/scripts/checkpatch.pl
