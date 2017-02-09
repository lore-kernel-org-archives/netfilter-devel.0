From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: AUDIT_NETFILTER_PKT message format
Date: Thu, 9 Feb 2017 11:56:17 +0100
Message-ID: <20170209105617.GA2089@salvia>
References: <20170117052551.GQ3087@madcap2.tricolour.ca>
 <20170207205219.GA5864@madcap2.tricolour.ca>
 <CAGH-KguuAriVuLEE+mb2HwQLcq6ePeDfVyZ=acoxmomnK5R09w@mail.gmail.com>
 <5128842.c7Bb9yu5kt@x2>
 <CAHC9VhTG-ByCf5v0tmXmVJBhCer3-3AvMUJP45UPTNF_Xik3JA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Steve Grubb <sgrubb@redhat.com>, Paul Moore <pmoore@redhat.com>,
        Richard Guy Briggs <rgb@redhat.com>,
        Linux-Audit Mailing List <linux-audit@redhat.com>,
        Netfilter Developer Mailing List
        <netfilter-devel@vger.kernel.org>,
        Thomas Graf <tgraf@infradead.org>
To: Paul Moore <paul@paul-moore.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:44418 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752144AbdBIK5M (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 9 Feb 2017 05:57:12 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 9630911A1CA
        for <netfilter-devel@vger.kernel.org>; Thu,  9 Feb 2017 11:56:28 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 85CB5DA862
        for <netfilter-devel@vger.kernel.org>; Thu,  9 Feb 2017 11:56:28 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 57AB8DA854
        for <netfilter-devel@vger.kernel.org>; Thu,  9 Feb 2017 11:56:26 +0100 (CET)
Content-Disposition: inline
In-Reply-To: <CAHC9VhTG-ByCf5v0tmXmVJBhCer3-3AvMUJP45UPTNF_Xik3JA@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi Paul,

On Wed, Feb 08, 2017 at 06:09:07PM -0500, Paul Moore wrote:
> On Wed, Feb 8, 2017 at 11:30 AM, Steve Grubb <sgrubb@redhat.com> wrote:
> > On Tuesday, February 7, 2017 10:56:39 PM EST Paul Moore wrote:
> >> On Tue, Feb 7, 2017 at 3:52 PM, Richard Guy Briggs <rgb@redhat.com> wrote:
> >> > So while I'm not advocating this is what should be done and I'm trying
> >> > to establish bounds to the scope of this feature, but would it be
> >> > reasonable to simply not log packets that were transiting this machine
> >> > without a local endpoint?
> >>
> >> I'm still waiting on more detailed requirements information from
> >> Steve, but based on what we've heard so far, it seems that ignoring
> >> forwarded traffic is a reasonable thing to do.
> >
> > OK, I have done teh analysis to see where things stand on this ...
> 
> ...
> 
> > At this point, I would say there is no purpose for xt_AUDIT.c based on Common
> > Criteria. It looks like its built in response to the
> > CONFIG_NETFILTER_XT_TARGET_AUDIT config option. So, it can be cleanly
> > deprecated.
> 
> Based on some off-list discussions with Richard it would appear that
> there are several users of the NETFILTER_PKT record so I am in no
> hurry to deprecate it.  Considering that there are no CC requirements
> on the record, I think we can focus on simply providing a basic record
> that satisfies the whims of the userspace tools without adding any
> pain to the kernel.  I believe Richard is currently working on a
> proposal to do that, let's discuss it further in that thread.

If the concern is to keep the existing output format around, you can
add new functions with the specific new layout at the cost of keeping
more code around. That should be fine since this code is not much
complex IMO. You can probably add a new explicit command line option,
eg. --version, that indicates what audit format version you want to
use, so users don't break.

BTW, any plans to add audit support to nf_tables?

Thanks.
