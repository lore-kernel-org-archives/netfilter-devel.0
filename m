Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.4 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1AE7EC433B4
	for <netfilter-devel@archiver.kernel.org>; Fri,  7 May 2021 10:36:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BDF366102A
	for <netfilter-devel@archiver.kernel.org>; Fri,  7 May 2021 10:36:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236933AbhEGKhv (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 7 May 2021 06:37:51 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:46003 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S236915AbhEGKhu (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 7 May 2021 06:37:50 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1620383811;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=NJ/oO8zYmELJ93OA4GqPbsJBBGOph7K3kwhRSSUmEVs=;
        b=icQ58Y0ZrE7gpNN5Qo2sWfTo981PhaLx0lbaIFGpB59zeIcQjWrdEZEa18Wp5hIdpjWwhl
        b4v2IUVChMZY5r+etFM63u/VLClhc+wLklTm5dooIGONT8yLH5/GWwt2qynHlJHgtYUvCj
        easei3EhHtYlo8ovw2cVBF1H5a2zSrQ=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-500-5vVflmB6OAWp3U6KWXhqAQ-1; Fri, 07 May 2021 06:36:49 -0400
X-MC-Unique: 5vVflmB6OAWp3U6KWXhqAQ-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 47E22107ACE6;
        Fri,  7 May 2021 10:36:48 +0000 (UTC)
Received: from maya.cloud.tilaa.com (unknown [10.36.110.6])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 178E45C277;
        Fri,  7 May 2021 10:36:48 +0000 (UTC)
Date:   Fri, 7 May 2021 12:36:36 +0200
From:   Stefano Brivio <sbrivio@redhat.com>
To:     Arturo Borrero Gonzalez <arturo@netfilter.org>
Cc:     "netfilter-devel@vger.kernel.org" <netfilter-devel@vger.kernel.org>
Subject: Re: nft_pipapo_avx2_lookup backtrace in linux 5.10
Message-ID: <20210507123636.030e98ef@elisabeth>
In-Reply-To: <8ff71ad7-7171-c8c7-f31b-d4bd7577cc18@netfilter.org>
References: <8ff71ad7-7171-c8c7-f31b-d4bd7577cc18@netfilter.org>
Organization: Red Hat
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Hi Arturo,

On Fri, 7 May 2021 11:26:51 +0200
Arturo Borrero Gonzalez <arturo@netfilter.org> wrote:

> Hi there,
> 
> I got this backtrace in one of my servers. I wonder if it is known or fixed 
> already in a later version.

Not as far as I know. At a glance:

> [...]
>
> [Thu May  6 16:20:21 2021]  nft_pipapo_avx2_lookup+0x4c/0x1cba [nf_tables]
>
> [...]
>
> [Thu May  6 16:20:21 2021]  asm_common_interrupt+0x1e/0x40
> [Thu May  6 16:20:21 2021] RIP: 0010:crc_41+0x0/0x1e [crc32c_intel]

we probably need to add an irq_fpu_usable() check in
nft_pipapo_avx2_lookup() and fall back to nft_pipapo_avx2_lookup_slow()
if that returns false, but I haven't looked into this thoroughly yet.

Can you reproduce this reliably? That would be helpful.

-- 
Stefano

