Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9FBA0C433DB
	for <netfilter-devel@archiver.kernel.org>; Thu, 18 Feb 2021 21:21:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 42E4464E4B
	for <netfilter-devel@archiver.kernel.org>; Thu, 18 Feb 2021 21:21:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229700AbhBRVVt (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 18 Feb 2021 16:21:49 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:26037 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229544AbhBRVVr (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 18 Feb 2021 16:21:47 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1613683220;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=1ewdW74Ea/Q6Basd8TgHUzZo3WsqpwUIBmwyboI5wwo=;
        b=HJEsFV1Inv0jpVxgr1x8Hu/mDxNNzl7wTQMJYhFxZXSOcyPP+Jqq4PVMWWGv07FT+GNrBd
        8r8pIWr0Wn0FVurXggWnuOaFPoxoXgB2CYfz1PeEiECnPC2kAkj+oAqSkVRzm/v1kGQTHX
        HZb8hwFK2DA6huJRRD7RXP4iOps9gIk=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-116-NgMDP51xMAC2331K9yM1qA-1; Thu, 18 Feb 2021 16:20:16 -0500
X-MC-Unique: NgMDP51xMAC2331K9yM1qA-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 75171EC1A1;
        Thu, 18 Feb 2021 21:20:15 +0000 (UTC)
Received: from madcap2.tricolour.ca (unknown [10.10.110.8])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 0CFD85D9C2;
        Thu, 18 Feb 2021 21:20:03 +0000 (UTC)
Date:   Thu, 18 Feb 2021 16:20:01 -0500
From:   Richard Guy Briggs <rgb@redhat.com>
To:     Florian Westphal <fw@strlen.de>
Cc:     Phil Sutter <phil@nwl.cc>, LKML <linux-kernel@vger.kernel.org>,
        Linux-Audit Mailing List <linux-audit@redhat.com>,
        netfilter-devel@vger.kernel.org, twoerner@redhat.com,
        Eric Paris <eparis@parisplace.org>, tgraf@infradead.org
Subject: Re: [PATCH ghak124 v3] audit: log nftables configuration change
 events
Message-ID: <20210218212001.GQ3141668@madcap2.tricolour.ca>
References: <f9da8b5dbf2396b621c77c17b5b1123be5aa484e.1591275439.git.rgb@redhat.com>
 <20210211151606.GX3158@orbyte.nwl.cc>
 <CAHC9VhTNQW9d=8GCW-70vAEMh8-LXviP+JHFC2-YkuitokLLMQ@mail.gmail.com>
 <20210211202628.GP2015948@madcap2.tricolour.ca>
 <20210211220930.GC2766@breakpoint.cc>
 <20210217234131.GN3141668@madcap2.tricolour.ca>
 <20210218082207.GJ2766@breakpoint.cc>
 <20210218124211.GO3141668@madcap2.tricolour.ca>
 <20210218125248.GB22944@breakpoint.cc>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210218125248.GB22944@breakpoint.cc>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On 2021-02-18 13:52, Florian Westphal wrote:
> Richard Guy Briggs <rgb@redhat.com> wrote:
> > On 2021-02-18 09:22, Florian Westphal wrote:
> > > > It seems I'd need to filter out the NFT_MSG_GET_* ops.
> > > 
> > > No need, the GET ops do not cause changes and will not trigger a
> > > generation id change.
> > 
> > Ah, so it could trigger on generation change.  Would GET ops be included
> > in any other change
> 
> No, GET ops are standalone, they cannot be part of a transaction.
> If you look at
> 
> static const struct nfnl_callback nf_tables_cb[NFT_MSG_MAX] = {
> 
> array in nf_tables_api.c, then those ops with a '.call_batch' can
> appear in transaction (i.e., can cause modification).
> 
> The other ones (.call_rcu) are read-only.
> 
> If they appear in a batch tehy will be ignored, if the batch consists of
> such non-modifying ops only then nf_tables_commit() returns early
> because the transaction list is empty (nothing to do/change).

Ok, one little inconvenient question: what about GETOBJ_RESET?  That
looks like a hybrid that modifies kernel table counters and reports
synchronously.  That could be a special case call in
nf_tables_dump_obj() and nf_tables_getobj().  Will that cause a storm
per commit?

> > such that it would be desirable to filter them out
> > to reduce noise in that single log line if it is attempted to list all
> > the change ops?  It almost sounds like it would be better to do one
> > audit log line for each table for each family, and possibly for each op
> > to avoid the need to change userspace.  This would already be a
> > significant improvement picking the highest ranking op.
> 
> I think i understand what you'd like to do.  Yes, that would reduce
> the log output a lot.

Coded, testing...

- RGB

--
Richard Guy Briggs <rgb@redhat.com>
Sr. S/W Engineer, Kernel Security, Base Operating Systems
Remote, Ottawa, Red Hat Canada
IRC: rgb, SunRaycer
Voice: +1.647.777.2635, Internal: (81) 32635

