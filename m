Return-Path: <SRS0=kfn4=SQ=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_NEOMUTT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4BD63C10F13
	for <netfilter-devel@archiver.kernel.org>; Sun, 14 Apr 2019 22:33:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 203F82084D
	for <netfilter-devel@archiver.kernel.org>; Sun, 14 Apr 2019 22:33:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725807AbfDNWcz (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sun, 14 Apr 2019 18:32:55 -0400
Received: from Chamillionaire.breakpoint.cc ([146.0.238.67]:48410 "EHLO
        Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725772AbfDNWcz (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sun, 14 Apr 2019 18:32:55 -0400
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.89)
        (envelope-from <fw@strlen.de>)
        id 1hFnfw-0006Vz-SC; Mon, 15 Apr 2019 00:32:37 +0200
Date:   Mon, 15 Apr 2019 00:32:36 +0200
From:   Florian Westphal <fw@strlen.de>
To:     Andy Lutomirski <luto@amacapital.net>
Cc:     syzbot <syzbot+659574e7bcc7f7eb4df7@syzkaller.appspotmail.com>,
        alexl@redhat.com, bridge@lists.linux-foundation.org,
        coreteam@netfilter.org, cosimo@endlessm.com, davem@davemloft.net,
        dvyukov@google.com, fw@strlen.de, kadlec@blackhole.kfki.hu,
        libc-alpha@sourceware.org, linux-kernel@vger.kernel.org,
        luto@kernel.org, mingo@kernel.org, netdev@vger.kernel.org,
        netfilter-devel@vger.kernel.org, nicholson@endlessm.com,
        pablo@netfilter.org, peterz@infradead.org, raji@linux.vnet.ibm.com,
        stephen@networkplumber.org, syzkaller-bugs@googlegroups.com,
        tglx@linutronix.de, torvalds@linux-foundation.org,
        tuliom@linux.vnet.ibm.com
Subject: Re: WARNING in compat_copy_entries (2)
Message-ID: <20190414223236.amahulln6fw4hwaw@breakpoint.cc>
References: <00000000000019eb000586826c2a@google.com>
 <0E15851D-59E4-455D-985E-65F066E7A85A@amacapital.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <0E15851D-59E4-455D-985E-65F066E7A85A@amacapital.net>
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Andy Lutomirski <luto@amacapital.net> wrote:
> This is likely a confused bisection.  I bet that reverting this patch breaks your test but has nothing to do with the bug. Try reproducing with socketcall() to bisect farther.

No need, this WARN_ON can be removed. I'll send a patch.
