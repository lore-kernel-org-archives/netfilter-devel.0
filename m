From: Joseph Conley <joseph.j.conley@gmail.com>
Subject: Re: [PATCH] netfilter: conntrack: Fix ifdef checks for CONFIG_NF_CONNTRACK_MARK
Date: Mon, 19 Dec 2016 10:40:50 -0500
Message-ID: <CAGCFG8vM+6zpCbH_HxLvx2JfdVyF-bdr2Owk-kwbnw0vKoNwuw@mail.gmail.com>
References: <1481751357-22893-1-git-send-email-joseph.j.conley@gmail.com> <20161215205537.GA4830@salvia>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: netfilter-devel@vger.kernel.org,
        Joe Conley <joe.conley@lairdtech.com>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-qk0-f196.google.com ([209.85.220.196]:35350 "EHLO
        mail-qk0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751652AbcLSPkw (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 19 Dec 2016 10:40:52 -0500
Received: by mail-qk0-f196.google.com with SMTP id u25so214420qki.2
        for <netfilter-devel@vger.kernel.org>; Mon, 19 Dec 2016 07:40:52 -0800 (PST)
In-Reply-To: <20161215205537.GA4830@salvia>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Thu, Dec 15, 2016 at 3:55 PM, Pablo Neira Ayuso <pablo@netfilter.org> wrote:
>
> On Wed, Dec 14, 2016 at 04:35:57PM -0500, joseph.j.conley@gmail.com wrote:
> > From: Joe Conley <joe.conley@lairdtech.com>
> >
> > Two missing ifdef checks for CONFIG_NF_CONNTRACK_MARK were causing
> > EOPNOTSUPP to be returned. Every single place that cda[CTA_MARK] or cda[CTA_MARK_MASK]
> > was checked was inside a #ifdef for CONFIG_NF_CONNTRACK_MARK except for these
> > two places. The reason for this change stems from this commit:
> > 866476f323465a8afef10b14b48d5136bf5c51fe (netfilter: conntrack: Flush connections with a given mark)
> >
> > This allows conntrack -L to be ran succesfully when CONFIG_NF_CONNTRACK_MARK
> > is not enabled.
>
> I would like to understand how you're triggering this problem. If it
> is a plain 'conntrack -L' command line invocation that triggers the
> problem, then it's probably a userspace problem since we should not
> send any mark attribute to the kernel if not set.

Building the kernel with CONFIG_NF_CONNTRACK_MARK disabled will cause
conntrack -L to return EOPNOTSUPP because of the missing ifdef checks.
Building the kernel with it enabled allows conntrack -L to run
successfully. At first, I thought this was a userspace bug as well but
it is not. Every single place CTA_MARK or CTA_MARK_MASK is used is
inside an ifdef check for CONFIG_NF_CONNTRACK_MARK except for these
two places. There is no clear reason as to why. There is no reason
that conntrack -L should return EOPNOTSUPP when
CONFIG_NF_CONNTRACK_MARK is disabled.
