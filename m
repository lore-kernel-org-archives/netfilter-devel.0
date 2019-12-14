Return-Path: <SRS0=nEPA=2E=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 73007C43603
	for <netfilter-devel@archiver.kernel.org>; Sat, 14 Dec 2019 08:27:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 498A824658
	for <netfilter-devel@archiver.kernel.org>; Sat, 14 Dec 2019 08:27:53 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=netronome-com.20150623.gappssmtp.com header.i=@netronome-com.20150623.gappssmtp.com header.b="JIl1lb+0"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726454AbfLNI1w (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sat, 14 Dec 2019 03:27:52 -0500
Received: from mail-wm1-f41.google.com ([209.85.128.41]:52598 "EHLO
        mail-wm1-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726445AbfLNI1w (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sat, 14 Dec 2019 03:27:52 -0500
Received: by mail-wm1-f41.google.com with SMTP id p9so1221141wmc.2
        for <netfilter-devel@vger.kernel.org>; Sat, 14 Dec 2019 00:27:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=HnlEcCOnYPfHXdichRmfeYAMJzTPH1YMq8eGs2nlFVo=;
        b=JIl1lb+0B4stHP+TwpmUZr8KGIcp+L2ENnGEYmt4g7UbyPo5wZFFby3YSFl5Wi2Jx5
         g6yHJkKOMzEcmglMgyKsSBolwQFH60bbHy6G08VJQ6y0NjiBPw9eNSQKcl2DHxNJUyI0
         QzIuDk/Wc1NI3qtT2f2iQigAaXQfcHuXmIXteI4YkHOm1Tq77/4D1e4YnPhEamhkmvBM
         rhoDEN8y0y8ghg77X1r+7OGu8uTbOYs7D1qb4U5idZVY11SlLYdhRTABXzkjV80b2Ddw
         OAFVClt9syT4YzzOUwV5nfsCBXDOQ0kWhPPwFm664icC2iGoCYZMp/RMABU+iJrDXCp/
         mXow==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=HnlEcCOnYPfHXdichRmfeYAMJzTPH1YMq8eGs2nlFVo=;
        b=Od1JzTQ8jYHKG6LgyLxnW5KaDYBpQWZ5HqtiZxf2IYzOlshKVVbLyPWMKak11I0EE5
         Y5iuteanu1mef+bQblMizrwa3zVIxDlMPjcOjT0sH6tPx2o3UMCF+NWxt7sLFOPtqwSj
         JpyYDVJ20WnYjCHy4lZc5jRQo0HPjpELpKP8URi9Pi/K7ua2PbtS5x+uUEMgmlLa1qxW
         qPMpU8MS9/czSgskPgSSZElh7eDiVDgQiAO/IgyKCahLoQid2Zbm/eC6bJAj3EzK8ouI
         hki3YvuJgl87xtrFVAm+5MBNLXQv7y/HV8WvOxEuL7NBXHzFGUTIl7zNK/b8AoIO5Zod
         o7dw==
X-Gm-Message-State: APjAAAX4uSgNOOx/ng3o0bDepzfMyqO+arcoSn/l1tuy/ADYUoquYVtL
        5ZlF98aFKbAW23wIoHp78E9BdQ==
X-Google-Smtp-Source: APXvYqyj/p7ZPJa1PvNrgBuNNKzwLReIIT8KBlVn9Qrr2oMSH32F8rdPJGWdPtwK6zgKqK8b7cdpnw==
X-Received: by 2002:a7b:cb97:: with SMTP id m23mr17790128wmi.37.1576312070597;
        Sat, 14 Dec 2019 00:27:50 -0800 (PST)
Received: from netronome.com (fred-musen.rivierenbuurt.horms.nl. [2001:470:7eb3:404:a2a4:c5ff:fe4c:9ce9])
        by smtp.gmail.com with ESMTPSA id m7sm13029900wma.39.2019.12.14.00.27.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 14 Dec 2019 00:27:50 -0800 (PST)
Date:   Sat, 14 Dec 2019 09:27:49 +0100
From:   Simon Horman <simon.horman@netronome.com>
To:     Xin Long <lucien.xin@gmail.com>
Cc:     network dev <netdev@vger.kernel.org>,
        netfilter-devel@vger.kernel.org, davem@davemloft.net,
        Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCHv2 nf-next 5/5] netfilter: nft_tunnel: add the missing
 nla_nest_cancel()
Message-ID: <20191214082748.GE5926@netronome.com>
References: <cover.1576226965.git.lucien.xin@gmail.com>
 <eef81a92304174c58faed2403c7b487b00193626.1576226965.git.lucien.xin@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <eef81a92304174c58faed2403c7b487b00193626.1576226965.git.lucien.xin@gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Fri, Dec 13, 2019 at 04:53:09PM +0800, Xin Long wrote:
> When nla_put_xxx() fails under nla_nest_start_noflag(),
> nla_nest_cancel() should be called, so that the skb can
> be trimmed properly.
> 
> Signed-off-by: Xin Long <lucien.xin@gmail.com>
> Acked-by: Pablo Neira Ayuso <pablo@netfilter.org>

Reviewed-by: Simon Horman <simon.horman@netronome.com>

