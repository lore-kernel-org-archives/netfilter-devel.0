Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 742BFC4708D
	for <netfilter-devel@archiver.kernel.org>; Wed, 26 May 2021 15:06:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5D75C613D3
	for <netfilter-devel@archiver.kernel.org>; Wed, 26 May 2021 15:06:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235258AbhEZPHr (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 26 May 2021 11:07:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41644 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233472AbhEZPHr (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 26 May 2021 11:07:47 -0400
Received: from mail-wr1-x42a.google.com (mail-wr1-x42a.google.com [IPv6:2a00:1450:4864:20::42a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9770BC061574
        for <netfilter-devel@vger.kernel.org>; Wed, 26 May 2021 08:06:15 -0700 (PDT)
Received: by mail-wr1-x42a.google.com with SMTP id x8so1484823wrq.9
        for <netfilter-devel@vger.kernel.org>; Wed, 26 May 2021 08:06:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=6wind.com; s=google;
        h=reply-to:subject:to:cc:references:from:organization:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=IZUbYzYxrsViHDlvJajZuuPUz8bBlkbxvpmBeWEMGkI=;
        b=im9Ft60ASHVodRtZkgSyhLSn3g0yBiriFPnP/eOruxePVu78jZEMYfcLxAat7J1m7u
         SxBeuMgMoIwXmvt7zPNEvgOXjs985YemXqSpSbmcyC2HGY9/RK9SM/23CV9MG52zAHJW
         d5woMMmJrKTJ1DOLOO2F1RnsBP/OBLHcvm4wcTYUngtYBl9pYOKkIGxjeqp2X6u9Yy7a
         iUDvH76/mgsVtf5t2DlLMU0RtrnCA6uUaQHw7uePIZAQTi7tDBIBVizRsvdyX+vcEe2B
         890fcZduLmgousALFBadeogbe5F9T4Rogoo3JlufPLWSPKW5L0QZ52x50n9dN4SXWJD3
         fSXw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:reply-to:subject:to:cc:references:from
         :organization:message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=IZUbYzYxrsViHDlvJajZuuPUz8bBlkbxvpmBeWEMGkI=;
        b=RjRLIlUXkhz3Uwvm4xUtGwYcg+sbEVEME7nwXlcj4gBOnbG05LEFomL0C6svZIebqN
         KsTjk5WvJV1lbs+pzIw+Ol7DGkx3aFYRKcZ/nUdXMNUatWNDFx9fVWDlfOVBwb+dBubC
         adZdmrwIXTw2dP+COtbRKcCHfaYmMZlQ4a08oxwzBCTWJbQdu9/ypxuV/DMa9Z16zv5G
         5pN90lfA/JP7etl/8K693h/KQqwiJasvIiZMU71n7y9DHra7Qv6D9rj0DALOGcHq1xtl
         b/ibhYldt/4gssi/HqWadmbmf4nAbLaopfeg92VSgUxw27bTOmhQ05sgq1OodfbGzb81
         CcPg==
X-Gm-Message-State: AOAM530D18QMq11w4Smt8pwb0Z+nfQSWldtwlSv4bPV+JCJPgkzOVY38
        xr0OXeWWtzrxbe4iM78pcLVVSp4rTp94hg==
X-Google-Smtp-Source: ABdhPJx07h3u7aXdbrXuvWEt/VfGB9c1JgZ8VEHrivrcpyGC83aI8UKtN8nZ/784sEHG+w58xfYZIQ==
X-Received: by 2002:a05:6000:1541:: with SMTP id 1mr33473675wry.364.1622041574226;
        Wed, 26 May 2021 08:06:14 -0700 (PDT)
Received: from ?IPv6:2a01:e0a:410:bb00:907f:22ed:6bd2:e2b9? ([2a01:e0a:410:bb00:907f:22ed:6bd2:e2b9])
        by smtp.gmail.com with ESMTPSA id f188sm6753095wmf.24.2021.05.26.08.06.13
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 26 May 2021 08:06:13 -0700 (PDT)
Reply-To: nicolas.dichtel@6wind.com
Subject: Re: [PATCH] netfilter: conntrack: add new sysctl to disable RST check
To:     Ali Abdallah <ali.abdallah@suse.com>
Cc:     netfilter-devel@vger.kernel.org
References: <20210526092444.lca726ghsrli5fpx@Fryzen495>
 <e48eac1e-dd8e-52c2-3a15-a9404933d1dd@6wind.com>
 <20210526143454.2x3riukvcz4b322s@Fryzen495>
From:   Nicolas Dichtel <nicolas.dichtel@6wind.com>
Organization: 6WIND
Message-ID: <97089f6c-9889-0824-8aea-6fada4a93b20@6wind.com>
Date:   Wed, 26 May 2021 17:06:13 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
MIME-Version: 1.0
In-Reply-To: <20210526143454.2x3riukvcz4b322s@Fryzen495>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Le 26/05/2021 à 16:34, Ali Abdallah a écrit :
> On 26.05.2021 16:29, Nicolas Dichtel wrote:
>>> +nf_conntrack_tcp_ignore_invalid_rst - BOOLEAN
>>> +	- 0 - disabled (default)
>>> +	- not 0 - enabled
>> If I correctly read the patch, the only "not 0" possible value is 1. Why not
>> using explicitly "1"?
> 
> That what the doc on nf_conntrack_tcp_be_liberal says as well, logically
> not 0 is 1, so IMHO I don't think that can lead to confusion.

There is a lot of sysctl that have several magic values, see
https://www.kernel.org/doc/Documentation/networking/ip-sysctl.txt

And some act like boolean but accept all values,
/proc/sys/net/ipv4/conf/*/forwarding for example.

There is nothing obvious with sysctl values (and a lot of inconsistencies), it's
why I suggest to be explicit.

Regards,
Nicolas
