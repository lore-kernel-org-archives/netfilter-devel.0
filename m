Return-Path: <SRS0=2jko=VQ=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5A100C76195
	for <netfilter-devel@archiver.kernel.org>; Fri, 19 Jul 2019 16:00:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3D55D2186A
	for <netfilter-devel@archiver.kernel.org>; Fri, 19 Jul 2019 16:00:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729011AbfGSQAw (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 19 Jul 2019 12:00:52 -0400
Received: from out01.mta.xmission.com ([166.70.13.231]:58713 "EHLO
        out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727927AbfGSQAw (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 19 Jul 2019 12:00:52 -0400
Received: from in02.mta.xmission.com ([166.70.13.52])
        by out01.mta.xmission.com with esmtps (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.87)
        (envelope-from <ebiederm@xmission.com>)
        id 1hoVJR-0000DQ-Q5; Fri, 19 Jul 2019 10:00:49 -0600
Received: from ip68-227-160-95.om.om.cox.net ([68.227.160.95] helo=x220.xmission.com)
        by in02.mta.xmission.com with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.87)
        (envelope-from <ebiederm@xmission.com>)
        id 1hoVJF-00007t-01; Fri, 19 Jul 2019 10:00:49 -0600
From:   ebiederm@xmission.com (Eric W. Biederman)
To:     Paul Moore <paul@paul-moore.com>
Cc:     Richard Guy Briggs <rgb@redhat.com>,
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
        <CAHC9VhTYV02ws3QcezER5cY+Xt+tExcJEO-dumTDx=FXGFh3nw@mail.gmail.com>
Date:   Fri, 19 Jul 2019 11:00:24 -0500
In-Reply-To: <CAHC9VhTYV02ws3QcezER5cY+Xt+tExcJEO-dumTDx=FXGFh3nw@mail.gmail.com>
        (Paul Moore's message of "Thu, 18 Jul 2019 17:52:58 -0400")
Message-ID: <87muhadnfr.fsf@xmission.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/25.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-XM-SPF: eid=1hoVJF-00007t-01;;;mid=<87muhadnfr.fsf@xmission.com>;;;hst=in02.mta.xmission.com;;;ip=68.227.160.95;;;frm=ebiederm@xmission.com;;;spf=neutral
X-XM-AID: U2FsdGVkX18MlRZOnz5KekqSTfqL1FafpgF6dgr4Jq4=
X-SA-Exim-Connect-IP: 68.227.160.95
X-SA-Exim-Mail-From: ebiederm@xmission.com
Subject: Re: [PATCH ghak90 V6 02/10] audit: add container id
X-SA-Exim-Version: 4.2.1 (built Thu, 05 May 2016 13:38:54 -0600)
X-SA-Exim-Scanned: Yes (on in02.mta.xmission.com)
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Paul Moore <paul@paul-moore.com> writes:

> On Wed, Jul 17, 2019 at 8:52 PM Richard Guy Briggs <rgb@redhat.com> wrote:
>> On 2019-07-16 19:30, Paul Moore wrote:
>
> ...
>
>> > We can trust capable(CAP_AUDIT_CONTROL) for enforcing audit container
>> > ID policy, we can not trust ns_capable(CAP_AUDIT_CONTROL).
>>
>> Ok.  So does a process in a non-init user namespace have two (or more)
>> sets of capabilities stored in creds, one in the init_user_ns, and one
>> in current_user_ns?  Or does it get stripped of all its capabilities in
>> init_user_ns once it has its own set in current_user_ns?  If the former,
>> then we can use capable().  If the latter, we need another mechanism, as
>> you have suggested might be needed.
>
> Unfortunately I think the problem is that ultimately we need to allow
> any container orchestrator that has been given privileges to manage
> the audit container ID to also grant that privilege to any of the
> child process/containers it manages.  I don't believe we can do that
> with capabilities based on the code I've looked at, and the
> discussions I've had, but if you find a way I would leave to hear it.

>> If some random unprivileged user wants to fire up a container
>> orchestrator/engine in his own user namespace, then audit needs to be
>> namespaced.  Can we safely discard this scenario for now?
>
> I think the only time we want to allow a container orchestrator to
> manage the audit container ID is if it has been granted that privilege
> by someone who has that privilege already.  In the zero-container, or
> single-level of containers, case this is relatively easy, and we can
> accomplish it using CAP_AUDIT_CONTROL as the privilege.  If we start
> nesting container orchestrators it becomes more complicated as we need
> to be able to support granting and inheriting this privilege in a
> manner; this is why I suggested a new mechanism *may* be necessary.


Let me segway a bit and see if I can get this conversation out of the
rut it seems to have drifted into.

Unprivileged containers and nested containers exist today and are going
to become increasingly common.  Let that be a given.

As I recall the interesting thing for audit to log is actions by
privileged processes.  Audit can log more but generally configuring
logging by of the actions of unprivileged users is effectively a self
DOS.

So I think the initial implementation can safely ignore actions of
nested containers and unprivileged containers because you don't care
about their actions. 

If we start allow running audit in a container then we need to deal with
all of the nesting issues but until then I don't think you folks care.

Or am I wrong.  Do the requirements for securely auditing things from
the kernel care about the actions of unprivileged users?

Eric
