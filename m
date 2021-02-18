Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 51F97C433DB
	for <netfilter-devel@archiver.kernel.org>; Thu, 18 Feb 2021 13:23:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id EC16A64E76
	for <netfilter-devel@archiver.kernel.org>; Thu, 18 Feb 2021 13:23:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232544AbhBRNWS (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 18 Feb 2021 08:22:18 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:32196 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233169AbhBRMoq (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 18 Feb 2021 07:44:46 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1613652145;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=nVrd9G628h0NB/gKNnBTpu/6zrPi5r6BbRgDdDS9hdc=;
        b=hZixlmeL83KCmOH/evgtiE+nvMqZ/QCFFgpg9aFNCQMf9Q4zW11kAo0UvM111hrodSPYu7
        vYu6muMZ+WWs5DrM514wkHV7vLH8FBtfiK7BvY/xsBCy+KbdYJwDhPj2pdKVVrhlMYXS1X
        ErjOmfWt7YMfBBdZWcHUJXllJYuFI9I=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-469-YJkbiILVNdyfMPqUlGghyw-1; Thu, 18 Feb 2021 07:42:23 -0500
X-MC-Unique: YJkbiILVNdyfMPqUlGghyw-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id E71A9801980;
        Thu, 18 Feb 2021 12:42:21 +0000 (UTC)
Received: from madcap2.tricolour.ca (unknown [10.10.110.8])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id D4DB019D61;
        Thu, 18 Feb 2021 12:42:13 +0000 (UTC)
Date:   Thu, 18 Feb 2021 07:42:11 -0500
From:   Richard Guy Briggs <rgb@redhat.com>
To:     Florian Westphal <fw@strlen.de>
Cc:     Phil Sutter <phil@nwl.cc>, LKML <linux-kernel@vger.kernel.org>,
        Linux-Audit Mailing List <linux-audit@redhat.com>,
        netfilter-devel@vger.kernel.org, twoerner@redhat.com,
        Eric Paris <eparis@parisplace.org>, tgraf@infradead.org
Subject: Re: [PATCH ghak124 v3] audit: log nftables configuration change
 events
Message-ID: <20210218124211.GO3141668@madcap2.tricolour.ca>
References: <f9da8b5dbf2396b621c77c17b5b1123be5aa484e.1591275439.git.rgb@redhat.com>
 <20210211151606.GX3158@orbyte.nwl.cc>
 <CAHC9VhTNQW9d=8GCW-70vAEMh8-LXviP+JHFC2-YkuitokLLMQ@mail.gmail.com>
 <20210211202628.GP2015948@madcap2.tricolour.ca>
 <20210211220930.GC2766@breakpoint.cc>
 <20210217234131.GN3141668@madcap2.tricolour.ca>
 <20210218082207.GJ2766@breakpoint.cc>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210218082207.GJ2766@breakpoint.cc>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On 2021-02-18 09:22, Florian Westphal wrote:
> Richard Guy Briggs <rgb@redhat.com> wrote:
> > On 2021-02-11 23:09, Florian Westphal wrote:
> > > So, if just a summary is needed a single audit_log_nfcfg()
> > > after 'step 3' and outside of the list_for_each_entry_safe() is all
> > > that is needed.
> > 
> > Ok, so it should not matter if it is before or after that
> > list_for_each_entry_safe(), which could be used to collect that summary.
> 
> Right, it won't matter.
> 
> > > If a summary is wanted as well one could fe. count the number of
> > > transaction types in the batch, e.g. table adds, chain adds, rule
> > > adds etc. and then log a summary count instead.
> > 
> > The current fields are "table", "family", "entries", "op".
> > 
> > Could one batch change more than one table?  (I think it could?)
> 
> Yes.

Ok, listing all tables involved in one commit with deduplication will be
a bit of a nuisance.

> > It appears it can change more than one family.
> > "family" is currently a single integer, so that might need to be changed
> > to a list, or something to indicate multi-family.
> 
> Yes, it can also affect different families.
> 
> > Listing all the ops seems a bit onerous.  Is there a hierarchy to the
> > ops and if so, are they in that order in a batch or in nf_tables_commit()?
> 
> No.  There is a hierarchy, e.g. you can't add a chain without first
> adding a table, BUT in case the table was already created by an earlier
> transaction it can also be stand-alone.

Ok, so there could be a stand-alone chain mod with one table, then a
table add of a different one with a "higher ranking" op...

> > It seems I'd need to filter out the NFT_MSG_GET_* ops.
> 
> No need, the GET ops do not cause changes and will not trigger a
> generation id change.

Ah, so it could trigger on generation change.  Would GET ops be included
in any other change, such that it would be desirable to filter them out
to reduce noise in that single log line if it is attempted to list all
the change ops?  It almost sounds like it would be better to do one
audit log line for each table for each family, and possibly for each op
to avoid the need to change userspace.  This would already be a
significant improvement picking the highest ranking op.

- RGB

--
Richard Guy Briggs <rgb@redhat.com>
Sr. S/W Engineer, Kernel Security, Base Operating Systems
Remote, Ottawa, Red Hat Canada
IRC: rgb, SunRaycer
Voice: +1.647.777.2635, Internal: (81) 32635

