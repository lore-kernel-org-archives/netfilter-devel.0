From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH] netfilter: conntrack: Fix ifdef checks for
 CONFIG_NF_CONNTRACK_MARK
Date: Fri, 23 Dec 2016 15:55:34 +0100
Message-ID: <20161223145534.GA14038@salvia>
References: <1481751357-22893-1-git-send-email-joseph.j.conley@gmail.com>
 <20161215205537.GA4830@salvia>
 <CAGCFG8vM+6zpCbH_HxLvx2JfdVyF-bdr2Owk-kwbnw0vKoNwuw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org,
        Joe Conley <joe.conley@lairdtech.com>
To: Joseph Conley <joseph.j.conley@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:49426 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1760222AbcLWOzj (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 23 Dec 2016 09:55:39 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 0FA553066A2
        for <netfilter-devel@vger.kernel.org>; Fri, 23 Dec 2016 15:55:38 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id F30CC1B3083
        for <netfilter-devel@vger.kernel.org>; Fri, 23 Dec 2016 15:55:37 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id AC7F41B3085
        for <netfilter-devel@vger.kernel.org>; Fri, 23 Dec 2016 15:55:35 +0100 (CET)
Content-Disposition: inline
In-Reply-To: <CAGCFG8vM+6zpCbH_HxLvx2JfdVyF-bdr2Owk-kwbnw0vKoNwuw@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Mon, Dec 19, 2016 at 10:40:50AM -0500, Joseph Conley wrote:
> On Thu, Dec 15, 2016 at 3:55 PM, Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> >
> > On Wed, Dec 14, 2016 at 04:35:57PM -0500, joseph.j.conley@gmail.com wrote:
> > > From: Joe Conley <joe.conley@lairdtech.com>
> > >
> > > Two missing ifdef checks for CONFIG_NF_CONNTRACK_MARK were causing
> > > EOPNOTSUPP to be returned. Every single place that cda[CTA_MARK] or cda[CTA_MARK_MASK]
> > > was checked was inside a #ifdef for CONFIG_NF_CONNTRACK_MARK except for these
> > > two places. The reason for this change stems from this commit:
> > > 866476f323465a8afef10b14b48d5136bf5c51fe (netfilter: conntrack: Flush connections with a given mark)
> > >
> > > This allows conntrack -L to be ran succesfully when CONFIG_NF_CONNTRACK_MARK
> > > is not enabled.
> >
> > I would like to understand how you're triggering this problem. If it
> > is a plain 'conntrack -L' command line invocation that triggers the
> > problem, then it's probably a userspace problem since we should not
> > send any mark attribute to the kernel if not set.
> 
> Building the kernel with CONFIG_NF_CONNTRACK_MARK disabled will cause
> conntrack -L to return EOPNOTSUPP because of the missing ifdef checks.
> Building the kernel with it enabled allows conntrack -L to run
> successfully. At first, I thought this was a userspace bug as well but
> it is not. Every single place CTA_MARK or CTA_MARK_MASK is used is
> inside an ifdef check for CONFIG_NF_CONNTRACK_MARK except for these
> two places. There is no clear reason as to why. There is no reason
> that conntrack -L should return EOPNOTSUPP when
> CONFIG_NF_CONNTRACK_MARK is disabled.

I think this a userspace bug, since we shouldn't send mark filter if
not set by the user.

Kernel rejects with EOPNOTSUPP to indicate userspace that the mark
filtering that requests is not supported. This check is good so user
knows that this mark-based filtering doesn't work.

Just sent a patch for userspace, thanks a lot for reporting.
