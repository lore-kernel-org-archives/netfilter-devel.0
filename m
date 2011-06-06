From: Steve Grubb <sgrubb@redhat.com>
Subject: Re: [PATCH 2nd revision] Add SELinux context support to AUDIT target
Date: Mon, 6 Jun 2011 08:30:52 -0400
Message-ID: <201106060830.52644.sgrubb@redhat.com>
References: <4DDE9194.4030303@netfilter.org> <201106060814.12524.sgrubb@redhat.com> <4DECC754.6040003@googlemail.com>
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
Received: from mx1.redhat.com ([209.132.183.28]:56752 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755149Ab1FFMbJ (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 6 Jun 2011 08:31:09 -0400
In-Reply-To: <4DECC754.6040003@googlemail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Monday, June 06, 2011 08:25:56 AM Mr Dash Four wrote:
> > Normally there would be an else here to do something like
> > audit_log_format(ab, " osid=%u", skb->secmark);
> > so that its recorded numerically if the context could not be looked up.
> 
> I disagree! That approach was dropped long ago when the secctx was first
> introduced to prevent kernel information leaking into userspace (Eric
> would know more about this as he designed that aspect of it a couple of
> months ago). 

This is not any more leak than leaking the context string to user space as this patch 
attempts to do. The rest of the audit code does log the numeric representation when 
text fails.

-Steve
