Return-Path: <SRS0=hDGH=VH=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A5128C73C7C
	for <netfilter-devel@archiver.kernel.org>; Wed, 10 Jul 2019 07:52:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7237F20693
	for <netfilter-devel@archiver.kernel.org>; Wed, 10 Jul 2019 07:52:30 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=resnulli-us.20150623.gappssmtp.com header.i=@resnulli-us.20150623.gappssmtp.com header.b="qzxxD21Z"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726996AbfGJHwa (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 10 Jul 2019 03:52:30 -0400
Received: from mail-wm1-f66.google.com ([209.85.128.66]:40849 "EHLO
        mail-wm1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726043AbfGJHwa (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 10 Jul 2019 03:52:30 -0400
Received: by mail-wm1-f66.google.com with SMTP id v19so1154511wmj.5
        for <netfilter-devel@vger.kernel.org>; Wed, 10 Jul 2019 00:52:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=qhTlrZHLNRMRw8CxaRivDcNwdwMdgPSvNlEj+BqbS6g=;
        b=qzxxD21ZSlj/SnwoplyKvzDxnDoMTqjZ4dzBknodnZD3j/W54/Hgk8A+UJhPCAGmta
         KeMC7iqea4B5jx6RS5dTpsVrDOi2l9opBGNfkwgZKomnCGHH9URUQ5XZFjfejh3e/vHA
         QXVEcCpRM7mQabGMhGTS3DCZ/sVCUiqSwcBdUVMmTMVzm4nosN3652eYrl8+gUjm/Jm3
         Lf61GpKculW4W2/lFpMMotCQuhFuKKnRFeto8Aqp9mWi8uiieItkFZhFdQu4pW+A9wRI
         9EO9tGzt0GjjtkNPeCJ2/zh1tyPkLgB5pJKQhpHn8z8LjLO6ksKbOducvepOacba7NPZ
         BvbA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=qhTlrZHLNRMRw8CxaRivDcNwdwMdgPSvNlEj+BqbS6g=;
        b=TeHN++E06rTqcHLP5BOvSYImNyiOz2dmUaVesIwJSt3lNGLmDQVALiK5CrAzM/DgO5
         d3HsdBoxJ5i/KNpJYAWyVlwzehGYmiHcMf0Qt5PRvMZduy1zhi9yos1hUxsTiBMr/j4f
         PfBXG8PxFXFeYUEUJXelhsnM1ZFhZO0dSVMWp9Jb5N8an9Hy01Rmo7v7BpbEIbbI24qq
         h4JXamlefUld5dy3HlyLJ7KzTvLf1pJWnxkgOM7ux9b6IiHWleBizGA6kmYH/1Nt1lG4
         nLsu81LW2COq8PegAc7wuRg6ipVHCY77fbHiYNIgrSYeccIhiIkQtSI2wL7eyrP1XpLh
         /W5Q==
X-Gm-Message-State: APjAAAVPUBhy6WY0wQZCaugqHz6r0miBURN7yl3gAEGyfkFqn2D0x1+z
        sXbV4erXmVLy6f4CXF6At7vflg==
X-Google-Smtp-Source: APXvYqy6DV5QN0XuO9nDO+bPKuNho9zU5hAr8U+yPzsraxkLWo3NR+Ld6rb4oTBpf43bvfDhnU2e4w==
X-Received: by 2002:a1c:a01a:: with SMTP id j26mr3768636wme.112.1562745148345;
        Wed, 10 Jul 2019 00:52:28 -0700 (PDT)
Received: from localhost (jirka.pirko.cz. [84.16.102.26])
        by smtp.gmail.com with ESMTPSA id l25sm1125061wme.13.2019.07.10.00.52.27
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Wed, 10 Jul 2019 00:52:28 -0700 (PDT)
Date:   Wed, 10 Jul 2019 09:52:27 +0200
From:   Jiri Pirko <jiri@resnulli.us>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netdev@vger.kernel.org, davem@davemloft.net,
        thomas.lendacky@amd.com, f.fainelli@gmail.com,
        ariel.elior@cavium.com, michael.chan@broadcom.com,
        madalin.bucur@nxp.com, yisen.zhuang@huawei.com,
        salil.mehta@huawei.com, jeffrey.t.kirsher@intel.com,
        tariqt@mellanox.com, saeedm@mellanox.com, jiri@mellanox.com,
        idosch@mellanox.com, jakub.kicinski@netronome.com,
        peppe.cavallaro@st.com, grygorii.strashko@ti.com, andrew@lunn.ch,
        vivien.didelot@gmail.com, alexandre.torgue@st.com,
        joabreu@synopsys.com, linux-net-drivers@solarflare.com,
        ogerlitz@mellanox.com, Manish.Chopra@cavium.com,
        marcelo.leitner@gmail.com, mkubecek@suse.cz,
        venkatkumar.duvvuru@broadcom.com, maxime.chevallier@bootlin.com,
        cphealy@gmail.com, phil@nwl.cc, netfilter-devel@vger.kernel.org
Subject: Re: [PATCH net-next,v4 12/12] netfilter: nf_tables: add hardware
 offload support
Message-ID: <20190710075227.GA4362@nanopsycho>
References: <20190709205550.3160-1-pablo@netfilter.org>
 <20190709205550.3160-13-pablo@netfilter.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190709205550.3160-13-pablo@netfilter.org>
User-Agent: Mutt/1.11.4 (2019-03-13)
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Tue, Jul 09, 2019 at 10:55:50PM CEST, pablo@netfilter.org wrote:

[...]

>+	if (!dev || !dev->netdev_ops->ndo_setup_tc)

Why didn't you rename ndo_setup_tc? I put a comment about it in the
previous version thread. I expect that you can at least write why it is
a wrong idea.

[...]
