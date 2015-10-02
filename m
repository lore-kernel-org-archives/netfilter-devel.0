From: Neutron Soutmun <neo.neutron@gmail.com>
Subject: Re: [PATCH] libmnl: Drop the EXPORT_SYMBOL() tags
Date: Fri, 2 Oct 2015 08:38:03 +0700
Message-ID: <CAMQP0skhJLGDBYSSLePZTE4TvdBh7fAKkQrcpvEi2hDhax6bJw@mail.gmail.com>
References: <20151001110521.GA11642@oxygen>
	<20151001165035.GB2107@salvia>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-ig0-f179.google.com ([209.85.213.179]:37169 "EHLO
	mail-ig0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751049AbbJBBiE (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 1 Oct 2015 21:38:04 -0400
Received: by igbni9 with SMTP id ni9so7533360igb.0
        for <netfilter-devel@vger.kernel.org>; Thu, 01 Oct 2015 18:38:03 -0700 (PDT)
In-Reply-To: <20151001165035.GB2107@salvia>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Thu, Oct 1, 2015 at 11:50 PM, Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> On Thu, Oct 01, 2015 at 06:05:21PM +0700, Neutron Soutmun wrote:
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
> Do we need the internal.h file anymore?

I think, "no".

If what the consensus think is the same, please find the
updated patch [1] - [PATCH v2] libmnl: Drop the EXPORT_SYMBOL() tags


Best regards,
Neutron Soutmun

[1] https://marc.info/?l=netfilter-devel&m=144374965006777&w=2
