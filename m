Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4496FC433E0
	for <netfilter-devel@archiver.kernel.org>; Fri, 19 Feb 2021 19:26:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0AA2764E77
	for <netfilter-devel@archiver.kernel.org>; Fri, 19 Feb 2021 19:26:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229876AbhBST0x (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 19 Feb 2021 14:26:53 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:29234 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229649AbhBST0x (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 19 Feb 2021 14:26:53 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1613762727;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=W0XtyFoYPd45tbMHV7KimVZYYJ5vrSX8aHkAnlZNZqc=;
        b=UdoOLbGYfzbLYdS/ziLp1ItHjw6iTSTiQRx223rHD93rfifh6hvrhE0+rLAQzr237875jn
        Ps1vbH1eOWYTT+3GWB60jSmtizMLHp6XXNPGTDRVKI5SFTMKPwYYxOZJZtX/+AwYQw+dGz
        n65MNBxzTV/g6qA5mPXt9Jw0pUVwzfg=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-567-nWc5juIFPaOU-fRjooDamw-1; Fri, 19 Feb 2021 14:25:25 -0500
X-MC-Unique: nWc5juIFPaOU-fRjooDamw-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 846F28799EB;
        Fri, 19 Feb 2021 19:25:22 +0000 (UTC)
Received: from madcap2.tricolour.ca (unknown [10.10.110.8])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 096186A035;
        Fri, 19 Feb 2021 19:25:14 +0000 (UTC)
Date:   Fri, 19 Feb 2021 14:25:12 -0500
From:   Richard Guy Briggs <rgb@redhat.com>
To:     Florian Westphal <fw@strlen.de>
Cc:     Phil Sutter <phil@nwl.cc>, LKML <linux-kernel@vger.kernel.org>,
        Linux-Audit Mailing List <linux-audit@redhat.com>,
        netfilter-devel@vger.kernel.org, twoerner@redhat.com,
        Eric Paris <eparis@parisplace.org>, tgraf@infradead.org
Subject: Re: [PATCH ghak124 v3] audit: log nftables configuration change
 events
Message-ID: <20210219192512.GR3141668@madcap2.tricolour.ca>
References: <CAHC9VhTNQW9d=8GCW-70vAEMh8-LXviP+JHFC2-YkuitokLLMQ@mail.gmail.com>
 <20210211202628.GP2015948@madcap2.tricolour.ca>
 <20210211220930.GC2766@breakpoint.cc>
 <20210217234131.GN3141668@madcap2.tricolour.ca>
 <20210218082207.GJ2766@breakpoint.cc>
 <20210218124211.GO3141668@madcap2.tricolour.ca>
 <20210218125248.GB22944@breakpoint.cc>
 <20210218212001.GQ3141668@madcap2.tricolour.ca>
 <20210218224200.GF22944@breakpoint.cc>
 <20210219062651.GR2015948@madcap2.tricolour.ca>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210219062651.GR2015948@madcap2.tricolour.ca>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On 2021-02-19 01:26, Richard Guy Briggs wrote:
> On 2021-02-18 23:42, Florian Westphal wrote:
> > Richard Guy Briggs <rgb@redhat.com> wrote:
> > > > If they appear in a batch tehy will be ignored, if the batch consists of
> > > > such non-modifying ops only then nf_tables_commit() returns early
> > > > because the transaction list is empty (nothing to do/change).
> > > 
> > > Ok, one little inconvenient question: what about GETOBJ_RESET?  That
> > > looks like a hybrid that modifies kernel table counters and reports
> > > synchronously.  That could be a special case call in
> > > nf_tables_dump_obj() and nf_tables_getobj().  Will that cause a storm
> > > per commit?
> > 
> > No, since they can't be part of a commit (they don't implement the
> > 'call_batch' function).
> 
> Ok, good, so they should be safe (but still needs the gfp param to
> audit_log_nfcfg() for atomic alloc in that obj reset callback).

I just noticed that nft_quota_obj_eval() misses logging NFT_MSG_NEWOBJ
in nf_tables_commit(), so that looks like it should be added.

> - RGB

- RGB

--
Richard Guy Briggs <rgb@redhat.com>
Sr. S/W Engineer, Kernel Security, Base Operating Systems
Remote, Ottawa, Red Hat Canada
IRC: rgb, SunRaycer
Voice: +1.647.777.2635, Internal: (81) 32635

