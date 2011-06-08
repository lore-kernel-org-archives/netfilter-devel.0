From: Steve Grubb <sgrubb@redhat.com>
Subject: Re: [PATCH 3rd revision] Add SELinux context support to AUDIT target
Date: Wed, 8 Jun 2011 15:28:22 -0400
Message-ID: <201106081528.22926.sgrubb@redhat.com>
References: <4DEDEB99.4070601@netfilter.org> <4DEFC6C9.5030004@googlemail.com> <BANLkTikhbT7EVXcKM8vSHir=6Va+qWY19A@mail.gmail.com>
Mime-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Cc: Mr Dash Four <mr.dash.four@googlemail.com>,
	Casey Schaufler <casey@schaufler-ca.com>,
	linux-audit@redhat.com, Thomas Graf <tgraf@redhat.com>,
	netfilter-devel@vger.kernel.org, Al Viro <viro@zeniv.linux.org.uk>,
	Patrick McHardy <kaber@trash.net>,
	Pablo Neira Ayuso <pablo@netfilter.org>
To: Eric Paris <eparis@parisplace.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:13498 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754492Ab1FHT2q (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 8 Jun 2011 15:28:46 -0400
In-Reply-To: <BANLkTikhbT7EVXcKM8vSHir=6Va+qWY19A@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Wednesday, June 08, 2011 03:08:38 PM Eric Paris wrote:
> On Wed, Jun 8, 2011 at 3:00 PM, Mr Dash Four
> 
> <mr.dash.four@googlemail.com> wrote:
> >> int audit_log_secctx(struct auditbuffer *ab, u32 secid)
> >> {
> >>    int len, rc;
> >>    char *ctx;
> >> 
> >>    rc = security_secid_to_secctx(sid, &ctx, &len);
> >>    if (rc) {
> >>        audit_panic("Cannot convert secid to context");
> >>    } else {
> >>            audit_log_format(ab, " subj=%s", ctx);
> >>            security_release_secctx(ctx, len);
> >>    }
> >>    return rc;
> >> }
> >> 
> >> Such a function could be used a couple of places in the audit code
> >> itself.
> > 
> > My view on this is that LSM error-handling should be part of LSM.
> > 
> > I presume security_secid_to_secctx is going to be called from quite a few
> > places (well, I know of at least two now and they have nothing to do with
> > the LSM) and in my opinion it would be better if that error handling, if
> > adopted, is implemented within the function itself - whether by calling
> > another function, like the one you proposed above, or as part of the
> > secctx retrieval - this could be open to interpretation, but the point I
> > am trying to make is that whichever code security_secid_to_secctx is
> > invoked from shouldn't be involved in reporting/handling (internal LSM)
> > errors at all.
> > 
> > I think I made that point in my previous post, but just wanted to make
> > sure that is the case.
> 
> The LSM might report and error.  It's up to the caller to figure out
> how to deal with that error.  In this case we want to use the audit
> system so it's up to the audit system how to handle that error. 

We are happy recording the failed number. Its the LSM people that say nuke the system. 
So, I would put that in security_secid_to_secctx() so that everyone knows whose 
requirements it was to do the nuclear option.

-Steve
