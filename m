Return-Path: <SRS0=pLNN=YE=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B5C77ECE58D
	for <netfilter-devel@archiver.kernel.org>; Fri, 11 Oct 2019 00:39:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 915B52190F
	for <netfilter-devel@archiver.kernel.org>; Fri, 11 Oct 2019 00:39:15 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=paul-moore-com.20150623.gappssmtp.com header.i=@paul-moore-com.20150623.gappssmtp.com header.b="SUM+Ozmq"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727854AbfJKAjM (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 10 Oct 2019 20:39:12 -0400
Received: from mail-lf1-f68.google.com ([209.85.167.68]:43394 "EHLO
        mail-lf1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727793AbfJKAjM (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 10 Oct 2019 20:39:12 -0400
Received: by mail-lf1-f68.google.com with SMTP id u3so5721257lfl.10
        for <netfilter-devel@vger.kernel.org>; Thu, 10 Oct 2019 17:39:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=paul-moore-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=aFT8cm8S0DEJCyLgBpASXj1oSQTtinFEh4s2GyLpCAk=;
        b=SUM+Ozmq/ACZrOTEwqmyCavmWazXGQLL83huZDzHGsYRooxZavBq96G3gSZB8aZEun
         4tNuU+9vatgFwhZ2C3CnGZuIm6rSCm9tF7Ri4hZuTLyRNG9wMsfSGbDW4ixy4pABeYx8
         RiZoc4KtGQBAZafsKpyIRkoagGDxiybFw91oHrLAIp2elU9Glh7hQMRnxYemxk3LXdAf
         83242C0BufY7yeIMuHD1/BJ/mBqjnb4LbON2RYZFDpSRI7c5hR+satKSZpXAtXUtZp2a
         IsbLva/X8n/wCo/lzhff7J2wgO0KRpDAcFyAp4oyWjPRYAF/2wcK+vpAQmg9N9Fs+doF
         90IQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=aFT8cm8S0DEJCyLgBpASXj1oSQTtinFEh4s2GyLpCAk=;
        b=p/hveLA2xKiJReeIsn/zBxt3aW3t7JDB/4m4ar9HnlweoA7V4n4aL4idpn3bD4LzZ4
         3Z7e/2mFYk92yvkyzGToj8TtK8Ym3jUeX+bJ4U+hUm5avv2Nge4GJ1Sa8VeZ+141ajU5
         Gz8mHBk9vfetW1xHKWZPH4lzTbgdYRKha2e5soAMgt/st/1D6HY4LY2aH9+ev6xw710z
         UuKayoqN3rLf4lBGxxrdCoVcoA/jE4i3IR72JjZwC8zMJntYv08N4gSdV1JwKwfFe4S4
         fJeor7t4FzL3IfNnEfTX9RkOOTB/+CPsCdgb7ZlNgKc7Vr15ZxJ9jN5r/TGEi3ca6uZF
         besg==
X-Gm-Message-State: APjAAAXjfEhPzuVdYj8TlzE6+AgjQ7Wp2HvDxUDbHhynZdohCyEy9uPI
        hMferkjU6mPiK68dX1wcCiCaAzh/rqtFTSf0/LmQ
X-Google-Smtp-Source: APXvYqy7lQItMV1AedUlABKN6Qqbi/t4grfJyN2rcTNd4EtP3vm905LTdxYK80Osnp73B/vBccWvg766BbHJwloILAc=
X-Received: by 2002:a19:520d:: with SMTP id m13mr7617840lfb.137.1570754349796;
 Thu, 10 Oct 2019 17:39:09 -0700 (PDT)
MIME-Version: 1.0
References: <cover.1568834524.git.rgb@redhat.com> <230e91cd3e50a3d8015daac135c24c4c58cf0a21.1568834524.git.rgb@redhat.com>
 <20190927125142.GA25764@hmswarspite.think-freely.org>
In-Reply-To: <20190927125142.GA25764@hmswarspite.think-freely.org>
From:   Paul Moore <paul@paul-moore.com>
Date:   Thu, 10 Oct 2019 20:38:58 -0400
Message-ID: <CAHC9VhRbSUCB0OZorC4+y+5uJDR5uMXdRn2LOTYGu2gcFJSrcA@mail.gmail.com>
Subject: Re: [PATCH ghak90 V7 06/21] audit: contid limit of 32k imposed to
 avoid DoS
To:     Neil Horman <nhorman@tuxdriver.com>
Cc:     Richard Guy Briggs <rgb@redhat.com>,
        containers@lists.linux-foundation.org, linux-api@vger.kernel.org,
        Linux-Audit Mailing List <linux-audit@redhat.com>,
        linux-fsdevel@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        netdev@vger.kernel.org, netfilter-devel@vger.kernel.org,
        sgrubb@redhat.com, omosnace@redhat.com, dhowells@redhat.com,
        simo@redhat.com, Eric Paris <eparis@parisplace.org>,
        Serge Hallyn <serge@hallyn.com>, ebiederm@xmission.com,
        Dan Walsh <dwalsh@redhat.com>, mpatel@redhat.com
Content-Type: text/plain; charset="UTF-8"
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Fri, Sep 27, 2019 at 8:52 AM Neil Horman <nhorman@tuxdriver.com> wrote:
> On Wed, Sep 18, 2019 at 09:22:23PM -0400, Richard Guy Briggs wrote:
> > Set an arbitrary limit on the number of audit container identifiers to
> > limit abuse.
> >
> > Signed-off-by: Richard Guy Briggs <rgb@redhat.com>
> > ---
> >  kernel/audit.c | 8 ++++++++
> >  kernel/audit.h | 4 ++++
> >  2 files changed, 12 insertions(+)
> >
> > diff --git a/kernel/audit.c b/kernel/audit.c
> > index 53d13d638c63..329916534dd2 100644
> > --- a/kernel/audit.c
> > +++ b/kernel/audit.c

...

> > @@ -2465,6 +2472,7 @@ int audit_set_contid(struct task_struct *task, u64 contid)
> >                               newcont->owner = current;
> >                               refcount_set(&newcont->refcount, 1);
> >                               list_add_rcu(&newcont->list, &audit_contid_hash[h]);
> > +                             audit_contid_count++;
> >                       } else {
> >                               rc = -ENOMEM;
> >                               goto conterror;
> > diff --git a/kernel/audit.h b/kernel/audit.h
> > index 162de8366b32..543f1334ba47 100644
> > --- a/kernel/audit.h
> > +++ b/kernel/audit.h
> > @@ -219,6 +219,10 @@ static inline int audit_hash_contid(u64 contid)
> >       return (contid & (AUDIT_CONTID_BUCKETS-1));
> >  }
> >
> > +extern int audit_contid_count;
> > +
> > +#define AUDIT_CONTID_COUNT   1 << 16
> > +
>
> Just to ask the question, since it wasn't clear in the changelog, what
> abuse are you avoiding here?  Ostensibly you should be able to create as
> many container ids as you have space for, and the simple creation of
> container ids doesn't seem like the resource strain I would be concerned
> about here, given that an orchestrator can still create as many
> containers as the system will otherwise allow, which will consume
> significantly more ram/disk/etc.

I've got a similar question.  Up to this point in the patchset, there
is a potential issue of hash bucket chain lengths and traversing them
with a spinlock held, but it seems like we shouldn't be putting an
arbitrary limit on audit container IDs unless we have a good reason
for it.  If for some reason we do want to enforce a limit, it should
probably be a tunable value like a sysctl, or similar.

--
paul moore
www.paul-moore.com
