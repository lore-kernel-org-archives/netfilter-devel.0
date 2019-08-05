Return-Path: <SRS0=7PQj=WB=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 07CD8C433FF
	for <netfilter-devel@archiver.kernel.org>; Mon,  5 Aug 2019 19:05:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id CBDDD205F4
	for <netfilter-devel@archiver.kernel.org>; Mon,  5 Aug 2019 19:05:05 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=netronome-com.20150623.gappssmtp.com header.i=@netronome-com.20150623.gappssmtp.com header.b="aTlk8gES"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730099AbfHETFF (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 5 Aug 2019 15:05:05 -0400
Received: from mail-qk1-f194.google.com ([209.85.222.194]:33486 "EHLO
        mail-qk1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727802AbfHETFF (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 5 Aug 2019 15:05:05 -0400
Received: by mail-qk1-f194.google.com with SMTP id r6so60994309qkc.0
        for <netfilter-devel@vger.kernel.org>; Mon, 05 Aug 2019 12:05:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :organization:mime-version:content-transfer-encoding;
        bh=cLqvyspbp7OWOUoq3ZFYv4mC87V5IQVjr1iTTqcs6mQ=;
        b=aTlk8gES6npsuwmghCx2Na80kCnL2squsqK9whr55L5dlxjRnrBfkMSFXyUw80XYnB
         CvO7XyDZgN3ChS0v/yS8AzsK6TFuYm5P7pQvGbkOnjn32i0lmJnxGcxj4upGDk9pA9PE
         072EfxuQW4nHDKrYj89qLK+CYdhY/7Hv05lnZjSKo4UNx7CZa3X5M3NVoRqnvCG0Taud
         gemdFfZ7Br/MYbsANmb5V4MSJYehfhsMPq1BMAs7qvc/gNAHEGaRGzO3TPFp37W6UMLw
         SZjz1dW+Mp9X9SC5s2H4MhytPyzEvnuiuL1JWpBgMdJ6MBy/AXJcWG7uF1eYcrA1NAPe
         WyfQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=cLqvyspbp7OWOUoq3ZFYv4mC87V5IQVjr1iTTqcs6mQ=;
        b=jh56WqGa9itDSK8OTa4b3RoOCUuBqIqx92L27JjvOXCDJJ01oi4gW+3Hk6JV8tNUtZ
         moVzuxjL+SxLSalBgXvUvgzad+v4NvGmU7oTwUOkFIlnNMWMMcyByKAqpcy8kxOHac+w
         uWfvuYwqufZQzniUN06LluFrf3dfwlnP9h+eiizoJWNDerr8kLN8HMEcxGTH18hKaZ45
         Xd6HQOt1FvpDujfQQCqD6hnCx3beQtcICE1Or6CRn/PKVBG13XzDmAuy1mJ7KYwMsnR3
         EMVD4s8D/HFKkWWiU6rnXQkG2a28GEjBafhf0dbQL7KAsynkFb8dE1QUPkA36tq5c/1j
         pY0Q==
X-Gm-Message-State: APjAAAVBomQcQ46QdJ+IqRzQolWYlASl/1ciGGwYsqUHmNu1dOsPTeVk
        Z/0YWIMzpR1WzI9kGTsTisy18g==
X-Google-Smtp-Source: APXvYqwRKui4nbKI13V2UXz+YNMPur0gm6dZWDgkzt5mfTEvpQPnpLXr+fcIXum3h47MYsPK8eV0FA==
X-Received: by 2002:a05:620a:13ec:: with SMTP id h12mr104099406qkl.266.1565031904006;
        Mon, 05 Aug 2019 12:05:04 -0700 (PDT)
Received: from cakuba.netronome.com ([66.60.152.14])
        by smtp.gmail.com with ESMTPSA id y4sm34415124qti.84.2019.08.05.12.05.02
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Mon, 05 Aug 2019 12:05:03 -0700 (PDT)
Date:   Mon, 5 Aug 2019 12:04:39 -0700
From:   Jakub Kicinski <jakub.kicinski@netronome.com>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org, davem@davemloft.net,
        netdev@vger.kernel.org, marcelo.leitner@gmail.com,
        jiri@resnulli.us, wenxu@ucloud.cn, saeedm@mellanox.com,
        paulb@mellanox.com, gerlitz.or@gmail.com
Subject: Re: [PATCH net 0/2] flow_offload hardware priority fixes
Message-ID: <20190805120439.40d70cee@cakuba.netronome.com>
In-Reply-To: <20190803070854.zb3nvwj4ubx2mzy6@salvia>
References: <20190801112817.24976-1-pablo@netfilter.org>
        <20190801172014.314a9d01@cakuba.netronome.com>
        <20190802110023.udfcxowe3vmihduq@salvia>
        <20190802134738.328691b4@cakuba.netronome.com>
        <20190802220409.klwdkcvjgegz6hj2@salvia>
        <20190802152549.357784a7@cakuba.netronome.com>
        <20190803070854.zb3nvwj4ubx2mzy6@salvia>
Organization: Netronome Systems, Ltd.
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Sat, 3 Aug 2019 09:08:54 +0200, Pablo Neira Ayuso wrote:
> The idea is that every subsystem (ethtool, tc, nf) sets up/binds its
> own flow_block object. And each flow_block object has its own priority
> range space. So whatever priority the user specifies only applies to
> the specific subsystem.

Right, okay so that part is pretty obvious but thanks for spelling it
out. 

Are you also agreeing that priorities of blocks, not rules within 
a block are dictated by the order of processing within the kernel?
IOW TC blocks are _always_ before nft blocks?

> Drivers still need to be updated to support for more than one
> flow_block/subsystem binding at this stage though.
