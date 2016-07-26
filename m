From: "Pablo M. Bermudo Garay" <pablombg@gmail.com>
Subject: Re: [PATCH iptables 2/2] xtables-translate: fix issue with quotes
Date: Tue, 26 Jul 2016 18:22:49 +0200
Message-ID: <CAAaDf4trupvsudo1-_4b+iafgXRoBBs+3LBBjT21OxvABMxriQ@mail.gmail.com>
References: <20160722154834.1802-1-pablombg@gmail.com> <20160722154834.1802-2-pablombg@gmail.com>
 <20160725153134.GA11209@salvia>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-io0-f196.google.com ([209.85.223.196]:36389 "EHLO
	mail-io0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754567AbcGZQWv (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 26 Jul 2016 12:22:51 -0400
Received: by mail-io0-f196.google.com with SMTP id y34so2357854ioi.3
        for <netfilter-devel@vger.kernel.org>; Tue, 26 Jul 2016 09:22:50 -0700 (PDT)
In-Reply-To: <20160725153134.GA11209@salvia>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

2016-07-25 17:31 GMT+02:00 Pablo Neira Ayuso <pablo@netfilter.org>:
> On Fri, Jul 22, 2016 at 05:48:34PM +0200, Pablo M. Bermudo Garay wrote:
>> Some translations included escaped quotes when they were called from
>> nft:
>>
>> $ sudo nft list ruleset
>> table ip mangle {
>>     chain FORWARD {
>>         type filter hook forward priority -150; policy accept;
>>         ct helper \"ftp\" counter packets 0 bytes 0
>>                   ^^   ^^
>>     }
>> }
>>
>> This behavior is only correct when xlate functions are called from a
>> xtables-translate command. This patch solves that issue if nft revision
>> is using the field added to the xt_xlate struct with "xtables-translate:
>> add new field to identify the caller" commit.
>
> Please, rebase this change on top of:
>
> http://git.netfilter.org/iptables/commit/?id=7a0992da44cfb6cab0ccd1beadcf326df8773552
>
> I'd suggest you add a new parameter for this, something like:
>
>         bool escape_quotes;
>
> Or is there use for this nft_compat field you propose out of this.

For the moment, the quotes issue is the only use I have found for the
nft_compat field. So the escape_quotes boolean seems a good idea.

Thanks.
