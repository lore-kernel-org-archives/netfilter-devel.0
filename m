Return-Path: <SRS0=4pKc=6U=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6FC21C28CBC
	for <netfilter-devel@archiver.kernel.org>; Wed,  6 May 2020 21:26:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 49A002075A
	for <netfilter-devel@archiver.kernel.org>; Wed,  6 May 2020 21:26:43 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="JqkklJK9"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729722AbgEFV0j (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 6 May 2020 17:26:39 -0400
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:23118 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727995AbgEFV0i (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 6 May 2020 17:26:38 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1588800396;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=x+4JHOeVom+2+GvS+WBN7vb+d53P3ecF4mumR/1VYtA=;
        b=JqkklJK9KKh1Y4xqKkkcq3/4Pd53tRgeSkLhqzf7hdHxlIptnL+N8WGtDq88bNrWjXo0BL
        nt7bx/iNG6HJOkwFqAcF84kaRcBeqGl2U3zTRWJHH5Gp/6J2X4q5zpf2GWrXHhtD4embgr
        aSgWd4ZJKWh+5cewPyGTHpu3Lf5M0kM=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-464-li2f7KgoOsmbIc3SCO0qoA-1; Wed, 06 May 2020 17:26:35 -0400
X-MC-Unique: li2f7KgoOsmbIc3SCO0qoA-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 63725100CCC2;
        Wed,  6 May 2020 21:26:33 +0000 (UTC)
Received: from x2.localnet (ovpn-113-240.phx2.redhat.com [10.3.113.240])
        by smtp.corp.redhat.com (Postfix) with ESMTP id EE2B510013D9;
        Wed,  6 May 2020 21:26:26 +0000 (UTC)
From:   Steve Grubb <sgrubb@redhat.com>
To:     Richard Guy Briggs <rgb@redhat.com>
Cc:     Paul Moore <paul@paul-moore.com>,
        Linux-Audit Mailing List <linux-audit@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>,
        netfilter-devel@vger.kernel.org, omosnace@redhat.com, fw@strlen.de,
        twoerner@redhat.com, Eric Paris <eparis@parisplace.org>,
        ebiederm@xmission.com, tgraf@infradead.org
Subject: Re: [PATCH ghak25 v4 3/3] audit: add subj creds to NETFILTER_CFG record to cover async unregister
Date:   Wed, 06 May 2020 17:26:25 -0400
Message-ID: <3250272.v6NOfJhyum@x2>
Organization: Red Hat
In-Reply-To: <20200429213247.6ewxqf66i2apgyuz@madcap2.tricolour.ca>
References: <cover.1587500467.git.rgb@redhat.com> <3348737.k9gCtgYObn@x2> <20200429213247.6ewxqf66i2apgyuz@madcap2.tricolour.ca>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="UTF-8"
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Wednesday, April 29, 2020 5:32:47 PM EDT Richard Guy Briggs wrote:
> On 2020-04-29 14:47, Steve Grubb wrote:
> > On Wednesday, April 29, 2020 10:31:46 AM EDT Richard Guy Briggs wrote:
> > > On 2020-04-28 18:25, Paul Moore wrote:
> > > > On Wed, Apr 22, 2020 at 5:40 PM Richard Guy Briggs <rgb@redhat.com>
> >=20
> > wrote:
> > > > > Some table unregister actions seem to be initiated by the kernel =
to
> > > > > garbage collect unused tables that are not initiated by any
> > > > > userspace
> > > > > actions.  It was found to be necessary to add the subject
> > > > > credentials
> > > > > to  cover this case to reveal the source of these actions.  A
> > > > > sample
> > > > > record:
> > > > > type=3DNETFILTER_CFG msg=3Daudit(2020-03-11 21:25:21.491:269) :
> > > > > table=3Dnat
> > > > > family=3Dbridge entries=3D0 op=3Dunregister pid=3D153 uid=3Droot =
auid=3Dunset
> > > > > tty=3D(none) ses=3Dunset subj=3Dsystem_u:system_r:kernel_t:s0
> > > > > comm=3Dkworker/u4:2 exe=3D(null)>
> > > >=20
> > > > [I'm going to comment up here instead of in the code because it is a
> > > > bit easier for everyone to see what the actual impact might be on t=
he
> > > > records.]
> > > >=20
> > > > Steve wants subject info in this case, okay, but let's try to trim
> > > > out
> > > > some of the fields which simply don't make sense in this record; I'm
> > > > thinking of fields that are unset/empty in the kernel case and are
> > > > duplicates of other records in the userspace/syscall case.  I think
> > > > that means we can drop "tty", "ses", "comm", and "exe" ... yes?
> > >=20
> > > From the ghak28 discussion, this list and order was selected due to
> > > Steve's preference for the "kernel" record convention, so deviating
> > > from this will create yet a new field list.  I'll defer to Steve on
> > > this. It also has to do with the searchability of fields if they are
> > > missing.
> > >=20
> > > I do agree that some fields will be superfluous in the kernel case.
> > > The most important field would be "subj", but then "pid" and "comm", I
> > > would think.  Based on this contents of the "subj" field, I'd think
> > > that "uid", "auid", "tty", "ses" and "exe" are not needed.
> >=20
> > We can't be adding deleting fields based on how its triggered. If they
> > are unset, that is fine. The main issue is they have to behave the same.
>=20
> I don't think the intent was to have fields swing in and out depending
> on trigger.  The idea is to potentially permanently not include them in
> this record type only.  The justification is that where they aren't
> needed for the kernel trigger situation it made sense to delete them
> because if it is a user context event it will be accompanied by a
> syscall record that already has that information and there would be no
> sense in duplicating it.

We should not be adding syscall records to anything that does not result fr=
om=20
a syscall rule triggering the event. Its very wasteful. More wasteful than=
=20
just adding the necessary fields.

I also wished we had a coding specification that put this in writing so tha=
t=20
every event is not a committee decision. That anyone can look at the docume=
nt=20
and Do The Right Thing =E2=84=A2.

If I add a section to Writing-Good-Events outlining the expected ordering o=
f=20
fields, would that be enough that we do not have long discussions about eve=
nt=20
format? I'm thinking this would also help new people that want to contribut=
e.

=2DSteve


