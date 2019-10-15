Return-Path: <SRS0=TYlN=YI=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 487ABC10F14
	for <netfilter-devel@archiver.kernel.org>; Tue, 15 Oct 2019 06:06:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 21A0721835
	for <netfilter-devel@archiver.kernel.org>; Tue, 15 Oct 2019 06:06:41 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=resnulli-us.20150623.gappssmtp.com header.i=@resnulli-us.20150623.gappssmtp.com header.b="GrUUroDH"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727142AbfJOGFg (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 15 Oct 2019 02:05:36 -0400
Received: from mail-wr1-f66.google.com ([209.85.221.66]:46489 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726101AbfJOGFg (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 15 Oct 2019 02:05:36 -0400
Received: by mail-wr1-f66.google.com with SMTP id o18so22148402wrv.13
        for <netfilter-devel@vger.kernel.org>; Mon, 14 Oct 2019 23:05:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=RX/0WlRnLie8nc00maGTLlElJyVLretH5t1EwCBi6yQ=;
        b=GrUUroDHZcx5miQbAFag6xz92nI0cLIl5rk+R3g1wX/5W9D11BrGt175qRQMQz4sdU
         Z/VSOsDk3shgI3UauWNw3dWtJYec3AJ1ORB4IxacWWokYGdhf3Zf1t7GmFQIyNTu/Fw8
         ghFePxQ5WBts+vvQ+OZ0i4p4Oqk6Kav+q+xhp2Q7KngBDXRDYU7ylzZr7SScJe28t69X
         88cN8YlgGEiHbRAxFtFXt9b9h/+2uuvr20gOJJEpzujyhL/Zt3gUu2ZN4/lQpm8tZsb3
         ccg3BXUnWkwe+0gwbd3nLhGiQ2Y339kCN5w8cYQHww0TAOlWDASIGQrOYElnzmZ9B2bT
         G96g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=RX/0WlRnLie8nc00maGTLlElJyVLretH5t1EwCBi6yQ=;
        b=dqqVG3pPND3ZzLUtYuSNfPobQfdctjEs3TKvT/eMFRJzJq6bpteF9C5FeXmUTkMy9L
         iTa5Vz+kYR0PchGD0JjDu8vQMhh3qpMqW/SuemD/XeAoY+OecyBfYxn+BRmGlQWGHMH9
         2QPP85jv3jZsrCmnj/3blgK1w+zcOHmn85QzMZiiQA5kiOG0BzhoGBfExb4eOzjX8bgK
         i8KHILT3TIf5mB7RzAeCrk2u6qy+VIOD0MhORCpI1wL7uKyOgw3g81L4BlmpFET8/Rw2
         IBAUY1PddzQlgEWlYL+BiREeox/eucFyPagGqaZO8kmG9oyHK0h3B2gTN2HToznWG19T
         ZIeA==
X-Gm-Message-State: APjAAAVFIBLuOKMEcjm7YJ+gAelwvVaaF7fiHrwuSqq0H9AoIsylfFgE
        kBxYqV2LxWu9GDAFuDZ14BawTg==
X-Google-Smtp-Source: APXvYqz0PjvYI9x4nvoVkn96vBeaRX6h9jYu5qLUxzQNkmLB3kDrDb8R72hQMk3AYY0SKbUL0C+sdQ==
X-Received: by 2002:adf:b69f:: with SMTP id j31mr28498627wre.277.1571119533683;
        Mon, 14 Oct 2019 23:05:33 -0700 (PDT)
Received: from localhost (ip-89-177-225-135.net.upcbroadband.cz. [89.177.225.135])
        by smtp.gmail.com with ESMTPSA id e18sm28357956wrv.63.2019.10.14.23.05.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 14 Oct 2019 23:05:33 -0700 (PDT)
Date:   Tue, 15 Oct 2019 08:05:32 +0200
From:   Jiri Pirko <jiri@resnulli.us>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org, davem@davemloft.net,
        netdev@vger.kernel.org, jakub.kicinski@netronome.com,
        saeedm@mellanox.com, vishal@chelsio.com, vladbu@mellanox.com,
        ecree@solarflare.com
Subject: Re: [PATCH net-next,v5 1/4] net: flow_offload: flip mangle action
 mask
Message-ID: <20191015060532.GD2314@nanopsycho>
References: <20191014221051.8084-1-pablo@netfilter.org>
 <20191014221051.8084-2-pablo@netfilter.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191014221051.8084-2-pablo@netfilter.org>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Tue, Oct 15, 2019 at 12:10:48AM CEST, pablo@netfilter.org wrote:
>Userspace tc pedit action performs a bitwise NOT operation on the mask.
>All of the existing drivers in the tree undo this operation. Prepare the
>mangle mask in the way the drivers expect from the
>tc_setup_flow_action() function.
>
>Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>

Acked-by: Jiri Pirko <jiri@mellanox.com>
