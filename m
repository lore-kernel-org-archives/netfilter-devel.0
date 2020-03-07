Return-Path: <SRS0=kyt/=4Y=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ECC6EC10F00
	for <netfilter-devel@archiver.kernel.org>; Sat,  7 Mar 2020 10:16:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id BBE282073C
	for <netfilter-devel@archiver.kernel.org>; Sat,  7 Mar 2020 10:16:56 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="BQW2Vpjv"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726114AbgCGKQ4 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sat, 7 Mar 2020 05:16:56 -0500
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:38810 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726105AbgCGKQ4 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sat, 7 Mar 2020 05:16:56 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1583576215;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=+dtcjPrqZObrEPNpx15SskTERxUgPHC5cHBQX84CZk4=;
        b=BQW2Vpjvs7d+PoIQScLna0JQzwmcpVB7CRtM0orf584ThWxvnUjlk/csjp2HqY1gpZbjO5
        D8sAw9G5e1ghJIPG1iw5Ccp8HehbNmanwCgJ+3cUImuhUyyUFvmEvG3SlTUrMDi9mz+U7X
        Z5KtFOGKNEe4gICsZ8f70Jdyl1JZYG0=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-182-0MSGAlc1OvWJ45GZW89vPQ-1; Sat, 07 Mar 2020 05:16:51 -0500
X-MC-Unique: 0MSGAlc1OvWJ45GZW89vPQ-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id B22B78017CC;
        Sat,  7 Mar 2020 10:16:49 +0000 (UTC)
Received: from elisabeth (ovpn-200-26.brq.redhat.com [10.40.200.26])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 2F2C88B570;
        Sat,  7 Mar 2020 10:16:46 +0000 (UTC)
Date:   Sat, 7 Mar 2020 11:16:41 +0100
From:   Stefano Brivio <sbrivio@redhat.com>
To:     Phil Sutter <phil@nwl.cc>
Cc:     Pablo Neira Ayuso <pablo@netfilter.org>, Eric Garver <e@erig.me>,
        netfilter-devel@vger.kernel.org
Subject: Re: [nft PATCH v2 2/2] tests/py: Add tests involving concatenated
 ranges
Message-ID: <20200307111641.64b1c35b@elisabeth>
In-Reply-To: <20200307022633.6181-2-phil@nwl.cc>
References: <20200307022633.6181-1-phil@nwl.cc>
        <20200307022633.6181-2-phil@nwl.cc>
Organization: Red Hat
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Sat,  7 Mar 2020 03:26:33 +0100
Phil Sutter <phil@nwl.cc> wrote:

> * Anonymous sets don't accept concatenated ranges yet, so the second
>   rule is manually disabled for now.

By the way, I'm looking into this these days.

-- 
Stefano

