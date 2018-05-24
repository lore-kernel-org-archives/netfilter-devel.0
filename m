From: Cong Wang <xiyou.wangcong@gmail.com>
Subject: Re: [PATCH 00/14] Modify action API for implementing lockless actions
Date: Thu, 24 May 2018 16:34:54 -0700
Message-ID: <CAM_iQpXMbtUWsaGBrpJH08dM4p9oVwpMSGrev1PThbP5d23sdA@mail.gmail.com>
References: <1526308035-12484-1-git-send-email-vladbu@mellanox.com>
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
In-Reply-To: <1526308035-12484-1-git-send-email-vladbu@mellanox.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

On Mon, May 14, 2018 at 7:27 AM, Vlad Buslov <vladbu@mellanox.com> wrote:
> Currently, all netlink protocol handlers for updating rules, actions and
> qdiscs are protected with single global rtnl lock which removes any
> possibility for parallelism. This patch set is a first step to remove
> rtnl lock dependency from TC rules update path. It updates act API to
> use atomic operations, rcu and spinlocks for fine-grained locking. It
> also extend API with functions that are needed to update existing
> actions for parallel execution.

Can you give a summary here for what and how it is achieved?

You said this is the first step, what do you want to achieve in this
very first step? And how do you achieve it? Do you break the RTNL
lock down to, for a quick example, a per-device lock? Or perhaps you
completely remove it because of what reason?

I go through all the descriptions of your 14 patches (but not any code),
I still have no clue how you successfully avoid RTNL. Please don't
let me read into your code to understand that, there must be some
high-level justification on how it works. Without it, I don't event want
to read into the code.

Thanks.
