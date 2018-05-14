From: Jamal Hadi Salim <jhs@mojatatu.com>
Subject: Re: [PATCH 00/14] Modify action API for implementing lockless actions
Date: Mon, 14 May 2018 14:03:20 -0400
Message-ID: <23f37e5a-dd30-0ad3-a5ab-df22bf0ad7f9@mojatatu.com>
References: <1526308035-12484-1-git-send-email-vladbu@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Cc: davem@davemloft.net, xiyou.wangcong@gmail.com, jiri@resnulli.us,
        pablo@netfilter.org, kadlec@blackhole.kfki.hu, fw@strlen.de,
        ast@kernel.org, daniel@iogearbox.net, edumazet@google.com,
        keescook@chromium.org, linux-kernel@vger.kernel.org,
        netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
        kliteyn@mellanox.com
To: Vlad Buslov <vladbu@mellanox.com>, netdev@vger.kernel.org
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1526308035-12484-1-git-send-email-vladbu@mellanox.com>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

On 14/05/18 10:27 AM, Vlad Buslov wrote:
> Currently, all netlink protocol handlers for updating rules, actions and
> qdiscs are protected with single global rtnl lock which removes any
> possibility for parallelism. This patch set is a first step to remove
> rtnl lock dependency from TC rules update path. It updates act API to
> use atomic operations, rcu and spinlocks for fine-grained locking. It
> also extend API with functions that are needed to update existing
> actions for parallel execution.
> 
> Outline of changes:
> - Change tc action to use atomic reference and bind counters, rcu
>    mechanism for cookie update.
> - Extend action ops API with 'delete' function and 'unlocked' flag.
> - Change action API to work with actions in lockless manner based on
>    primitives implemented in previous patches.
> - Extend action API with new functions necessary to implement unlocked
>    actions.

Please run all the tdc tests with these changes. This area has almost
good test coverage at this point. If you need help just ping me.

cheers,
jamal
