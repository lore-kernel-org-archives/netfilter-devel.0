From: Florian Westphal <fw@strlen.de>
Subject: Re: KASAN: slab-out-of-bounds Read in clusterip_tg_check
Date: Mon, 5 Feb 2018 14:26:23 +0100
Message-ID: <20180205132623.GA13879@breakpoint.cc>
References: <001a1143c56ee814890563d9de79@google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org, syzkaller-bugs@googlegroups.com
To: syzbot <syzbot+7afeeb8e62e4716de370@syzkaller.appspotmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([146.0.238.67]:59032 "EHLO
        Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1752510AbeBEN3Y (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 5 Feb 2018 08:29:24 -0500
Content-Disposition: inline
In-Reply-To: <001a1143c56ee814890563d9de79@google.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

syzbot <syzbot+7afeeb8e62e4716de370@syzkaller.appspotmail.com> wrote:

#syz-fix: netfilter: ipt_CLUSTERIP: fix out-of-bounds accesses in clusterip_tg_check()
