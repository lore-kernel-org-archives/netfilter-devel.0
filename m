Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7B44AC004D4
	for <netfilter-devel@archiver.kernel.org>; Sat, 21 Jan 2023 11:03:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229553AbjAULDo (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sat, 21 Jan 2023 06:03:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37540 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229493AbjAULDn (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sat, 21 Jan 2023 06:03:43 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 20C9D16AE3
        for <netfilter-devel@vger.kernel.org>; Sat, 21 Jan 2023 03:02:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1674298972;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=ooSeY0f2ZPv0P/+JUzkk4AE7kl5XhdsYhEk4JpozuM4=;
        b=Lpf/9/z+PSy+6vEaWKbTluLjJh0OR8gLutQWVsAiQ1IHuLeBznFmnEgHQCoNvEB4BR8Pq6
        tdHotq+DJT5Y6JIx/WWKn5h5SklgbBJbUVcq0ip9uBr/GVpVwRzyhDsYaqt5GiQq6nUVjP
        Kin1gxMBDu9ksm1IrbFe3qOeSMGauDI=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-316-4xhj0obpP666W_dfYSf5_A-1; Sat, 21 Jan 2023 06:02:49 -0500
X-MC-Unique: 4xhj0obpP666W_dfYSf5_A-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com [10.11.54.6])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id E9471101A521;
        Sat, 21 Jan 2023 11:02:48 +0000 (UTC)
Received: from maya.cloud.tilaa.com (ovpn-208-4.brq.redhat.com [10.40.208.4])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id A0F862166B2A;
        Sat, 21 Jan 2023 11:02:48 +0000 (UTC)
Date:   Sat, 21 Jan 2023 12:02:37 +0100
From:   Stefano Brivio <sbrivio@redhat.com>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org, fw@strlen.de
Subject: Re: [PATCH nf,v4 1/2] netfilter: nft_set_rbtree: Switch to node
 list walk for overlap detection
Message-ID: <20230121120237.49b73c65@elisabeth>
In-Reply-To: <20230118151839.547103-1-pablo@netfilter.org>
References: <20230118151839.547103-1-pablo@netfilter.org>
Organization: Red Hat
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.6
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Wed, 18 Jan 2023 16:18:38 +0100
Pablo Neira Ayuso <pablo@netfilter.org> wrote:

> ...instead of a tree descent, which became overly complicated in an
> attempt to cover cases where expired or inactive elements would affect
> comparisons with the new element being inserted.
> 
> Further, it turned out that it's probably impossible to cover all those
> cases, as inactive nodes might entirely hide subtrees consisting of a
> complete interval plus a node that makes the current insertion not
> overlap.
> 
> To speed up the overlap check, descent the tree to find a greater
> element that is closer to the key value to insert. Then walk down the
> node list for overlap detection. Starting the overlap check from
> rb_first() unconditionally is slow, it takes 10 times longer due to the
> full linear traversal of the list.
> 
> Moreover, perform garbage collection of expired elements when walking
> down the node list to avoid bogus overlap reports.
> 
> For the insertion operation itself, this essentially reverts back to the
> implementation before commit 7c84d41416d8 ("netfilter: nft_set_rbtree:
> Detect partial overlaps on insertion"), except that cases of complete
> overlap are already handled in the overlap detection phase itself, which
> slightly simplifies the loop to find the insertion point.
> 
> Based on initial patch from Stefano Brivio, including text from the
> original patch description too.
> 
> Fixes: 7c84d41416d8 ("netfilter: nft_set_rbtree: Detect partial overlaps on insertion")
> Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
> ---
> v4: - s/Descent/Descend in comments as per Stefano.
>     - reintroduce nft_rbtree_update_first().

Reviewed-by: Stefano Brivio <sbrivio@redhat.com>

-- 
Stefano

