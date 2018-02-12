From: Dmitry Vyukov <dvyukov@google.com>
Subject: Re: general protection fault in ipt_do_table
Date: Mon, 12 Feb 2018 17:31:23 +0100
Message-ID: <CACT4Y+a18OmXX=V_mAOzqc3txT9C8piJWJa=rN7aWfRk0yfo0g@mail.gmail.com>
References: <f403043ccfb8093db9056506338e@google.com> <20180212162013.GA27605@breakpoint.cc>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Cc: syzbot <syzbot+c914fd8c6a751c4fddbd@syzkaller.appspotmail.com>,
        netdev <netdev@vger.kernel.org>, netfilter-devel@vger.kernel.org,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        syzkaller-bugs@googlegroups.com
To: Florian Westphal <fw@strlen.de>
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20180212162013.GA27605@breakpoint.cc>
Sender: netdev-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

On Mon, Feb 12, 2018 at 5:20 PM, Florian Westphal <fw@strlen.de> wrote:
> syzbot <syzbot+c914fd8c6a751c4fddbd@syzkaller.appspotmail.com> wrote:
>> Hello,
>>
>> syzbot hit the following crash on net-next commit
>> 9a61df9e5f7471fe5be3e02bd0bed726b2761a54 (Sat Feb 10 03:32:41 2018 +0000)
>> Merge tag 'kbuild-v4.16-2' of
>> git://git.kernel.org/pub/scm/linux/kernel/git/masahiroy/linux-kbuild
>>
>> So far this crash happened 2 times on net-next, upstream.
>> C reproducer is attached.
>> syzkaller reproducer is attached.
>> Raw console output is attached.
>> compiler: gcc (GCC) 7.1.1 20170620
>> .config is attached.
>
> #sys-dup: general protection fault in ip6t_do_table

this should read as:

#syz dup: general protection fault in ip6t_do_table

> (well, its not strictly a duplicate but ip(6)tables is copypastry
>  sauce so its bug compatible, the fix I sent for ip6tables report
>  also fixes ip and arptables.)
