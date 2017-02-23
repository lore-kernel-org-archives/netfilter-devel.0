From: Richard Guy Briggs <rgb@redhat.com>
Subject: Re: [PATCH V2] audit: normalize NETFILTER_PKT
Date: Thu, 23 Feb 2017 12:29:09 -0500
Message-ID: <20170223172909.GP18258@madcap2.tricolour.ca>
References: <9504740e9333a0b7074abe0dddfc487aeeae6cff.1487813996.git.rgb@redhat.com>
 <2939836.UGfmiAhj2Z@x2>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Netfilter Developer Mailing List
        <netfilter-devel@vger.kernel.org>, linux-audit@redhat.com,
        Thomas Graf <tgraf@infradead.org>,
        Eric Paris <eparis@redhat.com>, Paul Moore <pmoore@redhat.com>
To: Steve Grubb <sgrubb@redhat.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:36918 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751049AbdBWR3N (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 23 Feb 2017 12:29:13 -0500
Content-Disposition: inline
In-Reply-To: <2939836.UGfmiAhj2Z@x2>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On 2017-02-23 12:20, Steve Grubb wrote:
> On Wednesday, February 22, 2017 9:50:54 PM EST Richard Guy Briggs wrote:
> > Simplify and eliminate flipping in and out of message fields, relying on
> > nfmark the way we do for audit_key.
> > 
> > https://github.com/linux-audit/audit-kernel/issues/11
> > 
> > Signed-off-by: Richard Guy Briggs <rgb@redhat.com>
> 
> If this is reworked, do you mind including a raw log event in the explanation 
> part of the patch? I need to see the resulting event to see how user space 
> needs to adapt.

Yes, I'll make a note to remember to add that.

> -Steve

- RGB

--
Richard Guy Briggs <rgb@redhat.com>
Kernel Security Engineering, Base Operating Systems, Red Hat
Remote, Ottawa, Canada
Voice: +1.647.777.2635, Internal: (81) 32635
