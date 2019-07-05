Return-Path: <SRS0=b56t=VC=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 63411C5B57D
	for <netfilter-devel@archiver.kernel.org>; Fri,  5 Jul 2019 08:25:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2898B218A3
	for <netfilter-devel@archiver.kernel.org>; Fri,  5 Jul 2019 08:25:32 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=cumulusnetworks.com header.i=@cumulusnetworks.com header.b="eMcRgBYS"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727113AbfGEIZb (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 5 Jul 2019 04:25:31 -0400
Received: from mail-wr1-f65.google.com ([209.85.221.65]:38351 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726601AbfGEIZb (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 5 Jul 2019 04:25:31 -0400
Received: by mail-wr1-f65.google.com with SMTP id p11so3485464wro.5
        for <netfilter-devel@vger.kernel.org>; Fri, 05 Jul 2019 01:25:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cumulusnetworks.com; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=QdI/+SYCsxY3INQuhw7JvmpOSaPdcwC03yXDxoauh68=;
        b=eMcRgBYSbFPn9Ig6FBm++m3rc1Cye/pYaPigJLOeUBQFd2yutFghxgh6eE2nSJEeQI
         zB9KDtX1Lx+bSRwHWtK2UI0au2xOR3vDON4hYXT+FvLIwmhdyDUXl84uJL6U+MBxLO+e
         wl38roNL4UgcF8vyHJ6w8fLzNxZodvm+oMlEI=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=QdI/+SYCsxY3INQuhw7JvmpOSaPdcwC03yXDxoauh68=;
        b=to4Q83xkR4BJx+BYepMZqeKV4hgMJWMsJxz+uN3Ulyx7CaqzNxwD/jpwPV7m23nKka
         KtwnYLBeben7WiOf9vr646iLr5eH6wAhud+XTJoaFPV558/cSFR0e58HP7z2973ZGjW8
         Ib6FzuopIy85WOGWMSm7DWtvRwm8+umUD14no55itklxiJI6tKZ6ZiM3h2Iftln/zpiS
         GCagdpLGld1NBn5hJICbFpdTe58Po5wweXxTmL/AIF/F7ArqE3l1E5somKBO/Qw3y+Ll
         E6ylVTX40F/enKpgbFbopLefl3aJ16TGJu46BkOWkF3sJbRjz5vSURRAv99uh6PeLkFd
         oPLQ==
X-Gm-Message-State: APjAAAUMzCWGRVlEuTV7qVMP5KL+zjM97/mon5v4mp0qSLP/vifCXZlg
        jUW8p0f5s5GPWZYFXa7L1+IU20b6C+ZtYQ==
X-Google-Smtp-Source: APXvYqzaXHgRS8ho7/358mwiQMYodkjXtM4Gb6lO97yClj8UHkbvPtb8jNzlUOYqLpBWoJ9cp00eSA==
X-Received: by 2002:a5d:4a02:: with SMTP id m2mr2668157wrq.193.1562315130141;
        Fri, 05 Jul 2019 01:25:30 -0700 (PDT)
Received: from [192.168.0.107] (84-238-136-197.ip.btc-net.bg. [84.238.136.197])
        by smtp.gmail.com with ESMTPSA id o6sm14729172wra.27.2019.07.05.01.25.29
        (version=TLS1_3 cipher=AEAD-AES128-GCM-SHA256 bits=128/128);
        Fri, 05 Jul 2019 01:25:29 -0700 (PDT)
Subject: Re: [PATCH 5/7 nf-next] bridge: add br_vlan_get_proto()
To:     wenxu@ucloud.cn, pablo@netfilter.org
Cc:     netfilter-devel@vger.kernel.org, bridge@lists.linux-foundation.org
References: <1562224955-3979-1-git-send-email-wenxu@ucloud.cn>
 <1562224955-3979-5-git-send-email-wenxu@ucloud.cn>
From:   Nikolay Aleksandrov <nikolay@cumulusnetworks.com>
Message-ID: <a598a8b7-caa5-af39-609e-42e53ecf3727@cumulusnetworks.com>
Date:   Fri, 5 Jul 2019 11:25:28 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <1562224955-3979-5-git-send-email-wenxu@ucloud.cn>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On 04/07/2019 10:22, wenxu@ucloud.cn wrote:
> From: wenxu <wenxu@ucloud.cn>
> 
> This new function allows you to fetch bridge vlan proto.
> 
> Signed-off-by: wenxu <wenxu@ucloud.cn>
> ---
>  include/linux/if_bridge.h |  6 ++++++
>  net/bridge/br_vlan.c      | 10 ++++++++++
>  2 files changed, 16 insertions(+)
> 


Acked-by: Nikolay Aleksandrov <nikolay@cumulusnetworks.com>
