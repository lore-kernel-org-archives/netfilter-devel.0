Return-Path: <SRS0=suf1=VM=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 91879C76191
	for <netfilter-devel@archiver.kernel.org>; Mon, 15 Jul 2019 21:10:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 64C7420665
	for <netfilter-devel@archiver.kernel.org>; Mon, 15 Jul 2019 21:10:19 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=paul-moore-com.20150623.gappssmtp.com header.i=@paul-moore-com.20150623.gappssmtp.com header.b="Jc3fkDPo"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730091AbfGOVKM (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 15 Jul 2019 17:10:12 -0400
Received: from mail-lj1-f196.google.com ([209.85.208.196]:33920 "EHLO
        mail-lj1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729969AbfGOVKL (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 15 Jul 2019 17:10:11 -0400
Received: by mail-lj1-f196.google.com with SMTP id p17so17744998ljg.1
        for <netfilter-devel@vger.kernel.org>; Mon, 15 Jul 2019 14:10:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=paul-moore-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=QqWs6tnJsgPqdUO1RETz8iVY1LYxL4xOc0UaMWvwPg0=;
        b=Jc3fkDPoiovpnK/n6pDHbPLS9nVpGOM7djQI5/ClJN/dSVYx0G2CcXdfv23vT3PanX
         Qn6AUs3nVlieQDU5Z4c7eqmhRVhmiFpAcCkovtd0tanJyIidCZd+LqSce4GoI/lUymw3
         ElQLBiBEe1Ku5Olg531yOzIB+dCJGL8uU4Lf44GoktV3dBNmKyeVkOTIuJ7cMV0EA4hN
         rcTTJVbFdwgsoDOx4fLkWerxaPeZb6F33gh+JEpagB8bKE/FmRMbnODKAMa0coDjYDqZ
         4BjkOPXxge1sCEh141rXpKRh4sAooMqCmZgsr22pRF9VCyPb2695owHUo7FbJ1nKjCGq
         vcNg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=QqWs6tnJsgPqdUO1RETz8iVY1LYxL4xOc0UaMWvwPg0=;
        b=UQnxkVFaqfZWmATvrDJjd3RMBcjWmbhSpxVBox8bsMVCP3GQO9imEdUOZARMrR2kF1
         r/zdr70GPMeTjlB5qipvunLg8/wDkgv7+oPi9kkZZMTCyBKhKIxhId90DeGH+iDL2SGR
         IPTs9cnNovhijekar6VOL/9IPAbjllwRMKCFfrsecV13CQzpdS/ZVulBM7GzGSVs5AZH
         l7uD//76249U551BvSLmXHZV6YV2Rn1p9X4BJ/EZLupSriHBxRWNvLj6NvW1+DS+BFDx
         IlmHo2/JMzPJQRxuy7WOeCRnHrEYPRIdywii4s3HidPjO17h8NuSVEDIZmyR5ShFOnvh
         RHiA==
X-Gm-Message-State: APjAAAVPK0oVNdVNdVzobQCM3nLuDyG1lxet2qFXYAXWblVSnPtXkyfz
        Euw2hnFvpKSoXJEzOQZTMu0Qvf5LTsn8WrMgGw==
X-Google-Smtp-Source: APXvYqxVf+AvafI76eso5Vi9qaZvd/1ppBT5BDFcvn0IUAfeDjccWO8ASbUvznAJcvMELWLizujdPIuM3Zrv5fujIzE=
X-Received: by 2002:a2e:9dc1:: with SMTP id x1mr15382970ljj.0.1563225009574;
 Mon, 15 Jul 2019 14:10:09 -0700 (PDT)
MIME-Version: 1.0
References: <20190529145742.GA8959@cisco> <CAHC9VhR4fudQanvZGYWMvCf7k2CU3q7e7n1Pi7hzC3v_zpVEdw@mail.gmail.com>
 <20190529153427.GB8959@cisco> <CAHC9VhSF3AjErX37+eeusJ7+XRw8yuPsmqBTRwc9EVoRBh_3Tw@mail.gmail.com>
 <20190529222835.GD8959@cisco> <CAHC9VhRS66VGtug3fq3RTGHDvfGmBJG6yRJ+iMxm3cxnNF-zJw@mail.gmail.com>
 <20190530170913.GA16722@mail.hallyn.com> <CAHC9VhThLiQzGYRUWmSuVfOC6QCDmA75BDB7Eg7V8HX4x7ymQg@mail.gmail.com>
 <20190530212900.GC5739@cisco> <CAHC9VhT5HPt9rCJoDutdvA3r1Y1GOHfpXe2eJ54atNC1=Vd8LA@mail.gmail.com>
 <20190708181237.5poheliito7zpvmc@madcap2.tricolour.ca>
In-Reply-To: <20190708181237.5poheliito7zpvmc@madcap2.tricolour.ca>
From:   Paul Moore <paul@paul-moore.com>
Date:   Mon, 15 Jul 2019 17:09:58 -0400
Message-ID: <CAHC9VhT0V+xi_6nAR5TsM2vs34LbgMeO=-W+MS_kqiXRRzneZQ@mail.gmail.com>
Subject: Re: [PATCH ghak90 V6 02/10] audit: add container id
To:     Richard Guy Briggs <rgb@redhat.com>
Cc:     Tycho Andersen <tycho@tycho.ws>,
        "Serge E. Hallyn" <serge@hallyn.com>,
        containers@lists.linux-foundation.org, linux-api@vger.kernel.org,
        Linux-Audit Mailing List <linux-audit@redhat.com>,
        linux-fsdevel@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        netdev@vger.kernel.org, netfilter-devel@vger.kernel.org,
        sgrubb@redhat.com, omosnace@redhat.com, dhowells@redhat.com,
        simo@redhat.com, Eric Paris <eparis@parisplace.org>,
        ebiederm@xmission.com, nhorman@tuxdriver.com
Content-Type: text/plain; charset="UTF-8"
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Mon, Jul 8, 2019 at 2:12 PM Richard Guy Briggs <rgb@redhat.com> wrote:
> On 2019-05-30 19:26, Paul Moore wrote:

...

> > I like the creativity, but I worry that at some point these
> > limitations are going to be raised (limits have a funny way of doing
> > that over time) and we will be in trouble.  I say "trouble" because I
> > want to be able to quickly do an audit container ID comparison and
> > we're going to pay a penalty for these larger values (we'll need this
> > when we add multiple auditd support and the requisite record routing).
> >
> > Thinking about this makes me also realize we probably need to think a
> > bit longer about audit container ID conflicts between orchestrators.
> > Right now we just take the value that is given to us by the
> > orchestrator, but if we want to allow multiple container orchestrators
> > to work without some form of cooperation in userspace (I think we have
> > to assume the orchestrators will not talk to each other) we likely
> > need to have some way to block reuse of an audit container ID.  We
> > would either need to prevent the orchestrator from explicitly setting
> > an audit container ID to a currently in use value, or instead generate
> > the audit container ID in the kernel upon an event triggered by the
> > orchestrator (e.g. a write to a /proc file).  I suspect we should
> > start looking at the idr code, I think we will need to make use of it.
>
> To address this, I'd suggest that it is enforced to only allow the
> setting of descendants and to maintain a master list of audit container
> identifiers (with a hash table if necessary later) that includes the
> container owner.

We're discussing the audit container ID management policy elsewhere in
this thread so I won't comment on that here, but I did want to say
that we will likely need something better than a simple list of audit
container IDs from the start.  It's common for systems to have
thousands of containers now (or multiple thousands), which tells me
that a list is a poor choice.  You mentioned a hash table, so I would
suggest starting with that over the list for the initial patchset.

-- 
paul moore
www.paul-moore.com
