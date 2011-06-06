From: Steve Grubb <sgrubb@redhat.com>
Subject: Re: [PATCH 2nd revision] Add SELinux context support to AUDIT target
Date: Mon, 6 Jun 2011 08:53:57 -0400
Message-ID: <201106060853.57940.sgrubb@redhat.com>
References: <4DDE9194.4030303@netfilter.org> <201106060830.52644.sgrubb@redhat.com> <4DECCB27.6040706@googlemail.com>
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
Received: from mx1.redhat.com ([209.132.183.28]:30684 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754911Ab1FFMyP (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 6 Jun 2011 08:54:15 -0400
In-Reply-To: <4DECCB27.6040706@googlemail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Monday, June 06, 2011 08:42:15 AM Mr Dash Four wrote:
> > This is not any more leak than leaking the context string to user space
> > as this patch attempts to do. The rest of the audit code does log the
> > numeric representation when text fails.
> 
> There is no "leak" when the secctx is recorded in the audit log - it is
> supposed to be there, if present (and retrievable). 

Exactly my point. There is no leak if its text or numeric.

> As for exposing the (internal) numerical representation of the secctx - this was
> discussed previously and the approach you are suggesting was dropped. To quote
> Eric on this very issue "[It] exports the internal secid to userspace.
> These are dynamic, can change on lsm changes, and have no meaning in
> userspace. We should instead be sending lsm contexts to userspace
> instead.".

Doesn't matter. The requirements of the protection profiles say to log the object's 
label. It does not care if its text or numeric. It also does not say sometimes or only 
when its convenient. :)  Its either important enough to log even if text conversion 
fails or its not important enough to log at all.

-Steve
