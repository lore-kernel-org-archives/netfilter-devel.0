Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3FAB7C433FE
	for <netfilter-devel@archiver.kernel.org>; Tue, 17 May 2022 12:58:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345994AbiEQM6J (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 17 May 2022 08:58:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41310 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347068AbiEQM5Q (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 17 May 2022 08:57:16 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 5485A3C70B
        for <netfilter-devel@vger.kernel.org>; Tue, 17 May 2022 05:57:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1652792234;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=M39lLXLK5XPSQ/qQHxYKjMP7yCloVfOezzAFeXrlmSg=;
        b=S5IFfh38vq/y1A3mTwQ1f18gFQDhj1K9v63dRJ/4PPjpg+v7FksO5BLrj/K2ht6q/r/75K
        cP7kjWTgQXgByR2GA93yc67u9+Ix2V13X+85uWN2QETnyQyx8y+HG79Tcsfv7yZ+63H55k
        Ekk79a2/nxX6/V/LxBZyRjT9wwlRUfs=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-618-jDwtFlWsPSemddOub0LHDA-1; Tue, 17 May 2022 08:57:13 -0400
X-MC-Unique: jDwtFlWsPSemddOub0LHDA-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com [10.11.54.8])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id E5EC929AB452;
        Tue, 17 May 2022 12:57:12 +0000 (UTC)
Received: from maya.cloud.tilaa.com (unknown [10.40.208.33])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id ACDC5C27D8F;
        Tue, 17 May 2022 12:57:12 +0000 (UTC)
Date:   Tue, 17 May 2022 14:57:09 +0200
From:   Stefano Brivio <sbrivio@redhat.com>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org
Subject: Re: [PATCH nf] nft_set_rbtree: Move clauses for expired nodes, last
 active node as leaf
Message-ID: <20220517145709.08694803@elisabeth>
In-Reply-To: <YoKVFRR1gggECpiZ@salvia>
References: <20220512183421.712556-1-sbrivio@redhat.com>
        <YoKVFRR1gggECpiZ@salvia>
Organization: Red Hat
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.8
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Mon, 16 May 2022 20:16:53 +0200
Pablo Neira Ayuso <pablo@netfilter.org> wrote:

> Hi Stefano,
> 
> On Thu, May 12, 2022 at 08:34:21PM +0200, Stefano Brivio wrote:
> > In the overlap detection performed as part of the insertion operation,
> > we have to skip nodes that are not active in the current generation or
> > expired. This was done by adding several conditions in overlap decision
> > clauses, which made it hard to check for correctness, and debug the
> > actual issue this patch is fixing.
> > 
> > Consolidate these conditions into a single clause, so that we can
> > proceed with debugging and fixing the following issue.
> > 
> > Case b3. described in comments covers the insertion of a start
> > element after an existing end, as a leaf. If all the descendants of
> > a given element are inactive, functionally, for the purposes of
> > overlap detection, we still have to treat this as a leaf, but we don't.
> > 
> > If, in the same transaction, we remove a start element to the right,
> > remove an end element to the left, and add a start element to the right
> > of an existing, active end element, we don't hit case b3. For example:
> > 
> > - existing intervals: 1-2, 3-5, 6-7
> > - transaction: delete 3-5, insert 4-5
> > 
> > node traversal might happen as follows:
> > - 2 (active end)
> > - 5 (inactive end)
> > - 3 (inactive start)
> > 
> > when we add 4 as start element, we should simply consider 2 as
> > preceding end, and consider it as a leaf, because interval 3-5 has been
> > deleted. If we don't, we'll report an overlap because we forgot about
> > this.
> > 
> > Add an additional flag which is set as we find an active end, and reset
> > it if we find an active start (to the left). If we finish the traversal
> > with this flag set, it means we need to functionally consider the
> > previous active end as a leaf, and allow insertion instead of reporting
> > overlap.  
> 
> I can still trigger EEXIST with deletion of existing interval. It
> became harder to reproduce after this patch.
> 
> After hitting EEXIST, if I do:
> 
>         echo "flush ruleset" > test.nft
>         nft list ruleset >> test.nft
> 
> to dump the existing ruleset, then I run the delete element command
> again to remove the interval and it works. Before this patch I could
> reproduce it by reloading an existing ruleset dump.
> 
> I'm running the script that I'm attaching manually, just one manual
> invocation after another.

Ouch, sorry for that.

It looks like there's another case where inactive elements still affect
overlap detection in an unexpected way... at least with the structure
of this patch it should be easier to find, I'm looking into that now.

-- 
Stefano

