Return-Path: <SRS0=2jko=VQ=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9E763C7618F
	for <netfilter-devel@archiver.kernel.org>; Fri, 19 Jul 2019 15:32:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7DB7C2184E
	for <netfilter-devel@archiver.kernel.org>; Fri, 19 Jul 2019 15:32:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728394AbfGSPcc (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 19 Jul 2019 11:32:32 -0400
Received: from out03.mta.xmission.com ([166.70.13.233]:48180 "EHLO
        out03.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726072AbfGSPcc (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 19 Jul 2019 11:32:32 -0400
Received: from in01.mta.xmission.com ([166.70.13.51])
        by out03.mta.xmission.com with esmtps (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.87)
        (envelope-from <ebiederm@xmission.com>)
        id 1hoUs1-0002I0-Fb; Fri, 19 Jul 2019 09:32:29 -0600
Received: from ip68-227-160-95.om.om.cox.net ([68.227.160.95] helo=x220.xmission.com)
        by in01.mta.xmission.com with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.87)
        (envelope-from <ebiederm@xmission.com>)
        id 1hoUs0-0005zu-CO; Fri, 19 Jul 2019 09:32:29 -0600
From:   ebiederm@xmission.com (Eric W. Biederman)
To:     Richard Guy Briggs <rgb@redhat.com>
Cc:     Paul Moore <paul@paul-moore.com>,
        "Serge E. Hallyn" <serge@hallyn.com>,
        Tycho Andersen <tycho@tycho.ws>,
        containers@lists.linux-foundation.org, linux-api@vger.kernel.org,
        Linux-Audit Mailing List <linux-audit@redhat.com>,
        linux-fsdevel@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        netdev@vger.kernel.org, netfilter-devel@vger.kernel.org,
        sgrubb@redhat.com, omosnace@redhat.com, dhowells@redhat.com,
        simo@redhat.com, Eric Paris <eparis@parisplace.org>,
        nhorman@tuxdriver.com
References: <20190529153427.GB8959@cisco>
        <CAHC9VhSF3AjErX37+eeusJ7+XRw8yuPsmqBTRwc9EVoRBh_3Tw@mail.gmail.com>
        <20190529222835.GD8959@cisco>
        <CAHC9VhRS66VGtug3fq3RTGHDvfGmBJG6yRJ+iMxm3cxnNF-zJw@mail.gmail.com>
        <20190530170913.GA16722@mail.hallyn.com>
        <CAHC9VhThLiQzGYRUWmSuVfOC6QCDmA75BDB7Eg7V8HX4x7ymQg@mail.gmail.com>
        <20190708180558.5bar6ripag3sdadl@madcap2.tricolour.ca>
        <CAHC9VhRTT7JWqNnynvK04wKerjc-3UJ6R1uPtjCAPVr_tW-7MA@mail.gmail.com>
        <20190716220320.sotbfqplgdructg7@madcap2.tricolour.ca>
        <CAHC9VhScHizB2r5q3T5s0P3jkYdvzBPPudDksosYFp_TO7W9-Q@mail.gmail.com>
        <20190718005145.eshekqfr3navqqiy@madcap2.tricolour.ca>
Date:   Fri, 19 Jul 2019 10:32:13 -0500
In-Reply-To: <20190718005145.eshekqfr3navqqiy@madcap2.tricolour.ca> (Richard
        Guy Briggs's message of "Wed, 17 Jul 2019 20:51:45 -0400")
Message-ID: <874l3ighvm.fsf@xmission.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/25.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-XM-SPF: eid=1hoUs0-0005zu-CO;;;mid=<874l3ighvm.fsf@xmission.com>;;;hst=in01.mta.xmission.com;;;ip=68.227.160.95;;;frm=ebiederm@xmission.com;;;spf=neutral
X-XM-AID: U2FsdGVkX1+51FYWsW8BRSUlMyR1nWn6IFnz4uCKOTQ=
X-SA-Exim-Connect-IP: 68.227.160.95
X-SA-Exim-Mail-From: ebiederm@xmission.com
Subject: Re: [PATCH ghak90 V6 02/10] audit: add container id
X-SA-Exim-Version: 4.2.1 (built Thu, 05 May 2016 13:38:54 -0600)
X-SA-Exim-Scanned: Yes (on in01.mta.xmission.com)
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Richard Guy Briggs <rgb@redhat.com> writes:

> On 2019-07-16 19:30, Paul Moore wrote:
>> On Tue, Jul 16, 2019 at 6:03 PM Richard Guy Briggs <rgb@redhat.com> wrote:
>> > On 2019-07-15 17:04, Paul Moore wrote:
>> > > On Mon, Jul 8, 2019 at 2:06 PM Richard Guy Briggs <rgb@redhat.com> wrote:
>> 
>> > > > At this point I would say we are at an impasse unless we trust
>> > > > ns_capable() or we implement audit namespaces.
>> > >
>> > > I'm not sure how we can trust ns_capable(), but if you can think of a
>> > > way I would love to hear it.  I'm also not sure how namespacing audit
>> > > is helpful (see my above comments), but if you think it is please
>> > > explain.
>> >
>> > So if we are not namespacing, why do we not trust capabilities?
>> 
>> We can trust capable(CAP_AUDIT_CONTROL) for enforcing audit container
>> ID policy, we can not trust ns_capable(CAP_AUDIT_CONTROL).
>
> Ok.  So does a process in a non-init user namespace have two (or more)
> sets of capabilities stored in creds, one in the init_user_ns, and one
> in current_user_ns?  Or does it get stripped of all its capabilities in
> init_user_ns once it has its own set in current_user_ns?  If the former,
> then we can use capable().  If the latter, we need another mechanism, as
> you have suggested might be needed.

The latter.  There is only one set of capabilities and it is in the
processes current user namespace.

Eric
