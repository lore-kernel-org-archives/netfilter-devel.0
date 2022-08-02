Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 68425C00140
	for <netfilter-devel@archiver.kernel.org>; Tue,  2 Aug 2022 18:14:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230175AbiHBSOe (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 2 Aug 2022 14:14:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33242 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230050AbiHBSOd (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 2 Aug 2022 14:14:33 -0400
Received: from mail-qv1-xf2e.google.com (mail-qv1-xf2e.google.com [IPv6:2607:f8b0:4864:20::f2e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E55E824F29
        for <netfilter-devel@vger.kernel.org>; Tue,  2 Aug 2022 11:14:31 -0700 (PDT)
Received: by mail-qv1-xf2e.google.com with SMTP id d1so9755608qvs.0
        for <netfilter-devel@vger.kernel.org>; Tue, 02 Aug 2022 11:14:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=mentovai.com; s=google;
        h=mime-version:references:message-id:in-reply-to:subject:to:from:date
         :from:to:cc;
        bh=PLwOp8NzmjH3Y9Bf/1hntqkD7OIryqYL+a9USo2o3ko=;
        b=c/TmtpCaueVz0wNDEn9xaPIIwerGzZcwt2HobIzg1ygGDv+mcu7zllCraaOS8aeVxo
         nMQrLQAOw5Z5mnxdrs0nSpeVj7LsiOVAtFIaQDM6jxV6EwzYCgwkXa8Y0ZaDTU+cS5XV
         /yqJexxpyLV8D+DIDYh5hYIQjF6RAm8YRCeVU=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=mime-version:references:message-id:in-reply-to:subject:to:from:date
         :x-gm-message-state:from:to:cc;
        bh=PLwOp8NzmjH3Y9Bf/1hntqkD7OIryqYL+a9USo2o3ko=;
        b=rGPqzz4GFjAUZIdWgyCMyRbozJPTMVhqmo9W37Ztm4gSp4RmK97BmcgElYU8r3c2m4
         ZXsik297JI2rxQWm4OX3gzRTrEbNihzR+Rtgk5ZzhcwDG9AtUGxp2mMBoHEEl8nofdlS
         VLx9vNetOLumsGjVHM58Goa+Tv5TKYlr6D7IUjwqSnqDqhl2Q+870ldZH67RfLuQAnUT
         Kl2lppaSY3joYayGboGgMTRYZbis3yy/it0Bvxede2Xyh+gjl00tKdpLPLy9Rla4l58T
         SGcdFwaEgDzcwGNJwc1YhJDsKb7gynEV/xvYD3sqpqqq3M4Sg1ndz71MEkeQvwPdOGaF
         hkgg==
X-Gm-Message-State: ACgBeo0gV2f3XvU0BnDiqRB1AhOsMusLhhTLMTquxe7pfbmrA5l61R2k
        XoMl/QjN8sMmnTwydDaYFcxLlX4TePog1mnI
X-Google-Smtp-Source: AA6agR6u2rEsXsycwbFId/BVvbpd42FdjvBNfzPbbden3rOSsItw7ni/aVY26Udkkr4NNUyO0gtJkQ==
X-Received: by 2002:a05:6214:21a3:b0:473:2161:f820 with SMTP id t3-20020a05621421a300b004732161f820mr19552235qvc.123.1659464070894;
        Tue, 02 Aug 2022 11:14:30 -0700 (PDT)
Received: from [2620:0:1003:512:a092:150f:e1ed:ac04] ([2620:0:1003:512:a092:150f:e1ed:ac04])
        by smtp.gmail.com with ESMTPSA id y25-20020ac85259000000b0033a7d89e27bsm1303176qtn.22.2022.08.02.11.14.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 02 Aug 2022 11:14:30 -0700 (PDT)
Date:   Tue, 2 Aug 2022 14:14:29 -0400 (EDT)
From:   Mark Mentovai <mark@mentovai.com>
To:     Duncan Roe <duncan_roe@optusnet.com.au>,
        Netfilter Development <netfilter-devel@vger.kernel.org>
Subject: Re: [PATCH libmnl] build: doc: refer to bash as bash, not
 /bin/bash
In-Reply-To: <YuhyM1TE7a/vTjFu@slk15.local.net>
Message-ID: <2152a8fd-a06f-bad2-fbae-36828e4919a@mentovai.com>
References: <20220801172620.34547-1-mark@mentovai.com> <YuhyM1TE7a/vTjFu@slk15.local.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII; format=flowed
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Duncan Roe wrote:
> On Mon, Aug 01, 2022 at 01:26:20PM -0400, Mark Mentovai wrote:
>> This locates bash according to its presence in the PATH, not at a
>> hard-coded path which may not exist or may not be the most suitable bash
>> to use.
>>
>> Signed-off-by: Mark Mentovai <mark@mentovai.com>
>> ---
>>  doxygen/Makefile.am | 2 +-
>>  1 file changed, 1 insertion(+), 1 deletion(-)
>>
>> diff --git a/doxygen/Makefile.am b/doxygen/Makefile.am
>> index 29078dee122a..189a233f3760 100644
>> --- a/doxygen/Makefile.am
>> +++ b/doxygen/Makefile.am
>> @@ -21,7 +21,7 @@ doxyfile.stamp: $(doc_srcs) Makefile.am
>>  # The command has to be a single line so the functions work
>>  # and so `make` gives all lines to `bash -c`
>>  # (hence ";\" at the end of every line but the last).
>> -	/bin/bash -p -c 'declare -A renamed_page;\
>> +	bash -p -c 'declare -A renamed_page;\
>>  main(){ set -e; cd man/man3; rm -f _*;\
>>    count_real_pages;\
>>    rename_real_pages;\
>> --
>> 2.37.1
>>
> I would not apply this patch unless it's actually necessary for some
> distribution.
>
> If you have discovered a distribution where /bin/bash doesn't work, please let
> us know.
>
> Scripts that start "#!/bin/bash" are not uncommon, and Netfilter already has a
> couple of these, in libnetfilter_queue and libnetfilter_log.
>
> I somehow omitted to update libmnl to replace the cumbersome embedded script in
> Makefile.am with a stand-alone script, but you've reminded me.
>
> Cheers ... Duncan.

The context here is in OpenWrt, 
https://github.com/openwrt/openwrt/commit/beeb49740bb4. The use of 
/bin/bash is a problem during a cross build of libmnl, with a build system 
running macOS or BSD. /bin/bash on macOS is an unsuitably old version, and 
the OpenWrt build ensures that a recent bash is available in PATH. BSD 
derivatives tend not to have /bin/bash at all, although bash may be 
present elsewhere in PATH. Again, the OpenWrt build ensures this.

I would not expect the same treatment to be strictly necessary for scripts 
like libnetfilter_queue or libnetfilter_log, which run on the target 
system, but the reliance on /bin/bash is a problem for cross builds and in 
particular non-Linux build systems. Considering that these cross builds 
are otherwise perfectly clean given an appropriate toolchain, it seems 
unnecessary to leave them broken for something like this, when a simple 
reliance on locating bash via PATH ought to suffice for everyone.

Mark
