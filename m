From: Shivani Bhardwaj <shivanib134@gmail.com>
Subject: Re: [PATCH iptables] configure: Fix logic to show connlabel support
Date: Wed, 22 Jun 2016 22:15:57 +0530
Message-ID: <CAKHNQQHzW_xSXkn79Ega1=QkqVAf81bungh=KVAHu=S7fnBgEA@mail.gmail.com>
References: <1466604637-26536-1-git-send-email-shivanib134@gmail.com> <20160622163026.GC10213@breakpoint.cc>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: Netfilter Development Mailing list
	<netfilter-devel@vger.kernel.org>
To: Florian Westphal <fw@strlen.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-vk0-f67.google.com ([209.85.213.67]:34024 "EHLO
	mail-vk0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751848AbcFVQqh (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 22 Jun 2016 12:46:37 -0400
Received: by mail-vk0-f67.google.com with SMTP id w1so8850882vka.1
        for <netfilter-devel@vger.kernel.org>; Wed, 22 Jun 2016 09:46:37 -0700 (PDT)
In-Reply-To: <20160622163026.GC10213@breakpoint.cc>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Wed, Jun 22, 2016 at 10:00 PM, Florian Westphal <fw@strlen.de> wrote:
> Shivani Bhardwaj <shivanib134@gmail.com> wrote:
>> With the earlier logic, when libnfnetlink and libnetfilter_conntrack
>> were not installed, all the warnings showed up correctly but the final
>> configuration showed:
>>
>>             connlabel support:                      yes
>>
>> which was faulty.
>> This was happening because connlabel module was blacklisted first and
>> then set to "no" if package requirements were not met.
>
> its because ...
>
>> diff --git a/configure.ac b/configure.ac
>> index c91e9e7..131bc8b 100644
>> --- a/configure.ac
>> +++ b/configure.ac
>> @@ -173,9 +173,9 @@ if test "x$enable_connlabel" = "xyes"; then
>>               [nfconntrack=1], [nfconntrack=0])
>>
>>       if test "$nfconntrack" -ne 1; then
>> +             enable_connlabel="no";
>>               blacklist_modules="$blacklist_modules connlabel";
>>               echo "WARNING: libnetfilter_conntrack not found, connlabel match will not be built";
>> -             enable_connlabel = "no";
>
> ... of the space around the '=', shell tried to execute
> 'enable_connlabel' command here.

Thanks. I'm sorry for misinterpreting and writing the wrong message. I
shall resend the patch.
