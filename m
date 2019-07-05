Return-Path: <SRS0=b56t=VC=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 61781C5B57D
	for <netfilter-devel@archiver.kernel.org>; Fri,  5 Jul 2019 08:23:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 15228218A3
	for <netfilter-devel@archiver.kernel.org>; Fri,  5 Jul 2019 08:23:17 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=cumulusnetworks.com header.i=@cumulusnetworks.com header.b="CQlzpE/J"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727092AbfGEIXQ (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 5 Jul 2019 04:23:16 -0400
Received: from mail-wm1-f67.google.com ([209.85.128.67]:38210 "EHLO
        mail-wm1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727074AbfGEIXQ (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 5 Jul 2019 04:23:16 -0400
Received: by mail-wm1-f67.google.com with SMTP id s15so8431812wmj.3
        for <netfilter-devel@vger.kernel.org>; Fri, 05 Jul 2019 01:23:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cumulusnetworks.com; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=SuddDTHB7Z8B8sUF248QER9k0T7rIWuLc0Ru7WUYpI8=;
        b=CQlzpE/JiVprrt8EiTO+bozfQKK8Y/Yo4zm31B3qCHkUQTMk8a4+Eff4PLY6l6cRyr
         XkE8646Rw53crfH57uOjDtBSPOHBctswexkDT5385oZ2EEvLoQp6byYLMUSxF9OhTX/b
         y3qQhK7+weZ8ks4JNowADfs+sFpy6s6/6kQgw=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=SuddDTHB7Z8B8sUF248QER9k0T7rIWuLc0Ru7WUYpI8=;
        b=IvmmQQfbHhCnUApEI3+Cd8V9t6SWzZc1VjOt5HYqYXglAUx08yqYjPVORcS1Phi6Sx
         Ae+fqMdloWBrcQLycn976KlHTP71KlYF5HP7XBGjgUJANaAkKLYaqyP69iodDng6tH8X
         Tn2UyCViXGtShsiDX89+XAWpzGV9QmjLQ4dc6v8ngObHXdK7lbhAlVl1dIeytnkteaPk
         Uq3V4gV+PFVKGSFCoJyQ85nC6AF0iTSPR+RbxkkxHj9oWOXcDv2+304/Z0MpZhTmHH0Q
         AKij6vFuNnDZY1wCUvHC2TpBQRcUopdjHSfVBt9+SLYRx8c6nWbw8VkmxBd7so1SePN9
         1sOw==
X-Gm-Message-State: APjAAAWPP4ZkXp4W9Jlx6GRn+iwjpwJZR1MFDDXaq/vVwTmMd0pEkxdP
        GC/PDEalTjiJx6ULV/wtLQbJHQ==
X-Google-Smtp-Source: APXvYqxdnZo7N3/z/bFZdw1B/goBTojtQ8+zC+jf1AbPoqUB+6h4+38BbJ/sPfkQvMMlRctGujI9XQ==
X-Received: by 2002:a05:600c:21d4:: with SMTP id x20mr2035423wmj.61.1562314994458;
        Fri, 05 Jul 2019 01:23:14 -0700 (PDT)
Received: from [192.168.0.107] (84-238-136-197.ip.btc-net.bg. [84.238.136.197])
        by smtp.gmail.com with ESMTPSA id r16sm21785293wrr.42.2019.07.05.01.23.13
        (version=TLS1_3 cipher=AEAD-AES128-GCM-SHA256 bits=128/128);
        Fri, 05 Jul 2019 01:23:13 -0700 (PDT)
Subject: Re: [PATCH 3/7 nf-next] bridge: add br_vlan_get_pvid_rcu()
To:     wenxu@ucloud.cn, pablo@netfilter.org
Cc:     netfilter-devel@vger.kernel.org, bridge@lists.linux-foundation.org
References: <1562224955-3979-1-git-send-email-wenxu@ucloud.cn>
 <1562224955-3979-3-git-send-email-wenxu@ucloud.cn>
From:   Nikolay Aleksandrov <nikolay@cumulusnetworks.com>
Message-ID: <df83723a-4dd5-7c38-4240-9ef47fde55cf@cumulusnetworks.com>
Date:   Fri, 5 Jul 2019 11:23:12 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <1562224955-3979-3-git-send-email-wenxu@ucloud.cn>
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
> This new function allows you to fetch bridge pvid from packet path.
> 
> Signed-off-by: wenxu <wenxu@ucloud.cn>
> ---
>  include/linux/if_bridge.h |  6 ++++++
>  net/bridge/br_vlan.c      | 19 +++++++++++++++----
>  2 files changed, 21 insertions(+), 4 deletions(-)
> 

While the patch looks fine, you've taken authorship of Pablo's patch.
From technical POV:
Acked-by: Nikolay Aleksandrov <nikolay@cumulusnetworks.com>


