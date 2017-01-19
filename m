From: Patrick PIGNOL <patrick.pignol@gmail.com>
Subject: Re: [PATCH nf] netfilter: nf_tables: report error if stateful obj's
 name is truncated
Date: Thu, 19 Jan 2017 16:55:11 +0100
Message-ID: <b62f0224-11fc-86f2-bcdd-9398b0407029@gmail.com>
References: <1484834420-55121-1-git-send-email-zlpnobody@163.com>
 <20170119140914.GA11241@salvia>
 <CAML_gOc=0wpF9ERvvC5Vp3ncMdijrt9hOkSci1tc4tMUoR2uQg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Cc: Liping Zhang <zlpnobody@163.com>,
        Netfilter Developer Mailing List
        <netfilter-devel@vger.kernel.org>
To: Liping Zhang <zlpnobody@gmail.com>,
        Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-lf0-f66.google.com ([209.85.215.66]:36140 "EHLO
        mail-lf0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753137AbdASPzO (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 19 Jan 2017 10:55:14 -0500
Received: by mail-lf0-f66.google.com with SMTP id h65so5866823lfi.3
        for <netfilter-devel@vger.kernel.org>; Thu, 19 Jan 2017 07:55:14 -0800 (PST)
In-Reply-To: <CAML_gOc=0wpF9ERvvC5Vp3ncMdijrt9hOkSci1tc4tMUoR2uQg@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi all,

I KNOW that I will say something stupid but I'm thinking 'Why don't set NFT_OBJ_MAXNAMELEN to 255(or maybe size_t|SIZE_MAX|) on x86 ?'.

The true question that I can't answer now is : 'Why it is so stupid ?'

Best regards,

Patrick


Le 19/01/2017 à 15:41, Liping Zhang a écrit :
> 2017-01-19 22:09 GMT+08:00 Pablo Neira Ayuso <pablo@netfilter.org>:
>> On Thu, Jan 19, 2017 at 10:00:20PM +0800, Liping Zhang wrote:
>>> From: Liping Zhang <zlpnobody@gmail.com>
>>>
>>> Currently, if the user add a stateful object with the name size exceed
>>> NFT_OBJ_MAXNAMELEN - 1 (i.e. 31), we truncate it down to 31 silently.
>>> This is not friendly, furthermore, this will cause duplicated stateful
>>> objects when the first 31 characters of the name is same. So limit the
>>> stateful object's name size to NFT_OBJ_MAXNAMELEN - 1.
>>>
>>> After apply this patch, error message will be printed out like this:
>>>    # name_32=$(printf "%0.sQ" {1..32})
>>>    # nft add counter filter $name_32
>>>    <cmdline>:1:1-52: Error: Could not process rule: Numerical result out
>>>    of range
>>>    add counter filter QQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQ
>>>    ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
>> Good catch.
>>
>> At quick glance, I can see other spots lacking this validation:
>>
>> static const struct nla_policy nft_chain_policy[NFTA_CHAIN_MAX + 1] =
>> {
>>          [NFTA_CHAIN_TABLE]      = { .type = NLA_STRING },
>>
>> Probably review and fix them in one go?
> The nft table name's size is limited at this place:
> static const struct nla_policy nft_table_policy[NFTA_TABLE_MAX + 1] = {
>          [NFTA_TABLE_NAME] = { .type = NLA_STRING,
>                                                     .len =
> NFT_TABLE_MAXNAMELEN - 1 },
>
> If NFTA_CHAIN_TABLE's size exceeded 31, nf_tables_table_lookup will
> fail eventually.
>
> So I think adding the validation of NFTA_CHAIN_TABLE's size is not
> important.
>
> I had checked the table, chain, rule(no name), set, setelem(no name)
> and object, I only found the validation of the object's name was missed.
> --
> To unsubscribe from this list: send the line "unsubscribe netfilter-devel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

