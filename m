From: Florian Westphal <fw@strlen.de>
Subject: Re: [PATCH V2] audit: normalize NETFILTER_PKT
Date: Fri, 24 Feb 2017 02:50:02 +0100
Message-ID: <20170224015002.GB12342@breakpoint.cc>
References: <9504740e9333a0b7074abe0dddfc487aeeae6cff.1487813996.git.rgb@redhat.com>
 <20170223052015.GE11144@breakpoint.cc>
 <20170223155156.GL18258@madcap2.tricolour.ca>
 <CAHC9VhQwSH-CjWeaPJZhBpK2+vh8YqfG6kVaMCis--WrZCopEQ@mail.gmail.com>
 <20170223170431.GM18258@madcap2.tricolour.ca>
 <CAHC9VhSm+=9HB=+rVeOMDY12sC5fNS1Cz1pygSBT14YuGVsd=A@mail.gmail.com>
 <20170223171324.GN18258@madcap2.tricolour.ca>
 <CAHC9VhSUKTQ+mx4ha7_LRM7SaSbnK9sP5Sz7C+aFn26sB0riBQ@mail.gmail.com>
 <20170223173500.GQ18258@madcap2.tricolour.ca>
 <CAHC9VhTkx2pyRw-b64U=B+VdXUBNXebbQOAAkS60Nw1m96YB3w@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Richard Guy Briggs <rgb@redhat.com>,
        Florian Westphal <fw@strlen.de>, linux-audit@redhat.com,
        Netfilter Developer Mailing List
        <netfilter-devel@vger.kernel.org>,
        Thomas Graf <tgraf@infradead.org>
To: Paul Moore <paul@paul-moore.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([146.0.238.67]:45780 "EHLO
        Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751271AbdBXBvS (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 23 Feb 2017 20:51:18 -0500
Content-Disposition: inline
In-Reply-To: <CAHC9VhTkx2pyRw-b64U=B+VdXUBNXebbQOAAkS60Nw1m96YB3w@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Paul Moore <paul@paul-moore.com> wrote:
> On Thu, Feb 23, 2017 at 12:35 PM, Richard Guy Briggs <rgb@redhat.com> wrote:
> > I had another idea on how to include the sport and dport and that was to
> > use the same identifier for sport/icmptype and also for dport/icmpcode,
> > but you've already said you are not interested.
> 
> Not at this point in time since we don't have any good requirements at
> the moment.  I would like us to keep this small until we have a better
> idea of how people want to use this, this way we don't end up stuck
> maintaining something that is ill suited for what people actually
> want/use.

Right, I think people that want more info should just use NFLOG to
dump the packet to userspace, extracting all the stuff in kernel is
just a mess.
