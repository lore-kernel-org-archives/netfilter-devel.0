Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.5 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4885FC433B4
	for <netfilter-devel@archiver.kernel.org>; Sat,  8 May 2021 01:00:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id F124161421
	for <netfilter-devel@archiver.kernel.org>; Sat,  8 May 2021 01:00:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230152AbhEHBBw (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 7 May 2021 21:01:52 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:21534 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229524AbhEHBBv (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 7 May 2021 21:01:51 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1620435651;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=ME5pagLhdcdp2EfQiF12b7sWVV6mylj3kTUPAbdQpRY=;
        b=d0I+T8fn0i3Eytal/FRplCbsRVbPX7KFWgTiNdT3VBx0WlxNV7+WZhczPYRf7cbgzZ6XLn
        fyIUMalFEmHpzhMUVstcUIb8NJm9Qxjn2awPuR3IO8qv9xYZTZk0OKsdMN+8q6bwyTjjLb
        CA2VeX4YS61ateDygZFmdfLmqJJ5gKY=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-480-vkp5euYoOgOBwtLoU5_EiQ-1; Fri, 07 May 2021 21:00:49 -0400
X-MC-Unique: vkp5euYoOgOBwtLoU5_EiQ-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 5F27C80059E;
        Sat,  8 May 2021 01:00:48 +0000 (UTC)
Received: from maya.cloud.tilaa.com (unknown [10.36.110.6])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 3601436D5;
        Sat,  8 May 2021 01:00:48 +0000 (UTC)
Date:   Sat, 8 May 2021 03:00:46 +0200
From:   Stefano Brivio <sbrivio@redhat.com>
To:     Arturo Borrero Gonzalez <arturo@netfilter.org>
Cc:     "netfilter-devel@vger.kernel.org" <netfilter-devel@vger.kernel.org>
Subject: Re: nft_pipapo_avx2_lookup backtrace in linux 5.10
Message-ID: <20210508030046.4ae872f6@redhat.com>
In-Reply-To: <a044a8bb-e7cd-35e5-9602-0879f872656c@netfilter.org>
References: <8ff71ad7-7171-c8c7-f31b-d4bd7577cc18@netfilter.org>
        <20210507123636.030e98ef@elisabeth>
        <a044a8bb-e7cd-35e5-9602-0879f872656c@netfilter.org>
Organization: Red Hat
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Fri, 7 May 2021 13:12:43 +0200
Arturo Borrero Gonzalez <arturo@netfilter.org> wrote:

> However, the nft ruleset is quite simple. It should be possible for you to grab 
> a similar arch CPU, introduce the ruleset and generate some traffic to trigger 
> the lookup(), no?

Unfortunately, this has little to do with the ruleset, it's rather
about the fact that a kthread using the FPU gets interrupted by
net_rx_action() which ends up in a call to nft_pipapo_avx2_lookup(),
which also uses the FPU.

The amount of luck I'd need to hit this with some ext4 worklaod
together with packet classification discourages me from even trying. ;)
But luckily my mistake here looks simple enough to fix.

-- 
Stefano

