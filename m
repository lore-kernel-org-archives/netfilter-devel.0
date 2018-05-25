From: Vlad Buslov <vladbu@mellanox.com>
Subject: Re: [PATCH 00/14] Modify action API for implementing lockless actions
Date: Fri, 25 May 2018 23:39:10 +0300
Message-ID: <vbfo9h3zd01.fsf@reg-r-vrt-018-180.mtr.labs.mlnx>
References: <1526308035-12484-1-git-send-email-vladbu@mellanox.com> <CAM_iQpXMbtUWsaGBrpJH08dM4p9oVwpMSGrev1PThbP5d23sdA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain
Cc: Linux Kernel Network Developers <netdev@vger.kernel.org>,
        David Miller <davem@davemloft.net>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Jiri Pirko <jiri@resnulli.us>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>,
        Florian Westphal <fw@strlen.de>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Eric Dumazet <edumazet@google.com>,
        Kees Cook <keescook@chromium.org>,
        LKML <linux-kernel@vger.kernel.org>,
        NetFilter <netfilter-devel@vger.kernel.org>,
        coreteam@netfilter.org, kliteyn@mellanox.com
To: Cong Wang <xiyou.wangcong@gmail.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-reply-to: <CAM_iQpXMbtUWsaGBrpJH08dM4p9oVwpMSGrev1PThbP5d23sdA@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org


On Thu 24 May 2018 at 23:34, Cong Wang <xiyou.wangcong@gmail.com> wrote:
> On Mon, May 14, 2018 at 7:27 AM, Vlad Buslov <vladbu@mellanox.com> wrote:
>> Currently, all netlink protocol handlers for updating rules, actions and
>> qdiscs are protected with single global rtnl lock which removes any
>> possibility for parallelism. This patch set is a first step to remove
>> rtnl lock dependency from TC rules update path. It updates act API to
>> use atomic operations, rcu and spinlocks for fine-grained locking. It
>> also extend API with functions that are needed to update existing
>> actions for parallel execution.
>
> Can you give a summary here for what and how it is achieved?

Got it, will expand cover letter in V2 with summary.
>
> You said this is the first step, what do you want to achieve in this
> very first step? And how do you achieve it? Do you break the RTNL

But aren't this questions answered in paragraph you quoted?
What: Change act API to not rely on one-big-global-RTNL-lock and to use
more fine-grained synchronization methods to allow safe concurrent
execution.
How: Refactor act API code to use atomics, rcu and spinlocks, etc. for
protecting shared data structures, add new functions required to update
specific actions implementation for parallel execution. (step 2)

If you feel that this cover letter is too terse, I will add outline of
changes in V2.

> lock down to, for a quick example, a per-device lock? Or perhaps you
> completely remove it because of what reason?

I want to remove RTNL _dependency_ from act API data structures and
code. I probably should me more specific in this case:

Florian recently made a change that allows registering netlink protocol
handlers with flag RTNL_FLAG_DOIT_UNLOCKED. Handlers registered with
this flag are called without RTNL taken. My end goal is to have rule
update handlers(RTM_NEWTFILTER, RTM_DELTFILTER, etc.) to be registered
with UNLOCKED flag to allow parallel execution.

I do not intend to globally remove or break RTNL.

>
> I go through all the descriptions of your 14 patches (but not any code),
> I still have no clue how you successfully avoid RTNL. Please don't
> let me read into your code to understand that, there must be some
> high-level justification on how it works. Without it, I don't event want
> to read into the code.

On internal code review I've been asked not to duplicate info from
commit messages in cover letter, but I guess I can expand it with some
high level outline in V2.

>
> Thanks.

Thank you for your feedback!
