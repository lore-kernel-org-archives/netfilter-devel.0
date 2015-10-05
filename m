From: Neutron Soutmun <neo.neutron@gmail.com>
Subject: Re: [PATCH v2] libmnl: Drop the EXPORT_SYMBOL() tags
Date: Tue, 6 Oct 2015 00:45:24 +0700
Message-ID: <CAMQP0s=iP=yKrOV54Ytc0mGcenB+899cdTR2iCe+uXDwN1BSxw@mail.gmail.com>
References: <20151002013240.GA21692@oxygen>
	<20151005153925.GA22976@salvia>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-ig0-f182.google.com ([209.85.213.182]:33642 "EHLO
	mail-ig0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750738AbbJERpZ (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 5 Oct 2015 13:45:25 -0400
Received: by igbkq10 with SMTP id kq10so68620317igb.0
        for <netfilter-devel@vger.kernel.org>; Mon, 05 Oct 2015 10:45:24 -0700 (PDT)
In-Reply-To: <20151005153925.GA22976@salvia>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Mon, Oct 5, 2015 at 10:39 PM, Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> On Fri, Oct 02, 2015 at 08:32:40AM +0700, Neutron Soutmun wrote:
>> diff --git a/src/internal.h b/src/internal.h
>> index 3a88d1a..1012df2 100644
>> --- a/src/internal.h
>> +++ b/src/internal.h
>> @@ -2,11 +2,5 @@
>>  #define INTERNAL_H 1
>>
>>  #include "config.h"
>> -#ifdef HAVE_VISIBILITY_HIDDEN
>> -#    define __visible        __attribute__((visibility("default")))
>> -#    define EXPORT_SYMBOL(x) typeof(x) (x) __visible
>> -#else
>> -#    define EXPORT_SYMBOL
>> -#endif
>>
>>  #endif
>
> Could you git rm src/internal.h there and resubmit?

Done, please find [1] - [PATCH v3] libmnl: Drop the EXPORT_SYMBOL() tags

> BTW, I would *really* appreciate if you send me similar patches for
> other libraries in the tree, to leave things in consistent state.

Sure, I'll check which libraries need to be patched and will submit
for review soon.

Best regards,
Neutron Soutmun

[1] https://marc.info/?l=netfilter-devel&m=144406670311242&w=2
