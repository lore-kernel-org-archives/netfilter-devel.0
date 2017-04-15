From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH nf V2] netfilter: nf_ct_helper: permit cthelpers with
 different names via nfnetlink
Date: Sat, 15 Apr 2017 11:28:20 +0200
Message-ID: <20170415092820.GA5125@salvia>
References: <1490792404-6035-1-git-send-email-zlpnobody@163.com>
 <CAML_gOdMiDPy==pvW5D5MrJZ1UfnpAzK172R4QbehnSkmHZP0w@mail.gmail.com>
 <20170413222914.GA5089@salvia>
 <CAML_gOdLUzEteQC1UEw8N9FEnudWHfM3K-hv7hy5xKwehRWNCA@mail.gmail.com>
 <20170413235702.GA10583@salvia>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Liping Zhang <zlpnobody@163.com>,
        Netfilter Developer Mailing List
        <netfilter-devel@vger.kernel.org>
To: Liping Zhang <zlpnobody@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:36272 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751893AbdDOJ2d (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Sat, 15 Apr 2017 05:28:33 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 1090AE04B9
        for <netfilter-devel@vger.kernel.org>; Sat, 15 Apr 2017 11:28:28 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 002C8DA7E9
        for <netfilter-devel@vger.kernel.org>; Sat, 15 Apr 2017 11:28:28 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id B05A4DA804
        for <netfilter-devel@vger.kernel.org>; Sat, 15 Apr 2017 11:28:24 +0200 (CEST)
Content-Disposition: inline
In-Reply-To: <20170413235702.GA10583@salvia>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Fri, Apr 14, 2017 at 01:57:02AM +0200, Pablo Neira Ayuso wrote:
> On Fri, Apr 14, 2017 at 07:50:26AM +0800, Liping Zhang wrote:
> > Hi Pablo,
> > 
> > 2017-04-14 6:29 GMT+08:00 Pablo Neira Ayuso <pablo@netfilter.org>:
> > [...]
> > >> After I have a closer look, inside hlist_for_each_entry_rcu, we use the
> > >> rcu_dereference_raw() to get the pointer, and this will not generate warning:
> > >>
> > >> #define hlist_for_each_entry_rcu(pos, head, member) \
> > >>     for (pos = hlist_entry_safe (rcu_dereference_raw(hlist_first_rcu(head)),\
> > >>                          typeof(*(pos)), member);
> > >>    ....
> > >>
> > >> Then "This is likely going to spot false positives with the RCU
> > >> debugging instrumentation"
> > >> will not happen.
> > >
> > > Right, instrumentation will not trigger any problem.
> > >
> > > But even if instrumention is not a problem, I just would like to avoid
> > > people sending me "obvious" fixes afterwards, by removing _rcu since
> > > they see this code runs under mutex or how knows what.
> > 
> > I'm a little confusing about this one.
> > 
> > I found "http://patchwork.ozlabs.org/patch/744786/" and
> > "http://patchwork.ozlabs.org/patch/743472/" were both set
> > to "Changes Requested".
> > 
> > So which one is you prefer to :)? What's next step should I do?
> 
> The latter, please resubmit bumping your version number and log.
> 
> That makes things easier for me than going back and forth trying to
> figure out what I should do, thanks!

Hm, this patch requires no changes actually. Now I understand why
you're confused there.

So let me know if you I should just take this or wait for you to
resubmit.

In case of doubt, resubmitting is just fine. Thanks!
