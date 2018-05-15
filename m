From: Jiri Pirko <jiri@resnulli.us>
Subject: Re: [PATCH 00/14] Modify action API for implementing lockless actions
Date: Tue, 15 May 2018 10:20:43 +0200
Message-ID: <20180515082043.GH2134@nanopsycho.orion>
References: <1526308035-12484-1-git-send-email-vladbu@mellanox.com>
 <23f37e5a-dd30-0ad3-a5ab-df22bf0ad7f9@mojatatu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Vlad Buslov <vladbu@mellanox.com>, netdev@vger.kernel.org,
        davem@davemloft.net, xiyou.wangcong@gmail.com, pablo@netfilter.org,
        kadlec@blackhole.kfki.hu, fw@strlen.de, ast@kernel.org,
        daniel@iogearbox.net, edumazet@google.com, keescook@chromium.org,
        linux-kernel@vger.kernel.org, netfilter-devel@vger.kernel.org,
        coreteam@netfilter.org, kliteyn@mellanox.com
To: Jamal Hadi Salim <jhs@mojatatu.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <23f37e5a-dd30-0ad3-a5ab-df22bf0ad7f9@mojatatu.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

Mon, May 14, 2018 at 08:03:20PM CEST, jhs@mojatatu.com wrote:
>On 14/05/18 10:27 AM, Vlad Buslov wrote:
>> Currently, all netlink protocol handlers for updating rules, actions and
>> qdiscs are protected with single global rtnl lock which removes any
>> possibility for parallelism. This patch set is a first step to remove
>> rtnl lock dependency from TC rules update path. It updates act API to
>> use atomic operations, rcu and spinlocks for fine-grained locking. It
>> also extend API with functions that are needed to update existing
>> actions for parallel execution.
>> 
>> Outline of changes:
>> - Change tc action to use atomic reference and bind counters, rcu
>>    mechanism for cookie update.
>> - Extend action ops API with 'delete' function and 'unlocked' flag.
>> - Change action API to work with actions in lockless manner based on
>>    primitives implemented in previous patches.
>> - Extend action API with new functions necessary to implement unlocked
>>    actions.
>
>Please run all the tdc tests with these changes. This area has almost
>good test coverage at this point. If you need help just ping me.

Oh, that reminds me. Vlad, please run also:
tools/testing/selftests/net/forwarding/tc_*

Thanks!
