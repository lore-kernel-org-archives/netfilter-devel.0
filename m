Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 83C96EE4993
	for <netfilter-devel@archiver.kernel.org>; Wed, 23 Aug 2023 09:19:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233442AbjHWJR3 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 23 Aug 2023 05:17:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46930 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235238AbjHWJPQ (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 23 Aug 2023 05:15:16 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 311035252
        for <netfilter-devel@vger.kernel.org>; Wed, 23 Aug 2023 02:06:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1692781595;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=9c+TgxZa7cnrCJBQLGvPaOLfSuQltahIaqxXjSxqF0g=;
        b=b3gir6vMty9ivEJAbVa/sjuoIz1dP5dEFsJSItHOz7M/AzBy4FP9eXVDKSk6BTEaW4FUIZ
        E8mxdzSnRWMyvh/ixCKe6iVDiuEW2H0GlS+rmK1fWWCT0gmfsN81ALSkEMkA61HCxqKC7J
        PQxGKS+xzXPhOfMjE1iEnsdDN2bxAwM=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-435-YKgENhSqP4aI-no2RKgcow-1; Wed, 23 Aug 2023 05:06:31 -0400
X-MC-Unique: YKgENhSqP4aI-no2RKgcow-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com [10.11.54.2])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 2E42E101A528;
        Wed, 23 Aug 2023 09:06:31 +0000 (UTC)
Received: from elisabeth (unknown [10.39.208.21])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 5558340D283A;
        Wed, 23 Aug 2023 09:06:30 +0000 (UTC)
Date:   Wed, 23 Aug 2023 11:06:28 +0200
From:   Stefano Brivio <sbrivio@redhat.com>
To:     Florian Westphal <fw@strlen.de>
Cc:     <netfilter-devel@vger.kernel.org>
Subject: Re: [PATCH nf] netfilter: nft_set_pipapo: fix out of memory error
 handling
Message-ID: <20230823110628.56a553d3@elisabeth>
In-Reply-To: <20230823072752.16361-1-fw@strlen.de>
References: <20230823072752.16361-1-fw@strlen.de>
Organization: Red Hat
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.2
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Wed, 23 Aug 2023 09:27:47 +0200
Florian Westphal <fw@strlen.de> wrote:

> Several instances of pipapo_resize() don't propagate allocation failures,
> this causes a crash when fault injection is used with
> 
>  echo Y > /sys/kernel/debug/failslab/ignore-gfp-wait

Oops, I didn't think about that. Thanks.

> Cc: Stefano Brivio <sbrivio@redhat.com>
> Signed-off-by: Florian Westphal <fw@strlen.de>

Reviewed-by: Stefano Brivio <sbrivio@redhat.com>

-- 
Stefano

