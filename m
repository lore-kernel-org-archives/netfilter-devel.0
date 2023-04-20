Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 43AC1C77B72
	for <netfilter-devel@archiver.kernel.org>; Thu, 20 Apr 2023 16:37:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232182AbjDTQhM (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 20 Apr 2023 12:37:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52346 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231526AbjDTQhG (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 20 Apr 2023 12:37:06 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E07EA3AA4
        for <netfilter-devel@vger.kernel.org>; Thu, 20 Apr 2023 09:36:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1682008561;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=sldBKJY82MsApTKZ62ld5w6opIim9pqSE/sgrzAPQZM=;
        b=bAmYxX5LgTdQ8nuFdXt8nIUz/QHTvDU/qlhzRXlQXE8bv5xjgIk5fWPzWIMNYUidXJeqmD
        YfxgT7m+8jyxS3c1kNp4Q7cn3bzEIdRiHsLF7YWa6WW92PaGVq8vT8+fxz6SCHMNAF/3ah
        tIkm6/jW8Yx9cavw1Gxsgm5mhsasKEM=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-477-L-9ttOTRNZClXxFHxQwN9Q-1; Thu, 20 Apr 2023 12:35:57 -0400
X-MC-Unique: L-9ttOTRNZClXxFHxQwN9Q-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com [10.11.54.4])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 370571C08989;
        Thu, 20 Apr 2023 16:35:57 +0000 (UTC)
Received: from maya.cloud.tilaa.com (unknown [10.42.30.11])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id F13DE2026D16;
        Thu, 20 Apr 2023 16:35:56 +0000 (UTC)
Date:   Thu, 20 Apr 2023 18:35:54 +0200
From:   Stefano Brivio <sbrivio@redhat.com>
To:     Phil Sutter <phil@nwl.cc>
Cc:     Pablo Neira Ayuso <pablo@netfilter.org>,
        netfilter-devel@vger.kernel.org
Subject: Re: [nft PATCH] tests: shell: Fix for unstable
 sets/0043concatenated_ranges_0
Message-ID: <20230420183554.4af78bbd@elisabeth>
In-Reply-To: <20230420154723.27089-1-phil@nwl.cc>
References: <20230420154723.27089-1-phil@nwl.cc>
Organization: Red Hat
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.4
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Thu, 20 Apr 2023 17:47:23 +0200
Phil Sutter <phil@nwl.cc> wrote:

> On my (slow?) testing VM, The test tends to fail when doing a full run
> (i.e., calling run-test.sh without arguments) and tends to pass when run
> individually.
> 
> The problem seems to be the 1s element timeout which in some cases may
> pass before element deletion occurs.

Whoops. Yes I think so too.

> Simply fix this by doubling the
> timeout. It has to pass just once, so shouldn't hurt too much.
> 
> Fixes: 618393c6b3f25 ("tests: Introduce test for set with concatenated ranges")
> Cc: Stefano Brivio <sbrivio@redhat.com>
> Signed-off-by: Phil Sutter <phil@nwl.cc>

Reviewed-by: Stefano Brivio <sbrivio@redhat.com>

-- 
Stefano

