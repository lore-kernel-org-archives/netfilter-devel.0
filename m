From: Alexandru Ardelean <ardeleanalex@gmail.com>
Subject: Re: [PATCH] ulogd: add +1 char for null char
Date: Wed, 22 Mar 2017 09:07:26 +0200
Message-ID: <CA+U=DsoLF=6pOyH+7-+6Shi8ihEBTfbvxFWrvy47kKVDEm7sZg@mail.gmail.com>
References: <1489998667-15183-1-git-send-email-ardeleanalex@gmail.com> <1490129693.2157.21.camel@regit.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: netfilter-devel@vger.kernel.org
To: Eric Leblond <eric@regit.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-pg0-f53.google.com ([74.125.83.53]:33676 "EHLO
        mail-pg0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752115AbdCVHOg (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 22 Mar 2017 03:14:36 -0400
Received: by mail-pg0-f53.google.com with SMTP id w20so2438338pgc.0
        for <netfilter-devel@vger.kernel.org>; Wed, 22 Mar 2017 00:14:35 -0700 (PDT)
In-Reply-To: <1490129693.2157.21.camel@regit.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Tue, Mar 21, 2017 at 10:54 PM, Eric Leblond <eric@regit.org> wrote:
> Hello,
>
> Thanks for the report and the patch. I'm not sure of your
> implementation. Can you test with the patch to follow ?
>
> On Mon, 2017-03-20 at 10:31 +0200, Alexandru Ardelean wrote:
>> This is a bit zealous to fix like this, but it seems to work.
>>
>> The crash was reproduced on ppc32, with GCC 5.4 & musl libc 1.1.16.
>>
>> And also on LEDE (mips_24kc and ARM):
>> https://github.com/openwrt/packages/issues/4123
>> https://github.com/openwrt/packages/issues/4090
>>
>> I personally saw it on ppc32.
>> The offending code was in `pluginstance_alloc_init()` line 671:
>> ```
>> memcpy(pi->id, pi_id, sizeof(pi->id));
>> ```
>
> Thanks in advance,
> --
> Eric Leblond <eric@regit.org>

Hey,

Thanks for the response.
Will test out your patch & come back.

After submitting mine, there was a similar discussion on one of the
Github threads [to use strncpy()/strlcpy()].

A few questions:
1) would strlcpy(d,s,len) be better [here & in general] ?  [since it
guarantees a null-char at the end of `len`] ?
1a) maybe it could be considered to replace strncpy() in more places
[where the case is appropriate]
2) any thoughts on sanitizing the use of ULOGD_MAX_KEYLEN ? ; general
gist of it would be #define ULOGD_MAX_KEYLEN 32  and remove any
`ULOGD_MAX_KEYLEN+1`  or   `ULOGD_MAX_KEYLEN-1` ; which sort of seemed
confusing ; and combined with strlcpy() it should give an overall more
robust approach

Thanks
Alex
