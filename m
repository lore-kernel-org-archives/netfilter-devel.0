From: Kirill Tkhai <ktkhai@virtuozzo.com>
Subject: Re: [PATCH net-next 0/3] Close race between {un,
 }register_netdevice_notifier and pernet_operations
Date: Fri, 30 Mar 2018 18:01:24 +0300
Message-ID: <8c9717e3-3388-9f88-7de6-ce7b201aff77@virtuozzo.com>
References: <152233127015.1654.2122693690388452589.stgit@localhost.localdomain>
 <20180330.110012.2226179718404929635.davem@davemloft.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Cc: steffen.klassert@secunet.com, herbert@gondor.apana.org.au,
        pablo@netfilter.org, kadlec@blackhole.kfki.hu, fw@strlen.de,
        daniel@iogearbox.net, jakub.kicinski@netronome.com, ast@kernel.org,
        brouer@redhat.com, linux@rasmusvillemoes.dk,
        john.fastabend@gmail.com, dsahern@gmail.com,
        netdev@vger.kernel.org, netfilter-devel@vger.kernel.org,
        coreteam@netfilter.org
To: David Miller <davem@davemloft.net>
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20180330.110012.2226179718404929635.davem@davemloft.net>
Content-Language: en-US
Sender: netdev-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

On 30.03.2018 18:00, David Miller wrote:
> From: Kirill Tkhai <ktkhai@virtuozzo.com>
> Date: Thu, 29 Mar 2018 17:03:15 +0300
> 
>> the problem is {,un}register_netdevice_notifier() do not take
>> pernet_ops_rwsem, and they don't see network namespaces, being
>> initialized in setup_net() and cleanup_net(), since at this
>> time net is not hashed to net_namespace_list.
>>
>> This may lead to imbalance, when a notifier is called at time of
>> setup_net()/net is alive, but it's not called at time of cleanup_net(),
>> for the devices, hashed to the net, and vise versa. See (3/3) for
>> the scheme of imbalance.
>>
>> This patchset fixes the problem by acquiring pernet_ops_rwsem
>> at the time of {,un}register_netdevice_notifier() (3/3).
>> (1-2/3) are preparations in xfrm and netfilter subsystems.
>>
>> The problem was introduced a long ago, but backporting won't be easy,
>> since every previous kernel version may have changes in netdevice
>> notifiers, and they all need review and testing. Otherwise, there
>> may be more pernet_operations, which register or unregister
>> netdevice notifiers, and that leads to deadlock (which is was fixed
>> in 1-2/3). This patchset is for net-next.
> 
> I am applying this series and skipping the rwsem revert.
> 
> Thanks Kirill.

Thanks, David.

I'll send the fixing patch soon today.

Kirill
