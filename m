Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 24A48C433F5
	for <netfilter-devel@archiver.kernel.org>; Thu,  6 Oct 2022 10:10:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230408AbiJFKKI (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 6 Oct 2022 06:10:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35722 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231179AbiJFKKH (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 6 Oct 2022 06:10:07 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C77C910577
        for <netfilter-devel@vger.kernel.org>; Thu,  6 Oct 2022 03:10:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1665050999;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=jSto643Cx8rEXHrKhHHQeIV35qjzGbem1ulkzbvAhyU=;
        b=cguGDm6CebXWs1B/KPvPLCeZdBzE/5mxol6uZrClAXZu7Qk2n1nEKHFxPJ+s3Sr8ZhCegN
        +XUVDtMCH+QMR7mmWI3udNNyBGub8FCKhXotgAKycoXz6i4zOH8IV5LEXSA0zGAR4xzLoC
        VzVyvAAW4iewirbJjG8xorXPbAVBv68=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-496-Ak047e1xN0u2uy_KQjc_ag-1; Thu, 06 Oct 2022 06:09:58 -0400
X-MC-Unique: Ak047e1xN0u2uy_KQjc_ag-1
Received: by mail-wm1-f71.google.com with SMTP id k38-20020a05600c1ca600b003b49a809168so2350750wms.5
        for <netfilter-devel@vger.kernel.org>; Thu, 06 Oct 2022 03:09:58 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date;
        bh=jSto643Cx8rEXHrKhHHQeIV35qjzGbem1ulkzbvAhyU=;
        b=EVOsYYeo0JF5tQq9NDJRm10KNH3jJ/JJyNtImfSZzSRVr2ERzX9zgM0LMUMqDkzW36
         ChR+w6jHHvIpGPpF+dVc9cAT2Du9T3q/6ld13k5QMI35xEgtDlNFCr6/YKngU3aCqhrB
         RTfwTLhyoPSpGBqoC5uxDWYqfNftKAaFeejizSOWO1yT5tNPnpwKRlwHOOrZk34ADKiZ
         BQPVyDxU8QsW6vOSurnHNx+Ijjz9wRTnDA1vpvOszJF+xix+pFvE1HkUKxN5JIZOJzh7
         fLJUqWvhkVX/HAyuY7Q6kxIua6Us0UjwqPytSj8XGIH8PI/27aXv1d8pN9JGhMv+GGSK
         ucPw==
X-Gm-Message-State: ACrzQf2XxVcfkLZacXNOiCNvxsF+3la1DG65opFTgHMK0kiBHjktXg9l
        uSALmAU6QtwUEiNbGqKAz/fgepiCX899AsyF9Wayu4bTIc5/K796nVMMMA9MbpKnfzuprz/Ui7z
        m2t/93jrM7dLYDGaJo/n0i82MJ+s8
X-Received: by 2002:a1c:f311:0:b0:3b5:18ca:fc5e with SMTP id q17-20020a1cf311000000b003b518cafc5emr2643830wmq.70.1665050996774;
        Thu, 06 Oct 2022 03:09:56 -0700 (PDT)
X-Google-Smtp-Source: AMsMyM6BqzTPDWuI55Vkt3q0nzUG7tYjSP+tinoaQDqi1hZCM/OKp1WlNGN+T/DvswQ5E8e/g0NYzA==
X-Received: by 2002:a1c:f311:0:b0:3b5:18ca:fc5e with SMTP id q17-20020a1cf311000000b003b518cafc5emr2643822wmq.70.1665050996632;
        Thu, 06 Oct 2022 03:09:56 -0700 (PDT)
Received: from localhost.localdomain ([92.62.32.42])
        by smtp.gmail.com with ESMTPSA id bj3-20020a0560001e0300b00226dfac0149sm11502649wrb.114.2022.10.06.03.09.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 06 Oct 2022 03:09:56 -0700 (PDT)
Date:   Thu, 6 Oct 2022 12:09:53 +0200
From:   Guillaume Nault <gnault@redhat.com>
To:     Phil Sutter <phil@nwl.cc>
Cc:     Pablo Neira Ayuso <pablo@netfilter.org>,
        netfilter-devel@vger.kernel.org, Florian Westphal <fw@strlen.de>,
        David Ahern <dsahern@kernel.org>,
        Miaohe Lin <linmiaohe@huawei.com>
Subject: Re: [nf-next PATCH 1/2] selftests: netfilter: Test reverse path
 filtering
Message-ID: <20221006100953.GB3328@localhost.localdomain>
References: <20221005160705.8725-1-phil@nwl.cc>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221005160705.8725-1-phil@nwl.cc>
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Wed, Oct 05, 2022 at 06:07:04PM +0200, Phil Sutter wrote:
> Test reverse path (filter) matches in iptables, ip6tables and nftables.
> Both with a regular interface and a VRF.

Reviewed-by: Guillaume Nault <gnault@redhat.com>

