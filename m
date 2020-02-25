Return-Path: <SRS0=2ZCu=4N=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D4459C35E04
	for <netfilter-devel@archiver.kernel.org>; Tue, 25 Feb 2020 20:38:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A773520675
	for <netfilter-devel@archiver.kernel.org>; Tue, 25 Feb 2020 20:38:40 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="UTFgFdQE"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731847AbgBYUik (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 25 Feb 2020 15:38:40 -0500
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:59083 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728119AbgBYUik (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 25 Feb 2020 15:38:40 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1582663118;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=ubusoSsZ/8MiDLmsZ6sZn9fdYkcXkGNT7dKKZYMsnG8=;
        b=UTFgFdQEzbOnQ8WjJRa+bboUo4rDgVqRKhWPnoB/q/vHE+BMKCI5ULAn2xhxFyxADi2vbu
        Pnc+4lCt2evAv/cfIXi4odEGsIAHjzlr6l9hBJE2xDGU9pYL7x1WBseY2Y4t4KAkHUDYZi
        +cf0vFOsWRyyI1KWOzzfBw5hwgilb1Y=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-67-CAw0vTtoOb2NJQuyEAetTA-1; Tue, 25 Feb 2020 15:38:36 -0500
X-MC-Unique: CAw0vTtoOb2NJQuyEAetTA-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 84E24DB2C;
        Tue, 25 Feb 2020 20:38:35 +0000 (UTC)
Received: from localhost (ovpn-200-22.brq.redhat.com [10.40.200.22])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 56A2A60BE2;
        Tue, 25 Feb 2020 20:38:32 +0000 (UTC)
Date:   Tue, 25 Feb 2020 21:38:15 +0100
From:   Stefano Brivio <sbrivio@redhat.com>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     Phil Sutter <phil@nwl.cc>, netfilter-devel@vger.kernel.org,
        Florian Westphal <fw@strlen.de>
Subject: Re: [PATCH nf 0/2] nft_set_pipapo: Fix crash due to dangling
 entries in mapping table
Message-ID: <20200225213815.3c0a1caa@redhat.com>
In-Reply-To: <20200225202143.tqsfhggvklvhnsvs@salvia>
References: <cover.1582250437.git.sbrivio@redhat.com>
        <20200221211704.GM20005@orbyte.nwl.cc>
        <20200221232218.2157d72b@elisabeth>
        <20200222011933.GO20005@orbyte.nwl.cc>
        <20200223222258.2bb7516a@redhat.com>
        <20200225123934.p3vru3tmbsjj2o7y@salvia>
        <20200225141346.7406e06b@redhat.com>
        <20200225134236.sdz5ujufvxm2in3h@salvia>
        <20200225153435.17319874@redhat.com>
        <20200225202143.tqsfhggvklvhnsvs@salvia>
Organization: Red Hat
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Tue, 25 Feb 2020 21:21:43 +0100
Pablo Neira Ayuso <pablo@netfilter.org> wrote:

> Hi Stefano,
> 
> On Tue, Feb 25, 2020 at 03:34:35PM +0100, Stefano Brivio wrote:
> [...]
> > This is the problem Phil reported:  
> [...]
> > Or also simply with:
> > 
> > # nft add element t s '{ 20-30 . 40 }'
> > # nft add element t s '{ 25-35 . 40 }'
> > 
> > the second element is silently ignored. I'm returning -EEXIST from
> > nft_pipapo_insert(), but nft_add_set_elem() clears it because NLM_F_EXCL
> > is not set.
> > 
> > Are you suggesting that this is consistent and therefore not a problem?  
> 
>                         NLM_F_EXCL      !NLM_F_EXCL
>         exact match       EEXIST             0 [*]
>         partial match     EEXIST           EEXIST
> 
> The [*] case would allow for element timeout/expiration updates from
> the control plane for exact matches.

A-ha. I didn't even consider that.

> Note that element updates are not
> supported yet, so this check for !NLM_F_EXCL is a stub. I don't think
> we should allow for updates on partial matches
> 
> I think what it is missing is a error to report "partial match" from
> pipapo. Then, the core translates this "partial match" error to EEXIST
> whether NLM_F_EXCL is set or not.

Yes, given what you explained, I also think it's the case.

> Would this work for you?

It would. I need to write a few more lines in nft_pipapo_insert(),
because right now I don't have a special case for "entirely
overlapping". Something on the lines of:

	dup = pipapo_get(net, set, start, genmask);
	if (PTR_ERR(dup) == -ENOENT) {

-->		compare start and end key for this entry with
		start and end key from 'ext'

Let me know if you want me to post a patch with a placeholder for
whatever you have in mind, or if I can help implementing this, etc.

Thanks!

-- 
Stefano

