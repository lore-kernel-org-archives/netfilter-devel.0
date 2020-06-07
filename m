Return-Path: <SRS0=+9KY=7U=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 19892C433DF
	for <netfilter-devel@archiver.kernel.org>; Sun,  7 Jun 2020 16:06:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DC09920663
	for <netfilter-devel@archiver.kernel.org>; Sun,  7 Jun 2020 16:06:28 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="fiy9n7ku"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726571AbgFGQG2 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sun, 7 Jun 2020 12:06:28 -0400
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:42912 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726545AbgFGQG2 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sun, 7 Jun 2020 12:06:28 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1591545985;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=mAgNsyjbomOFdTU3wGMTPpVXndRmXBxx3Au70+2J9oY=;
        b=fiy9n7ku3uVrejzTh15f9wp0KKVeQj5FSsMy52N3sJUoIr3nkx03nQyGJB5WfpwyGCLAgq
        JhmIis8QMWl2Z0jGP9LXwIeISU4BC+yUFMdynUAosCAo5yv/Fmk7I68ew2bgePyNBQU49T
        bRJ0W1UzYoTbvQDxISgZ69ZLewkM9Uk=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-139-FnojifjMO7mx0lXg1d4rDA-1; Sun, 07 Jun 2020 12:06:23 -0400
X-MC-Unique: FnojifjMO7mx0lXg1d4rDA-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 8FA2E18B6425;
        Sun,  7 Jun 2020 16:06:22 +0000 (UTC)
Received: from elisabeth (unknown [10.36.110.8])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 1708B10013D0;
        Sun,  7 Jun 2020 16:06:20 +0000 (UTC)
Date:   Sun, 7 Jun 2020 18:06:14 +0200
From:   Stefano Brivio <sbrivio@redhat.com>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org, nucleo@fedoraproject.org
Subject: Re: [PATCH nft,v2] evaluate: missing datatype definition in
 implicit_set_declaration()
Message-ID: <20200607180614.2146750e@elisabeth>
In-Reply-To: <20200607134007.1798-1-pablo@netfilter.org>
References: <20200607134007.1798-1-pablo@netfilter.org>
Organization: Red Hat
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Sun,  7 Jun 2020 15:40:07 +0200
Pablo Neira Ayuso <pablo@netfilter.org> wrote:

> set->data from implicit_set_declaration(), otherwise, set_evaluation()
> bails out with:
> 
>  # nft -f /etc/nftables/inet-filter.nft
>  /etc/nftables/inet-filter.nft:8:32-54: Error: map definition does not specify
>  mapping data type
>                 tcp dport vmap { 22 : jump ssh_input }
>                                ^^^^^^^^^^^^^^^^^^^^^^^
>  /etc/nftables/inet-filter.nft:13:26-52: Error: map definition does not specify
>  mapping data type
>                  iif vmap { "eth0" : jump wan_input }
>                           ^^^^^^^^^^^^^^^^^^^^^^^^^^^
> 
> Add a test to cover this case.
> 
> Fixes: 7aa08d45031e ("evaluate: Perform set evaluation on implicitly declared (anonymous) sets")
> Closes: https://bugzilla.kernel.org/show_bug.cgi?id=208093
> Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>

Whoops, sorry, I didn't think of that case at all. Thanks for fixing it.

Reviewed-by: Stefano Brivio <sbrivio@redhat.com>

-- 
Stefano

