Return-Path: <SRS0=/8pw=SU=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 028A4C282DC
	for <netfilter-devel@archiver.kernel.org>; Thu, 18 Apr 2019 02:02:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C49C92183E
	for <netfilter-devel@archiver.kernel.org>; Thu, 18 Apr 2019 02:02:21 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Z9I6BAym"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387534AbfDRCCP (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 17 Apr 2019 22:02:15 -0400
Received: from mail-pg1-f195.google.com ([209.85.215.195]:43732 "EHLO
        mail-pg1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729189AbfDRCCO (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 17 Apr 2019 22:02:14 -0400
Received: by mail-pg1-f195.google.com with SMTP id z9so400751pgu.10;
        Wed, 17 Apr 2019 19:02:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=s6InVlmwhf7nDs3US5FW36FMkwSol+9ahSHqxp3m2yw=;
        b=Z9I6BAymfGIMLS9r5mmp2sPOZsCGuZ+ND3z+VHRi98g3k3Lv8UtPuDqVwdMMMJPQoh
         RQkO8hd+afXPWlK1RFtuSTNGEpZL09zqMnFkHfuGuS8xGKPLzmuAqyF4dKjhSY+A2DOo
         i+B6vke8Mn66KdVOC1SFsgFV5Ul5TImSKnUIteE3d2bm0iboEsdoI5qUBsxUspo1dSEz
         Vehxd/tiPJwSmivjpheCMwpARar9uHm0kNhRgrGJYZ9wKvDXz0tTjeKdo7iqiR3wBoDv
         +0npKuOeH0oix3TWQnfqHUkgtuebPWga/3X+S6xPoPGYaXJkfjodLLylYnZl1JNKxvtd
         +MAA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=s6InVlmwhf7nDs3US5FW36FMkwSol+9ahSHqxp3m2yw=;
        b=ppUv1L2RRaYmIK2oAPWZ2vF9sVHAIOz4l3EaRugp7dOteeD1oC74Nbnjp1wkm9j9Ft
         miv1tUEIr9+dpSZNIoXF6CZYbPIJD9UG5TTwt2AbH/+Li31WfEebuyxGQWgNpMyL6669
         3S2bRhy/mOrf0fZsoSH57UFawu5KBfkI/5AM0ahwW7EGrXXd2jF2oGXo9LELKu6YQyQM
         3adrZFGbuz+dsUu/9YVt7QRH8iNDNV08Cbm6VtDeQ94cPViuWanMKbUN/jh8lFpGfXtZ
         roYsRv13cGIUbAVBtQV/reKSD/u6gADsQRwTea/90C897aB+exDyQoXfQWMo6I/zdoZz
         DRqw==
X-Gm-Message-State: APjAAAXSiKOb1m2IZZ4MfoSHDVYi4cwuqfNc3jjFm9HxGwylJzloosn1
        pPFc4HSbFOfAN9pOWZ32PAEwgVCo
X-Google-Smtp-Source: APXvYqwFHX7KZMX9OZYlaWc3EGUFw4QfeRCZJinlfDyzoj0HIU53oJJS3C/l2DwGMODVrLZFPlh54g==
X-Received: by 2002:aa7:914d:: with SMTP id 13mr93681451pfi.149.1555552934047;
        Wed, 17 Apr 2019 19:02:14 -0700 (PDT)
Received: from [192.168.86.235] (c-73-241-150-70.hsd1.ca.comcast.net. [73.241.150.70])
        by smtp.gmail.com with ESMTPSA id i10sm688579pfj.7.2019.04.17.19.02.12
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 17 Apr 2019 19:02:13 -0700 (PDT)
Subject: Re: [PATCH] ipvs:set sock send/receive buffer correctly
To:     linmiaohe <linmiaohe@huawei.com>,
        Eric Dumazet <eric.dumazet@gmail.com>, wensong@linux-vs.org,
        horms@verge.net.au, ja@ssi.bg, pablo@netfilter.org,
        kadlec@blackhole.kfki.hu, fw@strlen.de, davem@davemloft.net,
        netdev@vger.kernel.org, lvs-devel@vger.kernel.org,
        netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
        linux-kernel@vger.kernel.org
Cc:     Mingfangsen <mingfangsen@huawei.com>, liujie165@huawei.com
References: <501e5522-1d69-7c67-a1bc-fd8502d3b5d1@huawei.com>
 <60c11e72-99eb-fcde-e130-a35ecdc1d2d1@gmail.com>
 <bbfcccf4-626b-1029-62a6-a82b79edacbb@huawei.com>
From:   Eric Dumazet <eric.dumazet@gmail.com>
Message-ID: <a8ed41f3-1576-cbf6-907a-f501b3df189e@gmail.com>
Date:   Wed, 17 Apr 2019 19:02:11 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:52.0) Gecko/20100101
 Thunderbird/52.9.1
MIME-Version: 1.0
In-Reply-To: <bbfcccf4-626b-1029-62a6-a82b79edacbb@huawei.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org



On 04/17/2019 06:45 PM, linmiaohe wrote:
> 

> In fact, I just implemented this function with reference to
> sock_setsockopt(). When val * 2 overflow, we will set the
> buffer as SOCK_MIN_SNDBUF, just as sock_setsockopt() do.
> 

I do not think so.

Please check latest linux kernel, not some old version.

commit 4057765f2dee79cb92f9067909477303360be8d3    sock: consistent handling of extreme SO_SNDBUF/SO_RCVBUF values
