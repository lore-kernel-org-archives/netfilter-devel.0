From: Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Subject: Re: .config for iptables icmp rule delete failure
Date: Tue, 9 May 2017 00:47:37 -0400
Message-ID: <CA+FuTSdaLvUYf4scq1ohVS+veM82qp2girjbDpVO2tfSr5qcnw@mail.gmail.com>
References: <20170507204306.GW25861@madcap2.tricolour.ca> <20170508202236.GC9660@breakpoint.cc>
 <CA+FuTSdikLZoOZDXLPG933DP6sBzqSU0s9DE7L+3Y4xMquK3fQ@mail.gmail.com> <CA+FuTSd5-_vTODJsQ+8C2uMSYsZM9f8zf=VyOLVqSzd=SO6BKw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: Florian Westphal <fw@strlen.de>,
        Richard Guy Briggs <rgb@redhat.com>, fwestpha@redhat.com,
        netfilter-devel <netfilter-devel@vger.kernel.org>,
        pmoore@redhat.com, pvrabec@redhat.com
To: Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-wr0-f193.google.com ([209.85.128.193]:35802 "EHLO
        mail-wr0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750909AbdEIEsL (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 9 May 2017 00:48:11 -0400
Received: by mail-wr0-f193.google.com with SMTP id g12so11237715wrg.2
        for <netfilter-devel@vger.kernel.org>; Mon, 08 May 2017 21:48:11 -0700 (PDT)
Received: from mail-wm0-f43.google.com (mail-wm0-f43.google.com. [74.125.82.43])
        by smtp.gmail.com with ESMTPSA id s72sm21823134wmb.18.2017.05.08.21.48.08
        for <netfilter-devel@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 08 May 2017 21:48:09 -0700 (PDT)
Received: by mail-wm0-f43.google.com with SMTP id 142so86777156wma.1
        for <netfilter-devel@vger.kernel.org>; Mon, 08 May 2017 21:48:08 -0700 (PDT)
In-Reply-To: <CA+FuTSd5-_vTODJsQ+8C2uMSYsZM9f8zf=VyOLVqSzd=SO6BKw@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Tue, May 9, 2017 at 12:18 AM, Willem de Bruijn <willemb@google.com> wrote:
> On Mon, May 8, 2017 at 10:22 PM, Willem de Bruijn
> <willemdebruijn.kernel@gmail.com> wrote:
>> On Mon, May 8, 2017 at 4:22 PM, Florian Westphal <fw@strlen.de> wrote:
>>> Richard Guy Briggs <rgb@redhat.com> wrote:
>>>
>>> [ CC'ing Willem ]
>>>
>>>> (Summary of IRC conversation for background...)
>>>> Paul Moore and I hit what appears to be a bug since f25's 4.10.11 and
>>>> upstream's 4.11-rc3 that would fail to locate on deletion an icmp rule
>>>> in iptables.  Paul narrowed it down to the icmp option.
>>>> Here's our issue where it came up:
>>>>       https://github.com/linux-audit/audit-testsuite/pull/43#issuecomment-296831880
>>>>
>>>> The test case is:
>>>> # iptables -t mangle -I INPUT -i lo -p icmp --icmp-type 1 -j MARK --set-mark 0xdeadbeef
>>>> # iptables -t mangle -D INPUT -i lo -p icmp --icmp-type 1 -j MARK --set-mark 0xdeadbeef
>>>> The error we're getting is "iptables: No chain/target/match by that name."
>>>
>>> This is a iptables (yes, userspace) bug exposed with
>>> f77bc5b23fb1af51fc0faa8a479dea8969eb5079
>>> (iptables: use match, target and data copy_to_user helpers)
>>>
>>> icmp is 4 byte in size, but for some silly(?) reason userspace size
>>> in iptables userland is set as XT_ALIGN(sizeof(ipt_icmp), so userspace
>>> thinks its 8.
>>>
>>> In 4.10, kernel copied the full kernel blob to userspace, and since
>>> its allocated with kz/vzalloc the 4 padding bytes are 0.
>>>
>>> libiptc uses malloc, so in case that contains garbage bytes the
>>> memcmp() used to figure out if we found the correct rule in libiptc
>>> during -D mode returns false because it chokes on the extra padding
>>> after struct ipt_icmp match :-/
>>>
>>> Simples fix is to use calloc/memset to 0 in libiptc, but we can't
>>> go with userspace-only fix ...
>>>
>>> So we have to fix this in the kernel and have xt_data_to_user()
>>> zero out any padding as well.
>>>
>>> Willem, if you don't have time to fix this let me know and i'll
>>> try to work on this tomorrow.
>>
>> Thanks, Florian. Also for the detailed context. I'm having a look.
>> The following might be sufficient. It fixes the given example for me.
>>
>> @@ -288,6 +288,10 @@ int xt_data_to_user(void __user *dst, const void *src,
>>         usersize = usersize ? : size;
>>         if (copy_to_user(dst, src, usersize))
>>                 return -EFAULT;
>> +       size = XT_ALIGN(size);
>>         if (usersize != size && clear_user(dst + usersize, size - usersize))
>>                 return -EFAULT;
>
> This works for me on 64-bit, where __alignof__(struct _xt_align) is 8.
> In a 32-bit environment it is 4. I will need to revise it to work correctly
> for compat. See also COMPAT_XT_ALIGN.

This works for both cases. It requires changing the callers in ebtables,
unfortunately.

diff --git a/net/netfilter/x_tables.c b/net/netfilter/x_tables.c
index f134d384852f..29ae5fbd0c08 100644
--- a/net/netfilter/x_tables.c
+++ b/net/netfilter/x_tables.c
@@ -283,12 +283,14 @@ static int xt_obj_to_user(u16 __user *psize, u16 size,
                       &U->u.user.revision, K->u.kernel.TYPE->revision)

 int xt_data_to_user(void __user *dst, const void *src,
-                   int usersize, int size)
+                   int usersize, int size, int aligned_size)
 {
        usersize = usersize ? : size;
        if (copy_to_user(dst, src, usersize))
                return -EFAULT;
-       if (usersize != size && clear_user(dst + usersize, size - usersize))
+       if (usersize != aligned_size &&
+           clear_user(dst + usersize, aligned_size - usersize))
                return -EFAULT;

        return 0;
@@ -298,7 +300,9 @@ EXPORT_SYMBOL_GPL(xt_data_to_user);
 #define XT_DATA_TO_USER(U, K, TYPE, C_SIZE)                            \
        xt_data_to_user(U->data, K->data,                               \
                        K->u.kernel.TYPE->usersize,                     \
-                       C_SIZE ? : K->u.kernel.TYPE->TYPE##size)
+                       C_SIZE ? : K->u.kernel.TYPE->TYPE##size,        \
+                       C_SIZE ? COMPAT_XT_ALIGN(C_SIZE) :              \
+                                XT_ALIGN(K->u.kernel.TYPE->TYPE##size))
