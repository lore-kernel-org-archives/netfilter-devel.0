Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.5 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C808BC433DB
	for <netfilter-devel@archiver.kernel.org>; Fri, 19 Mar 2021 12:58:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8480B64DBA
	for <netfilter-devel@archiver.kernel.org>; Fri, 19 Mar 2021 12:58:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230106AbhCSM6W (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 19 Mar 2021 08:58:22 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:20325 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230096AbhCSM6B (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 19 Mar 2021 08:58:01 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1616158680;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=AvDFQrBAbe8H5yunB45IdDhjKgC5KZgLyWB2+9tLEDs=;
        b=X9UUNHN1Cdc0Il9VGeN3D3rdRh3CMgWdcB0P04YCQJQYokAo2jdG2nhUoQ0SyiSll6xpTj
        ytIxrqvrckquhAOH3wD+RUPhK8gI2c0bG3L/rCJtf0MLDz1aQfD4gMejzRqypSI7h9VdOF
        FjHjppubGCrk7lujnq9oM+D6XunokS0=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-13-10XZudypN1ekSEFbUy3ynQ-1; Fri, 19 Mar 2021 08:57:56 -0400
X-MC-Unique: 10XZudypN1ekSEFbUy3ynQ-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 79A32180FCA0;
        Fri, 19 Mar 2021 12:57:54 +0000 (UTC)
Received: from madcap2.tricolour.ca (unknown [10.10.110.27])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 736B919CB1;
        Fri, 19 Mar 2021 12:57:45 +0000 (UTC)
Date:   Fri, 19 Mar 2021 08:57:42 -0400
From:   Richard Guy Briggs <rgb@redhat.com>
To:     Phil Sutter <phil@nwl.cc>,
        Linux-Audit Mailing List <linux-audit@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>,
        netfilter-devel@vger.kernel.org, Paul Moore <paul@paul-moore.com>,
        Eric Paris <eparis@parisplace.org>,
        Steve Grubb <sgrubb@redhat.com>,
        Florian Westphal <fw@strlen.de>, twoerner@redhat.com,
        tgraf@infradead.org, dan.carpenter@oracle.com,
        Jones Desougi <jones.desougi+netfilter@gmail.com>
Subject: Re: [PATCH] audit: log nftables configuration change events once per
 table
Message-ID: <20210319125742.GM3141668@madcap2.tricolour.ca>
References: <7e73ce4aa84b2e46e650b5727ee7a8244ec4a0ac.1616078123.git.rgb@redhat.com>
 <20210318163032.GS5298@orbyte.nwl.cc>
 <20210318183703.GL3141668@madcap2.tricolour.ca>
 <20210319125243.GU5298@orbyte.nwl.cc>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210319125243.GU5298@orbyte.nwl.cc>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On 2021-03-19 13:52, Phil Sutter wrote:
> On Thu, Mar 18, 2021 at 02:37:03PM -0400, Richard Guy Briggs wrote:
> > On 2021-03-18 17:30, Phil Sutter wrote:
> [...]
> > > Why did you leave the object-related logs in place? They should reappear
> > > at commit time just like chains and sets for instance, no?
> > 
> > There are other paths that can trigger these messages that don't go
> > through nf_tables_commit() that affect the configuration data.  The
> > counters are considered config data for auditing purposes and the act of
> > resetting them is audittable.  And the only time we want to emit a
> > record is when they are being reset.
> 
> Oh, I see. I wasn't aware 'nft reset' bypasses the transaction logic,
> thanks for clarifying!

That's my current understanding.  If someone else has a better
understanding I'd be grateful if they could correct me.

> Cheers, Phil

- RGB

--
Richard Guy Briggs <rgb@redhat.com>
Sr. S/W Engineer, Kernel Security, Base Operating Systems
Remote, Ottawa, Red Hat Canada
IRC: rgb, SunRaycer
Voice: +1.647.777.2635, Internal: (81) 32635

