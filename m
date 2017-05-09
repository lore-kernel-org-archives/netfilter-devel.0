From: Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Subject: Re: .config for iptables icmp rule delete failure
Date: Mon, 8 May 2017 22:22:15 -0400
Message-ID: <CA+FuTSdikLZoOZDXLPG933DP6sBzqSU0s9DE7L+3Y4xMquK3fQ@mail.gmail.com>
References: <20170507204306.GW25861@madcap2.tricolour.ca> <20170508202236.GC9660@breakpoint.cc>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: Richard Guy Briggs <rgb@redhat.com>, fwestpha@redhat.com,
        netfilter-devel <netfilter-devel@vger.kernel.org>,
        pmoore@redhat.com, pvrabec@redhat.com
To: Florian Westphal <fw@strlen.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-wm0-f67.google.com ([74.125.82.67]:32891 "EHLO
        mail-wm0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751094AbdEICWt (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 8 May 2017 22:22:49 -0400
Received: by mail-wm0-f67.google.com with SMTP id y10so19286936wmh.0
        for <netfilter-devel@vger.kernel.org>; Mon, 08 May 2017 19:22:48 -0700 (PDT)
Received: from mail-wm0-f47.google.com (mail-wm0-f47.google.com. [74.125.82.47])
        by smtp.gmail.com with ESMTPSA id l7sm22835333wrc.52.2017.05.08.19.22.46
        for <netfilter-devel@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 08 May 2017 19:22:46 -0700 (PDT)
Received: by mail-wm0-f47.google.com with SMTP id u65so104618699wmu.1
        for <netfilter-devel@vger.kernel.org>; Mon, 08 May 2017 19:22:46 -0700 (PDT)
In-Reply-To: <20170508202236.GC9660@breakpoint.cc>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Mon, May 8, 2017 at 4:22 PM, Florian Westphal <fw@strlen.de> wrote:
> Richard Guy Briggs <rgb@redhat.com> wrote:
>
> [ CC'ing Willem ]
>
>> (Summary of IRC conversation for background...)
>> Paul Moore and I hit what appears to be a bug since f25's 4.10.11 and
>> upstream's 4.11-rc3 that would fail to locate on deletion an icmp rule
>> in iptables.  Paul narrowed it down to the icmp option.
>> Here's our issue where it came up:
>>       https://github.com/linux-audit/audit-testsuite/pull/43#issuecomment-296831880
>>
>> The test case is:
>> # iptables -t mangle -I INPUT -i lo -p icmp --icmp-type 1 -j MARK --set-mark 0xdeadbeef
>> # iptables -t mangle -D INPUT -i lo -p icmp --icmp-type 1 -j MARK --set-mark 0xdeadbeef
>> The error we're getting is "iptables: No chain/target/match by that name."
>
> This is a iptables (yes, userspace) bug exposed with
> f77bc5b23fb1af51fc0faa8a479dea8969eb5079
> (iptables: use match, target and data copy_to_user helpers)
>
> icmp is 4 byte in size, but for some silly(?) reason userspace size
> in iptables userland is set as XT_ALIGN(sizeof(ipt_icmp), so userspace
> thinks its 8.
>
> In 4.10, kernel copied the full kernel blob to userspace, and since
> its allocated with kz/vzalloc the 4 padding bytes are 0.
>
> libiptc uses malloc, so in case that contains garbage bytes the
> memcmp() used to figure out if we found the correct rule in libiptc
> during -D mode returns false because it chokes on the extra padding
> after struct ipt_icmp match :-/
>
> Simples fix is to use calloc/memset to 0 in libiptc, but we can't
> go with userspace-only fix ...
>
> So we have to fix this in the kernel and have xt_data_to_user()
> zero out any padding as well.
>
> Willem, if you don't have time to fix this let me know and i'll
> try to work on this tomorrow.

Thanks, Florian. Also for the detailed context. I'm having a look.
The following might be sufficient. It fixes the given example for me.

@@ -288,6 +288,10 @@ int xt_data_to_user(void __user *dst, const void *src,
        usersize = usersize ? : size;
        if (copy_to_user(dst, src, usersize))
                return -EFAULT;
+       size = XT_ALIGN(size);
        if (usersize != size && clear_user(dst + usersize, size - usersize))
                return -EFAULT;
