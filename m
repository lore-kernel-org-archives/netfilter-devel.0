From: Florian Westphal <fw@strlen.de>
Subject: Re: WARNING: proc registration bug in clusterip_tg_check
Date: Wed, 7 Feb 2018 12:31:18 +0100
Message-ID: <20180207113118.GD14261@breakpoint.cc>
References: <089e082d13a0cf25ed05648bf8b3@google.com>
 <945c8517a87c671825b61223088064ea2ad0a8cb.1517999262.git.pabeni@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        netfilter-devel@vger.kernel.org, syzkaller-bugs@googlegroups.com,
        Cong Wang <xiyou.wangcong@gmail.com>
To: Paolo Abeni <pabeni@redhat.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <945c8517a87c671825b61223088064ea2ad0a8cb.1517999262.git.pabeni@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

Paolo Abeni <pabeni@redhat.com> wrote:

[ pruning CC list ]

> #syz test: git://git.kernel.org/pub/scm/linux/kernel/git/davem/net.git master
> 
> I can't reproduce the issue locally, so asking the syzbot to test the 
> tentive fix for me (and hoping I did not mess with the tag/format) 

I can reproduce it.

CLUSTERIP has multiple other bugs that need to be fixed, I'll look into
this asap.
