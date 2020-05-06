Return-Path: <SRS0=4pKc=6U=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.4 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5A864C47257
	for <netfilter-devel@archiver.kernel.org>; Wed,  6 May 2020 22:43:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 30CA32075E
	for <netfilter-devel@archiver.kernel.org>; Wed,  6 May 2020 22:43:34 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="KOvnW73n"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730102AbgEFWnb (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 6 May 2020 18:43:31 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:25181 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1729675AbgEFWnb (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 6 May 2020 18:43:31 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1588805009;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=7z9HLYS+z6m/b1mcYfh3E6ao+IPJSv0pn9CqJYGPito=;
        b=KOvnW73njyTznCB2+GGY5XpAPE/Lm76WJSDzmudfBs2ivTPa4IsuCaUW8Iz3kqNFl/W2vP
        FTHW4i+1NkMntQS4BH30EGhn08VdgF8zcU4hidei2ZtoaVCUVZYmxzAREuU1jzMBDoaV3C
        7lpXANl6YU2L7yWBU/WUgdIcmxt1GVs=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-495-EZ3RCm1nOE6vlhn3NtOmOQ-1; Wed, 06 May 2020 18:43:27 -0400
X-MC-Unique: EZ3RCm1nOE6vlhn3NtOmOQ-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 9DAB0926E88;
        Wed,  6 May 2020 22:42:45 +0000 (UTC)
Received: from madcap2.tricolour.ca (unknown [10.3.128.9])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 0C82170460;
        Wed,  6 May 2020 22:42:36 +0000 (UTC)
Date:   Wed, 6 May 2020 18:42:33 -0400
From:   Richard Guy Briggs <rgb@redhat.com>
To:     Steve Grubb <sgrubb@redhat.com>
Cc:     Paul Moore <paul@paul-moore.com>,
        Linux-Audit Mailing List <linux-audit@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>,
        netfilter-devel@vger.kernel.org, omosnace@redhat.com, fw@strlen.de,
        twoerner@redhat.com, Eric Paris <eparis@parisplace.org>,
        ebiederm@xmission.com, tgraf@infradead.org
Subject: Re: [PATCH ghak25 v4 3/3] audit: add subj creds to NETFILTER_CFG
 record to cover async unregister
Message-ID: <20200506224233.najv6ltb5gzcicqb@madcap2.tricolour.ca>
References: <cover.1587500467.git.rgb@redhat.com>
 <3348737.k9gCtgYObn@x2>
 <20200429213247.6ewxqf66i2apgyuz@madcap2.tricolour.ca>
 <3250272.v6NOfJhyum@x2>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <3250272.v6NOfJhyum@x2>
User-Agent: NeoMutt/20180716
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Content-Transfer-Encoding: quoted-printable
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On 2020-05-06 17:26, Steve Grubb wrote:
> On Wednesday, April 29, 2020 5:32:47 PM EDT Richard Guy Briggs wrote:
> > On 2020-04-29 14:47, Steve Grubb wrote:
> > > On Wednesday, April 29, 2020 10:31:46 AM EDT Richard Guy Briggs wro=
te:
> > > > On 2020-04-28 18:25, Paul Moore wrote:
> > > > > On Wed, Apr 22, 2020 at 5:40 PM Richard Guy Briggs <rgb@redhat.=
com>
> > >=20
> > > wrote:
> > > > > > Some table unregister actions seem to be initiated by the ker=
nel to
> > > > > > garbage collect unused tables that are not initiated by any
> > > > > > userspace
> > > > > > actions.  It was found to be necessary to add the subject
> > > > > > credentials
> > > > > > to  cover this case to reveal the source of these actions.  A
> > > > > > sample
> > > > > > record:
> > > > > > type=3DNETFILTER_CFG msg=3Daudit(2020-03-11 21:25:21.491:269)=
 :
> > > > > > table=3Dnat
> > > > > > family=3Dbridge entries=3D0 op=3Dunregister pid=3D153 uid=3Dr=
oot auid=3Dunset
> > > > > > tty=3D(none) ses=3Dunset subj=3Dsystem_u:system_r:kernel_t:s0
> > > > > > comm=3Dkworker/u4:2 exe=3D(null)>
> > > > >=20
> > > > > [I'm going to comment up here instead of in the code because it=
 is a
> > > > > bit easier for everyone to see what the actual impact might be =
on the
> > > > > records.]
> > > > >=20
> > > > > Steve wants subject info in this case, okay, but let's try to t=
rim
> > > > > out
> > > > > some of the fields which simply don't make sense in this record=
; I'm
> > > > > thinking of fields that are unset/empty in the kernel case and =
are
> > > > > duplicates of other records in the userspace/syscall case.  I t=
hink
> > > > > that means we can drop "tty", "ses", "comm", and "exe" ... yes?
> > > >=20
> > > > From the ghak28 discussion, this list and order was selected due =
to
> > > > Steve's preference for the "kernel" record convention, so deviati=
ng
> > > > from this will create yet a new field list.  I'll defer to Steve =
on
> > > > this. It also has to do with the searchability of fields if they =
are
> > > > missing.
> > > >=20
> > > > I do agree that some fields will be superfluous in the kernel cas=
e.
> > > > The most important field would be "subj", but then "pid" and "com=
m", I
> > > > would think.  Based on this contents of the "subj" field, I'd thi=
nk
> > > > that "uid", "auid", "tty", "ses" and "exe" are not needed.
> > >=20
> > > We can't be adding deleting fields based on how its triggered. If t=
hey
> > > are unset, that is fine. The main issue is they have to behave the =
same.
> >=20
> > I don't think the intent was to have fields swing in and out dependin=
g
> > on trigger.  The idea is to potentially permanently not include them =
in
> > this record type only.  The justification is that where they aren't
> > needed for the kernel trigger situation it made sense to delete them
> > because if it is a user context event it will be accompanied by a
> > syscall record that already has that information and there would be n=
o
> > sense in duplicating it.
>=20
> We should not be adding syscall records to anything that does not resul=
t from=20
> a syscall rule triggering the event. Its very wasteful. More wasteful t=
han=20
> just adding the necessary fields.

So what you are saying is you want all the fields that are being
proposed to be added to this record?

If the records are all from one event, they all should all have the same
timestamp/serial number so that the records are kept together and not
mistaken for multiple events.  One reason for having information in
seperate records is to be able to filter them either in kernel or in
userspace if you don't need certain records.

> I also wished we had a coding specification that put this in writing so=
 that=20
> every event is not a committee decision. That anyone can look at the do=
cument=20
> and Do The Right Thing =E2=84=A2.
>=20
> If I add a section to Writing-Good-Events outlining the expected orderi=
ng of=20
> fields, would that be enough that we do not have long discussions about=
 event=20
> format? I'm thinking this would also help new people that want to contr=
ibute.

If you add this expected ordering of fields, can we re-factor all the
kernel code to use this order because the userspace parser won't care
what order they are in?

I realize this isn't what you are saying, but having a clear description
in that document that talks about the different classes of events and
what each one needs in terms of minimum to full subject attributes and
object attributes would help a lot.  It would also help for new records
to be able to decide if it should follow the format of an existing
related or similar record, or a new class with the expected standard orde=
r.

> -Steve

- RGB

--
Richard Guy Briggs <rgb@redhat.com>
Sr. S/W Engineer, Kernel Security, Base Operating Systems
Remote, Ottawa, Red Hat Canada
IRC: rgb, SunRaycer
Voice: +1.647.777.2635, Internal: (81) 32635

