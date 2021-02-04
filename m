Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.5 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MISSING_SUBJECT,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 334EDC433DB
	for <netfilter-devel@archiver.kernel.org>; Thu,  4 Feb 2021 19:06:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 02DF164F5E
	for <netfilter-devel@archiver.kernel.org>; Thu,  4 Feb 2021 19:06:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239596AbhBDTGX (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 4 Feb 2021 14:06:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57224 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239540AbhBDTFj (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 4 Feb 2021 14:05:39 -0500
Received: from mail-qk1-x736.google.com (mail-qk1-x736.google.com [IPv6:2607:f8b0:4864:20::736])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8E8FAC06178B
        for <netfilter-devel@vger.kernel.org>; Thu,  4 Feb 2021 11:04:58 -0800 (PST)
Received: by mail-qk1-x736.google.com with SMTP id 19so4443908qkh.3
        for <netfilter-devel@vger.kernel.org>; Thu, 04 Feb 2021 11:04:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=solutti.com.br; s=google2;
        h=to:from:message-id:date:user-agent:mime-version
         :content-transfer-encoding:content-language;
        bh=O+KhWljHJj9RTRyG743lyLZ/y3N16cg1s2qitFDCHHk=;
        b=eXfAmc09SqEtBI/fyMXgZjsuFBQ0g0h2LXCKhw6Qc/8tYDF4RgPgTMOP/43ZXj7ApJ
         L/wCVY4YQJPH7x3fp2S0RtpCHCqS7cNHtbfmfIY7Of8CjWMUS4ktRhxxKe9+WfcPRL7l
         9lUwZiWeCG4idNJZ398gzhLxbxgHSSFCXwdSYoqlS/JH16tV/6BL9GSypsznERJ9TGrj
         KE/0J3Rrs84VRZd0YIR66Op0qbnaYiR3o7Ost+KhclVBQloRIQLu1lw+AitN49ac/haP
         YESkDX381Yl9N1sgRDvdT1OHeQg00WvokH7zn5UsOjeos90kj2Pyuz5oPuL4yivRxVEW
         jTVg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:from:message-id:date:user-agent:mime-version
         :content-transfer-encoding:content-language;
        bh=O+KhWljHJj9RTRyG743lyLZ/y3N16cg1s2qitFDCHHk=;
        b=iAdzhUYjyh2dhu5LTKHkOMY/RLFBu0yzev7rw4A/kDqWOEPN1Wd5JDmv3hUUGxgptR
         WWyq4HZIX9yDxKt7AxJWtqykXaoSlOkdY80rc9EdWdV+VMGPgJMhb+jaY7vJ4JbD0IPu
         pDa13CLdxCzRm41m5SOH345QBOHhFznkCIv7L/Ts4sCL6VwkAyakazFtqvikr3niQvig
         QBrZt3w+1R+/JBXo+ZfYwf8/F5wzq0jgWgvBeQxv39DgruaUmtxLbBS+EaRmbgdOqj6J
         GpY1D2Xkc9CfUkplIP1FmGsJH9CAkUpFkksJEv/JXek8xrJXk+wf939GtvyBiQeBfkQr
         HHlA==
X-Gm-Message-State: AOAM530gBIcVnUPEKqBSFGhyfd3glzY2VJ49U32x9I3W+2Aj0rzMG2Q7
        BaiWR5w+mNsx+7Y8hFdTdhn0f5BvRtq+jA==
X-Google-Smtp-Source: ABdhPJwOsaKtY0CfaJRuh32deZvaY8ZnJo2n6+U4+eX6hxf1EIZN/IawyUbf0/c267BCGiZ+XhMFIw==
X-Received: by 2002:a05:620a:152c:: with SMTP id n12mr585530qkk.447.1612465497583;
        Thu, 04 Feb 2021 11:04:57 -0800 (PST)
Received: from [172.16.0.50] ([187.72.224.244])
        by smtp.gmail.com with ESMTPSA id 16sm5209548qtp.38.2021.02.04.11.04.56
        for <netfilter-devel@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 04 Feb 2021 11:04:57 -0800 (PST)
To:     netfilter-devel@vger.kernel.org
From:   Leonardo Rodrigues <leolistas@solutti.com.br>
Message-ID: <218b6575-384a-78a0-195b-76ab3c98cfa2@solutti.com.br>
Date:   Thu, 4 Feb 2021 16:04:54 -0300
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.0
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: quoted-printable
Content-Language: pt-BR
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

unsubscribe netfilter-devel

--=20


	Atenciosamente / Sincerily,
	Leonardo Rodrigues
	Solutti Tecnologia
	http://www.solutti.com.br

	Minha armadilha de SPAM, N=C3=83O mandem email
	gertrudes@solutti.com.br
	My SPAMTRAP, do not email it



