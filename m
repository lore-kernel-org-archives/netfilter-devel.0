From: Vlad Buslov <vladbu@mellanox.com>
Subject: Re: [PATCH 00/14] Modify action API for implementing lockless actions
Date: Wed, 16 May 2018 00:21:55 +0300
Message-ID: <vbfh8n81uoc.fsf@reg-r-vrt-018-180.mtr.labs.mlnx>
References: <1526308035-12484-1-git-send-email-vladbu@mellanox.com> <23f37e5a-dd30-0ad3-a5ab-df22bf0ad7f9@mojatatu.com> <vbfo9him0d7.fsf@reg-r-vrt-018-180.mtr.labs.mlnx> <97ccb118-a3dc-6eb0-b127-9c04adf9e2fd@mojatatu.com>
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
In-reply-to: <97ccb118-a3dc-6eb0-b127-9c04adf9e2fd@mojatatu.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org


On Tue 15 May 2018 at 18:25, Jamal Hadi Salim <jhs@mojatatu.com> wrote:
> On 14/05/18 04:46 PM, Vlad Buslov wrote:
>> 
>> On Mon 14 May 2018 at 18:03, Jamal Hadi Salim <jhs@mojatatu.com> wrote:
>>> On 14/05/18 10:27 AM, Vlad Buslov wrote:
>
>
>> Hello Jamal,
>> 
>> I'm trying to run tdc, but keep getting following error even on clean
>> branch without my patches:
>
> Vlad, not sure if you saw my email:
> Apply Roman's patch and try again
>
> https://marc.info/?l=linux-netdev&m=152639369112020&w=2
>
> cheers,
> jamal

With patch applied I get following error:

Test 7d50: Add skbmod action to set destination mac
exit: 255 0
dst MAC address <11:22:33:44:55:66>
RTNETLINK answers: No such file or directory
We have an error talking to the kernel


-----> teardown stage *** Could not execute: "$TC actions flush action skbmod"

-----> teardown stage *** Error message: "RTNETLINK answers: Invalid argument
We have an error flushing
"

-----> teardown stage *** Aborting test run.


<_io.BufferedReader name=3> *** stdout ***


<_io.BufferedReader name=5> *** stderr ***
"-----> teardown stage" did not complete successfully
Exception <class '__main__.PluginMgrTestFail'> ('teardown', 'dst MAC address <11:22:33:44:55:66>\nRTNETLINK answers: No such file or directory\nWe have an error talking to the kernel\n', '"-----> teardown stage" did not complete successful
ly') (caught in test_runner, running test 87 7d50 Add skbmod action to set destination mac stage teardown)
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
dst MAC address <11:22:33:44:55:66>
RTNETLINK answers: No such file or directory
We have an error talking to the kernel

---------------


Regards,
Vlad
