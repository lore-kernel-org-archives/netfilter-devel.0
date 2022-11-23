Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 376C9C4167D
	for <netfilter-devel@archiver.kernel.org>; Wed, 23 Nov 2022 15:02:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236875AbiKWPCF (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 23 Nov 2022 10:02:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35004 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238103AbiKWPCD (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 23 Nov 2022 10:02:03 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 67659616C
        for <netfilter-devel@vger.kernel.org>; Wed, 23 Nov 2022 07:01:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1669215659;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=FM3rua+YJ3wAZfR5GvCKM+092JwtI664TeDSun388g8=;
        b=QV9Wm966v+FNWwC8uYH81NL4hOfn43bz8//3gFnykbr8ylGqT6Uxha06xk6JJFvmiSfpzA
        ZjUP3c9V2idsMLm6ETN2jKc/9Ot32ZZzzQaYXGT6ZaBxWU1W2ekGKvag6bu4pudqSRcWMO
        JnTqMFP9tO3dD24HCb4YC0gPL0AO/ew=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-561-Z-pUyIETM1W7NIbqfUWi9w-1; Wed, 23 Nov 2022 10:00:58 -0500
X-MC-Unique: Z-pUyIETM1W7NIbqfUWi9w-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com [10.11.54.8])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id D7DAC296A601;
        Wed, 23 Nov 2022 15:00:57 +0000 (UTC)
Received: from localhost (wsfd-netdev-vmhost.ntdv.lab.eng.bos.redhat.com [10.19.188.17])
        by smtp.corp.redhat.com (Postfix) with ESMTP id C9F87C1908A;
        Wed, 23 Nov 2022 15:00:57 +0000 (UTC)
Date:   Wed, 23 Nov 2022 10:00:47 -0500
From:   Eric Garver <egarver@redhat.com>
To:     Florian Westphal <fw@strlen.de>
Cc:     netfilter-devel@vger.kernel.org
Subject: Re: [PATCH v2 nf] netfilter: conntrack: set icmpv6 redirects as
 RELATED
Message-ID: <Y341n075lg67rm0U@wsfd-netdev-vmhost.ntdv.lab.eng.bos.redhat.com>
Mail-Followup-To: Eric Garver <egarver@redhat.com>,
        Florian Westphal <fw@strlen.de>, netfilter-devel@vger.kernel.org
References: <20221123121639.27624-1-fw@strlen.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221123121639.27624-1-fw@strlen.de>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.8
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Wed, Nov 23, 2022 at 01:16:39PM +0100, Florian Westphal wrote:
> icmp conntrack will set icmp redirects as RELATED, but icmpv6 will not
> do this.
> 
> For icmpv6, only icmp errors (code <= 128) are examined for RELATED state.
> ICMPV6 Redirects are part of neighbour discovery mechanism, those are
> handled by marking a selected subset (e.g.  neighbour solicitations) as
> UNTRACKED, but not REDIRECT -- they will thus be flagged as INVALID.
> 
> Add minimal support for REDIRECTs.  No parsing of neighbour options is
> added for simplicity, so this will only check that we have the embeeded
> original header (ND_OPT_REDIRECT_HDR), and then attempt to do a flow
> lookup for this tuple.
> 
> Also extend the existing test case to cover redirects.
> 
> Reported-by: Eric Garver <eric@garver.life>
> Link: https://github.com/firewalld/firewalld/issues/1046
> Signed-off-by: Florian Westphal <fw@strlen.de>
> ---
>  v2: fix up comment typo and reformat commit message.  No other changes.
> 
>  net/netfilter/nf_conntrack_proto_icmpv6.c     | 53 +++++++++++++++++++
>  .../netfilter/conntrack_icmp_related.sh       | 36 ++++++++++++-
>  2 files changed, 87 insertions(+), 2 deletions(-)

Thanks Florian!

Acked-by: Eric Garver <eric@garver.life>

