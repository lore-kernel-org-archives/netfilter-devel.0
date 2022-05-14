Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9E11EC433EF
	for <netfilter-devel@archiver.kernel.org>; Sat, 14 May 2022 19:14:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234856AbiENTOm (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sat, 14 May 2022 15:14:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53536 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234855AbiENTOl (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sat, 14 May 2022 15:14:41 -0400
Received: from mail-io1-xd31.google.com (mail-io1-xd31.google.com [IPv6:2607:f8b0:4864:20::d31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 509FA2FFD2
        for <netfilter-devel@vger.kernel.org>; Sat, 14 May 2022 12:14:40 -0700 (PDT)
Received: by mail-io1-xd31.google.com with SMTP id m6so12131663iob.4
        for <netfilter-devel@vger.kernel.org>; Sat, 14 May 2022 12:14:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Xl5dx5nkeIO2nTicw9oEQ3qg8OUN+HFJRd1+tjJwjiE=;
        b=b420JXIQ7eTCXfEoUzr9WOeI8yzKLnh0grpFGFiYvHayDFsRdXTqsQP+Vj8uBHZfnR
         qq5nAG/XBcMwYCAaSuNANn8o9oDgqmL6mLart6CZTwtDPMn4UrtQLp2ayxLk2b7E0QBT
         ED1L2jym2QZ/cZt9YwG4JvQ0FNq3MqrGc/f8cWhEm3dw3bA5w3n6dLAHFZqZ63KRJo8v
         GVkTC+Zs20bSWSw3ZX3Wjn03dU7efsfcQ4WU7OQ8fQT/NRsNI3KS7cs4RvNPPMuI6yGE
         y9JjQTYZhlewWfMWnTJk3OH7enijw4556vs/qtH56Th6B81samcxnxdgeyhA8H4p7eSx
         Y1mQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Xl5dx5nkeIO2nTicw9oEQ3qg8OUN+HFJRd1+tjJwjiE=;
        b=4yKpz2x9C7uHhEXz2BGpR6lIiAy+5XCLZdZ9f8RHxoaj2Kam8Qf6KoreDRu14gW2Fx
         TUtEGumwxRXbDDiEV73TSMV/er2RcaKZBrbXjOHUVj/eIcLApNmjFF+onNHSVKSRbpDU
         OE/sWR2GxXsHRu8VJZnHdeK7YAdxqxkVhJ7oRCFlUp8ELMZTUOcxW7Na4oKItsnfcZc1
         acm+C89p07kp+fmXw2sgqdg75/DxLgIS5rwZlIiOxRYdGsZjOUdBw0xOGPIIjAsZWr36
         zVUUZYuQkmGDwOphpO9wcicdal6VVbDXbVNXqr0JggSSOLP3ziRYS0WMiCw1M6i9poPh
         EClA==
X-Gm-Message-State: AOAM531veN/0cEhVMyq+Yazz77OISZYSGc+9M9wR0XaG8zrm3MwXEeeZ
        jThjhSq3LiFZA4HN30fT+ngZiTFpBJPUGOufe1l3nQ==
X-Google-Smtp-Source: ABdhPJxHEDKEM3SrOiW7WfvDEBSFvmVGnf44qtxdtBFq7SpVcV5Vfn9CdujZypG7upqiZuslBOpHtiTrWoZGiLvWimE=
X-Received: by 2002:a05:6638:2496:b0:32b:7c1b:b523 with SMTP id
 x22-20020a056638249600b0032b7c1bb523mr5420949jat.198.1652555679461; Sat, 14
 May 2022 12:14:39 -0700 (PDT)
MIME-Version: 1.0
References: <20220514163325.54266-1-vincent@systemli.org> <Yn/hMODAkEEbzQno@orbyte.nwl.cc>
In-Reply-To: <Yn/hMODAkEEbzQno@orbyte.nwl.cc>
From:   =?UTF-8?Q?Maciej_=C5=BBenczykowski?= <maze@google.com>
Date:   Sat, 14 May 2022 12:14:27 -0700
Message-ID: <CANP3RGfP4Et8PCviNLLUJNHBCbo-B53UkaZfZJyqHBu_Ccs3Ow@mail.gmail.com>
Subject: Re: [PATCH iptables 1/2] xtables: fix compilation with musl
To:     Phil Sutter <phil@nwl.cc>, Nick Hainke <vincent@systemli.org>,
        Netfilter Development Mailing List 
        <netfilter-devel@vger.kernel.org>,
        =?UTF-8?Q?Maciej_=C5=BBenczykowski?= <maze@google.com>
Cc:     =?UTF-8?Q?Maciej_=C5=BBenczykowski?= <zenczykowski@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Sat, May 14, 2022 at 10:04 AM Phil Sutter <phil@nwl.cc> wrote:
> On Sat, May 14, 2022 at 06:33:24PM +0200, Nick Hainke wrote:
> > Only include <linux/if_ether.h> if glibc is used.
>
> This looks like a bug in musl? OTOH explicit include of linux/if_ether.h
> was added in commit c5d9a723b5159 ("fix build for missing ETH_ALEN
> definition"), despite netinet/ether.h being included in line 2248 of
> libxtables/xtables.c. So maybe *also* a bug in bionic?!

You stripped the email you're replying to, and while I'm on lkml and
netdev - with my personal account - I'm not (apparently) subscribed to
netfilter-devel (or I'm not subscribed from work account).
Either way, if my search-fu is correct you're replying to
https://marc.info/?l=netfilter-devel&m=165254651011397&w=2

+#if defined(__GLIBC__)
 #include <linux/if_ether.h> /* ETH_ALEN */
+#endif

and you're presumably CC'ing me due to

https://git.netfilter.org/iptables/commit/libxtables/xtables.c?id=c5d9a723b5159a28f547b577711787295a14fd84

which added the include in the first place...:

fix build for missing ETH_ALEN definition
(this is needed at least with bionic)

+#include <linux/if_ether.h> /* ETH_ALEN */

Based on the above, clearly adding an 'if defined GLIBC' wrapper will
break bionic...
and presumably glibc doesn't care whether the #include is done one way
or the other?

Obviously it could be '#if !defined MUSL' instead...

As for the fix?  And whether glibc or musl or bionic are wrong or not...
Utterly uncertain...

Though, I will point out #include's 2000 lines into a .c file are kind of funky.

Ultimately I find
https://android.git.corp.google.com/platform/external/iptables/+/7608e136bd495fe734ad18a6897dd4425e1a633b%5E%21/

+#ifdef __BIONIC__
+#include <linux/if_ether.h> /* ETH_ALEN */
+#endif

which is in aosp to this day... see:
https://android.git.corp.google.com/platform/external/iptables/+/refs/heads/master/libxtables/xtables.c#48

If I revert that (ie. remove the above 3 lines), then aosp compilation fails:

external/iptables/libxtables/xtables.c:2144:45: error: use of
undeclared identifier 'ETH_ALEN'
static const unsigned char mac_type_unicast[ETH_ALEN] =   {};
                                            ^
...etc...

which suggests the "#include <netinet/ether.h>" immediately before
that isn't sufficient.

I think that should include

https://cs.android.com/android/platform/superproject/+/master:bionic/libc/include/netinet/ether.h

which should #include <netinet/if_ether.h> which is

https://cs.android.com/android/platform/superproject/+/master:bionic/libc/include/netinet/if_ether.h

which should #include <linux/if_ether.h>

but... only #if defined(__USE_BSD)

is the problem perhaps the lack of __USE_BSD?

And indeed defining __USE_BSD just before the include:

+#define __USE_BSD 1
 #include <netinet/ether.h>

fixes the build on aosp (with the 3 lines still removed).

But I have no idea if we should or should not #define __USE_BSD ...
And who / what is actually wrong...
