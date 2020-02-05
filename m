Return-Path: <SRS0=2+fO=3Z=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C1CE1C352A1
	for <netfilter-devel@archiver.kernel.org>; Wed,  5 Feb 2020 23:06:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9866D214AF
	for <netfilter-devel@archiver.kernel.org>; Wed,  5 Feb 2020 23:06:08 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=paul-moore-com.20150623.gappssmtp.com header.i=@paul-moore-com.20150623.gappssmtp.com header.b="g3A0hNA6"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727761AbgBEXGH (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 5 Feb 2020 18:06:07 -0500
Received: from mail-ed1-f65.google.com ([209.85.208.65]:33810 "EHLO
        mail-ed1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727457AbgBEXGG (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 5 Feb 2020 18:06:06 -0500
Received: by mail-ed1-f65.google.com with SMTP id r18so3913291edl.1
        for <netfilter-devel@vger.kernel.org>; Wed, 05 Feb 2020 15:06:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=paul-moore-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=vlJ/U1sEBP1oQwj7OCYoHbsQvGpwGivKoqIGPKoUwhQ=;
        b=g3A0hNA6kxL9eVlbJg40LlUAgcaXfVIhyAWWXE+HXr4LqixdrqRVAo/myymEo1mxz0
         7oLsCAN+970Ac58Bz39uxwHBk5xS8SmurEjexUpApiFBRmVaj+XThRHvQNFNlv5Nxdxo
         4Y1zuutWQbpPW1mbRN/esV23cyvTHNslCjf2ltrYRk5IuHoDiWXU476zY1D53uqKUG7s
         cJHhXWBb02p6B1RoTL5si0XL5svLP327G3/+Fl6KhJME78x4C51Ez4OcNAgFkA0DfIcX
         6IA/anxSDbd0lNnuSHawKXd/latZwau57XBct1nsJ/nu94DAxJ6NZhH7tJ76mKMrc570
         KC6Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=vlJ/U1sEBP1oQwj7OCYoHbsQvGpwGivKoqIGPKoUwhQ=;
        b=bZu0ye7S3XRMCojJpa074K+wquLGhysGGa3vNKM1fftiIUVsZ++avg1V5bbclRrmtW
         lmhAfCjcYHJzMJ7cPcGHUCUNGw7RTrNE4fTMD9vPHQP24Dkrk+RVv/MBNWyVEgVZmXgQ
         Gc1gD9G3X+Ua/3ugWmv2EGemZQhvcEHa2fzMl/VhupQ0IVbbz6lvcKf2ViEMNsVHvHbU
         5c+MPLLuIiOaiu5uq7oWZGlX4DksYb6YBza6d8Eb/ZxTOuWxrivMAVbV99+EJQFCNnnS
         R0btY+UAqbxvMdZdLecq3WAAz7cv/fdPyRbfagVMtNDr4aj7B0/dc+mc7UynBB7vfKss
         Dwqw==
X-Gm-Message-State: APjAAAUqi4IHAnUtGBti1Pe+Y2U7b5xMu0NI51vslP0CKdTUYVvvBacY
        4hJPMjYpo0+O51jLEALrEBChVkxg9vh5KnFazZpE
X-Google-Smtp-Source: APXvYqz/4rBVGOVjSYn3epCJFE9lKFv+T/52X8+lWfni3jO5pJYkLxPkkrOJ1odyceqG814XJFKyAUMdwXjFbMkHuZg=
X-Received: by 2002:a17:906:f251:: with SMTP id gy17mr338432ejb.308.1580943963052;
 Wed, 05 Feb 2020 15:06:03 -0800 (PST)
MIME-Version: 1.0
References: <cover.1577736799.git.rgb@redhat.com> <6452955c1e038227a5cd169f689f3fd3db27513f.1577736799.git.rgb@redhat.com>
 <CAHC9VhRkH=YEjAY6dJJHSp934grHnf=O4RiqLu3U8DzdVQOZkg@mail.gmail.com> <20200130192753.n7jjrshbhrczjzoe@madcap2.tricolour.ca>
In-Reply-To: <20200130192753.n7jjrshbhrczjzoe@madcap2.tricolour.ca>
From:   Paul Moore <paul@paul-moore.com>
Date:   Wed, 5 Feb 2020 18:05:52 -0500
Message-ID: <CAHC9VhSVN3mNb5enhLR1hY+ekiAyiYWbehrwd_zN7kz13dF=1w@mail.gmail.com>
Subject: Re: [PATCH ghak90 V8 13/16] audit: track container nesting
To:     Richard Guy Briggs <rgb@redhat.com>
Cc:     nhorman@tuxdriver.com, linux-api@vger.kernel.org,
        containers@lists.linux-foundation.org,
        LKML <linux-kernel@vger.kernel.org>, dhowells@redhat.com,
        Linux-Audit Mailing List <linux-audit@redhat.com>,
        netfilter-devel@vger.kernel.org, ebiederm@xmission.com,
        simo@redhat.com, netdev@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, Eric Paris <eparis@parisplace.org>,
        mpatel@redhat.com, Serge Hallyn <serge@hallyn.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Thu, Jan 30, 2020 at 2:28 PM Richard Guy Briggs <rgb@redhat.com> wrote:
> On 2020-01-22 16:29, Paul Moore wrote:
> > On Tue, Dec 31, 2019 at 2:51 PM Richard Guy Briggs <rgb@redhat.com> wrote:
> > >
> > > Track the parent container of a container to be able to filter and
> > > report nesting.
> > >
> > > Now that we have a way to track and check the parent container of a
> > > container, modify the contid field format to be able to report that
> > > nesting using a carrat ("^") separator to indicate nesting.  The
> > > original field format was "contid=<contid>" for task-associated records
> > > and "contid=<contid>[,<contid>[...]]" for network-namespace-associated
> > > records.  The new field format is
> > > "contid=<contid>[^<contid>[...]][,<contid>[...]]".
> >
> > Let's make sure we always use a comma as a separator, even when
> > recording the parent information, for example:
> > "contid=<contid>[,^<contid>[...]][,<contid>[...]]"
>
> The intent here is to clearly indicate and separate nesting from
> parallel use of several containers by one netns.  If we do away with
> that distinction, then we lose that inheritance accountability and
> should really run the list through a "uniq" function to remove the
> produced redundancies.  This clear inheritance is something Steve was
> looking for since tracking down individual events/records to show that
> inheritance was not aways feasible due to rolled logs or search effort.

Perhaps my example wasn't clear.  I'm not opposed to the little
carat/hat character indicating a container's parent, I just think it
would be good to also include a comma *in*addition* to the carat/hat.

> > > Signed-off-by: Richard Guy Briggs <rgb@redhat.com>
> > > ---
> > >  include/linux/audit.h |  1 +
> > >  kernel/audit.c        | 53 +++++++++++++++++++++++++++++++++++++++++++--------
> > >  kernel/audit.h        |  1 +
> > >  kernel/auditfilter.c  | 17 ++++++++++++++++-
> > >  kernel/auditsc.c      |  2 +-
> > >  5 files changed, 64 insertions(+), 10 deletions(-)
> >
> > ...
> >
> > > diff --git a/kernel/audit.c b/kernel/audit.c
> > > index ef8e07524c46..68be59d1a89b 100644
> > > --- a/kernel/audit.c
> > > +++ b/kernel/audit.c
> >
> > > @@ -492,6 +493,7 @@ void audit_switch_task_namespaces(struct nsproxy *ns, struct task_struct *p)
> > >                 audit_netns_contid_add(new->net_ns, contid);
> > >  }
> > >
> > > +void audit_log_contid(struct audit_buffer *ab, u64 contid);
> >
> > If we need a forward declaration, might as well just move it up near
> > the top of the file with the rest of the declarations.
>
> Ok.
>
> > > +void audit_log_contid(struct audit_buffer *ab, u64 contid)
> > > +{
> > > +       struct audit_contobj *cont = NULL, *prcont = NULL;
> > > +       int h;
> >
> > It seems safer to pass the audit container ID object and not the u64.
>
> It would also be faster, but in some places it isn't available such as
> for ptrace and signal targets.  This also links back to the drop record
> refcounts to hold onto the contobj until process exit, or signal
> delivery.
>
> What we could do is to supply two potential parameters, a contobj and/or
> a contid, and have it use the contobj if it is valid, otherwise, use the
> contid, as is done for names and paths supplied to audit_log_name().

Let's not do multiple parameters, that begs for misuse, let's take the
wrapper function route:

 func a(int id) {
   // important stuff
 }

 func ao(struct obj) {
   a(obj.id);
 }

... and we can add a comment that you *really* should be using the
variant that passes an object.

> > > @@ -2705,9 +2741,10 @@ int audit_set_contid(struct task_struct *task, u64 contid)
> > >         if (!ab)
> > >                 return rc;
> > >
> > > -       audit_log_format(ab,
> > > -                        "op=set opid=%d contid=%llu old-contid=%llu",
> > > -                        task_tgid_nr(task), contid, oldcontid);
> > > +       audit_log_format(ab, "op=set opid=%d contid=", task_tgid_nr(task));
> > > +       audit_log_contid(ab, contid);
> > > +       audit_log_format(ab, " old-contid=");
> > > +       audit_log_contid(ab, oldcontid);
> >
> > This is an interesting case where contid and old-contid are going to
> > be largely the same, only the first (current) ID is going to be
> > different; do we want to duplicate all of those IDs?
>
> At first when I read your comment, I thought we could just take contid
> and drop oldcontid, but if it fails, we still want all the information,
> so given the way I've set up the search code in userspace, listing only
> the newest contid in the contid field and all the rest in oldcontid
> could be a good compromise.

This is along the lines of what I was thinking.

-- 
paul moore
www.paul-moore.com
