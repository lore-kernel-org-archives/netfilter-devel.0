Return-Path: <SRS0=Vh4p=6F=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.4 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D5FA9C55181
	for <netfilter-devel@archiver.kernel.org>; Tue, 21 Apr 2020 18:54:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B9CEC2068F
	for <netfilter-devel@archiver.kernel.org>; Tue, 21 Apr 2020 18:54:39 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="aDUa5kLZ"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725930AbgDUSyj (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 21 Apr 2020 14:54:39 -0400
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:51740 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725886AbgDUSyj (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 21 Apr 2020 14:54:39 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1587495276;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=MrU2HNJZTQBPSn2z8yAKMiwd+9c1Olx+Jq2ydnHE1vM=;
        b=aDUa5kLZRte6QlMo28PgxuVxNgGFjZiQWCAXVwz6y/wd8OQeSI/SS9Zr+xiTwgonUF9Had
        3ev9Vyffs9ypJ24eao1RaeLZKKqOuHx2wqL1Tp/xSZ8NMNzCP0/iHIybMd8FtaiHvdXroA
        ok0dQPf6zKU+gMRK0FX3Xj0lpn2Tv4M=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-465-7PWAMLsjMYaygNzxcEJMOg-1; Tue, 21 Apr 2020 14:54:34 -0400
X-MC-Unique: 7PWAMLsjMYaygNzxcEJMOg-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 44AC01083E80;
        Tue, 21 Apr 2020 18:54:33 +0000 (UTC)
Received: from madcap2.tricolour.ca (unknown [10.3.128.9])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 7C5471001B30;
        Tue, 21 Apr 2020 18:54:25 +0000 (UTC)
Date:   Tue, 21 Apr 2020 14:54:22 -0400
From:   Richard Guy Briggs <rgb@redhat.com>
To:     Steve Grubb <sgrubb@redhat.com>
Cc:     linux-audit@redhat.com, fw@strlen.de,
        LKML <linux-kernel@vger.kernel.org>,
        netfilter-devel@vger.kernel.org, ebiederm@xmission.com,
        twoerner@redhat.com, Eric Paris <eparis@parisplace.org>,
        tgraf@infradead.org
Subject: Re: [PATCH ghak25 v3 3/3] audit: add subj creds to NETFILTER_CFG
 record to cover async unregister
Message-ID: <20200421185422.ziu2ejdvuofg5fu5@madcap2.tricolour.ca>
References: <cover.1584480281.git.rgb@redhat.com>
 <20200318213327.ow22q6nnjn3ijq6v@madcap2.tricolour.ca>
 <CAHC9VhSbbjFbF0A_-saquZ8B85XaF7SWD2e1QcWsXhFSQrUAbQ@mail.gmail.com>
 <2156032.xcGZvdN1jG@x2>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2156032.xcGZvdN1jG@x2>
User-Agent: NeoMutt/20180716
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On 2020-04-21 11:15, Steve Grubb wrote:
> On Friday, April 17, 2020 5:53:47 PM EDT Paul Moore wrote:
> > On Wed, Mar 18, 2020 at 5:33 PM Richard Guy Briggs <rgb@redhat.com> wrote:
> > > On 2020-03-18 17:22, Paul Moore wrote:
> > > > On Wed, Mar 18, 2020 at 9:12 AM Richard Guy Briggs <rgb@redhat.com> 
> wrote:
> > > > > On 2020-03-17 17:30, Richard Guy Briggs wrote:
> > > > > > Some table unregister actions seem to be initiated by the kernel to
> > > > > > garbage collect unused tables that are not initiated by any
> > > > > > userspace actions.  It was found to be necessary to add the subject
> > > > > > credentials to cover this case to reveal the source of these
> > > > > > actions.  A sample record:
> > > > > >   type=NETFILTER_CFG msg=audit(2020-03-11 21:25:21.491:269) :
> > > > > >   table=nat family=bridge entries=0 op=unregister pid=153 uid=root
> > > > > >   auid=unset tty=(none) ses=unset
> > > > > >   subj=system_u:system_r:kernel_t:s0 comm=kworker/u4:2 exe=(null)
> 
> If this is the kernel, why is pid not 0? And if pid is 0, then isn't 
> exe=/boot/vmlinuz-X.Y.Z-blah?

It isn't PID 0 because it is a kernel thread.

> > > > > Given the precedent set by bpf unload, I'd really rather drop this
> > > > > patch that adds subject credentials.
> 
> <snip> 
> 
> > I'm in the middle of building patches 1/3 and 2/3, assuming all goes
> > well I'll merge them into audit/next (expect mail soon), however I'm
> > going back and forth on this patch.  Like you I kinda don't like it,
> > and with both of us not in love with this patch I have to ask if there
> > is certification requirement for this?
> 
> Yes, any change to information flow must be auditable.
> 
> > I know about the generic
> > subj/obj requirements, but in the case where there is no associated
> > task/syscall/etc. information it isn't like the extra fields supplied
> > in this patch are going to have much information in that regard; it's
> > really the *absence* of that information which is telling.
> 
> Exactly. But if someone does a search based on the fields, they need to be 
> able to find this record. For example, suppose I want to know what actions 
> have been performed by kernel_t, I can run a  search and find this event. 
> 
> > Which brings me to wonder if simply the lack of any associated records in
> > this event is enough?  Before when we weren't associating records into
> > a single event it would have been a problem, but the way things
> > currently are, if there are no other records (and you have configured
> > that) then I think you have everything you need to know.
> > 
> > Thoughts?
> 
> You can't search on the absense of information. There are some fields that 
> have meaning. It's OK if they are unset. It happens for daemons, too. But we 
> don't remove the fields because of it. It tells part of the story.
> 
> -Steve
> 
> 
> --
> Linux-audit mailing list
> Linux-audit@redhat.com
> https://www.redhat.com/mailman/listinfo/linux-audit

- RGB

--
Richard Guy Briggs <rgb@redhat.com>
Sr. S/W Engineer, Kernel Security, Base Operating Systems
Remote, Ottawa, Red Hat Canada
IRC: rgb, SunRaycer
Voice: +1.647.777.2635, Internal: (81) 32635

