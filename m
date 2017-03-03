From: Richard Guy Briggs <rgb@redhat.com>
Subject: Re: [PATCH V3] audit: normalize NETFILTER_PKT
Date: Fri, 3 Mar 2017 12:11:32 -0500
Message-ID: <20170303171132.GK18258@madcap2.tricolour.ca>
References: <CAHC9VhTHfyPR-yj4kOAJBeU4D1=o4Uu-=S_STvQoj4OAr9Y-mQ@mail.gmail.com>
 <20170301223447.GA18258@madcap2.tricolour.ca>
 <CAHC9VhRGSzea_c9Gg-Z3gr8cu2UQA9DhNtba0tf9AShoNakxzw@mail.gmail.com>
 <20170303020007.GF18258@madcap2.tricolour.ca>
 <CAHC9VhRoy1TR46ZLfzLB1wzOq=VZfX-RnG=7ogVP1Xphk=qtBg@mail.gmail.com>
 <20170303115416.GH18258@madcap2.tricolour.ca>
 <20170303124526.GC29213@breakpoint.cc>
 <CAHC9VhQNEw4r00Ht-DsQc_t5TYpz395VrT=qGOK5UvxjA7rmRg@mail.gmail.com>
 <20170303132201.GF29213@breakpoint.cc>
 <CAHC9VhQ-n3tvZrZT4b2vmJCZ-qoi8sXBjrOR0YmBV+Zu6mJyXw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Florian Westphal <fw@strlen.de>,
        Netfilter Developer Mailing List
        <netfilter-devel@vger.kernel.org>, linux-audit@redhat.com,
        Thomas Woerner <twoerner@redhat.com>,
        Thomas Graf <tgraf@infradead.org>
To: Paul Moore <paul@paul-moore.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:28517 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751602AbdCCRLj (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 3 Mar 2017 12:11:39 -0500
Content-Disposition: inline
In-Reply-To: <CAHC9VhQ-n3tvZrZT4b2vmJCZ-qoi8sXBjrOR0YmBV+Zu6mJyXw@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On 2017-03-03 08:56, Paul Moore wrote:
> On Fri, Mar 3, 2017 at 8:22 AM, Florian Westphal <fw@strlen.de> wrote:
> > Paul Moore <paul@paul-moore.com> wrote:
> >> On Fri, Mar 3, 2017 at 7:45 AM, Florian Westphal <fw@strlen.de> wrote:
> >> > Richard Guy Briggs <rgb@redhat.com> wrote:
> >> >> > Perhaps I'm missing something here, but let me ask again, how does
> >> >> > userspace distinguish between an unset nfmark and a nfmark of
> >> >> > 0xffffffff?
> >> >>
> >> >> It can't.
> >> >
> >> > It can if you log it as 0, as I asked in patch 1 review.
> >> >
> >> > (You wouldn't log sk uid of 0 as -1 either, would you?)
> >>
> >> I want to see the code able to handle the full range of nfmark values
> >> as well as the unset case; if that means we need to tweak userspace a
> >> bit, please work with Steve on that.
> >
> > There is no 'unset nfmark'.  Its just a 32bit integer.
> 
> Yes, my apologies, this thread has dragged on so long I muddled the
> details in my mind ... here is what I'm trying to get at, Richard's
> latest patch (unless I've missed one in my inbox) has the following
> line:
> 
>   audit_log_format(ab, "mark=%#x", skb->mark ?: -1);
> 
> ... which I believe to be incorrect.  I was trying to lead Richard
> along to that same realization, but it would appear I'm not having
> much success, so to put it bluntly, here is what I want that line to
> look like:
> 
>   audit_log_format(ab, "mark=%#x", skb->mark);

Then just say that.  Given the arguments presented, I agree.  Done.

> paul moore

- RGB

--
Richard Guy Briggs <rgb@redhat.com>
Kernel Security Engineering, Base Operating Systems, Red Hat
Remote, Ottawa, Canada
Voice: +1.647.777.2635, Internal: (81) 32635
