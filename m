Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E4412C433E6
	for <netfilter-devel@archiver.kernel.org>; Thu, 18 Feb 2021 17:04:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A2FF564DFF
	for <netfilter-devel@archiver.kernel.org>; Thu, 18 Feb 2021 17:04:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230131AbhBRRCp (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 18 Feb 2021 12:02:45 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:25727 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231213AbhBRNeA (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 18 Feb 2021 08:34:00 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1613655148;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=LwJc5OvASzfvdbcGnjuZgUulTpqs+UTqZM4Fn7//J8E=;
        b=N1gGWWfAnStOcXGdL7GviK2NIV0x871Iy21UnmwWKt4t6bIXeDUFvgb8GpMMf4KDCMqzPE
        pVhnoqG2fKtxTLU78KgxZMvda7tirtOUvdlz6ajAQ0OSR1cNl/VOmTyVbl1VZiOyEy7o/3
        DL3hsA56ekh+x0PVwiPs2gPU8Y9aZSI=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-360-zklqRn62Oc61Tka6IOZESw-1; Thu, 18 Feb 2021 08:28:55 -0500
X-MC-Unique: zklqRn62Oc61Tka6IOZESw-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 96C27100CCC0;
        Thu, 18 Feb 2021 13:28:53 +0000 (UTC)
Received: from madcap2.tricolour.ca (unknown [10.10.110.8])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id AC66C60917;
        Thu, 18 Feb 2021 13:28:45 +0000 (UTC)
Date:   Thu, 18 Feb 2021 08:28:43 -0500
From:   Richard Guy Briggs <rgb@redhat.com>
To:     Florian Westphal <fw@strlen.de>
Cc:     Phil Sutter <phil@nwl.cc>, LKML <linux-kernel@vger.kernel.org>,
        Linux-Audit Mailing List <linux-audit@redhat.com>,
        netfilter-devel@vger.kernel.org, twoerner@redhat.com,
        Eric Paris <eparis@parisplace.org>, tgraf@infradead.org
Subject: Re: [PATCH ghak124 v3] audit: log nftables configuration change
 events
Message-ID: <20210218132843.GP3141668@madcap2.tricolour.ca>
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
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On 2021-02-18 13:52, Florian Westphal wrote:
> Richard Guy Briggs <rgb@redhat.com> wrote:
> > On 2021-02-18 09:22, Florian Westphal wrote:
> > > No.  There is a hierarchy, e.g. you can't add a chain without first
> > > adding a table, BUT in case the table was already created by an earlier
> > > transaction it can also be stand-alone.
> > 
> > Ok, so there could be a stand-alone chain mod with one table, then a
> > table add of a different one with a "higher ranking" op...
> 
> Yes, that can happen.

Ok, can I get one more clarification on this "hierarchy"?  Is it roughly
in the order they appear in nf_tables_commit() after step 3?  It appears
it might be mostly already.  If it isn't already, would it be reasonable
to re-order them?  Would you suggest a different order?

(snip GET bits, that's now clear, thank you)

> > such that it would be desirable to filter them out
> > to reduce noise in that single log line if it is attempted to list all
> > the change ops?  It almost sounds like it would be better to do one
> > audit log line for each table for each family, and possibly for each op
> > to avoid the need to change userspace.  This would already be a
> > significant improvement picking the highest ranking op.
> 
> I think i understand what you'd like to do.  Yes, that would reduce
> the log output a lot.

Would the generation change id be useful outside the kernel?  What
exactly does it look like?  I don't quite understand the genmask purpose.

- RGB

--
Richard Guy Briggs <rgb@redhat.com>
Sr. S/W Engineer, Kernel Security, Base Operating Systems
Remote, Ottawa, Red Hat Canada
IRC: rgb, SunRaycer
Voice: +1.647.777.2635, Internal: (81) 32635

