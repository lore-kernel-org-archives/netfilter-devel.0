Return-Path: <SRS0=1PBg=36=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0A6A9C352A4
	for <netfilter-devel@archiver.kernel.org>; Mon, 10 Feb 2020 15:12:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id CA84F20714
	for <netfilter-devel@archiver.kernel.org>; Mon, 10 Feb 2020 15:12:40 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="UxTDPgR4"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729065AbgBJPMh (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 10 Feb 2020 10:12:37 -0500
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:43553 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727637AbgBJPMg (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 10 Feb 2020 10:12:36 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1581347556;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=5TfrepxBJJxmbjB0OX3FYkTn2hilWeyBf15in8jo9Z4=;
        b=UxTDPgR47qZXmiZI1kWjVmyNW7srmYuEkHccHrfKn2KuH0ljn+WzTHOQupBh8nBU3pcBEg
        39RGVL7YSS9h+NKCfl+MLx7Yl3yw4haSypAVvna2etf1ZRyTHssYTziJSPSXvWw2jddkIK
        b2Pa7l6iXJoqdLsUi1grvdTvmx/Kc90=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-8-4cfTw6hJPZy4KqwQrnfAjA-1; Mon, 10 Feb 2020 10:12:18 -0500
X-MC-Unique: 4cfTw6hJPZy4KqwQrnfAjA-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id C3C2E108838A;
        Mon, 10 Feb 2020 15:12:16 +0000 (UTC)
Received: from localhost (ovpn-200-43.brq.redhat.com [10.40.200.43])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id A088A26FBF;
        Mon, 10 Feb 2020 15:12:13 +0000 (UTC)
Date:   Mon, 10 Feb 2020 16:12:09 +0100
From:   Stefano Brivio <sbrivio@redhat.com>
To:     Chen Wandun <chenwandun@huawei.com>
Cc:     <pablo@netfilter.org>, <kadlec@netfilter.org>, <fw@strlen.de>,
        <davem@davemloft.net>, <kuba@kernel.org>,
        <netfilter-devel@vger.kernel.org>, <coreteam@netfilter.org>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH next] nf_tables: make the symbol 'nft_pipapo_get' static
Message-ID: <20200210161209.588b5c4e@redhat.com>
In-Reply-To: <20200210085109.13954-1-chenwandun@huawei.com>
References: <20200210085109.13954-1-chenwandun@huawei.com>
Organization: Red Hat
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Mon, 10 Feb 2020 16:51:09 +0800
Chen Wandun <chenwandun@huawei.com> wrote:

> Fix the following sparse warning:
> 
> net/netfilter/nft_set_pipapo.c:739:6: warning: symbol 'nft_pipapo_get' was not declared. Should it be static?

Whoops, thanks for fixing this.

> Fixes: 3c4287f62044 ("nf_tables: Add set type for arbitrary concatenation of ranges")
> Signed-off-by: Chen Wandun <chenwandun@huawei.com>

Acked-by: Stefano Brivio <sbrivio@redhat.com>

-- 
Stefano

