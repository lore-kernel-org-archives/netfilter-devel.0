From: Vasily Averin <vvs@virtuozzo.com>
Subject: Re: [PATCH v3 11/21] clusterip: exit_net cleanup check added
Date: Mon, 6 Nov 2017 16:55:51 +0300
Message-ID: <6fce82aa-e3c9-f472-74bc-e5b30433a6dd@virtuozzo.com>
References: <4fdc4264-e338-6ee8-a662-7d98b45733a1@virtuozzo.com>
 <66995620-efe8-59ed-9097-a4fd96e30ae1@virtuozzo.com>
 <alpine.DEB.2.11.1711061435191.6547@blackhole.kfki.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Cc: Pablo Neira Ayuso <pablo@netfilter.org>,
        Florian Westphal <fw@strlen.de>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        netfilter-devel@vger.kernel.org, coreteam@netfilter.org
To: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mailhub.sw.ru ([195.214.232.25]:30134 "EHLO relay.sw.ru"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752591AbdKFN4D (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 6 Nov 2017 08:56:03 -0500
In-Reply-To: <alpine.DEB.2.11.1711061435191.6547@blackhole.kfki.hu>
Content-Language: en-US
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Dear Jozsef,
thank you for your feedback,
I've added description into cover letter,
however it was not sent into netfilters mailing lists:

"This patch set checks that lists initialized in net_init hooks were
return to initial state at end of net_exit hooks.

I hope such checks allows to detect leaked per-netns objects.
Also I hope that all new pernet_operations will inherit such checks too.

I assume that elements added into per-net lists should not live longer than net namespace,
and should be deleted from the list. I think exit_net hook is good place for such check.

Recently I've found lost list_entry and enabled timer on stop of net namespace.
Then I've reviewed all existing pernet_operations and found that many drivers
have such checks already. So I decided to complete this task and add such checks
into all affected subsystems.

v3:
- use net->ns.inum as net Id
- removed patches for hashlimit and recent,
    they handle tables list in exit_net hook.
- added patches for grace and lockd

v2:
- net pointer removed from output
- fixed compilation for phonet driver
"

On 2017-11-06 16:40, Jozsef Kadlecsik wrote:
> Hello Vasily,
> 
> On Mon, 6 Nov 2017, Vasily Averin wrote:
> 
>> Be sure that configs list initialized in net_init hook was return
>> to initial state.
> 
> What is the goal of the patch series you sent in the third version in a 
> row?
> 
> - If the deinitializations are missing from the files, the patches 
>   do not fix them, just emit warnings.
> - If the deinitializations are not missing, the patches are totally 
>   unnecessary.
> 
> It looks like debugging... but not expressed that way, neither in the 
> subject lines nor in the patch descriptions.
> 
> Best regards,
> Jozsef
> 
>> Signed-off-by: Vasily Averin <vvs@virtuozzo.com>
>> ---
>>  net/ipv4/netfilter/ipt_CLUSTERIP.c | 3 +++
>>  1 file changed, 3 insertions(+)
>>
>> diff --git a/net/ipv4/netfilter/ipt_CLUSTERIP.c b/net/ipv4/netfilter/ipt_CLUSTERIP.c
>> index 17b4ca5..4364a88 100644
>> --- a/net/ipv4/netfilter/ipt_CLUSTERIP.c
>> +++ b/net/ipv4/netfilter/ipt_CLUSTERIP.c
>> @@ -819,6 +819,9 @@ static void clusterip_net_exit(struct net *net)
>>  	cn->procdir = NULL;
>>  #endif
>>  	nf_unregister_net_hook(net, &cip_arp_ops);
>> +	WARN_ONCE(!list_empty(&cn->configs),
>> +		  "net %x %s: configs list is not empty\n",
>> +		  net->ns.inum, __func__);
>>  }
>>  
>>  static struct pernet_operations clusterip_net_ops = {
>> -- 
>> 2.7.4
>>
>>
> 
> -
> E-mail  : kadlec@blackhole.kfki.hu, kadlecsik.jozsef@wigner.mta.hu
> PGP key : http://www.kfki.hu/~kadlec/pgp_public_key.txt
> Address : Wigner Research Centre for Physics, Hungarian Academy of Sciences
>           H-1525 Budapest 114, POB. 49, Hungary
> 
