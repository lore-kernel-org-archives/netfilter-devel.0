Return-Path: <SRS0=jBJt=42=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0E279C10F29
	for <netfilter-devel@archiver.kernel.org>; Mon,  9 Mar 2020 10:26:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id CBA9A20409
	for <netfilter-devel@archiver.kernel.org>; Mon,  9 Mar 2020 10:26:47 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=wifirst-fr.20150623.gappssmtp.com header.i=@wifirst-fr.20150623.gappssmtp.com header.b="Dm9vQaw/"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726467AbgCIK0r (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 9 Mar 2020 06:26:47 -0400
Received: from mail-wm1-f66.google.com ([209.85.128.66]:34894 "EHLO
        mail-wm1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725956AbgCIK0r (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 9 Mar 2020 06:26:47 -0400
Received: by mail-wm1-f66.google.com with SMTP id m3so8959382wmi.0
        for <netfilter-devel@vger.kernel.org>; Mon, 09 Mar 2020 03:26:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=wifirst-fr.20150623.gappssmtp.com; s=20150623;
        h=subject:to:references:cc:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=yZxvxDg+hbcqiIhLuQKQHs5HqW2RLCMVMeb/r858Jmo=;
        b=Dm9vQaw/R4NeRPAOD2cagMNeA0/uN69jzBOYzK2v1MkbkS47ZKTruUr3+QBdnz1Pdd
         LsWZdf/XSWVNJmuXPZ1zx9UOYjPf6bJp1H7lJhR6MJKMsbCk16Qh2EdtAW0O3at4KdXQ
         16o+cfjJSG0Nk1svDIdCUIzk+djD1PD3dMwSNx7Qjdx4XKIMlR7R9sdBzRctroYu7e0P
         DuQJMZe2E3njpCL5jrsQFP+mePZaG/MKNRIKFqJ8hlU28Kkybgl9EVWezCv6+lGSqGGw
         kAhDpXqBCPve7rs4x9JyhPYKJVNyuMAXS7klcx0VIzcEvnk1qvGMTArNXo7nu7jAdU7D
         HFqQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:cc:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=yZxvxDg+hbcqiIhLuQKQHs5HqW2RLCMVMeb/r858Jmo=;
        b=S9fRz/qoRfotGR4HUOc/YtTb6fR/zxB+OoTnQm8BB8FOBCexXdOHVwb/1pi0Wb0acF
         1iY7KpblFWsE/AUnvZ6cgbm+AdVmoO+5G0w5Z1jpR/oq7ohp1Xb6TRzd0ULihMmzZozY
         Pocof5EVmo77QzDE8gFE7mZDbAeymPL/4bkmLOMDg9KRLZzFYgPo9n/XKZ93cyuA8eqx
         W5SaNu9lpFW1dZyTfYFSH8eU0Q731k7fU2sRpmzLLS5hgCJasL2V5zNePUTQDsOPWaiD
         UB3htMMO/+sq8h07A2tGZjDwLysszPLkZQT8CmO2kbMqDIMs0FQiU7VjvfpibH8lqxkx
         8d5g==
X-Gm-Message-State: ANhLgQ38Gcxr5gTsWGMUEYizhnFrkVgjKwLmfapsP4uHVte8V4H/pVwR
        yIvTOLh2pD2ALX6JCWvnX2oOi7hd3MU=
X-Google-Smtp-Source: ADFU+vv+I/0uYL04N3YjZS6S7M+CnNiOeZyXKGQaYP+XTJ5M3ZPCOcCTASLumhC/UCQ/9KoFAFzmTg==
X-Received: by 2002:a1c:63c4:: with SMTP id x187mr16858548wmb.124.1583749603864;
        Mon, 09 Mar 2020 03:26:43 -0700 (PDT)
Received: from [10.4.8.243] (wifirst-46-193-244.20.cust.wifirst.net. [46.193.244.20])
        by smtp.gmail.com with ESMTPSA id u1sm42046727wrt.78.2020.03.09.03.26.43
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 09 Mar 2020 03:26:43 -0700 (PDT)
Subject: Re: [PATCH nf-next V2] netfilter: ctnetlink: add kernel side
 filtering for dump
To:     Pablo Neira Ayuso <pablo@netfilter.org>
References: <20200129094642.610-1-romain.bellan@wifirst.fr>
Cc:     netfilter-devel@vger.kernel.org,
        Romain Bellan <romain.bellan@wifirst.fr>
From:   Florent Fourcot <florent.fourcot@wifirst.fr>
Message-ID: <e81fc1cc-03eb-4a8d-cf85-4c9876ad3d4c@wifirst.fr>
Date:   Mon, 9 Mar 2020 11:26:42 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <20200129094642.610-1-romain.bellan@wifirst.fr>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: fr
Content-Transfer-Encoding: 7bit
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Hello Pablo,

What do you think of this version, with related libnftnl patches? Can we 
improve it?

Best regards,

-- 
Florent.
