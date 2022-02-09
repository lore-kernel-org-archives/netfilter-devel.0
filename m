Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0FF00C433F5
	for <netfilter-devel@archiver.kernel.org>; Wed,  9 Feb 2022 10:04:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230428AbiBIKEj (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 9 Feb 2022 05:04:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47454 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230072AbiBIKEi (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 9 Feb 2022 05:04:38 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 5532BE0F4282
        for <netfilter-devel@vger.kernel.org>; Wed,  9 Feb 2022 02:04:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1644400665;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=YoAHclFfpdWOR3Rz2pjOqXwysYaFTuu6PzBf6Mjo0WA=;
        b=CJkOQ3vMt/cwle6+BrJolftwhDxDl4HZett5Sf/1ubVxPnznhPvANcj1AlFCnv2qfJo0+Y
        e2OA3lZWnD4ws9lDsIk8xE7HS6Vqx00WwjmtdSTkjmOka7ji7ukWZCR3FXL3GZ238toe6E
        7ceJqtixg3QtEX7M4B2iIgdj0tWtpjM=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-513-0-7_EnN5OKuVEAklmvS8VA-1; Wed, 09 Feb 2022 04:57:42 -0500
X-MC-Unique: 0-7_EnN5OKuVEAklmvS8VA-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 0FEB918B9EC3;
        Wed,  9 Feb 2022 09:57:40 +0000 (UTC)
Received: from maya.cloud.tilaa.com (unknown [10.40.208.3])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 12EC25BC4B;
        Wed,  9 Feb 2022 09:57:38 +0000 (UTC)
Date:   Wed, 9 Feb 2022 10:57:35 +0100
From:   Stefano Brivio <sbrivio@redhat.com>
To:     Hangbin Liu <liuhangbin@gmail.com>
Cc:     netdev@vger.kernel.org, netfilter-devel@vger.kernel.org,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Florian Westphal <fw@strlen.de>
Subject: Re: [PATCH nf] selftests: netfilter: fix exit value for
 nft_concat_range
Message-ID: <20220209105735.5cefed1d@elisabeth>
In-Reply-To: <20220209082551.894541-1-liuhangbin@gmail.com>
References: <20220209082551.894541-1-liuhangbin@gmail.com>
Organization: Red Hat
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Wed,  9 Feb 2022 16:25:51 +0800
Hangbin Liu <liuhangbin@gmail.com> wrote:

> When the nft_concat_range test failed, it exit 1 in the code
> specifically.
> 
> But when part of, or all of the test passed, it will failed the
> [ ${passed} -eq 0 ] check and thus exit with 1, which is the same
> exit value with failure result. Fix it by exit 0 when passed is not 0.

Oops, right, thanks for fixing this!
 
> Fixes: 611973c1e06f ("selftests: netfilter: Introduce tests for sets with range concatenation")
> Signed-off-by: Hangbin Liu <liuhangbin@gmail.com>

Reviewed-by: Stefano Brivio <sbrivio@redhat.com>

-- 
Stefano

