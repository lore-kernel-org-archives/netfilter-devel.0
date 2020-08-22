Return-Path: <SRS0=C2Rd=CA=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 700F9C433DF
	for <netfilter-devel@archiver.kernel.org>; Sat, 22 Aug 2020 09:15:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 38D25207C3
	for <netfilter-devel@archiver.kernel.org>; Sat, 22 Aug 2020 09:15:25 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="i4PxPVeF"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726169AbgHVJPY (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sat, 22 Aug 2020 05:15:24 -0400
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:20425 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725864AbgHVJPY (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sat, 22 Aug 2020 05:15:24 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1598087722;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=jAOtPkJ1v9T2WHGUuRabv7TQ5faUHFB0WFI+pMwaoLw=;
        b=i4PxPVeFcn/zpEYVT+yVOwNJofil7u9NU30pVPCOKuozvXiqKLicWaYpv33PqVjIcLt03n
        fbaA07DSnb2gYT4o+bJJqd17HHXH8ZDLH3s66vfR7hVtwUgg99h7OsswPwcgYSJlpt28V1
        J+AeiKwLFprK6Ldt3zn7ec75/Ic/qJc=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-457-ZcdlchfVO-ufXu5iw0vlPg-1; Sat, 22 Aug 2020 05:15:20 -0400
X-MC-Unique: ZcdlchfVO-ufXu5iw0vlPg-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 8948D81F00C;
        Sat, 22 Aug 2020 09:15:19 +0000 (UTC)
Received: from elisabeth (unknown [10.36.110.10])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 886DD7E573;
        Sat, 22 Aug 2020 09:15:18 +0000 (UTC)
Date:   Sat, 22 Aug 2020 11:15:13 +0200
From:   Stefano Brivio <sbrivio@redhat.com>
To:     Balazs Scheidler <bazsi77@gmail.com>
Cc:     netfilter-devel@vger.kernel.org
Subject: Re: [PATCH nftables 4/4] tests: allow tests to use a custom nft
 executable
Message-ID: <20200822111513.5495cddb@elisabeth>
In-Reply-To: <20200822062203.3617-5-bazsi77@gmail.com>
References: <20200822062203.3617-1-bazsi77@gmail.com>
        <20200822062203.3617-5-bazsi77@gmail.com>
Organization: Red Hat
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Hi Balazs,

On Sat, 22 Aug 2020 08:22:03 +0200
Balazs Scheidler <bazsi77@gmail.com> wrote:

> diff --git a/tests/shell/run-tests.sh b/tests/shell/run-tests.sh
> index 943f8877..5233ba86 100755
> --- a/tests/shell/run-tests.sh
> +++ b/tests/shell/run-tests.sh
> @@ -2,7 +2,7 @@
>  
>  # Configuration
>  TESTDIR="./$(dirname $0)/testcases"
> -SRC_NFT="$(dirname $0)/../../src/nft"
> +SRC_NFT=${NFT:-../../src/nft}

This isn't needed (and lacks quotes, won't work with a wrapper, e.g.
valgrind). It's already possible to pass a different nft executable
because later we have:

	[ -z "$NFT" ] && NFT=$SRC_NFT

...now, you could in theory replace this assignment with the one you
proposed, but I think a SRC_NFT="../../src/nft" variable is more obvious
to configure compared to NFT="${NFT:../../src/nft}".

-- 
Stefano

