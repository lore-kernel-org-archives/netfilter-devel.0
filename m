Return-Path: <SRS0=IQIq=VI=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E2C96C74A4D
	for <netfilter-devel@archiver.kernel.org>; Thu, 11 Jul 2019 08:07:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B640120838
	for <netfilter-devel@archiver.kernel.org>; Thu, 11 Jul 2019 08:07:31 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=resnulli-us.20150623.gappssmtp.com header.i=@resnulli-us.20150623.gappssmtp.com header.b="frJoerEE"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728247AbfGKIHb (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 11 Jul 2019 04:07:31 -0400
Received: from mail-wm1-f68.google.com ([209.85.128.68]:34978 "EHLO
        mail-wm1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727796AbfGKIHb (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 11 Jul 2019 04:07:31 -0400
Received: by mail-wm1-f68.google.com with SMTP id l2so4720948wmg.0
        for <netfilter-devel@vger.kernel.org>; Thu, 11 Jul 2019 01:07:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=bN+BI6wIdU+MoWOdnpXpLGxCTIW1Fg0blX+8NzdMUmY=;
        b=frJoerEEtdkSn2e0SezwtrVPop8uFIljey35yuKI7YCdhlmsB4rmkfw4jTlGzoWV+K
         7pIPdTiueDXIYLIi4x0IIhQXJvdZngrpahtoq/BjvVuPdSX0devuVaVbAs/HeMfn5Bt9
         uYo1qgMA2EgpTOSpTzFix8P1AAFcILn7XeRGx8Pze6Inj/Wnbs8t57UlQQfobXZAsy3o
         VNi7ZKgKQ88yxCsTid3+trJJVilrKSjzoqKtPvUe3NhO8QTC61raUH+nyWOZ7p3PtxGE
         iO0VOrA+vdjpB7Ynaalbi3WRtqEIfX3hn5U47Kc1DGswEGAY2mbxogQT0xE4H3k0W8/j
         hm4A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=bN+BI6wIdU+MoWOdnpXpLGxCTIW1Fg0blX+8NzdMUmY=;
        b=Lwwsg0W3reJ/ZA/b6Uyq9T2dfT48z6VB1KCPefFEQ2z57ZQQxN2YndV45kfuJn/+P/
         SLeFCopf1IrN7Y1QxdLNluaDF0fekZTOGkewg5bcGqZ6WbtXfdGu/VjMmYYiEsRqzqyQ
         26QYaEGh6TFt+hplWhDYtJKjWF6oqbK734KN8Fn0sy9RKNwB/KSBOmflEc+Y+DKjQbJR
         TEhvgGFnSBFYhzw7uGM5AqKm2b3EDwJrTIiHxpi3/dx5QmGa+sFsz/E6C1QVT841CBH8
         bXrOxGkK67AmZduJ08bXcdeUidYliFzT/lhxdcIHRzLaZ1Nje3KD/z4Klber9vFEMXVF
         ldbA==
X-Gm-Message-State: APjAAAW21t4Cj5WMehh/QTkb9tToZC1UXtJ9ewNSnPP8B+y/WPIHCH1M
        jnYfi3rQS3j2Z77TFW5dax0=
X-Google-Smtp-Source: APXvYqwFCk/2hg2gUoTbuWNo6ul2C70lsXx8D7T6+bRqvhQcCegN6k5QvNvs4bihylTJ9Yj6IBj6lw==
X-Received: by 2002:a7b:c38c:: with SMTP id s12mr2538541wmj.71.1562832449192;
        Thu, 11 Jul 2019 01:07:29 -0700 (PDT)
Received: from localhost (ip-89-176-1-116.net.upcbroadband.cz. [89.176.1.116])
        by smtp.gmail.com with ESMTPSA id c78sm5041017wmd.16.2019.07.11.01.07.28
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Thu, 11 Jul 2019 01:07:28 -0700 (PDT)
Date:   Thu, 11 Jul 2019 10:07:28 +0200
From:   Jiri Pirko <jiri@resnulli.us>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org, davem@davemloft.net,
        netdev@vger.kernel.org, jakub.kicinski@netronome.com
Subject: Re: [PATCH net-next 2/3] net: flow_offload: rename tc_setup_cb_t to
 flow_setup_cb_t
Message-ID: <20190711080728.GG2291@nanopsycho>
References: <20190711001235.20686-1-pablo@netfilter.org>
 <20190711001235.20686-2-pablo@netfilter.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190711001235.20686-2-pablo@netfilter.org>
User-Agent: Mutt/1.11.4 (2019-03-13)
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Thu, Jul 11, 2019 at 02:12:34AM CEST, pablo@netfilter.org wrote:
>Rename this type definition and adapt users.
>
>Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>

Acked-by: Jiri Pirko <jiri@mellanox.com>
