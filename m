Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7A3EAC3DA78
	for <netfilter-devel@archiver.kernel.org>; Tue, 17 Jan 2023 10:42:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236177AbjAQKm0 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 17 Jan 2023 05:42:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44998 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236116AbjAQKmK (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 17 Jan 2023 05:42:10 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 24B8F9026
        for <netfilter-devel@vger.kernel.org>; Tue, 17 Jan 2023 02:41:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1673952085;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=eLsm4I1RN3rXt9KqXrX9BEa28739TyjlzSWMCMGrCoY=;
        b=Wsk0Y6BiJARkB1p+WnrGVOSQf1e4xVIPApw2a6UwBrtsw6nQCvUqOwo5KZ1nQsxq3VggTh
        viThc8Hw6sE2XSoIC3iCKJ681dtB/BIyajyZ9nzysUN/gDAjDaCHziXAE5HxBnYbU0MhAD
        TU27nIXqdV+z/TXfn+aYSlEBemSjp1M=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-590-KX7zlMp0PMqtm5yycmr8rg-1; Tue, 17 Jan 2023 05:41:22 -0500
X-MC-Unique: KX7zlMp0PMqtm5yycmr8rg-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com [10.11.54.3])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id D5D8F1869B6F;
        Tue, 17 Jan 2023 10:41:21 +0000 (UTC)
Received: from maya.cloud.tilaa.com (ovpn-208-4.brq.redhat.com [10.40.208.4])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 9CF941121315;
        Tue, 17 Jan 2023 10:41:21 +0000 (UTC)
Date:   Tue, 17 Jan 2023 11:41:10 +0100
From:   Stefano Brivio <sbrivio@redhat.com>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org, fw@strlen.de
Subject: Re: [PATCH nf 2/2] netfilter: nft_set_rbtree: skip elements in
 transaction from garbage collection
Message-ID: <20230117114110.550b388e@elisabeth>
In-Reply-To: <20230114231047.948785-3-pablo@netfilter.org>
References: <20230114231047.948785-1-pablo@netfilter.org>
        <20230114231047.948785-3-pablo@netfilter.org>
Organization: Red Hat
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.3
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Sun, 15 Jan 2023 00:10:47 +0100
Pablo Neira Ayuso <pablo@netfilter.org> wrote:

> Skip interference with an ongoing transaction, do not perform garbage
> collection on inactive elements. Reset annotated previous end interval
> if the expired element is marked as busy (control plane removed the
> element right before expiration).
> 
> Fixes: 8d8540c4f5e0 ("netfilter: nft_set_rbtree: add timeout support")
> Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>

Reviewed-by: Stefano Brivio <sbrivio@redhat.com>

-- 
Stefano

