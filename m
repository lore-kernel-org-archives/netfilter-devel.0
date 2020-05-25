Return-Path: <SRS0=uYLw=7H=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 45949C433DF
	for <netfilter-devel@archiver.kernel.org>; Mon, 25 May 2020 12:50:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1C6A72073B
	for <netfilter-devel@archiver.kernel.org>; Mon, 25 May 2020 12:50:40 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="e2uV8r+5"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390618AbgEYMuj (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 25 May 2020 08:50:39 -0400
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:54106 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S2390501AbgEYMuj (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 25 May 2020 08:50:39 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1590411038;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=XHN+elCfwcOw0838CZW70Pam8zm7F5oVD/v2pP4Q0bY=;
        b=e2uV8r+5Ge3LUB74PtN6ero3bApi3eYGGdgYvEfCOEzJbiuDyazwPKxJjPXZfuKoT2mJj2
        OM6+fsnAwZk4QWTUzYOCEeSPlw3WEs4t9XoST7wnS5A4ytvVFCOqYgsgtITQN7a8MhuNcA
        5X/ziUjQYV7gMYfy5Wdhv0G9/uyiTQQ=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-112-iHXgy-rRMduXiuUXjvrXmw-1; Mon, 25 May 2020 08:50:36 -0400
X-MC-Unique: iHXgy-rRMduXiuUXjvrXmw-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 0EF08107ACCD;
        Mon, 25 May 2020 12:50:36 +0000 (UTC)
Received: from localhost (unknown [10.36.110.3])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 2962878B57;
        Mon, 25 May 2020 12:50:34 +0000 (UTC)
Date:   Mon, 25 May 2020 14:50:31 +0200
From:   Stefano Brivio <sbrivio@redhat.com>
To:     Konstantin Khorenko <khorenko@virtuozzo.com>
Cc:     netfilter-devel@vger.kernel.org
Subject: Re: How to test the kernel netfilter logic?
Message-ID: <20200525145031.42afc130@redhat.com>
In-Reply-To: <e925907a-475f-725e-a2b7-6b9d78b236d1@virtuozzo.com>
References: <e925907a-475f-725e-a2b7-6b9d78b236d1@virtuozzo.com>
Organization: Red Hat
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Hi Konstantin,

On Mon, 25 May 2020 11:37:57 +0300
Konstantin Khorenko <khorenko@virtuozzo.com> wrote:

> but did not find netfilter tests in kernel git repo as well.

Have a look at tools/testing/selftests/netfilter/, some of the tests
there actually send traffic and check the outcome.

-- 
Stefano

