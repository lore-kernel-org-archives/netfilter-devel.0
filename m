From: John Stultz <john.stultz@linaro.org>
Subject: Re: [Regression?] iptables broken on 32bit with pre-4.7-rc
Date: Thu, 26 May 2016 14:00:35 -0700
Message-ID: <CALAqxLWFvLhV8V++dFnNu0C2zmwgTyy5EKsnx9BGFvVpa-CN5A@mail.gmail.com>
References: <CALAqxLXgAA=zV_AAOTkWE3yFaxNJ02y0jGwVrdTW+rSCrSUMkg@mail.gmail.com>
	<20160526095112.GA14828@breakpoint.cc>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: Pablo Neira Ayuso <pablo@netfilter.org>,
	lkml <linux-kernel@vger.kernel.org>,
	netfilter-devel@vger.kernel.org
To: Florian Westphal <fw@strlen.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-oi0-f49.google.com ([209.85.218.49]:35032 "EHLO
	mail-oi0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755114AbcEZVAg (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 26 May 2016 17:00:36 -0400
Received: by mail-oi0-f49.google.com with SMTP id w184so137200772oiw.2
        for <netfilter-devel@vger.kernel.org>; Thu, 26 May 2016 14:00:36 -0700 (PDT)
In-Reply-To: <20160526095112.GA14828@breakpoint.cc>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Thu, May 26, 2016 at 2:51 AM, Florian Westphal <fw@strlen.de> wrote:
> John Stultz <john.stultz@linaro.org> wrote:
>> In updating a 32bit arm device from 4.6 to Linus' current HEAD, I
>> noticed I was having some trouble with networking, and realized that
>> /proc/net/ip_tables_names was suddenly empty.
>>
>> Digging through the registration process, it seems we're catching on the:
>>
>>        if (strcmp(t->u.user.name, XT_STANDARD_TARGET) == 0 &&
>>            target_offset + sizeof(struct xt_standard_target) != next_offset)
>>                return -EINVAL;
>>
>> check added in 7ed2abddd20cf ("netfilter: x_tables: check standard
>> target size too").
>>
>> Where next_offset seems to be 4 bytes larger then the the offset +
>> standard_target struct size.
>
> I guess its because arm32 needs 8 byte alignment for 64bit
> quantities.  So we can fix this either via XT_ALIGN()'ing the
> target_offset + sizeof() result or by weakening the test to a '>'.
>
> Since we already test proper alignment of start-of-rule in
> check_entry_size_and_hooks() I'd suggest we just change the test
> to fail only if the next offset is within the min size, i.e.:
>
> diff --git a/net/netfilter/x_tables.c b/net/netfilter/x_tables.c
> index c69c892..9643047 100644
> --- a/net/netfilter/x_tables.c
> +++ b/net/netfilter/x_tables.c
> @@ -612,7 +612,7 @@ int xt_compat_check_entry_offsets(const void *base, const char *elems,
>                 return -EINVAL;
>
>         if (strcmp(t->u.user.name, XT_STANDARD_TARGET) == 0 &&
> -           target_offset + sizeof(struct compat_xt_standard_target) != next_offset)
> +           target_offset + sizeof(struct compat_xt_standard_target) > next_offset)
>                 return -EINVAL;
>
>         /* compat_xt_entry match has less strict aligment requirements,
> @@ -694,7 +694,7 @@ int xt_check_entry_offsets(const void *base,
>                 return -EINVAL;
>
>         if (strcmp(t->u.user.name, XT_STANDARD_TARGET) == 0 &&
> -           target_offset + sizeof(struct xt_standard_target) != next_offset)
> +           target_offset + sizeof(struct xt_standard_target) > next_offset)
>                 return -EINVAL;
>
>         return xt_check_entry_match(elems, base + target_offset,
>
>> I'm not exactly sure how the next_offset value is set, so I'm hoping
>> the proper fix is more obvious to one of you.
>
> Its the start of the next rule so it has to be properly aligned
> via XT_ALIGN().  Only 32bit system I tested was plain x86 which
> only needs 4byte alignment for u64...
>
> Alternative would be something like this:
>
> diff --git a/net/netfilter/x_tables.c b/net/netfilter/x_tables.c
> index c69c892..ca16c26 100644
> --- a/net/netfilter/x_tables.c
> +++ b/net/netfilter/x_tables.c
> @@ -612,7 +612,7 @@ int xt_compat_check_entry_offsets(const void *base, const char *elems,
>                 return -EINVAL;
>
>         if (strcmp(t->u.user.name, XT_STANDARD_TARGET) == 0 &&
> -           target_offset + sizeof(struct compat_xt_standard_target) != next_offset)
> +           XT_COMPAT_ALIGN(target_offset + sizeof(struct compat_xt_standard_target)) != next_offset)
>                 return -EINVAL;
>
>         /* compat_xt_entry match has less strict aligment requirements,
> @@ -694,7 +694,7 @@ int xt_check_entry_offsets(const void *base,
>                 return -EINVAL;
>
>         if (strcmp(t->u.user.name, XT_STANDARD_TARGET) == 0 &&
> -           target_offset + sizeof(struct xt_standard_target) != next_offset)
> +           XT_ALIGN(target_offset + sizeof(struct xt_standard_target)) != next_offset)
>                 return -EINVAL;
>
>         return xt_check_entry_match(elems, base + target_offset,
>
>
> but afaics the stricter check does not buy anything.

I can validate that either of these solutions solves the issue for me.
But I'll leave the pick of which to merge up to you. :)

Thanks so much for the quick response!
-john
