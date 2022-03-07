Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1F44BC433F5
	for <netfilter-devel@archiver.kernel.org>; Mon,  7 Mar 2022 13:39:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237004AbiCGNku (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 7 Mar 2022 08:40:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60982 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235471AbiCGNkt (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 7 Mar 2022 08:40:49 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 62CBB85BE4
        for <netfilter-devel@vger.kernel.org>; Mon,  7 Mar 2022 05:39:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1646660394;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=CtoXzlWdMjEaTdkHRpRbjU16+CzIWpJ5Gk6mnrIwGKc=;
        b=YL3HMcElSneMp/r9xt782uwEf6IPZUCxf8TnqHY1xWWFpEMDy1yiQqL5Sq5nCsfU3gy/SF
        99h6K5K8WgFTGA50z1K3TJ+mGa/CPvW+Xl600+5rjMIPsx9tt7Bm+kkIYK+MzrjMc5v1Pl
        6mSS/1B+we3FTbexyYFEgQAXTTzEWeg=
Received: from mail-ot1-f72.google.com (mail-ot1-f72.google.com
 [209.85.210.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-356-zhm1tJpiNE2sYZU6PyyHyw-1; Mon, 07 Mar 2022 08:39:53 -0500
X-MC-Unique: zhm1tJpiNE2sYZU6PyyHyw-1
Received: by mail-ot1-f72.google.com with SMTP id t16-20020a9d7290000000b005b24005289dso777053otj.11
        for <netfilter-devel@vger.kernel.org>; Mon, 07 Mar 2022 05:39:53 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=CtoXzlWdMjEaTdkHRpRbjU16+CzIWpJ5Gk6mnrIwGKc=;
        b=O6GYHc4UvFW3cvWrzGV7YIMg4TyfXqVVLv8Jqw7f+8P72stJNUqoBAHDjUTLCcVhPn
         UkR68PBsra9AaRpA7MzFCUZb5PEgyS5uBHTQax67ID4uE7/bg3izhhpx/gv30tUuJovi
         CT2BlJguXFr5YK1c2fCh1D7YDuZ202j5W9wKSqeiwkU2D0jSV2sxG/P2GJ5zE+MZYUEI
         8O1+CcWX30o4PGkthoHEgsnjYIK0JbVhCgHmAvOnitsduZSMrkdQ6fnFpwmWBGT+NncZ
         Y97k6NibfF9PyRJsgUwAwuQemIxdUQwGTgqzDLpYuiiD5j1FPZnjJF6stYFCSrkhfEZs
         F7bA==
X-Gm-Message-State: AOAM530uoeJA60uylKDRJODwh3TxkIgXPHi78mn0zk/tb5wWPeMrFMDq
        mzRtzUUOEDkLPA7ECQ9+UTh4orll9+UyV7XX5SeztPa6e8jvHkmT32Lo5yevbvAL4g8D7pgKWOa
        x2gH7CfGsGc0VH8E1BFuRZBh3y1Y2
X-Received: by 2002:a05:6830:2646:b0:5b0:29e9:b623 with SMTP id f6-20020a056830264600b005b029e9b623mr5525176otu.266.1646660392492;
        Mon, 07 Mar 2022 05:39:52 -0800 (PST)
X-Google-Smtp-Source: ABdhPJzGLrIi2ki38vAlN8pwDU2wa+0EYJY5++5iZgmYWGYscX8JZBaezJHnxs4oMV1319QYnLYyHA==
X-Received: by 2002:a05:6830:2646:b0:5b0:29e9:b623 with SMTP id f6-20020a056830264600b005b029e9b623mr5525166otu.266.1646660392286;
        Mon, 07 Mar 2022 05:39:52 -0800 (PST)
Received: from localhost.localdomain (024-205-208-113.res.spectrum.com. [24.205.208.113])
        by smtp.gmail.com with ESMTPSA id m26-20020a05680806da00b002d797266870sm6326213oih.9.2022.03.07.05.39.51
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 07 Mar 2022 05:39:51 -0800 (PST)
Subject: Re: [PATCH] netfilter: conditionally use ct and ctinfo
To:     Florian Westphal <fw@strlen.de>
Cc:     pablo@netfilter.org, kadlec@netfilter.org, davem@davemloft.net,
        kuba@kernel.org, netfilter-devel@vger.kernel.org,
        coreteam@netfilter.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20220305180853.696640-1-trix@redhat.com>
 <20220307124652.GB21350@breakpoint.cc>
From:   Tom Rix <trix@redhat.com>
Message-ID: <b795685f-6cdb-5493-8280-75749ddb0f6f@redhat.com>
Date:   Mon, 7 Mar 2022 05:39:49 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <20220307124652.GB21350@breakpoint.cc>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org


On 3/7/22 4:46 AM, Florian Westphal wrote:
> trix@redhat.com <trix@redhat.com> wrote:
>> From: Tom Rix <trix@redhat.com>
>>
>> The setting ct and ctinfo are controlled by
>> CONF_NF_CONNTRACK.  So their use should also
>> be controlled.
> Any reason for this change?

Define and use are connected. Doing something to one without doing 
something to the other doesn't make sense.

Could removing the CONF_NF_CONNTRACK be done for the define side ?

Tom

> We try to avoid ifdef where possible, unless it avoids a compiler
> warning/build/linker issue.
>
> This doesn't change generated code for me (NF_CONNTRACK=n) either.
>

