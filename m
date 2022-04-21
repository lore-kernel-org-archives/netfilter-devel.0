Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D878CC433EF
	for <netfilter-devel@archiver.kernel.org>; Thu, 21 Apr 2022 14:06:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1388527AbiDUOJT (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 21 Apr 2022 10:09:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45500 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1388058AbiDUOJQ (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 21 Apr 2022 10:09:16 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 509302C3
        for <netfilter-devel@vger.kernel.org>; Thu, 21 Apr 2022 07:06:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1650549983;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=YTvhhbb1QVBFHnxmAE43DnMRLt1vOH0pEN6ykQsgLkw=;
        b=FD59pPyJts+AGaiHGcj8CqcSJS2BWYwQdQ/bV0zi0TgGfZyA3Cd4tyLGUjxLZYMs3RNqdO
        PSIO9Elek99LTlMb5lg+ZvaWkHLIFohJ79nV4bjpz5oP6h4vGZq2V5yAsRG4tCDVHaBnRQ
        PcNGHO52K9KVsLYmxVt7Fd0dyIlO7HA=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-403-iuhdPYdOPvWQoNW5RQ-4gw-1; Thu, 21 Apr 2022 10:06:20 -0400
X-MC-Unique: iuhdPYdOPvWQoNW5RQ-4gw-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com [10.11.54.7])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 2852F80418B;
        Thu, 21 Apr 2022 14:06:20 +0000 (UTC)
Received: from maya.cloud.tilaa.com (unknown [10.40.208.6])
        by smtp.corp.redhat.com (Postfix) with ESMTP id F2FE3145BA60;
        Thu, 21 Apr 2022 14:06:19 +0000 (UTC)
Date:   Thu, 21 Apr 2022 16:06:17 +0200
From:   Stefano Brivio <sbrivio@redhat.com>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org
Subject: Re: [PATCH nf] netfilter: nft_set_rbtree: overlap detection with
 element re-addition after deletion
Message-ID: <20220421160617.487260d4@elisabeth>
In-Reply-To: <20220418102105.826027-1-pablo@netfilter.org>
References: <20220418102105.826027-1-pablo@netfilter.org>
Organization: Red Hat
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.7
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Hi Pablo,

On Mon, 18 Apr 2022 12:21:05 +0200
Pablo Neira Ayuso <pablo@netfilter.org> wrote:

> This patch fixes spurious EEXIST errors.
> 
> Extend d2df92e98a34 ("netfilter: nft_set_rbtree: handle element
> re-addition after deletion") to deal with elements with same end flags
> in the same transation.
> 
> Reset the overlap flag as described by 7c84d41416d8 ("netfilter:
> nft_set_rbtree: Detect partial overlaps on insertion").
> 
> Fixes: 7c84d41416d8 ("netfilter: nft_set_rbtree: Detect partial overlaps on insertion")
> Fixes: d2df92e98a34 ("netfilter: nft_set_rbtree: handle element re-addition after deletion")
> Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>

Sorry for the delay, and thanks for fixing this. I believe this is
correct, but I haven't tested it.

Reviewed-by: Stefano Brivio <sbrivio@redhat.com>

-- 
Stefano

