Return-Path: <SRS0=IqR4=4O=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 83806C4BA20
	for <netfilter-devel@archiver.kernel.org>; Wed, 26 Feb 2020 18:11:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6580F21556
	for <netfilter-devel@archiver.kernel.org>; Wed, 26 Feb 2020 18:11:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726995AbgBZSLM (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 26 Feb 2020 13:11:12 -0500
Received: from correo.us.es ([193.147.175.20]:34414 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726907AbgBZSLL (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 26 Feb 2020 13:11:11 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 9CCA6EB90F
        for <netfilter-devel@vger.kernel.org>; Wed, 26 Feb 2020 19:11:01 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 8ECEADA3C4
        for <netfilter-devel@vger.kernel.org>; Wed, 26 Feb 2020 19:11:01 +0100 (CET)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 8325DDA801; Wed, 26 Feb 2020 19:11:01 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 8BD7ADA736;
        Wed, 26 Feb 2020 19:10:59 +0100 (CET)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Wed, 26 Feb 2020 19:10:59 +0100 (CET)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from us.es (unknown [90.77.255.23])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: 1984lsi)
        by entrada.int (Postfix) with ESMTPSA id 6E0EC42EF42B;
        Wed, 26 Feb 2020 19:10:59 +0100 (CET)
Date:   Wed, 26 Feb 2020 19:11:06 +0100
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Cong Wang <xiyou.wangcong@gmail.com>
Cc:     Linux Kernel Network Developers <netdev@vger.kernel.org>,
        Florian Westphal <fw@strlen.de>,
        NetFilter <netfilter-devel@vger.kernel.org>,
        syzbot <syzbot+d195fd3b9a364ddd6731@syzkaller.appspotmail.com>
Subject: Re: [Patch nf] netfilter: xt_hashlimit: unregister proc file before
 releasing mutex
Message-ID: <20200226181106.ekb2mpmtgbxrpepz@salvia>
References: <20200213065352.6310-1-xiyou.wangcong@gmail.com>
 <20200218213524.5yuccwnl2eie6p6x@salvia>
 <CAM_iQpWfb7xgd2LuRmaXhRSJskJPsupFk0A7=dRXtMEjZJjr3w@mail.gmail.com>
 <20200218220507.cqlhd4kj4ukyjhuu@salvia>
 <CAM_iQpUYGVpUCatMHVKSx4jM9c6kbYxcWBV0--1mrQi6NbPhhg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAM_iQpUYGVpUCatMHVKSx4jM9c6kbYxcWBV0--1mrQi6NbPhhg@mail.gmail.com>
User-Agent: NeoMutt/20170113 (1.7.2)
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Wed, Feb 19, 2020 at 07:32:13PM -0800, Cong Wang wrote:
> On Tue, Feb 18, 2020 at 2:05 PM Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> >
> > On Tue, Feb 18, 2020 at 01:40:26PM -0800, Cong Wang wrote:
> > > On Tue, Feb 18, 2020 at 1:35 PM Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> > > >
> > > > On Wed, Feb 12, 2020 at 10:53:52PM -0800, Cong Wang wrote:
> > > > > Before releasing the global mutex, we only unlink the hashtable
> > > > > from the hash list, its proc file is still not unregistered at
> > > > > this point. So syzbot could trigger a race condition where a
> > > > > parallel htable_create() could register the same file immediately
> > > > > after the mutex is released.
> > > > >
> > > > > Move htable_remove_proc_entry() back to mutex protection to
> > > > > fix this. And, fold htable_destroy() into htable_put() to make
> > > > > the code slightly easier to understand.
> > > >
> > > > Probably revert previous one?
> > >
> > > The hung task could appear again if we move the cleanup
> > > back under mutex.
> >
> > How could the hung task appear again by reverting
> > c4a3922d2d20c710f827? Please elaborate.
> 
> Because the cfg.max could be as large as 8*HASHLIMIT_MAX_SIZE:
> 
>  311         if (hinfo->cfg.max == 0)
>  312                 hinfo->cfg.max = 8 * hinfo->cfg.size;
>  313         else if (hinfo->cfg.max < hinfo->cfg.size)
>  314                 hinfo->cfg.max = hinfo->cfg.size;
> 
> Not sure whether we can finish cleaning up 8*HASHLIMIT_MAX_SIZE
> entries within the time a hung task tolerates. This largely depends on
> how much contention the spinlock has, at least I don't want to bet
> on it.

Please, resend. Thanks.
