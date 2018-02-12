From: Florian Westphal <fw@strlen.de>
Subject: Re: general protection fault in ipt_do_table
Date: Mon, 12 Feb 2018 17:20:13 +0100
Message-ID: <20180212162013.GA27605@breakpoint.cc>
References: <f403043ccfb8093db9056506338e@google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netdev@vger.kernel.org, netfilter-devel@vger.kernel.org,
        pablo@netfilter.org, syzkaller-bugs@googlegroups.com
To: syzbot <syzbot+c914fd8c6a751c4fddbd@syzkaller.appspotmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([146.0.238.67]:33058 "EHLO
        Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S964875AbeBLQX0 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 12 Feb 2018 11:23:26 -0500
Content-Disposition: inline
In-Reply-To: <f403043ccfb8093db9056506338e@google.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

syzbot <syzbot+c914fd8c6a751c4fddbd@syzkaller.appspotmail.com> wrote:
> Hello,
> 
> syzbot hit the following crash on net-next commit
> 9a61df9e5f7471fe5be3e02bd0bed726b2761a54 (Sat Feb 10 03:32:41 2018 +0000)
> Merge tag 'kbuild-v4.16-2' of
> git://git.kernel.org/pub/scm/linux/kernel/git/masahiroy/linux-kbuild
> 
> So far this crash happened 2 times on net-next, upstream.
> C reproducer is attached.
> syzkaller reproducer is attached.
> Raw console output is attached.
> compiler: gcc (GCC) 7.1.1 20170620
> .config is attached.

#sys-dup: general protection fault in ip6t_do_table

(well, its not strictly a duplicate but ip(6)tables is copypastry
 sauce so its bug compatible, the fix I sent for ip6tables report
 also fixes ip and arptables.)
