Return-Path: <SRS0=yGNv=5I=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 68114C54FCE
	for <netfilter-devel@archiver.kernel.org>; Mon, 23 Mar 2020 13:02:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3684A2072E
	for <netfilter-devel@archiver.kernel.org>; Mon, 23 Mar 2020 13:02:41 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="aZU/GgBa"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728245AbgCWNCl (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 23 Mar 2020 09:02:41 -0400
Received: from us-smtp-delivery-74.mimecast.com ([63.128.21.74]:37905 "EHLO
        us-smtp-delivery-74.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727608AbgCWNCk (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 23 Mar 2020 09:02:40 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1584968560;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=sCh9GYq7+wUzdE00tIoovgkGLE0YDWtD87rHvMNnLyU=;
        b=aZU/GgBajvXO3HWb6OyG6Y/amoeBeNC5XoYUHgzK9A3uX5A7HnM9kC0Iwj4DxZRgtH5vOc
        0A/DNRblIQYkADwiSeBPWtsHMxBfQ7jgdPy3mH297FM00mSpbl4Wucr8EEaIlJ5CoC5Mpq
        0Ny1IVtU4T8VCkM3IJYRIddmySYYfEk=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-242-lvv0_vaTM4q56z5beKrv4w-1; Mon, 23 Mar 2020 09:02:38 -0400
X-MC-Unique: lvv0_vaTM4q56z5beKrv4w-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 6E661107ACC7;
        Mon, 23 Mar 2020 13:02:37 +0000 (UTC)
Received: from localhost (unknown [10.40.208.77])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 376CF5DA81;
        Mon, 23 Mar 2020 13:02:35 +0000 (UTC)
Date:   Mon, 23 Mar 2020 14:02:31 +0100
From:   Stefano Brivio <sbrivio@redhat.com>
To:     Florian Westphal <fw@strlen.de>
Cc:     <netfilter-devel@vger.kernel.org>
Subject: Re: [PATCH nf] selftests: netfilter: add nfqueue test case
Message-ID: <20200323140231.56d71baf@redhat.com>
In-Reply-To: <20200323125200.2396-1-fw@strlen.de>
References: <20200323125200.2396-1-fw@strlen.de>
Organization: Red Hat
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Mon, 23 Mar 2020 13:52:00 +0100
Florian Westphal <fw@strlen.de> wrote:

>  tools/testing/selftests/netfilter/nf-queue.c  | 352 ++++++++++++++++++
>  .../testing/selftests/netfilter/nft_queue.sh  | 319 ++++++++++++++++

I guess you should add this as TEST_PROGS in the Makefile too.

-- 
Stefano

