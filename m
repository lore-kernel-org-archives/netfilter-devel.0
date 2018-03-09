From: Eric Dumazet <eric.dumazet@gmail.com>
Subject: Re: WARNING in __proc_create
Date: Fri, 9 Mar 2018 14:58:43 -0800
Message-ID: <c4b2dca8-f2b9-c187-9ee5-e7c4816848f5@gmail.com>
References: <001a113f2be668a1e9056701e617@google.com>
 <CAM_iQpV+PnGUXEKcSrF7u19NOeLLp0PhDW-DOkEfS+8pLnTgYw@mail.gmail.com>
 <a559bbb6-0db4-2b71-b363-792d88d7eef7@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Cc: coreteam@netfilter.org, David Miller <davem@davemloft.net>,
        Florian Westphal <fw@strlen.de>,
        Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>,
        LKML <linux-kernel@vger.kernel.org>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>,
        netfilter-devel@vger.kernel.org,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        syzkaller-bugs@googlegroups.com
To: Cong Wang <xiyou.wangcong@gmail.com>,
        syzbot <syzbot+0502b00edac2a0680b61@syzkaller.appspotmail.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <a559bbb6-0db4-2b71-b363-792d88d7eef7@gmail.com>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org



On 03/09/2018 02:56 PM, Eric Dumazet wrote:

> 
> I sent a patch a while back, but Pablo/Florian wanted more than that 
> simple fix.
> 
> We also need to filter special characters like '/'
> 
> Or maybe I am mixing with something else.

Yes, Florian mentioned that we also had to reject "."  and ".."
