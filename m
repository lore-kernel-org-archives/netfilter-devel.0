Return-Path: <SRS0=7yxH=7C=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.4 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B07A7C433DF
	for <netfilter-devel@archiver.kernel.org>; Wed, 20 May 2020 19:06:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 88901206B6
	for <netfilter-devel@archiver.kernel.org>; Wed, 20 May 2020 19:06:54 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="ZVb97ojs"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726812AbgETTGy (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 20 May 2020 15:06:54 -0400
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:60908 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726560AbgETTGx (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 20 May 2020 15:06:53 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1590001611;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=vOhbEgMkocnxd/SuSd9QcQbSLlk7GuMIQKjrDzR/nDE=;
        b=ZVb97ojsyMlW/8Dq+GFfYVuwLubqbwcSjEIUgBKshvvzKAhYl/Z8bQdVPIHQT/cx5W1Tt/
        VYWwzSzYeKOtzF7bPirOveOyqHqmbA1PiFshEun+Wgn5LtBJk4H2IBWtgRoxFZswhBC/hV
        /3sDpijU7ZEa3MmmyrrgdA+D9bt2J3M=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-298-W9iIFHZwPcqY5lE551OJpQ-1; Wed, 20 May 2020 15:06:47 -0400
X-MC-Unique: W9iIFHZwPcqY5lE551OJpQ-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 605481404;
        Wed, 20 May 2020 19:06:46 +0000 (UTC)
Received: from madcap2.tricolour.ca (unknown [10.10.110.46])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 8B49162932;
        Wed, 20 May 2020 19:06:38 +0000 (UTC)
Date:   Wed, 20 May 2020 15:06:35 -0400
From:   Richard Guy Briggs <rgb@redhat.com>
To:     Steve Grubb <sgrubb@redhat.com>
Cc:     linux-audit@redhat.com, Paul Moore <paul@paul-moore.com>,
        fw@strlen.de, LKML <linux-kernel@vger.kernel.org>,
        netfilter-devel@vger.kernel.org, twoerner@redhat.com,
        Eric Paris <eparis@parisplace.org>, tgraf@infradead.org
Subject: Re: [PATCH ghak25 v6] audit: add subj creds to NETFILTER_CFG record
 to cover async unregister
Message-ID: <20200520190635.z7iz2ivf53l4bxq6@madcap2.tricolour.ca>
References: <a585b9933896bc542347d8f3f26b08005344dd84.1589920939.git.rgb@redhat.com>
 <20200520165510.4l4q47vq6fyx7hh6@madcap2.tricolour.ca>
 <CAHC9VhRERV9_kgpcn2LBptgXGY0BB4A9CHT+V4-HFMcNd9_Ncg@mail.gmail.com>
 <17476338.hsbNre52Up@x2>
 <20200520185922.vnutg5z3hwp7grjm@madcap2.tricolour.ca>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200520185922.vnutg5z3hwp7grjm@madcap2.tricolour.ca>
User-Agent: NeoMutt/20180716
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On 2020-05-20 14:59, Richard Guy Briggs wrote:
> On 2020-05-20 14:51, Steve Grubb wrote:
> > On Wednesday, May 20, 2020 2:40:45 PM EDT Paul Moore wrote:
> > > On Wed, May 20, 2020 at 12:55 PM Richard Guy Briggs <rgb@redhat.com> wrote:
> > > > On 2020-05-20 12:51, Richard Guy Briggs wrote:
> > > > > Some table unregister actions seem to be initiated by the kernel to
> > > > > garbage collect unused tables that are not initiated by any userspace
> > > > > actions.  It was found to be necessary to add the subject credentials
> > > > > to cover this case to reveal the source of these actions.  A sample
> > > > > record:
> > > > > 
> > > > > The uid, auid, tty, ses and exe fields have not been included since
> > > > > they
> > > > > are in the SYSCALL record and contain nothing useful in the non-user
> > > > > context.
> > > > > 
> > > > >   type=NETFILTER_CFG msg=audit(2020-03-11 21:25:21.491:269) : table=nat
> > > > >   family=bridge entries=0 op=unregister pid=153
> > > > >   subj=system_u:system_r:kernel_t:s0 comm=kworker/u4:2
> > >
> > > FWIW, that record looks good.
> > 
> > It's severely broken
> > 
> > cat log.file
> > type=NETFILTER_CFG msg=audit(2020-03-11 21:25:21.491:269) : table=nat 
> > family=bridge entries=0 op=unregister pid=153 
> > subj=system_u:system_r:kernel_t:s0 comm=kworker/u4:2
> > 
> > ausearch -if log.file --format text
> > At 19:33:40 12/31/1969  did-unknown 
> > 
> > ausearch -if log.file --format csv
> > NODE,EVENT,DATE,TIME,SERIAL_NUM,EVENT_KIND,SESSION,SUBJ_PRIME,SUBJ_SEC,SUBJ_KIND,ACTION,RESULT,OBJ_PRIME,OBJ_SEC,OBJ_KIND,HOW
> > error normalizing NETFILTER_CFG
> > ,NETFILTER_CFG,12/31/1969,19:33:40,0,,,,,,,,,,
> > 
> > This is unusable. This is why the bug was filed in the first place.
> 
> Have you applied this patchset?
> 	https://www.redhat.com/archives/linux-audit/2020-May/msg00072.html
> 
> AUDIT_EVENT_LISTENER is also broken without this first patch.

And EVENT_LISTENER also needs this patch:
	https://github.com/linux-audit/audit-userspace/pull/114/commits/27daa6fca534b30199040d0ad05420a8331ab421

> > -Steve
> > 
> > > > > Signed-off-by: Richard Guy Briggs <rgb@redhat.com>
> > > > 
> > > > Self-NACK.  I forgot to remove cred and tty declarations.
> 
> - RGB

- RGB

--
Richard Guy Briggs <rgb@redhat.com>
Sr. S/W Engineer, Kernel Security, Base Operating Systems
Remote, Ottawa, Red Hat Canada
IRC: rgb, SunRaycer
Voice: +1.647.777.2635, Internal: (81) 32635

