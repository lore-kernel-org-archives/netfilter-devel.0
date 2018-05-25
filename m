From: Cong Wang <xiyou.wangcong@gmail.com>
Subject: Re: [PATCH 00/14] Modify action API for implementing lockless actions
Date: Fri, 25 May 2018 14:40:24 -0700
Message-ID: <CAM_iQpUKxY1jc9mfNYfd+0wy_Oe7xttHXazg3SU=8Doq+0uoZg@mail.gmail.com>
References: <1526308035-12484-1-git-send-email-vladbu@mellanox.com>
 <CAM_iQpXMbtUWsaGBrpJH08dM4p9oVwpMSGrev1PThbP5d23sdA@mail.gmail.com> <vbfo9h3zd01.fsf@reg-r-vrt-018-180.mtr.labs.mlnx>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
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
To: Vlad Buslov <vladbu@mellanox.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <vbfo9h3zd01.fsf@reg-r-vrt-018-180.mtr.labs.mlnx>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

On Fri, May 25, 2018 at 1:39 PM, Vlad Buslov <vladbu@mellanox.com> wrote:
>
> On Thu 24 May 2018 at 23:34, Cong Wang <xiyou.wangcong@gmail.com> wrote:
>> On Mon, May 14, 2018 at 7:27 AM, Vlad Buslov <vladbu@mellanox.com> wrote:
>>> Currently, all netlink protocol handlers for updating rules, actions and
>>> qdiscs are protected with single global rtnl lock which removes any
>>> possibility for parallelism. This patch set is a first step to remove
>>> rtnl lock dependency from TC rules update path. It updates act API to
>>> use atomic operations, rcu and spinlocks for fine-grained locking. It
>>> also extend API with functions that are needed to update existing
>>> actions for parallel execution.
>>
>> Can you give a summary here for what and how it is achieved?
>
> Got it, will expand cover letter in V2 with summary.
>>
>> You said this is the first step, what do you want to achieve in this
>> very first step? And how do you achieve it? Do you break the RTNL
>
> But aren't this questions answered in paragraph you quoted?


Obviously not, you said to remove it, but never explains why it can
be removed and how it is removed. This is crucial for review.

"use atomic operations, rcu and spinlocks for fine-grained locking"
is literately nothing, why atomic/rcu makes RTNL unnecessary?
How RCU is used? What spinlocks are you talking about? What
do these spinlocks protect after removing RTNL? Why are they
safe with other netdevice and netns operations?

You explain _nothing_ here. Really. Please don't force people to
read 14 patches to understand how it works. In fact, no one wants
to read the code unless there is some high-level explanation that
makes basic sense.


> What: Change act API to not rely on one-big-global-RTNL-lock and to use
> more fine-grained synchronization methods to allow safe concurrent
> execution.

Sure, how fine-grained it is after your patchset? Why this fine-grained
lock could safely replace RTNL?

Could you stop letting us guess your puzzle words? It would save your
time from exchanging emails with me, it would save my time from
guessing you too. It is a win-win.


> How: Refactor act API code to use atomics, rcu and spinlocks, etc. for
> protecting shared data structures, add new functions required to update


What shared data structures? The per-netns idr which is already protected
by a spinlock? The TC hierarchy? The shared standalone actions? Hey,
why do I have to guess? :-/


> specific actions implementation for parallel execution. (step 2)


Claim is easy, prove is hard. I can easily claim I break RTNL down
to a per-netns lock, but I can't prove it really works. :-D


>
> If you feel that this cover letter is too terse, I will add outline of
> changes in V2.

It is not my rule, it is how you have to help people to review your
14 patches. I think it is a fair game: you help people like me to
review your patches, we help you to get them reviewed and merged
if they all make sense.



>
>> lock down to, for a quick example, a per-device lock? Or perhaps you
>> completely remove it because of what reason?
>
> I want to remove RTNL _dependency_ from act API data structures and
> code. I probably should me more specific in this case:
>
> Florian recently made a change that allows registering netlink protocol
> handlers with flag RTNL_FLAG_DOIT_UNLOCKED. Handlers registered with
> this flag are called without RTNL taken. My end goal is to have rule
> update handlers(RTM_NEWTFILTER, RTM_DELTFILTER, etc.) to be registered
> with UNLOCKED flag to allow parallel execution.


Please add this paragraph in your cover letter, it is very important for review.

>
> I do not intend to globally remove or break RTNL.
>
>>
>> I go through all the descriptions of your 14 patches (but not any code),
>> I still have no clue how you successfully avoid RTNL. Please don't
>> let me read into your code to understand that, there must be some
>> high-level justification on how it works. Without it, I don't event want
>> to read into the code.
>
> On internal code review I've been asked not to duplicate info from
> commit messages in cover letter, but I guess I can expand it with some
> high level outline in V2.

In cover letter, you should put a high-level overview of "why" and "how".
If, in the worst case, on high-level it doesn't make sense, why should
we bother to read the code? In short, you have to convince people to
read your code here.

In each patch description, you should explain what a single patch does.
I don't see any duplication.
