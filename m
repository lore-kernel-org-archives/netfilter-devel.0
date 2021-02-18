Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 12878C433DB
	for <netfilter-devel@archiver.kernel.org>; Thu, 18 Feb 2021 22:43:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C1F9A64EB9
	for <netfilter-devel@archiver.kernel.org>; Thu, 18 Feb 2021 22:43:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229880AbhBRWmp (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 18 Feb 2021 17:42:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39020 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229787AbhBRWmo (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 18 Feb 2021 17:42:44 -0500
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:12e:520::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 10230C061574;
        Thu, 18 Feb 2021 14:42:04 -0800 (PST)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@strlen.de>)
        id 1lCrzk-0000sB-40; Thu, 18 Feb 2021 23:42:00 +0100
Date:   Thu, 18 Feb 2021 23:42:00 +0100
From:   Florian Westphal <fw@strlen.de>
To:     Richard Guy Briggs <rgb@redhat.com>
Cc:     Florian Westphal <fw@strlen.de>, Phil Sutter <phil@nwl.cc>,
        LKML <linux-kernel@vger.kernel.org>,
        Linux-Audit Mailing List <linux-audit@redhat.com>,
        netfilter-devel@vger.kernel.org, twoerner@redhat.com,
        Eric Paris <eparis@parisplace.org>, tgraf@infradead.org
Subject: Re: [PATCH ghak124 v3] audit: log nftables configuration change
 events
Message-ID: <20210218224200.GF22944@breakpoint.cc>
References: <f9da8b5dbf2396b621c77c17b5b1123be5aa484e.1591275439.git.rgb@redhat.com>
 <20210211151606.GX3158@orbyte.nwl.cc>
 <CAHC9VhTNQW9d=8GCW-70vAEMh8-LXviP+JHFC2-YkuitokLLMQ@mail.gmail.com>
 <20210211202628.GP2015948@madcap2.tricolour.ca>
 <20210211220930.GC2766@breakpoint.cc>
 <20210217234131.GN3141668@madcap2.tricolour.ca>
 <20210218082207.GJ2766@breakpoint.cc>
 <20210218124211.GO3141668@madcap2.tricolour.ca>
 <20210218125248.GB22944@breakpoint.cc>
 <20210218212001.GQ3141668@madcap2.tricolour.ca>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210218212001.GQ3141668@madcap2.tricolour.ca>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Richard Guy Briggs <rgb@redhat.com> wrote:
> > If they appear in a batch tehy will be ignored, if the batch consists of
> > such non-modifying ops only then nf_tables_commit() returns early
> > because the transaction list is empty (nothing to do/change).
> 
> Ok, one little inconvenient question: what about GETOBJ_RESET?  That
> looks like a hybrid that modifies kernel table counters and reports
> synchronously.  That could be a special case call in
> nf_tables_dump_obj() and nf_tables_getobj().  Will that cause a storm
> per commit?

No, since they can't be part of a commit (they don't implement the
'call_batch' function).

I'm not sure GETOBJ_RESET should be reported in the first place:
RESET only affects expr internal state, and that state changes all the time
anyway in response to network traffic.
