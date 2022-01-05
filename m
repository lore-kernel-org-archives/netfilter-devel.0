Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6D8A9C433F5
	for <netfilter-devel@archiver.kernel.org>; Wed,  5 Jan 2022 15:20:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241340AbiAEPUr (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 5 Jan 2022 10:20:47 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.129.124]:56876 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S241250AbiAEPUr (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 5 Jan 2022 10:20:47 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1641396046;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=FoTkAgELyeBPD7ESjdGuyptyxrIJiZ7RSV4d1iMM/c0=;
        b=PON18i2A8ysZjB8V9Sl5dBa8vBu1iUpeCUN0ykvCLJSWIPKIiNLG+DTkRThzadkaC2ue2p
        eD9g5HMJo0hCu2w5/SPckvgKHDXTjqg+lFLcGLQ5nfS/H1Rs/aadBiQvSHsORnYlwfm8Ef
        /WvCCMIBh5Ahc2PYVtcGcH67lZbU4eU=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-497-A2YadRrhNCOHfa2TyVcEeg-1; Wed, 05 Jan 2022 10:20:43 -0500
X-MC-Unique: A2YadRrhNCOHfa2TyVcEeg-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 328DD101AFA7;
        Wed,  5 Jan 2022 15:20:42 +0000 (UTC)
Received: from maya.cloud.tilaa.com (unknown [10.40.208.3])
        by smtp.corp.redhat.com (Postfix) with ESMTP id D69742B6D8;
        Wed,  5 Jan 2022 15:20:41 +0000 (UTC)
Date:   Wed, 5 Jan 2022 16:20:36 +0100
From:   Stefano Brivio <sbrivio@redhat.com>
To:     Florian Westphal <fw@strlen.de>
Cc:     <netfilter-devel@vger.kernel.org>,
        etkaar <lists.netfilter.org@prvy.eu>
Subject: Re: [PATCH nf] netfilter: nft_set_pipapo: allocate pcpu scratch
 maps on clone
Message-ID: <20220105162036.54653de0@elisabeth>
In-Reply-To: <20220105131954.23666-1-fw@strlen.de>
References: <20220105131954.23666-1-fw@strlen.de>
Organization: Red Hat
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Wed,  5 Jan 2022 14:19:54 +0100
Florian Westphal <fw@strlen.de> wrote:

> This is needed in case a new transaction is made that doesn't insert any
> new elements into an already existing set.
> 
> Else, after second 'nft -f ruleset.txt', lookups in such a set will fail
> because ->lookup() encounters raw_cpu_ptr(m->scratch) == NULL.
> 
> For the initial rule load, insertion of elements takes care of the
> allocation, but for rule reloads this isn't guaranteed: we might not
> have additions to the set.
> 
> Fixes: 3c4287f62044a90e ("nf_tables: Add set type for arbitrary concatenation of ranges")
> Reported-by: etkaar <lists.netfilter.org@prvy.eu>
> Signed-off-by: Florian Westphal <fw@strlen.de>

Reviewed-by: Stefano Brivio <sbrivio@redhat.com>

-- 
Stefano

