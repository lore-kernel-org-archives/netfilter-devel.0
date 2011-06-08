From: Steve Grubb <sgrubb@redhat.com>
Subject: Re: [PATCH 3rd revision] Add SELinux context support to AUDIT target
Date: Wed, 8 Jun 2011 13:14:55 -0400
Message-ID: <201106081314.55947.sgrubb@redhat.com>
References: <4DEDEB99.4070601@netfilter.org> <201106081049.48026.sgrubb@redhat.com> <4DEF9F77.1080406@googlemail.com>
Mime-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Cc: linux-audit@redhat.com, netfilter-devel@vger.kernel.org,
	Thomas Graf <tgraf@redhat.com>,
	Al Viro <viro@zeniv.linux.org.uk>,
	Eric Paris <eparis@parisplace.org>,
	Patrick McHardy <kaber@trash.net>,
	Pablo Neira Ayuso <pablo@netfilter.org>
To: Mr Dash Four <mr.dash.four@googlemail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:13695 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751233Ab1FHRPQ (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 8 Jun 2011 13:15:16 -0400
In-Reply-To: <4DEF9F77.1080406@googlemail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Wednesday, June 08, 2011 12:12:39 PM Mr Dash Four wrote:
> Mr Dash Four wrote:
> > Logging the internal numerical representation of secctx is, as I have
> > already stated about 3 times by now, exposing internal
> > (private-to-the-kernel-only) information to userspace. That cannot be
> > allowed.

It doesn't matter if its private. If its important enough to log to the audit system, 
we can't let something like this slide.


> > Besides, this numerical representation isn't reliable - these numbers
> > are dynamic and can change - another reason why they should not be
> > allowed to be present in the audit log. 

Doesn't matter. Its the event that we want and all its attributes. If the label is not 
correct, how else are we going to know? Do the LSMs generate an audit event saying 
they couldn't lookup a label?

> > What happens if I make changes to my security policy and then run
> > ausearch/aureport? 

Nothing.

> > I am either going to see different (wrong!) context reported if ausearch/aureport
> > attempts to "convert" those numbers into SELinux context, or, I am
> > going to see meaningless numbers. Either way, useless or misleading
> > information is going to be reported and we don't want that, do we?

Yes, we do.

> > else
> > 
> > 	audit_log_format(ab, " osid=%u", skb->secmark);
> > 
> > _All_  audit code records the number on a failed conversion.
> 
> I am assuming you haven't read the above. Show me one good reason why I
> should alter my patch to include that abomination of yours?

Because _all_ logging of object labels in the audit system do this. You are asking to 
add information to the audit system. I am telling you how its done everywhere else so 
that you patch is consistent.

-Steve
