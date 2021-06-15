Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 932C9C48BE5
	for <netfilter-devel@archiver.kernel.org>; Tue, 15 Jun 2021 07:12:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 66D5A61417
	for <netfilter-devel@archiver.kernel.org>; Tue, 15 Jun 2021 07:12:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230060AbhFOHO5 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 15 Jun 2021 03:14:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51466 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229493AbhFOHOz (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 15 Jun 2021 03:14:55 -0400
Received: from mail-wm1-x336.google.com (mail-wm1-x336.google.com [IPv6:2a00:1450:4864:20::336])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 44367C061574
        for <netfilter-devel@vger.kernel.org>; Tue, 15 Jun 2021 00:12:51 -0700 (PDT)
Received: by mail-wm1-x336.google.com with SMTP id t4-20020a1c77040000b029019d22d84ebdso988741wmi.3
        for <netfilter-devel@vger.kernel.org>; Tue, 15 Jun 2021 00:12:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=6wind.com; s=google;
        h=reply-to:subject:to:cc:references:from:organization:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=kEhS8WbNxJAAxy+rRYN5HF72Ei2eiyxrBNTYMUGogrM=;
        b=WEznw+gSNTwaNg9bTgABcEpoGQeieROV0X/07g0yo0lSPpifCt3g2VgXN6qSY8jS95
         BuCXxyQJOLY2Mw8Ux4V46YjbEHHzO2TV00hdXO6BIgyhjAJ7Y38egCe68BGoDWOog4lj
         Wb/xZWDfgMMJ6S9YN4HEk/5GHQ4tiZPPpl9UnL9bVikad8VCxHzv1bvA2YkZQL/2mB7j
         PKmVyfEAsRhXIv1AkAjPutaMduvtVCG06QzlpXqyWSqEuf8mmeFNTtYbODfYNA9QaB6c
         MghLkJ3vVpUPqFcGKMMakp42bBtR28MPUTIQnCUQvm65VP8sPDV+Yw9xYsZf+sg6bMGI
         o59w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:reply-to:subject:to:cc:references:from
         :organization:message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=kEhS8WbNxJAAxy+rRYN5HF72Ei2eiyxrBNTYMUGogrM=;
        b=VFvp/yxerq/KiggIdQ+DNRVWMhlO1Gqjzo22K8GkA6rsVwmc+qYOfEjbRaur6BLUl5
         8UAfkeLKPezIn7yQ1g0SgCRY9FntDJQnnUMVASPITkOTdVTkZ4ALN8vspbxIruyPp7TA
         gfB2lb+Yuj1E9UO0WBqLwOgkGpTTitJNt3SKGmlvWc2CEovJcysYZHEQxbaZ02FfdGZ1
         es1UM60+N7r+PulhlWni1dIPdlDXgLG+F1/jQXS/2hv9NZ+hYEqOLm39BDgU0hasZ2zT
         AAxqpv/tSeTSS02+jSxlFYbVYO1fiE8dnP54jJkoA69yFUe5lz8AV/ZBJM3CGBNlmkqp
         z0Yg==
X-Gm-Message-State: AOAM530euRxLJ8NjxfwYcNEkkZepj14sDdq4MLEz2RCpARCJ9KB7e48W
        u1Jabo28nuGJFKk/O0tQCC/SqA==
X-Google-Smtp-Source: ABdhPJzmLwFT9XQvACf8HmmCLcNkB+g8HpiIn+v/HmS5WF8h4UfFYwdUc497xEnSDW5xUBxjmQB+MA==
X-Received: by 2002:a7b:c10b:: with SMTP id w11mr3492332wmi.186.1623741169903;
        Tue, 15 Jun 2021 00:12:49 -0700 (PDT)
Received: from ?IPv6:2a01:e0a:410:bb00:ddd2:2038:ae02:164a? ([2a01:e0a:410:bb00:ddd2:2038:ae02:164a])
        by smtp.gmail.com with ESMTPSA id k5sm18893753wrv.85.2021.06.15.00.12.48
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 15 Jun 2021 00:12:49 -0700 (PDT)
Reply-To: nicolas.dichtel@6wind.com
Subject: Re: [PATCH nf] MAINTAINERS: netfilter: add irc channel
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org,
        Arturo Borrero Gonzalez <arturo@netfilter.org>,
        netdev <netdev@vger.kernel.org>
References: <20210528084849.19058-1-nicolas.dichtel@6wind.com>
 <9b60107e-dcd4-3ca0-f83d-0e51ccf5d67c@6wind.com>
 <20210614171712.GA28746@salvia>
From:   Nicolas Dichtel <nicolas.dichtel@6wind.com>
Organization: 6WIND
Message-ID: <bc0680f0-c15c-95ac-3f17-6b403ffdd741@6wind.com>
Date:   Tue, 15 Jun 2021 09:12:48 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
MIME-Version: 1.0
In-Reply-To: <20210614171712.GA28746@salvia>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Le 14/06/2021 à 19:17, Pablo Neira Ayuso a écrit :
> On Mon, Jun 14, 2021 at 03:18:00PM +0200, Nicolas Dichtel wrote:
>> Le 28/05/2021 à 10:48, Nicolas Dichtel a écrit :
>>> The community #netfilter IRC channel is now live on the libera.chat network
>>> (https://libera.chat/).
>>>
>>> CC: Arturo Borrero Gonzalez <arturo@netfilter.org>
>>> Link: https://marc.info/?l=netfilter&m=162210948632717
>>> Signed-off-by: Nicolas Dichtel <nicolas.dichtel@6wind.com>
>> I have no feedback on this. Is there a problem to add the irc channel in the
>> MAINTAINERS file?
> 
> *Problem*? Nah.
;-)

> 
> I'll add this patch to the nf queue.
> 
Thanks Pablo.
