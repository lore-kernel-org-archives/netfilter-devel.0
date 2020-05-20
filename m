Return-Path: <SRS0=7yxH=7C=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8C1E5C433E0
	for <netfilter-devel@archiver.kernel.org>; Wed, 20 May 2020 18:51:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6B507207ED
	for <netfilter-devel@archiver.kernel.org>; Wed, 20 May 2020 18:51:42 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="h/26i993"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727040AbgETSvj (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 20 May 2020 14:51:39 -0400
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:38801 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727033AbgETSvj (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 20 May 2020 14:51:39 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1590000698;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=i7NGOkH1/ieAk2tsV7Q3wjcwjWy0KsoOhkKcYWwhGtY=;
        b=h/26i993XvHlnwr86MD1OF3ApkjUCGeEZUgbLTugeYAIpx7fQTWMYUecT1HWsJ7VKsLcWl
        HGLU0Z3u9vgiAndH7ipbdFIH+piEggrBMoXCCruT+dnngV9X+Cjpg+CgeAA/WXiNQeiP0f
        kANrsKGfRgsuya2zWMykK8iU1HDavqg=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-330-fhHYUOsQM1-Yh8Ernl_uFQ-1; Wed, 20 May 2020 14:51:34 -0400
X-MC-Unique: fhHYUOsQM1-Yh8Ernl_uFQ-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 4B295EC1AD;
        Wed, 20 May 2020 18:51:33 +0000 (UTC)
Received: from x2.localnet (ovpn-113-172.phx2.redhat.com [10.3.113.172])
        by smtp.corp.redhat.com (Postfix) with ESMTP id CDC267D96E;
        Wed, 20 May 2020 18:51:27 +0000 (UTC)
From:   Steve Grubb <sgrubb@redhat.com>
To:     linux-audit@redhat.com
Cc:     Paul Moore <paul@paul-moore.com>,
        Richard Guy Briggs <rgb@redhat.com>, fw@strlen.de,
        LKML <linux-kernel@vger.kernel.org>,
        netfilter-devel@vger.kernel.org, twoerner@redhat.com,
        Eric Paris <eparis@parisplace.org>, tgraf@infradead.org
Subject: Re: [PATCH ghak25 v6] audit: add subj creds to NETFILTER_CFG record to cover async unregister
Date:   Wed, 20 May 2020 14:51:26 -0400
Message-ID: <17476338.hsbNre52Up@x2>
Organization: Red Hat
In-Reply-To: <CAHC9VhRERV9_kgpcn2LBptgXGY0BB4A9CHT+V4-HFMcNd9_Ncg@mail.gmail.com>
References: <a585b9933896bc542347d8f3f26b08005344dd84.1589920939.git.rgb@redhat.com> <20200520165510.4l4q47vq6fyx7hh6@madcap2.tricolour.ca> <CAHC9VhRERV9_kgpcn2LBptgXGY0BB4A9CHT+V4-HFMcNd9_Ncg@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Wednesday, May 20, 2020 2:40:45 PM EDT Paul Moore wrote:
> On Wed, May 20, 2020 at 12:55 PM Richard Guy Briggs <rgb@redhat.com> wrote:
> > On 2020-05-20 12:51, Richard Guy Briggs wrote:
> > > Some table unregister actions seem to be initiated by the kernel to
> > > garbage collect unused tables that are not initiated by any userspace
> > > actions.  It was found to be necessary to add the subject credentials
> > > to cover this case to reveal the source of these actions.  A sample
> > > record:
> > > 
> > > The uid, auid, tty, ses and exe fields have not been included since
> > > they
> > > are in the SYSCALL record and contain nothing useful in the non-user
> > > context.
> > > 
> > >   type=NETFILTER_CFG msg=audit(2020-03-11 21:25:21.491:269) : table=nat
> > >   family=bridge entries=0 op=unregister pid=153
> > >   subj=system_u:system_r:kernel_t:s0 comm=kworker/u4:2
>
> FWIW, that record looks good.

It's severely broken

cat log.file
type=NETFILTER_CFG msg=audit(2020-03-11 21:25:21.491:269) : table=nat 
family=bridge entries=0 op=unregister pid=153 
subj=system_u:system_r:kernel_t:s0 comm=kworker/u4:2

ausearch -if log.file --format text
At 19:33:40 12/31/1969  did-unknown 

ausearch -if log.file --format csv
NODE,EVENT,DATE,TIME,SERIAL_NUM,EVENT_KIND,SESSION,SUBJ_PRIME,SUBJ_SEC,SUBJ_KIND,ACTION,RESULT,OBJ_PRIME,OBJ_SEC,OBJ_KIND,HOW
error normalizing NETFILTER_CFG
,NETFILTER_CFG,12/31/1969,19:33:40,0,,,,,,,,,,

This is unusable. This is why the bug was filed in the first place.

-Steve

> > > Signed-off-by: Richard Guy Briggs <rgb@redhat.com>
> > 
> > Self-NACK.  I forgot to remove cred and tty declarations.




