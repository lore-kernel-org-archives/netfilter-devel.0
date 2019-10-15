Return-Path: <SRS0=TYlN=YI=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3DD72ECE58C
	for <netfilter-devel@archiver.kernel.org>; Tue, 15 Oct 2019 06:12:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 149F120854
	for <netfilter-devel@archiver.kernel.org>; Tue, 15 Oct 2019 06:12:33 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=resnulli-us.20150623.gappssmtp.com header.i=@resnulli-us.20150623.gappssmtp.com header.b="gZWcCNEu"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726994AbfJOGMX (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 15 Oct 2019 02:12:23 -0400
Received: from mail-wr1-f65.google.com ([209.85.221.65]:37932 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726382AbfJOGMX (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 15 Oct 2019 02:12:23 -0400
Received: by mail-wr1-f65.google.com with SMTP id y18so12764882wrn.5
        for <netfilter-devel@vger.kernel.org>; Mon, 14 Oct 2019 23:12:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=8jhn3G6ooIBKGF5W+1nI+KeFPaB8M8BxZpMwU7ttwsA=;
        b=gZWcCNEurTz1q97i2tw4BVFfvF9TVMulsdVWSO5PxelldzthOfSIDzr9koXKwEYz5Z
         ViVYpBEpNVB/97lDTHpeZMoYldeVBauxnrZ/+bGAD3yfKyR6pm7gjr6dlDbZfVCWL60d
         OVnRQw/4wAP+ygJ33XCBNepS1z6C+meFRnci+slrbhV1ZWAKWdXCrwqvTgB5Rwef7aM5
         /GgYUapD0q0TeACOCDm+v71JJ9aSRW9neCFHkbX/8f8wJkGkTCo0x78g+6UvFAvgAf2d
         adAErGImevYk3BRPCMeCn606jaYPEUmRf2JthH2KYA6LwLQA2++U1AHfF2cB0YPSmDEV
         toDw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=8jhn3G6ooIBKGF5W+1nI+KeFPaB8M8BxZpMwU7ttwsA=;
        b=kMd2OLR+uUW7CKnoDy0Cz9ut1arvETKEJL2RYfmnLcEsrmyTA4vyBJPWHhDVr/ekq8
         uHmo+8HyJX4RSNFrd7Y7+RokzEy8g9PaLXSaToYjYCu7sqz/WQyFIo5Rc2YtZd3DmTJi
         3/orM7fbV6T88A6SSt0l7RuTZ6mYLN6nQ2yxh5x/EF2UgrOgHmcObBn+HPMPNx/wSHHP
         XgpZ9gsUFG5dfNGbRodzHKR+yKfesGB3cW/uIXSf7o2QIY+3jS6BMwKUGTtPHSBTMDa+
         wGTqhOzP/1fqdsnAypv5Qxb0XqDZb5nB3BpTPjtZJP0Y3Z47fgve31OoItxRWPkw2pk7
         tMiw==
X-Gm-Message-State: APjAAAVDBsDFTUKePARRjdPBonHrmeBeKKhgCHUWObA2jm+Qu8aFCDZ+
        H8un0JAh/JZQxSQeZkN8OcJJhA==
X-Google-Smtp-Source: APXvYqxwAJCgfNd6ynp2vWCs508GmziRVxnjiz5aF1Z4eQm7uWrQ1dpzzfDD9KoJBfvo4hueP0mk7A==
X-Received: by 2002:a5d:488f:: with SMTP id g15mr15696552wrq.9.1571119939771;
        Mon, 14 Oct 2019 23:12:19 -0700 (PDT)
Received: from localhost (ip-89-177-225-135.net.upcbroadband.cz. [89.177.225.135])
        by smtp.gmail.com with ESMTPSA id o19sm25305238wmh.27.2019.10.14.23.12.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 14 Oct 2019 23:12:19 -0700 (PDT)
Date:   Tue, 15 Oct 2019 08:12:18 +0200
From:   Jiri Pirko <jiri@resnulli.us>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org, davem@davemloft.net,
        netdev@vger.kernel.org, jakub.kicinski@netronome.com,
        saeedm@mellanox.com, vishal@chelsio.com, vladbu@mellanox.com,
        ecree@solarflare.com
Subject: Re: [PATCH net-next,v5 2/4] net: flow_offload: bitwise AND on mangle
 action value field
Message-ID: <20191015061218.GE2314@nanopsycho>
References: <20191014221051.8084-1-pablo@netfilter.org>
 <20191014221051.8084-3-pablo@netfilter.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191014221051.8084-3-pablo@netfilter.org>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Tue, Oct 15, 2019 at 12:10:49AM CEST, pablo@netfilter.org wrote:
>Drivers perform a bitwise AND on the value and the mask. Update
>tc_setup_flow_action() to perform this operation so drivers do not need
>to do this.
>
>Remove sanity check for sane value and mask values from the nfp driver,
>the front-end already guarantees this after this patch.
>
>Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>

Acked-by: Jiri Pirko <jiri@mellanox.com>
