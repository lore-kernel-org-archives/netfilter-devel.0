Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B49FCC4361B
	for <netfilter-devel@archiver.kernel.org>; Thu, 10 Dec 2020 13:19:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 66B9923DE8
	for <netfilter-devel@archiver.kernel.org>; Thu, 10 Dec 2020 13:19:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389061AbgLJNT3 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 10 Dec 2020 08:19:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49774 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1733083AbgLJNT3 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 10 Dec 2020 08:19:29 -0500
Received: from mail-wm1-x342.google.com (mail-wm1-x342.google.com [IPv6:2a00:1450:4864:20::342])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9F285C0613CF
        for <netfilter-devel@vger.kernel.org>; Thu, 10 Dec 2020 05:18:48 -0800 (PST)
Received: by mail-wm1-x342.google.com with SMTP id x22so4615198wmc.5
        for <netfilter-devel@vger.kernel.org>; Thu, 10 Dec 2020 05:18:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=6wind.com; s=google;
        h=reply-to:subject:to:cc:references:from:organization:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=uXFug7L9qWCZxkMjBVSkRdbtuecpl57hP8ucDW6WLRw=;
        b=czMNCueTFJ6lOtxXb5uP18KKU/snef1yz02FUwB+fKTJs+t3laonmdZFiqIzIsM778
         SYUurxVYpxyPS0talHxRGm/8bhUajMXmfVrpmkviq8Mw57M5hEyt0vIJy9q5RJa3owPz
         HjThABHN8WpX50daeK4GAiQbS+mTjBX+skdw3ZAQGFxdW8/6UchEnVrgnYBWlyj2coPk
         z6LJWTuaEDlr3u0RjFoL2VT/MrG8F7KkcIKEOeKmTHlsvDvdJj/cfBU+6Y/0aHYXjLrB
         UG/+q06Oaw/BkLAANTHC1uosV8Zt7MsEEmxUk3D3yWCIbsUsHign3gJ/YtJH5Y1P+ovc
         RPsA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:reply-to:subject:to:cc:references:from
         :organization:message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=uXFug7L9qWCZxkMjBVSkRdbtuecpl57hP8ucDW6WLRw=;
        b=Ad8+ADFYJOxq4d8dISa2XGNs6tHRnio206Zvae4eqUA3SPxYzqg1IZmjKSpK4TYMDQ
         7JEuq3wa92WEbASOhEj1ldA0hcmCBgpsa46N22kZimoi2mqcMm4xnXgMoPRdu+vC2qyH
         8yAAVTB/rAeODWDM/MhRqt1gygra3TFC0gkJuwjgOS/5TEHLCZmNZQK3fSNGOTUtCtNA
         kWJBY7blro2725glETwLVSezNHrWrzq8nOXTTFrb9zYytEkF7CVISVxlnjXDPX948Cl8
         n5yh+O1zw+CbUzlLTfQaTO5D06QGm6T5QSrPSmbe/qxbmRF+7HAEuT1zQUiNBXCytMlW
         TxHw==
X-Gm-Message-State: AOAM533hrJRdey2ERSfJhTsZVZ2xFQKze79Ye9YYgcRGVpI5ZXc45S2g
        37shhNBVob00w5/Azw2b/IRDXpwqrI23pg==
X-Google-Smtp-Source: ABdhPJyIVe4Snlnmp5/kOqWTycHtXFgYqhjPUNGDOxs9YFzTVtumWFc8jao0c8x+VMTeLwtn2/ZwCQ==
X-Received: by 2002:a05:600c:40ca:: with SMTP id m10mr8111055wmh.54.1607606327369;
        Thu, 10 Dec 2020 05:18:47 -0800 (PST)
Received: from ?IPv6:2a01:e0a:410:bb00:4889:96e0:4dc7:717b? ([2a01:e0a:410:bb00:4889:96e0:4dc7:717b])
        by smtp.gmail.com with ESMTPSA id 189sm9385205wma.22.2020.12.10.05.18.46
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 10 Dec 2020 05:18:46 -0800 (PST)
Reply-To: nicolas.dichtel@6wind.com
Subject: Re: [PATCH v2] xfrm: interface: Don't hide plain packets from
 netfilter
To:     Eyal Birger <eyal.birger@gmail.com>
Cc:     Phil Sutter <phil@nwl.cc>,
        Steffen Klassert <steffen.klassert@secunet.com>,
        linux-crypto@vger.kernel.org, netfilter-devel@vger.kernel.org,
        Linux Kernel Network Developers <netdev@vger.kernel.org>
References: <20201207134309.16762-1-phil@nwl.cc>
 <CAHsH6Gupw7o96e5hOmaLBCZtqgoV0LZ4L7h-Y+2oROtXSXvTxw@mail.gmail.com>
 <20201208185139.GZ4647@orbyte.nwl.cc>
 <CAHsH6GvT=Af-BAWK0z_CdrYWPn0qt+C=BRjy10MLRNhLWfH0rQ@mail.gmail.com>
 <9fc5cbb8-26c7-c1c2-2018-3c0cd8c805f4@6wind.com>
 <CAHsH6GsoavW+435MOTKy33iznMc_-JZ-kndr+G=YxuW7DWLNPA@mail.gmail.com>
From:   Nicolas Dichtel <nicolas.dichtel@6wind.com>
Organization: 6WIND
Message-ID: <b5c1259b-71e8-57d2-85f2-d5971f33e977@6wind.com>
Date:   Thu, 10 Dec 2020 14:18:45 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <CAHsH6GsoavW+435MOTKy33iznMc_-JZ-kndr+G=YxuW7DWLNPA@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Le 10/12/2020 à 12:48, Eyal Birger a écrit :
> Hi Nicolas,
Hi Eyal,

> 
> On Thu, Dec 10, 2020 at 1:10 PM Nicolas Dichtel
> <nicolas.dichtel@6wind.com> wrote:
[snip]
> I also think they should be consistent. But it'd still be confusing to me
> to get an OUTPUT hook on the inner packet in the forwarding case.
I re-read the whole thread and I agree with you. There is no reason to pass the
inner packet through the OUTPUT hook (my comment about the consistency with ip
tunnels is still valid ;-)).
Sorry for the confusion.

Phil, with nftables, you can match the 'kind' of the interface, that should be
enough to match packets, isn't it?


Regards,
Nicolas
