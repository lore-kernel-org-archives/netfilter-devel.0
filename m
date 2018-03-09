From: Cong Wang <xiyou.wangcong@gmail.com>
Subject: Re: WARNING in __proc_create
Date: Fri, 9 Mar 2018 15:32:07 -0800
Message-ID: <CAM_iQpXPO_9=sj1DiMRfNmhZkUnCaoJtWw2O82g9AKSYjRFrZA@mail.gmail.com>
References: <001a113f2be668a1e9056701e617@google.com> <CAM_iQpV+PnGUXEKcSrF7u19NOeLLp0PhDW-DOkEfS+8pLnTgYw@mail.gmail.com>
 <a559bbb6-0db4-2b71-b363-792d88d7eef7@gmail.com> <c4b2dca8-f2b9-c187-9ee5-e7c4816848f5@gmail.com>
 <CAM_iQpXLQtaBRBPmcGzUTUhNHiomos4eAvXy7kyrY+uAzpNt3g@mail.gmail.com> <5d89ba78-64b4-9c9b-c9f3-c67094343c3f@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Cc: coreteam@netfilter.org, David Miller <davem@davemloft.net>,
        Florian Westphal <fw@strlen.de>,
        Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>,
        LKML <linux-kernel@vger.kernel.org>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>,
        netfilter-devel@vger.kernel.org,
        Pablo Neira Ayuso <pablo@netfilter.org>
To: Eric Dumazet <eric.dumazet@gmail.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <5d89ba78-64b4-9c9b-c9f3-c67094343c3f@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

On Fri, Mar 9, 2018 at 3:21 PM, Eric Dumazet <eric.dumazet@gmail.com> wrote:
>
>
> On 03/09/2018 03:05 PM, Cong Wang wrote:
>>
>>
>> BTW, the warning itself is all about empty names, so perhaps
>> it's better to fix them separately.
>
>
> Huh ? You want more syzbot reports ? I do not.

I always prefer one patch to fix one problem, and, as I already said,
checking "." and ".." is probably not as trivial as checking empty.

This why I believe 2 (or more) patches here are better than 1 single
patch.

BTW, I don't have any patch, it is so trivial that I don't want to spend
my time on it.

>
> I unblocked this report today [1], you can be sure that as soon
> as syzbot gets the correct tag (Reported-by: ...), it will find the other
> problems, which are currently on hold to avoid spam.
>
> [1] It has been sitting for a while here at Google, since January 28th.
>    At some point you have to ping Pablo/Florian again ;)

Sure, it can always find more problems... why just complain about
this one alone? ;)
