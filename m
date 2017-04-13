From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH nf-next v2 1/1] netfilter: SYNPROXY: Return NF_STOLEN
 instead of NF_DROP during handshaking
Date: Fri, 14 Apr 2017 01:11:35 +0200
Message-ID: <20170413231135.GA7158@salvia>
References: <1491963290-84377-1-git-send-email-gfree.wind@foxmail.com>
 <20170413215749.GA4208@salvia>
 <001201d2b4aa$57bc8ba0$0735a2e0$@foxmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Gao Feng <gfree.wind@foxmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:54974 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752070AbdDMXLn (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 13 Apr 2017 19:11:43 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id E5227C108D
        for <netfilter-devel@vger.kernel.org>; Fri, 14 Apr 2017 01:11:38 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 2DDB5DA804
        for <netfilter-devel@vger.kernel.org>; Fri, 14 Apr 2017 01:11:44 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 03307DA725
        for <netfilter-devel@vger.kernel.org>; Fri, 14 Apr 2017 01:11:42 +0200 (CEST)
Content-Disposition: inline
In-Reply-To: <001201d2b4aa$57bc8ba0$0735a2e0$@foxmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Fri, Apr 14, 2017 at 07:04:44AM +0800, Gao Feng wrote:
> > -----Original Message-----
> > From: Pablo Neira Ayuso [mailto:pablo@netfilter.org]
> > 
> > On Wed, Apr 12, 2017 at 10:14:50AM +0800, gfree.wind@foxmail.com wrote:
> > >
> > > Current SYNPROXY codes return NF_DROP during normal TCP handshaking,
> > > it is not friendly to caller. Because the nf_hook_slow would treat the
> > > NF_DROP as an error, and return -EPERM.
> > > As a result, it may cause the top caller think it meets one error.
> > >
> > > So use NF_STOLEN instead of NF_DROP now because there is no error
> > > happened indeed, and free the skb directly.
> > 
> > Is this really addressing a real problem? How did you reproduce it?
> 
> We defined the NF_DROP and NF_STOLEN, I think we should use them clearly.
> When NF_DROP happens, it means one error happened.

That's a valid concern. How did you tested this change?

[...]
> Sorry, I always use one command "git format-patch -s -n master..XX"
> according to one document
> whose title is "HOWTO: Create and submit your first Linux kernel patch using
> GIT".
> 
> It generate the "1/1" by default.

There are ways to avoid that. Only you send 1/1 patches.

> I will try to lookup other documents about the patch rule, and correct the
> current command.

OK.

[...]
> More carefully, and don't rush more.

Thank you.
