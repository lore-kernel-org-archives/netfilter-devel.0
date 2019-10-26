Return-Path: <SRS0=4S6R=YT=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2DC76CA9EB9
	for <netfilter-devel@archiver.kernel.org>; Sat, 26 Oct 2019 18:27:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0BE5F20867
	for <netfilter-devel@archiver.kernel.org>; Sat, 26 Oct 2019 18:27:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726460AbfJZS1k (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sat, 26 Oct 2019 14:27:40 -0400
Received: from Chamillionaire.breakpoint.cc ([193.142.43.52]:46608 "EHLO
        Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726404AbfJZS1k (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sat, 26 Oct 2019 14:27:40 -0400
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@strlen.de>)
        id 1iOQmp-00032l-5C; Sat, 26 Oct 2019 20:27:39 +0200
Date:   Sat, 26 Oct 2019 20:27:39 +0200
From:   Florian Westphal <fw@strlen.de>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     Florian Westphal <fw@strlen.de>, netfilter-devel@vger.kernel.org,
        syzkaller-bugs@googlegroups.com,
        syzbot+c7aabc9fe93e7f3637ba@syzkaller.appspotmail.com
Subject: Re: [PATCH nf-next] netfilter: ecache: don't look for ecache
 extension on dying/unconfirmed conntracks
Message-ID: <20191026182739.GA3321@breakpoint.cc>
References: <20191022165642.29698-1-fw@strlen.de>
 <20191026103607.urwwmxpwrxdcwijm@salvia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191026103607.urwwmxpwrxdcwijm@salvia>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> >  I plan to send a patch for nf tree to alter nf_conntrack_confirm()
> >  to not cache the ct -- I think its a bug too, we should call
> >  nf_ct_deliver_cached_events() on the ct that is assigned to skb *now*,
> >  not the old one.
> 
> This is the clash resolution that is triggering this path you describe
> in this note.

Yes, its the clash resolution.
