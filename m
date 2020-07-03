Return-Path: <SRS0=cAfZ=AO=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8DB51C433DF
	for <netfilter-devel@archiver.kernel.org>; Fri,  3 Jul 2020 14:19:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 62D88206BE
	for <netfilter-devel@archiver.kernel.org>; Fri,  3 Jul 2020 14:19:25 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Rl1bOO27"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726475AbgGCOTZ (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 3 Jul 2020 10:19:25 -0400
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:28149 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726035AbgGCOTX (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 3 Jul 2020 10:19:23 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1593785962;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=H1wWTI7QYlHZxaFsJCKponeO6UgXh5yMDcs00qFvbfU=;
        b=Rl1bOO27RtCvuBjCyOs6y8VI2r9uEB/jYyweu29P92gZGVxdEVn33+AIJ8yY7LBJianIWs
        Lbql/bKCWbqEsr6mLbFfh3Zn/aHHTPk0Z2kcKt0XgA9GsJybigIgPG+E+XIGamXLkvPLfq
        r9lQzH/i4Y/yLr3yvxS+1uadNfbU+0Y=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-58-hSnsQ8pwOhypj_SvCm9ZgQ-1; Fri, 03 Jul 2020 10:19:18 -0400
X-MC-Unique: hSnsQ8pwOhypj_SvCm9ZgQ-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 13BC018A8221;
        Fri,  3 Jul 2020 14:19:17 +0000 (UTC)
Received: from madcap2.tricolour.ca (unknown [10.10.110.3])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 60C2218B05;
        Fri,  3 Jul 2020 14:19:06 +0000 (UTC)
Date:   Fri, 3 Jul 2020 10:19:03 -0400
From:   Richard Guy Briggs <rgb@redhat.com>
To:     Paul Moore <paul@paul-moore.com>
Cc:     Jones Desougi <jones.desougi+netfilter@gmail.com>,
        Linux-Audit Mailing List <linux-audit@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>,
        netfilter-devel@vger.kernel.org, sgrubb@redhat.com,
        Ondrej Mosnacek <omosnace@redhat.com>,
        Florian Westphal <fw@strlen.de>, twoerner@redhat.com,
        Eric Paris <eparis@parisplace.org>, tgraf@infradead.org,
        dan.carpenter@oracle.com
Subject: Re: [PATCH ghak124 v3fix] audit: add gfp parameter to audit_log_nfcfg
Message-ID: <20200703141903.zniosc4bxuw5dhit@madcap2.tricolour.ca>
References: <3eda864fb69977252a061c8c3ccd2d8fcd1f3a9b.1593278952.git.rgb@redhat.com>
 <CAGdUbJEwoxEFJZDUjF7ZwKurKNibPW86=s3yFSA6BBt-YsC=Nw@mail.gmail.com>
 <CAHC9VhTYy5Zd6kB77xYL6HbnqL29AL6jF8RzVAN6=UC6eVLqCg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAHC9VhTYy5Zd6kB77xYL6HbnqL29AL6jF8RzVAN6=UC6eVLqCg@mail.gmail.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On 2020-07-03 09:41, Paul Moore wrote:
> On Fri, Jul 3, 2020 at 8:41 AM Jones Desougi
> <jones.desougi+netfilter@gmail.com> wrote:
> >
> > Doesn't seem entirely consistent now either though. Two cases below.
> 
> Yes, you're right, that patch was incorrect; thanks for catching that.
> I just posted a fix (lore link below) that fixes the two problems you
> pointed out as well as converts a call in a RCU protected section to
> an ATOMIC.

Thanks Paul.  I was just about to switch branches and fix these.  :-)
I really need to upgrade this devel machine so I can use git 2.x
worktrees...

I checked all of these (I thought) thoroughly before I started changing
code and obviously didn't after.  :-/

> https://lore.kernel.org/linux-audit/159378341669.5956.13490174029711421419.stgit@sifl
> 
> paul moore

- RGB

--
Richard Guy Briggs <rgb@redhat.com>
Sr. S/W Engineer, Kernel Security, Base Operating Systems
Remote, Ottawa, Red Hat Canada
IRC: rgb, SunRaycer
Voice: +1.647.777.2635, Internal: (81) 32635

