Return-Path: <SRS0=cZSN=YJ=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8BCF2ECE599
	for <netfilter-devel@archiver.kernel.org>; Wed, 16 Oct 2019 20:51:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5AC80207FF
	for <netfilter-devel@archiver.kernel.org>; Wed, 16 Oct 2019 20:51:20 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="miScS8+c"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727806AbfJPUvU (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 16 Oct 2019 16:51:20 -0400
Received: from mail-pg1-f177.google.com ([209.85.215.177]:42955 "EHLO
        mail-pg1-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727156AbfJPUvT (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 16 Oct 2019 16:51:19 -0400
Received: by mail-pg1-f177.google.com with SMTP id f14so9875680pgi.9
        for <netfilter-devel@vger.kernel.org>; Wed, 16 Oct 2019 13:51:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=to:from:subject:message-id:date:user-agent:mime-version
         :content-transfer-encoding:content-language;
        bh=mE8KgPtgfjmRtLiqTEmiADVQTDcU7JQy6/WcTmCeXbk=;
        b=miScS8+cShqCN77dJcPp2omJEXadDMumDna30lqgdwsoxiqOHF26iKhLyvwNKA/yYR
         QjVuIf82W24Jr31M/www7Ue630ku2tnkPk990o2k9ViQv9N1PtxNvGG9As8AwSCD2LdI
         D5Kue8SGhsJjAy1KP23+A41IAtFmexP/Ib6aR/VdtVJWC4vFPMhZJwExqgeDOln8hJNM
         N715qVjZYTnE7mEJpWsuDk54OwnUjaWiSkItGX3E6ZYZWHheWkSrBNOIDlJP4a6ymtks
         HPf838l9AklvuziSSnQk8eqoRLZ18WtrSTFX4HjWbAyYhDlUcLLAbG38Pm+v6fjOEJa0
         L3Mw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:from:subject:message-id:date:user-agent
         :mime-version:content-transfer-encoding:content-language;
        bh=mE8KgPtgfjmRtLiqTEmiADVQTDcU7JQy6/WcTmCeXbk=;
        b=dylMIEwtyMmDHLVO+xlR2KeQx4q1kh8OOSz1psGiE3IsidN78rnFAI2gQ+B+W9lRrn
         Ff0Fk7UTNij50jDahhZlT4XsnPRb6b+IVJNJnoDnce1pVgy6mpyBF47iAbC/lzE+y4eX
         hrmZcYUUgpp56VMZ648Qvo5ARYJoaEhKVys+0ECxpbz/YNMxarKPl59psvdmMFC5ajJP
         +kt61PdAIqSUBnnL4GraPc8RCDBfv6p6ylWyFByePfp7zLQwe1iIOBgvnbe45rsHuFy9
         tT7T3fxVPRxog8hIcChFGOdLkAkeepulWfrE6FL8kN02R3KWiG+c/QEysgzHlfJI2Kwh
         L+tQ==
X-Gm-Message-State: APjAAAVk2tZBdXOvsMbBnrZOng3ke1rFIgsnDOeogSHBLcl6nmIT9G6a
        Y8sQcSVtck5g52KQ5kv6hNzfKmXT
X-Google-Smtp-Source: APXvYqyHEsdjYUy76P1kggYmyU3+8gnr0JncfBs4dEJzcJBLPgQhm0BmOqQo/R0j2v+GLOW8E80+FQ==
X-Received: by 2002:a62:3203:: with SMTP id y3mr45443477pfy.221.1571259078456;
        Wed, 16 Oct 2019 13:51:18 -0700 (PDT)
Received: from [192.168.0.77] ([78.19.104.55])
        by smtp.gmail.com with ESMTPSA id m68sm28982194pfb.122.2019.10.16.13.51.16
        for <netfilter-devel@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 16 Oct 2019 13:51:17 -0700 (PDT)
To:     netfilter-devel@vger.kernel.org
From:   Dmitri Seletski <drjoms@gmail.com>
Subject: feature request, way to check specific IP/port/protocol/etc
Message-ID: <74c57209-2f6e-5cc9-d64b-e2e0eddcae6e@gmail.com>
Date:   Wed, 16 Oct 2019 21:50:33 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Hello Dear IPTABLES/Netfilter Devs.


Thank you very much for your efforts.

I am strong  believer, that if you don't do something yourself - it wont 
be done.
With that said, I am no coder.(No C coder and not a competent by any 
stretch of imagination)


I have come across a situation where I need to write a script. In this 
script would be nice to check if specific port is opened. I checked 
iptables --help and I can't seem to find an easy way to check it.

I can do something like iptables -Ln and get a range and try to work 
around that. But I think it would be better to implement couple of ideas 
below:


1. To make a new option. Similar to -L , that will verbosely show all 
subnets/port ranges. So user can grep anything that may be remotely 
relevant. And yes I understand it may take a lot of time in some cases, 
but sometimes CPU time is a commodity you do have.

2. To make new option. May be call it -S, that will search, based on 
parameters, any and all rules that match for e.g. specific port or IP or 
protocol or combination of those.

So for example, -S -p tcp -s 127.0.0.1 -d 192.168.0.1

should show any rules that match search criteria above  and default 
policy. In other words likely to affect tcp ip coomunication between 
127.0.0.1 and 192.168.0.1

Which will give indication to script writers, if communication between 
script or some other app is possible to outside of the machine or to 
other VM or some other such stuff.

It's my first suggestion to a big list like this. So hit me on the face 
with soldier boots, but gently please. English is not my native tongue, 
so if you need clarification of stuff I have written above -  I'd be 
very happy to try to insult your intelligence with my attempts at 
english again.


Kind Regards

Dmitri

