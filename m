Return-Path: <SRS0=/ZNS=BC=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 28C61C43445
	for <netfilter-devel@archiver.kernel.org>; Thu, 23 Jul 2020 01:39:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E0F4320781
	for <netfilter-devel@archiver.kernel.org>; Thu, 23 Jul 2020 01:39:30 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="bniU+4f0"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387700AbgGWBja (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 22 Jul 2020 21:39:30 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:49383 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S2387462AbgGWBj3 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 22 Jul 2020 21:39:29 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1595468368;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=y65Ic7xyixrgoKM3KzC9SeurqcOsc1M4Xp3tNaOmohE=;
        b=bniU+4f0Qt1I1irl6K3a4O9uHu4QOm25xeOIQZuOu1IaQfqvoTnPfdCnCNg0y9Rzai7hQ4
        P5J0VgGQJEgoPALFo2hqOwEKs/iyWq5LLwKNrBTYSf5OhPsQIpjIdPynwAO8LyYj0b+y/G
        RYDfvALhnRAlzEBZ2NBvga3GvSkDAr4=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-509-UxYUDVlsNmucM41MNNghKw-1; Wed, 22 Jul 2020 21:39:26 -0400
X-MC-Unique: UxYUDVlsNmucM41MNNghKw-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 6B4081B18BC0;
        Thu, 23 Jul 2020 01:39:25 +0000 (UTC)
Received: from elisabeth (unknown [10.36.110.10])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 4ACD627CDD;
        Thu, 23 Jul 2020 01:39:23 +0000 (UTC)
Date:   Thu, 23 Jul 2020 03:39:18 +0200
From:   Stefano Brivio <sbrivio@redhat.com>
To:     Florian Westphal <fw@strlen.de>
Cc:     <netfilter-devel@vger.kernel.org>
Subject: Re: [PATCH nft 1/2] netlink: fix concat range expansion in map case
Message-ID: <20200723033918.3d88ffed@elisabeth>
In-Reply-To: <20200722115126.12596-1-fw@strlen.de>
References: <20200722115126.12596-1-fw@strlen.de>
Organization: Red Hat
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Wed, 22 Jul 2020 13:51:25 +0200
Florian Westphal <fw@strlen.de> wrote:

> This is not a display bug, nft sends broken information
> to kernel.  Use the correct key expression to fix this.

Thanks for fixing this! I didn't realise it could be so simple. :)

> Signed-off-by: Florian Westphal <fw@strlen.de>

Fixes: 8ac2f3b2fca3 ("src: Add support for concatenated set ranges")
Reviewed-by: Stefano Brivio <sbrivio@redhat.com>

-- 
Stefano

