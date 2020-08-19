Return-Path: <SRS0=iLnO=B5=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.9 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CB97BC433DF
	for <netfilter-devel@archiver.kernel.org>; Wed, 19 Aug 2020 21:59:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A85A7207DE
	for <netfilter-devel@archiver.kernel.org>; Wed, 19 Aug 2020 21:59:56 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="if++7naz"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727074AbgHSV74 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 19 Aug 2020 17:59:56 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:41079 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726948AbgHSV74 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 19 Aug 2020 17:59:56 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1597874394;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=ZNu1v/eRW5l4/6/GoXt9HUBooZgO9i7+aruLqFS9ib0=;
        b=if++7nazP/ziOs76ggQ14AGGUOBESnjYBYBOX78d4nzIZ3xn9xi1eonLcxsBQ5/Q2WXhSm
        Dr76JAvxnuLz3ICRKzKcNoF99w27yxF69KDY5/qfS1vB2EaqpzN1fHw+rNxRWTkVPnu0My
        dNhNBHBILsy/H/VUYYa8ftsyfIgsqaY=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-255-TYIkZx79Oh2_zclefYRLiQ-1; Wed, 19 Aug 2020 17:59:38 -0400
X-MC-Unique: TYIkZx79Oh2_zclefYRLiQ-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 21CC71DDFB;
        Wed, 19 Aug 2020 21:59:37 +0000 (UTC)
Received: from elisabeth (unknown [10.36.110.47])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id ED9AF5D9E8;
        Wed, 19 Aug 2020 21:59:35 +0000 (UTC)
Date:   Wed, 19 Aug 2020 23:59:31 +0200
From:   Stefano Brivio <sbrivio@redhat.com>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org
Subject: Re: [PATCH nf] netfilter: nft_set_rbtree: revisit partial overlap
 detection
Message-ID: <20200819235931.362539f9@elisabeth>
In-Reply-To: <20200814192126.29528-1-pablo@netfilter.org>
References: <20200814192126.29528-1-pablo@netfilter.org>
Organization: Red Hat
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Hi, sorry for the delay.

On Fri, 14 Aug 2020 21:21:26 +0200
Pablo Neira Ayuso <pablo@netfilter.org> wrote:

> Assuming d = memcmp(node, new) when comparing existing nodes and a new
> node, when descending the tree to find the spot to insert the node, the
> overlaps that can be detected are:
> 
> 1) If d < 0 and the new node represents an opening interval and there
>    is an existing opening interval node in the tree, then there is a
>    possible overlap.
> 
> 2) If d > 0 and the new node represents an end of interval and there is an
>    existing end of interval node, then there is a possible overlap.
> 
> When descending the tree, the overlap flag can be reset if the
> conditions above do not evaluate true anymore.
> 
> Note that it is not possible to detect some form of overlaps from the
> kernel: Assuming the interval [x, y] exists, then this code cannot
> detect when the interval [ a, b ] when [ a, b ] fully wraps [ x, y ], ie.
> 
>              [ a, b ]
> 	<---------------->
>              [ x, y ]
>            <---------->

Actually, also this kind of overlap is detected (and already covered by
testcases). Here, we would notice already while inserting 'x' that it
sits between non-matching existing start, x, and existing end, y.

This can't be detected with just local considerations, and it's the
reason why the 'overlap' flag is updated as we descend the tree. Now,
the issue mentioned below:
	https://bugzilla.netfilter.org/show_bug.cgi?id=1449

comes from a wrong assumption I took, namely, the fact that as end
elements are always inserted after start elements, they also need to be
found in the tree as descendants of start elements.

This isn't true with tree rebalancing operations resulting in
rotations, and in the case reported we have some delete operations
triggering that.

I fixed this case in a new series I'm posting, together with additional
tests that cause different types of rotations, and one fix for a false
negative case instead, that I found while playing around with nft
(skipping different types of overlap checks while keeping others in
place).

> Moreover, skip checks for anonymous sets where it is not possible to
> catch overlaps since anonymous sets might not have an explicit end of
> interval.  e.g.  192.168.0.0/24 and 192.168.1.0/24 results in three tree
> nodes, one open interval for 192.168.0.0, another open interval for
> 192.168.1.0 and the end of interval 192.168.2.0. In this case, there is
> no end of interval for 192.168.1.0 since userspace optimizes the
> structure to skip this redundant node.

Now, I couldn't find a way to insert anonymous sets that would trigger
(partial) overlap detection. This is because those overlaps are already
handled (by merging) by nft, and if I insert multiple anonymous sets
with overlapping intervals, they are, well... different sets, so
anything goes. Let me know if I'm missing something here.

-- 
Stefano

