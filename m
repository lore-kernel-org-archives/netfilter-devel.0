From: Florian Westphal <fw@strlen.de>
Subject: Re: [PATCH V2] audit: normalize NETFILTER_PKT
Date: Fri, 24 Feb 2017 02:59:28 +0100
Message-ID: <20170224015928.GB5277@breakpoint.cc>
References: <9504740e9333a0b7074abe0dddfc487aeeae6cff.1487813996.git.rgb@redhat.com>
 <20170223052015.GE11144@breakpoint.cc>
 <20170223155156.GL18258@madcap2.tricolour.ca>
 <CAHC9VhQwSH-CjWeaPJZhBpK2+vh8YqfG6kVaMCis--WrZCopEQ@mail.gmail.com>
 <20170223170431.GM18258@madcap2.tricolour.ca>
 <20170223170647.GA5277@breakpoint.cc>
 <20170223172030.GO18258@madcap2.tricolour.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Florian Westphal <fw@strlen.de>, Paul Moore <paul@paul-moore.com>,
        linux-audit@redhat.com,
        Netfilter Developer Mailing List
        <netfilter-devel@vger.kernel.org>,
        Thomas Graf <tgraf@infradead.org>
To: Richard Guy Briggs <rgb@redhat.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([146.0.238.67]:45808 "EHLO
        Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751283AbdBXCAo (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 23 Feb 2017 21:00:44 -0500
Content-Disposition: inline
In-Reply-To: <20170223172030.GO18258@madcap2.tricolour.ca>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Richard Guy Briggs <rgb@redhat.com> wrote:
> > Not following, sorry, are you saying users can/should use -j MARK
> > somehow?
> 
> Part of the discussed design and rationale for stripping many of the
> vanishing fields is that when setting up netfilter rules to invoke the
> AUDIT target, an accompanying nf mark should be used to indicate which
> rule caught that packet, since the chain name and rule number aren't
> available to the audit target.  We would use the nf mark similarly to
> the way we use a rule key in the audit rules (see man auditctl).

I see.  While this works, nfmark might already be used for other
purposes such as policy routing, so you might need an extra cookie
that can be passed to the AUDIT target instead.
