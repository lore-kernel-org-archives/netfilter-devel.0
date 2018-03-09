From: Florian Westphal <fw@strlen.de>
Subject: Re: WARNING in __proc_create
Date: Sat, 10 Mar 2018 00:18:59 +0100
Message-ID: <20180309231859.GA11882@breakpoint.cc>
References: <001a113f2be668a1e9056701e617@google.com>
 <CAM_iQpV+PnGUXEKcSrF7u19NOeLLp0PhDW-DOkEfS+8pLnTgYw@mail.gmail.com>
 <a559bbb6-0db4-2b71-b363-792d88d7eef7@gmail.com>
 <c4b2dca8-f2b9-c187-9ee5-e7c4816848f5@gmail.com>
 <CAM_iQpXLQtaBRBPmcGzUTUhNHiomos4eAvXy7kyrY+uAzpNt3g@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Eric Dumazet <eric.dumazet@gmail.com>,
        syzbot <syzbot+0502b00edac2a0680b61@syzkaller.appspotmail.com>,
        coreteam@netfilter.org, David Miller <davem@davemloft.net>,
        Florian Westphal <fw@strlen.de>,
        Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>,
        LKML <linux-kernel@vger.kernel.org>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>,
        netfilter-devel@vger.kernel.org,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        syzkaller-bugs@googlegroups.com
To: Cong Wang <xiyou.wangcong@gmail.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CAM_iQpXLQtaBRBPmcGzUTUhNHiomos4eAvXy7kyrY+uAzpNt3g@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

Cong Wang <xiyou.wangcong@gmail.com> wrote:
> On Fri, Mar 9, 2018 at 2:58 PM, Eric Dumazet <eric.dumazet@gmail.com> wrote:
> >
> >
> > On 03/09/2018 02:56 PM, Eric Dumazet wrote:
> >
> >>
> >> I sent a patch a while back, but Pablo/Florian wanted more than that
> >> simple fix.
> >>
> >> We also need to filter special characters like '/'
> 
> proc_create_data() itself accepts '/', so it must be xt_hashlimit doesn't
> want it.

--hashimit-name / also triggers WARN for me.
. or .. "work", (no crash), but cause appearance of 2nd ./.. in
/proc/net/ipt_hashlimit , so I think its better to disallow that too.
