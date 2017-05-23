From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH nf] netfilter: ctnetlink: fix incorrect nf_ct_put during
 hash resize
Date: Tue, 23 May 2017 23:34:27 +0200
Message-ID: <20170523213427.GA9071@salvia>
References: <1495322569-63361-1-git-send-email-zlpnobody@163.com>
 <20170521000047.GA1004@breakpoint.cc>
 <CAML_gOdnZkbCp8JnVpd8bbeTQuhK7hMtQio4iuLQe137HxE_+g@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Florian Westphal <fw@strlen.de>, Liping Zhang <zlpnobody@163.com>,
        Netfilter Developer Mailing List
        <netfilter-devel@vger.kernel.org>
To: Liping Zhang <zlpnobody@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:42878 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1031569AbdEWVer (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 23 May 2017 17:34:47 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 19A65E1229
        for <netfilter-devel@vger.kernel.org>; Tue, 23 May 2017 23:34:39 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 08EC7FF2F9
        for <netfilter-devel@vger.kernel.org>; Tue, 23 May 2017 23:34:39 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id E1E8BFF2C8
        for <netfilter-devel@vger.kernel.org>; Tue, 23 May 2017 23:34:36 +0200 (CEST)
Content-Disposition: inline
In-Reply-To: <CAML_gOdnZkbCp8JnVpd8bbeTQuhK7hMtQio4iuLQe137HxE_+g@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Sun, May 21, 2017 at 08:59:45AM +0800, Liping Zhang wrote:
> Hi Florian,
> 
> 2017-05-21 8:00 GMT+08:00 Florian Westphal <fw@strlen.de>:
> [...]
> > Yes, you're right, seems this was added in
> > 93bb0ceb75be2fdfa9fc0dd1fb522d9ada515d9c (it adds the 'goto out').
> 
> I added some trace logs, and when the hash size reduced, for example,
> from 60000 to 500, then the issue would happen.
> 
> Actually, hitting 'goto out' is not easy, so the issue exists for a very long
> time. Maybe commit 89f2e21883b5("[NETFILTER]: ctnetlink: change
> table dumping not to require an unique ID") is to blame for it.
> 
> > Your patch looks correct.
> >
> > However, why do we bump refcnt of 'last' in the first place?
> >
> > Its only the continuation marker, i.e. its expected to reside
> > in the hash slot at cb->args[0], but after rehash this might not
> > be true either.
> >
> > I think we should simplify this, just take the verbatim address,
> > and clear it right at start of ctnetlink_dump_table, i.e.
> >
> > unsigned long last = cb->args[1];
> > cb->args[1] = 0;
> >
> > for (; cb->args[0] < nf_conntrack_htable_size; cb->args[0]++) {
> >          ...
> >     hlist_nulls_for_each_entry ... {
> >        ...
> >        if (last) {
> >             if (last != (unsigned long)ct))
> >                cont;
> >             last = 0;
> >        }
> >        ...
> >        dump();
> >     }
> >     last = 0; /* reset it, as it wasn't in args[0] slot */
> >  }
> >
> > Do you see any problem with that?
> 
> I think this will be better, this will make code more clean.
> Also we can clean up the ctnetlink_exp_ct_dump_table too.

@Florian, no objection then if I place this into nf.git?

I will append the Fixes: tag:

Fixes: 89f2e21883b5 ("[NETFILTER]: ctnetlink: change table dumping not to require an unique ID")
