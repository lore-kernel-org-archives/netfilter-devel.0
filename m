From: Shivani Bhardwaj <shivanib134@gmail.com>
Subject: Re: [PATCH] extensions: libxt_helper: Add translation to nft
Date: Wed, 23 Dec 2015 15:32:54 +0530
Message-ID: <CAKHNQQFXEZiQPwKO2g3NsDdQyvcBnJqv=8xYa7+sbyj25t+uFg@mail.gmail.com>
References: <20151223095347.GA5866@gmail.com> <20151223100158.GA1952@salvia>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-wm0-f54.google.com ([74.125.82.54]:35870 "EHLO
	mail-wm0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933904AbbLWKDP (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 23 Dec 2015 05:03:15 -0500
Received: by mail-wm0-f54.google.com with SMTP id p187so139914448wmp.1
        for <netfilter-devel@vger.kernel.org>; Wed, 23 Dec 2015 02:03:14 -0800 (PST)
In-Reply-To: <20151223100158.GA1952@salvia>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Wed, Dec 23, 2015 at 3:31 PM, Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> On Wed, Dec 23, 2015 at 03:23:47PM +0530, Shivani Bhardwaj wrote:
>> Add translation for helper module to nftables.
>>
>> Examples:
>>
>> $ sudo iptables-translate -A FORWARD -m helper --helper sip
>> nft add rule ip filter FORWARD ct helper \"sip\" counter
>>
>> $ sudo iptables-translate -A FORWARD -m helper ! --helper ftp
>> nft add rule ip filter FORWARD ct helper != \"ftp\" counter
>>
>> Signed-off-by: Shivani Bhardwaj <shivanib134@gmail.com>
>> ---
>>  extensions/libxt_helper.c | 14 ++++++++++++++
>>  1 file changed, 14 insertions(+)
>>
>> diff --git a/extensions/libxt_helper.c b/extensions/libxt_helper.c
>> index c9f9435..5f1d8b1 100644
>> --- a/extensions/libxt_helper.c
>> +++ b/extensions/libxt_helper.c
>> @@ -45,6 +45,19 @@ static void helper_save(const void *ip, const struct xt_entry_match *match)
>>       xtables_save_string(info->name);
>>  }
>>
>> +static int helper_xlate(const struct xt_entry_match *match,
>> +                     struct xt_buf *buf, int numeric)
>> +{
>> +     const struct xt_helper_info *info = (const void *)match->data;
>> +
>> +     xt_buf_add(buf, "ct helper");
>> +
>> +     xt_buf_add(buf, "%s \\\"%s\\\" ",
>> +                info->invert ? " !=" : "", info->name);
>
> You can place this in one single call of xt_buf_add(), right?

Sending v2.
Thank you
