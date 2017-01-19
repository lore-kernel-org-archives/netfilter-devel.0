From: Liping Zhang <zlpnobody@gmail.com>
Subject: Re: [PATCH nf] netfilter: nf_tables: report error if stateful obj's
 name is truncated
Date: Thu, 19 Jan 2017 22:41:55 +0800
Message-ID: <CAML_gOc=0wpF9ERvvC5Vp3ncMdijrt9hOkSci1tc4tMUoR2uQg@mail.gmail.com>
References: <1484834420-55121-1-git-send-email-zlpnobody@163.com> <20170119140914.GA11241@salvia>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: Liping Zhang <zlpnobody@163.com>,
        Netfilter Developer Mailing List
        <netfilter-devel@vger.kernel.org>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-vk0-f67.google.com ([209.85.213.67]:33338 "EHLO
        mail-vk0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753225AbdASOmB (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 19 Jan 2017 09:42:01 -0500
Received: by mail-vk0-f67.google.com with SMTP id t8so3760920vke.0
        for <netfilter-devel@vger.kernel.org>; Thu, 19 Jan 2017 06:42:01 -0800 (PST)
In-Reply-To: <20170119140914.GA11241@salvia>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

2017-01-19 22:09 GMT+08:00 Pablo Neira Ayuso <pablo@netfilter.org>:
> On Thu, Jan 19, 2017 at 10:00:20PM +0800, Liping Zhang wrote:
>> From: Liping Zhang <zlpnobody@gmail.com>
>>
>> Currently, if the user add a stateful object with the name size exceed
>> NFT_OBJ_MAXNAMELEN - 1 (i.e. 31), we truncate it down to 31 silently.
>> This is not friendly, furthermore, this will cause duplicated stateful
>> objects when the first 31 characters of the name is same. So limit the
>> stateful object's name size to NFT_OBJ_MAXNAMELEN - 1.
>>
>> After apply this patch, error message will be printed out like this:
>>   # name_32=$(printf "%0.sQ" {1..32})
>>   # nft add counter filter $name_32
>>   <cmdline>:1:1-52: Error: Could not process rule: Numerical result out
>>   of range
>>   add counter filter QQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQ
>>   ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
>
> Good catch.
>
> At quick glance, I can see other spots lacking this validation:
>
> static const struct nla_policy nft_chain_policy[NFTA_CHAIN_MAX + 1] =
> {
>         [NFTA_CHAIN_TABLE]      = { .type = NLA_STRING },
>
> Probably review and fix them in one go?

The nft table name's size is limited at this place:
static const struct nla_policy nft_table_policy[NFTA_TABLE_MAX + 1] = {
        [NFTA_TABLE_NAME] = { .type = NLA_STRING,
                                                   .len =
NFT_TABLE_MAXNAMELEN - 1 },

If NFTA_CHAIN_TABLE's size exceeded 31, nf_tables_table_lookup will
fail eventually.

So I think adding the validation of NFTA_CHAIN_TABLE's size is not
important.

I had checked the table, chain, rule(no name), set, setelem(no name)
and object, I only found the validation of the object's name was missed.
