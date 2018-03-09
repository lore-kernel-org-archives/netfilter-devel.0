From: Cong Wang <xiyou.wangcong@gmail.com>
Subject: Re: WARNING in __proc_create
Date: Fri, 9 Mar 2018 14:48:13 -0800
Message-ID: <CAM_iQpV+PnGUXEKcSrF7u19NOeLLp0PhDW-DOkEfS+8pLnTgYw@mail.gmail.com>
References: <001a113f2be668a1e9056701e617@google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Cc: coreteam@netfilter.org, David Miller <davem@davemloft.net>,
        Florian Westphal <fw@strlen.de>,
        Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>,
        LKML <linux-kernel@vger.kernel.org>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>,
        netfilter-devel@vger.kernel.org,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        syzkaller-bugs@googlegroups.com
To: syzbot <syzbot+0502b00edac2a0680b61@syzkaller.appspotmail.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <001a113f2be668a1e9056701e617@google.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

On Fri, Mar 9, 2018 at 1:59 PM, syzbot
<syzbot+0502b00edac2a0680b61@syzkaller.appspotmail.com> wrote:
> Hello,
>
> syzbot hit the following crash on net-next commit
> 617aebe6a97efa539cc4b8a52adccd89596e6be0 (Sun Feb 4 00:25:42 2018 +0000)
> Merge tag 'usercopy-v4.16-rc1' of
> git://git.kernel.org/pub/scm/linux/kernel/git/kees/linux
>
> So far this crash happened 12 times on net-next, upstream.
> C reproducer is attached.
> syzkaller reproducer is attached.
> Raw console output is attached.
> compiler: gcc (GCC) 7.1.1 20170620
> .config is attached.
>
> IMPORTANT: if you fix the bug, please add the following tag to the commit:
> Reported-by: syzbot+0502b00edac2a0680b61@syzkaller.appspotmail.com
> It will help syzbot understand when the bug is fixed. See footer for
> details.
> If you forward the report, please keep this part and the footer.
>
> audit: type=1400 audit(1518223777.419:7): avc:  denied  { map } for
> pid=4159 comm="syzkaller598581" path="/root/syzkaller598581546" dev="sda1"
> ino=16481 scontext=unconfined_u:system_r:insmod_t:s0-s0:c0.c1023
> tcontext=unconfined_u:object_r:user_home_t:s0 tclass=file permissive=1
> ------------[ cut here ]------------
> name len 0
> WARNING: CPU: 0 PID: 4159 at fs/proc/generic.c:354 __proc_create+0x696/0x880
> fs/proc/generic.c:354

We need to reject empty names.
