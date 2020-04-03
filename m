Return-Path: <SRS0=NeGz=5T=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7AA82C43331
	for <netfilter-devel@archiver.kernel.org>; Fri,  3 Apr 2020 00:55:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 453C420737
	for <netfilter-devel@archiver.kernel.org>; Fri,  3 Apr 2020 00:55:22 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="CoPETSjn"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391189AbgDCAzV (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 2 Apr 2020 20:55:21 -0400
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:56243 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S2390138AbgDCAzV (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 2 Apr 2020 20:55:21 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1585875320;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=bJ6HiUIamB26F5pV3O2IuvU1E2vWyqChSE5uTfWN5ec=;
        b=CoPETSjnJL4pWy6b3g/tjuIsz9K6XUZclGaERW+YHLcOCGW+63thF0LIzNaZ06CNNVzS1W
        u+/G7GEIPKI3nlew0lewotuGZ/t27cKWVycqUjtotuZ8YrETskX99juhzFCyS9dyxzx8Ds
        agot25dZbkpMRlNdi89Q+95OtER5ppw=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-124-N_XcjYE7OJ2oE5qX-I78WA-1; Thu, 02 Apr 2020 20:55:05 -0400
X-MC-Unique: N_XcjYE7OJ2oE5qX-I78WA-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id A562B107ACC4;
        Fri,  3 Apr 2020 00:55:04 +0000 (UTC)
Received: from elisabeth (unknown [10.36.110.67])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id E920A5D9CA;
        Fri,  3 Apr 2020 00:55:01 +0000 (UTC)
Date:   Fri, 3 Apr 2020 02:54:53 +0200
From:   Stefano Brivio <sbrivio@redhat.com>
To:     Pablo Neira Ayuso <pablo@netfilter.org>, fw@strlen.de
Cc:     netfilter-devel@vger.kernel.org
Subject: Re: [PATCH] segtree: bail out on concatenations
Message-ID: <20200403025453.7c5f00ba@elisabeth>
In-Reply-To: <20200402214941.60097-1-pablo@netfilter.org>
References: <20200402214941.60097-1-pablo@netfilter.org>
Organization: Red Hat
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Hi,

On Thu,  2 Apr 2020 23:49:41 +0200
Pablo Neira Ayuso <pablo@netfilter.org> wrote:

> This patch adds a lazy check to validate that the first element is not a
> concatenation. The segtree code does not support for concatenations,
> bail out with EOPNOTSUPP.
> 
>  # nft add element x y { 10.0.0.0/8 . 192.168.1.3-192.168.1.9 . 1024-65535 }
>  Error: Could not process rule: Operation not supported
>  add element x y { 10.0.0.0/8 . 192.168.1.3-192.168.1.9 . 1024-65535 }
>  ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
> 
> Otherwise, the segtree code barfs with:
> 
>  BUG: invalid range expression type concat
> 
> Reported-by: Florian Westphal <fw@strlen.de>
> Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>

I know you both reported this to me, sorry, I still have to polish up
the actual fix before posting it. I'm not very familiar with this code
yet, and it's taking ages.

It might be a few more days before I get to it, so I guess this patch
might make sense for the moment being.

-- 
Stefano

