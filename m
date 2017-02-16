From: Richard Guy Briggs <rgb@redhat.com>
Subject: Re: AUDIT_NETFILTER_PKT message format
Date: Thu, 16 Feb 2017 17:41:51 -0500
Message-ID: <20170216224151.GN21519@madcap2.tricolour.ca>
References: <20170117052551.GQ3087@madcap2.tricolour.ca>
 <10185842.hTv0ExFpgc@x2>
 <20170210225445.GS26850@madcap2.tricolour.ca>
 <3926301.2G9jBBrVEf@x2>
 <20170213205005.GO26855@madcap2.tricolour.ca>
 <CAHC9VhTGJMtg6z-WjW+PYCrEAKdrrKhfJdi3j4DB=91r8XYH4Q@mail.gmail.com>
 <20170214002452.GT26850@madcap2.tricolour.ca>
 <CAHC9VhQfwgcc4KquQm3TtNm-GLS+4YpoF6NkoZ8wzVopAn4Now@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Steve Grubb <sgrubb@redhat.com>,
        Linux-Audit Mailing List <linux-audit@redhat.com>,
        Netfilter Developer Mailing List
        <netfilter-devel@vger.kernel.org>,
        Thomas Graf <tgraf@infradead.org>
To: Paul Moore <paul@paul-moore.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:43966 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S933157AbdBPWlz (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 16 Feb 2017 17:41:55 -0500
Content-Disposition: inline
In-Reply-To: <CAHC9VhQfwgcc4KquQm3TtNm-GLS+4YpoF6NkoZ8wzVopAn4Now@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On 2017-02-14 16:06, Paul Moore wrote:
> On Mon, Feb 13, 2017 at 7:24 PM, Richard Guy Briggs <rgb@redhat.com> wrote:
> > On 2017-02-13 18:50, Paul Moore wrote:
> >> On Mon, Feb 13, 2017 at 3:50 PM, Richard Guy Briggs <rgb@redhat.com> wrote:
> 
> ...
> 
> >> > useless?        smac, dmac, macproto
> >>
> >> Probably useless in the majority of use cases.
> >
> > How do we deal with the minority of cases where it could be quite useful?
> 
> First you first need to show me why I should care about this, in other
> words, why *must* you have the fields in the audit record.

Well, as I've just argued in my other reply, the only fields that are a
*must* are the subject attributes and the nfmark.

You've jettisoned the ports while keeping the addresses, which puzzles
me other than for expediancy.

MAC, IP and ports can all be spoofed, each layer easier as you get
higher, but it is all potentially useful information.

> >> > helpful         secmark (I forgot to change it from "obj" to "secmark" in my patch).
> >>
> >> We may also want to log the peer label if we are going to log the secmark.
> >
> > Ok, noted.
> 
> Please note well the "*if*" portion in the above statement.  I'm not
> overly convinced that either field is all that useful in the majority
> of cases.

Thank you for that reminder to link the two.

> paul moore

- RGB

--
Richard Guy Briggs <rgb@redhat.com>
Kernel Security Engineering, Base Operating Systems, Red Hat
Remote, Ottawa, Canada
Voice: +1.647.777.2635, Internal: (81) 32635
