From: Vlad Buslov <vladbu@mellanox.com>
Subject: Re: [PATCH 00/14] Modify action API for implementing lockless actions
Date: Mon, 14 May 2018 23:46:28 +0300
Message-ID: <vbfo9him0d7.fsf@reg-r-vrt-018-180.mtr.labs.mlnx>
References: <1526308035-12484-1-git-send-email-vladbu@mellanox.com> <23f37e5a-dd30-0ad3-a5ab-df22bf0ad7f9@mojatatu.com>
Mime-Version: 1.0
Content-Type: text/plain
Cc: netdev@vger.kernel.org, davem@davemloft.net,
        xiyou.wangcong@gmail.com, jiri@resnulli.us, pablo@netfilter.org,
        kadlec@blackhole.kfki.hu, fw@strlen.de, ast@kernel.org,
        daniel@iogearbox.net, edumazet@google.com, keescook@chromium.org,
        linux-kernel@vger.kernel.org, netfilter-devel@vger.kernel.org,
        coreteam@netfilter.org, kliteyn@mellanox.com
To: Jamal Hadi Salim <jhs@mojatatu.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-reply-to: <23f37e5a-dd30-0ad3-a5ab-df22bf0ad7f9@mojatatu.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org


On Mon 14 May 2018 at 18:03, Jamal Hadi Salim <jhs@mojatatu.com> wrote:
> On 14/05/18 10:27 AM, Vlad Buslov wrote:
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
> Please run all the tdc tests with these changes. This area has almost
> good test coverage at this point. If you need help just ping me.
>
> cheers,
> jamal


Hello Jamal,

I'm trying to run tdc, but keep getting following error even on clean
branch without my patches:

Test d190: Add police action with maximum index

-----> teardown stage *** Could not execute: "$TC actions flush action mirred"

-----> teardown stage *** Error message: "RTNETLINK answers: Invalid argument
We have an error flushing
"

-----> teardown stage *** Aborting test run.


<_io.BufferedReader name=3> *** stdout ***


<_io.BufferedReader name=5> *** stderr ***
"-----> teardown stage" did not complete successfully
Exception <class '__main__.PluginMgrTestFail'> ('teardown', 'RTNETLINK answers: Invalid argument\nWe have an error talking to the kernel\nCommand "action" is unknown, try "tc actions help".\n', '"-----> teardown stage" did not complete suc
cessfully') (caught in test_runner, running test 54 d190 Add police action with maximum index stage teardown)
---------------
traceback
  File "./tdc.py", line 293, in test_runner
    tap += run_one_test(pm, args, index, tidx)
  File "./tdc.py", line 229, in run_one_test
    prepare_env(args, pm, 'teardown', '-----> teardown stage', tidx['teardown'], procout)
  File "./tdc.py", line 177, in prepare_env
    '"{}" did not complete successfully'.format(prefix))
---------------
accumulated output for this test:
RTNETLINK answers: Invalid argument
We have an error talking to the kernel
Command "action" is unknown, try "tc actions help".

---------------


I've updated both iproute2 and kernel to latest master and net-next
respectively, but error persists. Am I missing something? Maybe I should
you some specific "blessed" version of TC?

Thanks,
Vlad
