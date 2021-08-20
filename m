Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 78445C4338F
	for <netfilter-devel@archiver.kernel.org>; Fri, 20 Aug 2021 00:44:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4F495610CE
	for <netfilter-devel@archiver.kernel.org>; Fri, 20 Aug 2021 00:44:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237020AbhHTApH (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 19 Aug 2021 20:45:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44800 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236411AbhHTApG (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 19 Aug 2021 20:45:06 -0400
Received: from mail-pg1-x52d.google.com (mail-pg1-x52d.google.com [IPv6:2607:f8b0:4864:20::52d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 13ACDC061575;
        Thu, 19 Aug 2021 17:44:30 -0700 (PDT)
Received: by mail-pg1-x52d.google.com with SMTP id q2so7518071pgt.6;
        Thu, 19 Aug 2021 17:44:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-transfer-encoding:content-language;
        bh=mru2aAZhlzaUY/DrSDbPFG1xG59cnFQ9kByAf+CKxao=;
        b=TKF5VEjfsBL3RlYuiD3YFQZ84YGaYuZwzQGc2O3VCtQM6x6sv8PnRJG2huU0LKAL4y
         qAlxyadFiAmSDI9PNzsgT0CbjSuWJDMh7WMmSD/iXgHLGS0wqimRt+azoywk3rQABSjv
         nbyYTsD/DRngXuIAZhQDo4S3Qr8fSDU1FYVUJRGMjy2q0Me+ELf5FRibSThFH//b9xmI
         0eqtrJPd7jRDRf0F/h2KI5f0snzOipE2rDSluKwKqwsH2RWwLDkjqkvW97/O1hz6/NpW
         W20qTWjgm+TC+2clPntXE+dXzdta1DEloNczyqR/OzNLeJCkjhXF3wrNvxKMh280ci89
         wlSQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=mru2aAZhlzaUY/DrSDbPFG1xG59cnFQ9kByAf+CKxao=;
        b=MLAGGrCE4Iik41F7d8p/dJHqD/GvSr6QNtCGyS5c84v4ZCE7sMKvNy9oLkynLkwSgO
         zM6sNQh7pqFMxP8wgW8OLoN77yEz5F7wJ4E9cOvPW936rVXCQKigsLWbZymiGOzg8zs/
         W1BGsUpSSemJfaeJwx0JBEKutcb8mh9CmY7GIFPPK04zwEjBIWja1rmT2svbAxzzpvt8
         rxcSVHzPFq8KBgzNCtbNcFube8jiAdNTahzzKjJziFQD9kOWwjR0YCrIgIBbD3VKY0Xo
         2Xv6Emazccak+15q3d8Imlck1Lrou91TBhJxbP59qxFkURQnn4umiRSHroLxEcEKWpi9
         fCQQ==
X-Gm-Message-State: AOAM5308wed0r8U2Zzlm3a2SxaZd4HZRZDdKIj44NlC0h6j/SJe3jAU6
        Pw9iIGp9QQfKawfPKty3hyE=
X-Google-Smtp-Source: ABdhPJwTGCChxWC26jG1D7oswHP+QZodK8LdAgQYvEyKAJ7PJFdFOOP4Q+DfK3edraQTp4VQxoAbQg==
X-Received: by 2002:a65:4682:: with SMTP id h2mr16608280pgr.409.1629420268905;
        Thu, 19 Aug 2021 17:44:28 -0700 (PDT)
Received: from [192.168.43.134] ([49.32.150.144])
        by smtp.gmail.com with ESMTPSA id e26sm4729539pfj.46.2021.08.19.17.44.26
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 19 Aug 2021 17:44:28 -0700 (PDT)
Subject: Re: [ANNOUNCE] nftables 1.0.0 release
To:     Pablo Neira Ayuso <pablo@netfilter.org>,
        netfilter <netfilter@vger.kernel.org>,
        netfilter-devel <netfilter-devel@vger.kernel.org>
Cc:     lwn@lwn.net
References: <20210819173626.GA1776@salvia>
From:   Amish <anon.amish@gmail.com>
Message-ID: <ffc4dd4e-bbb1-0380-2cf2-7053fc3ab39c@gmail.com>
Date:   Fri, 20 Aug 2021 06:14:24 +0530
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.13.0
MIME-Version: 1.0
In-Reply-To: <20210819173626.GA1776@salvia>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org


On 19/08/21 11:06 pm, Pablo Neira Ayuso wrote:
> * Allow to combine jhash, symhash and numgen expressions with the
>    queue statement, to fan out packets to userspace queues via
>    nfnetlink_queue.
>
>    ... queue to symhash mod 65536
>    ... queue flags bypass to numgen inc mod 65536
>    ... queue to jhash oif . meta mark mod 32
>
>    You can also combine it with maps, to select the userspace queue
>    based on any other singleton key or concatenations:
>
>    ... queue flags bypass to oifname map { "eth0" : 0, "ppp0" : 2, "eth1" : 2 }

I upgraded from nftables 0.9.9 to 1.0.0 (Arch Linux).

Earlier I had this statement which used to work in nftables 0.9.9:

define ips_queue = 0
add rule ip foo snortips queue num $ips_queue bypass

And it gave error in nftables 1.0.0:

Aug 20 05:51:00 amish nft[3540]: /etc/nftables4.conf:19:49-54: Error: 
syntax error, unexpected bypass, expecting -
Aug 20 05:51:00 amish nft[3540]: add rule ip foo snortips queue num 
$ips_queue bypass

So I changed the rule to:
define ips_queue = 0
add rule ip foo snortips queue flags bypass num $ips_queue

But it still gave me error:

Aug 20 05:54:51 amish nft[3649]: /etc/nftables4.conf:19:61-61: Error: 
syntax error, unexpected newline, expecting -
Aug 20 05:54:51 amish nft[3649]: add rule ip foo snortips queue flags 
bypass num $ips_queue


Then I replaced $ips_queue directly with 0 (zero), and it worked.

add rule ip foo snortips queue flags bypass num 0

So why isn't nftables allowing defined variable?

It used to work till nft 0.9.9

Regards,

Amish

