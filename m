Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6018DEE14CD
	for <netfilter-devel@archiver.kernel.org>; Wed,  6 Sep 2023 18:21:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240809AbjIFSVJ (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 6 Sep 2023 14:21:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40690 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237912AbjIFSVI (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 6 Sep 2023 14:21:08 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EB26910C8
        for <netfilter-devel@vger.kernel.org>; Wed,  6 Sep 2023 11:20:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1694024420;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=T05hooxeRl4ZM++ZpyNcVd57kXaqMLCMyUoYLVsPegI=;
        b=gHY/1yGJcrMfJUr/kDgwWlxf/5PBbEigc7oNbLIppyiAFWZojJ9XnNs/s03xvyu0VdsSIF
        PP7P/OgZPvc37HxMKQNQTNN2asedrNN7BUtrZT+YzUasAdkhU5tVJMTFyrzwHTCR/FKZ2U
        ACFxEQHbY+kFiBg76WgInWCpwGpqyBs=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-438-rYnBvyozOHGcBDdVkk7ozA-1; Wed, 06 Sep 2023 14:20:15 -0400
X-MC-Unique: rYnBvyozOHGcBDdVkk7ozA-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com [10.11.54.5])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 9D244946DC0;
        Wed,  6 Sep 2023 18:20:14 +0000 (UTC)
Received: from madcap2.tricolour.ca (unknown [10.22.48.8])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id DB9C7568FF;
        Wed,  6 Sep 2023 18:20:13 +0000 (UTC)
Date:   Wed, 6 Sep 2023 14:20:11 -0400
From:   Richard Guy Briggs <rgb@redhat.com>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     Phil Sutter <phil@nwl.cc>, netfilter-devel@vger.kernel.org,
        audit@vger.kernel.org
Subject: Re: [PATCH nf] netfilter: nf_tables: Unbreak audit log reset
Message-ID: <ZPjC2y45pF/IXcnE@madcap2.tricolour.ca>
References: <20230906094202.1712-1-pablo@netfilter.org>
 <ZPhjYkRpUvfqPB9F@orbyte.nwl.cc>
 <ZPhm1mf0GaeQUr0e@calendula>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZPhm1mf0GaeQUr0e@calendula>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.5
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On 2023-09-06 13:47, Pablo Neira Ayuso wrote:
> On Wed, Sep 06, 2023 at 01:32:50PM +0200, Phil Sutter wrote:
> > On Wed, Sep 06, 2023 at 11:42:02AM +0200, Pablo Neira Ayuso wrote:
> > > Deliver audit log from __nf_tables_dump_rules(), table dereference at
> > > the end of the table list loop might point to the list head, leading to
> > > this crash.
> > 
> > Ah, of course. Sorry for the mess. I missed the fact that one may just
> > call 'reset rules' and have it apply to all existing tables.
> > 
> > [...]
> > > Deliver audit log only once at the end of the rule dump+reset for
> > > consistency with the set dump+reset.
> > 
> > This may seem like number of audit logs is reduced, when it is actually
> > increased: With your patch, there will be at least one notification for
> > each chain, multiple with large chains (due to skb exhaustion).
> 
> With your patch, this is called for each netlink_recvmsg() invocation,
> which is more audit logs.
> 
> @@ -3540,9 +3544,6 @@ static int nf_tables_dump_rules(struct sk_buff *skb,
>  done:
>         rcu_read_unlock();
>  
> -       if (reset && idx > cb->args[0])
> -               audit_log_rule_reset(table, cb->seq, idx - cb->args[0]);
> -
>         cb->args[0] = idx;
>         return skb->len;
>  }
> 
> netlink dump is composed of a series of recvmsg() from userspace to
> fetch the multiple chunks that represent the rules in this table.
> If I read fine above, as the netlink dump makes progress, idx will
> always go over cb->args[0], which evaluates true for each recvmsg()
> call. With my patch this is less audit logs because audit log is only
> delivered once for each chain, not for each recvmsg() call.
> 
> So patch description is fine as it is :)
> 
> > Not necessarily a problem, but worth mentioning. Also, I wonder if
> > one should go the extra mile and add the chain name to log entries.
> > I had considered to pass a string like "mytable:123 chain=mychain"
> > to audit_log_nfcfg() for that matter, but it's quite a hack.

(I think I missed the start of this thread?)

Whatever you do, only ever add new fields to the *end* of the record to
avoid confusing the userspace parser.  I vaguely remember looking at
adding a chain field and dismissed it.

So if this needs to be done, the string needs to be parsed to see if
extra fields have been added and print them at the end of the record.
The better approach is to add a parameter to carry that field and
optionally append it to the record.

> Agreed. Audit folks can extend this later on according to their needs
> in case they need more fine grain reporting.
> 
> > > Ensure audit reset access to table under rcu read side lock. The table
> > > list iteration holds rcu read lock side, but recent audit code
> > > dereferences table object out of the rcu read lock side.
> > > 
> > > Fixes: ea078ae9108e ("netfilter: nf_tables: Audit log rule reset")
> > > Fixes: 7e9be1124dbe ("netfilter: nf_tables: Audit log setelem reset")
> > > Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
> > 
> > Acked-by: Phil Sutter <phil@nwl.cc>

- RGB

--
Richard Guy Briggs <rgb@redhat.com>
Sr. S/W Engineer, Kernel Security, Base Operating Systems
Remote, Ottawa, Red Hat Canada
Upstream IRC: SunRaycer
Voice: +1.613.860 2354 SMS: +1.613.518.6570

