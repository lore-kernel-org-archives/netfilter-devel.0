Return-Path: <SRS0=/ZNS=BC=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 25C7DC433E0
	for <netfilter-devel@archiver.kernel.org>; Thu, 23 Jul 2020 01:39:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0621320781
	for <netfilter-devel@archiver.kernel.org>; Thu, 23 Jul 2020 01:39:56 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="R4FPmaq4"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387732AbgGWBjz (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 22 Jul 2020 21:39:55 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:57686 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1733075AbgGWBjz (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 22 Jul 2020 21:39:55 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1595468394;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=j09wBfZSkgNAG8rgXViyGL7gthBd7q0Sy6owM9xrjL0=;
        b=R4FPmaq4jsn7C4+q0NS8l5CbOQS+dzVRoy3l9XKWAPCtl8iZvWVit7rqm2w6lOUaP1WFrC
        cZv8P0cNo75KfumI1SqO+UjG6xmeku7T8VdS8g9nZ/rKMj9joriaUFi7p3pGAzpa1ue+7Q
        dvh1uREfJ41vYz5apSuk8vm3nCy76IQ=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-326-jMEMrsxlPKqGZPGyg4J1qw-1; Wed, 22 Jul 2020 21:39:52 -0400
X-MC-Unique: jMEMrsxlPKqGZPGyg4J1qw-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id EE07B59;
        Thu, 23 Jul 2020 01:39:50 +0000 (UTC)
Received: from elisabeth (unknown [10.36.110.10])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 7BD748AD1C;
        Thu, 23 Jul 2020 01:39:48 +0000 (UTC)
Date:   Thu, 23 Jul 2020 03:39:41 +0200
From:   Stefano Brivio <sbrivio@redhat.com>
To:     Florian Westphal <fw@strlen.de>
Cc:     <netfilter-devel@vger.kernel.org>
Subject: Re: [PATCH nft 2/2] tests: extend 0043concatenated_ranges_0 to
 cover maps too
Message-ID: <20200723033941.560c3df5@elisabeth>
In-Reply-To: <20200722115126.12596-2-fw@strlen.de>
References: <20200722115126.12596-1-fw@strlen.de>
        <20200722115126.12596-2-fw@strlen.de>
Organization: Red Hat
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Wed, 22 Jul 2020 13:51:26 +0200
Florian Westphal <fw@strlen.de> wrote:

> +			"map")
> +				mapt=": mark"
> +				mark=$RANDOM
> +				mapv=$(printf " : 0x%08x" ${mark})

I don't have $RANDOM in dash :( Can you use $(date +%s) (it's
POSIX.2-1992) or a fixed number instead? The test doesn't fail for me
because printf turns that empty variable into 0x00000000 anyway, but it's
not really specified.

Looks good to me otherwise.

-- 
Stefano

