From: Harsha Sharma <harshasharmaiitr@gmail.com>
Subject: Re: [PATCH] extensions: libxt_hashlimit: Do not print default timeout
 and burst
Date: Tue, 19 Dec 2017 20:20:31 +0530
Message-ID: <CANMOCy24sTwdjOJS3bM0jRQcN-5_8dFw+tvtaZ3Mzd7PRTm3Bg@mail.gmail.com>
References: <20171219122716.19710-1-harshasharmaiitr@gmail.com> <20171219140119.xioa2io52yvofdws@salvia>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Cc: nmalykh@bilim.com, rv@wallfire.org, netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-ua0-f175.google.com ([209.85.217.175]:44886 "EHLO
        mail-ua0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1763833AbdLSOud (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 19 Dec 2017 09:50:33 -0500
Received: by mail-ua0-f175.google.com with SMTP id j14so13125673uag.11
        for <netfilter-devel@vger.kernel.org>; Tue, 19 Dec 2017 06:50:32 -0800 (PST)
In-Reply-To: <20171219140119.xioa2io52yvofdws@salvia>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Tue, Dec 19, 2017 at 7:31 PM, Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> On Tue, Dec 19, 2017 at 05:57:16PM +0530, Harsha Sharma wrote:
>> @@ -1340,7 +1345,9 @@ static int hashlimit_mt_xlate(struct xt_xlate *xl, const char *name,
>>       xt_xlate_add(xl, "flow table %s {", name);
>>       ret = hashlimit_mode_xlate(xl, cfg->mode, family,
>>                                  cfg->srcmask, cfg->dstmask);
>> -     xt_xlate_add(xl, " timeout %us limit rate", cfg->expire / 1000);
>> +     if (!XT_HASHLIMIT_BYTE_EXPIRE_DEFAULT)
>> +             xt_xlate_add(xl, " timeout %us", cfg->expire / 1000);
>
> Better print cfg->expire if only if the default timeout is set.
>
>         if (cfg->expire != XT_HASHLIMIT_XLATE_DEFAULT_TIMEOUT)
>                 ...
>
> Same thing for burst. Thanks.

This would result into not printing the timeout 1s (default value)
even if user specifies it.
For e.g.
iptables-translate -A INPUT -m tcp -p tcp --dport 80 -m hashlimit
--hashlimit-above 200kb/s --hashlimit-mode srcip,dstport
--hashlimit-name http2 --hashlimit-htable-expire 1000 -j DROP
nft add rule ip filter INPUT tcp dport 80 flow table http2 { tcp dport
. ip saddr limit rate over 200 kbytes/second} counter drop

and the expected output is
nft add rule ip filter INPUT tcp dport 80 flow table http2 { tcp dport
. ip saddr timeout 1s limit rate over 200 kbytes/second} counter drop
(This patch allows this.)
I hope this makes sense and same for burst.
Thanks a lot for the review.

Regards,
Harsha Sharma
