From: Gao feng <gaofeng@cn.fujitsu.com>
Subject: Re: [PATCH] nfnetlink: use rcu_assign_pointer in nfnetlink_subsys_unregister
Date: Wed, 09 Oct 2013 11:28:32 +0800
Message-ID: <5254CD60.3030306@cn.fujitsu.com>
References: <1381226648-10959-1-git-send-email-gaofeng@cn.fujitsu.com> <1381245834.12191.37.camel@edumazet-glaptop.roam.corp.google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: Eric Dumazet <eric.dumazet@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:9353 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1752949Ab3JID10 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 8 Oct 2013 23:27:26 -0400
In-Reply-To: <1381245834.12191.37.camel@edumazet-glaptop.roam.corp.google.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On 10/08/2013 11:23 PM, Eric Dumazet wrote:
> On Tue, 2013-10-08 at 18:04 +0800, Gao feng wrote:
>> Though I don't face an oops, but it is more safer to
>> set table's subsys through rcu_assign_pointer.
>>
>> Signed-off-by: Gao feng <gaofeng@cn.fujitsu.com>
>> ---
>>  net/netfilter/nfnetlink.c | 2 +-
>>  1 file changed, 1 insertion(+), 1 deletion(-)
>>
>> diff --git a/net/netfilter/nfnetlink.c b/net/netfilter/nfnetlink.c
>> index 572d87d..3cd2fe6 100644
>> --- a/net/netfilter/nfnetlink.c
>> +++ b/net/netfilter/nfnetlink.c
>> @@ -78,7 +78,7 @@ EXPORT_SYMBOL_GPL(nfnetlink_subsys_register);
>>  int nfnetlink_subsys_unregister(const struct nfnetlink_subsystem *n)
>>  {
>>  	nfnl_lock(n->subsys_id);
>> -	table[n->subsys_id].subsys = NULL;
>> +	rcu_assign_pointer(table[n->subsys_id].subsys, NULL);
>>  	nfnl_unlock(n->subsys_id);
>>  	synchronize_rcu();
>>  	return 0;
> 
> Certainly not.
> 
> Assigning a NULL pointer do not require rcu_assign_pointer() but this,
> if you want to be really really clean.
> 

The reason assigning a NULL pointer do not require rcu_assign_pointer
is it's impossible for a reader to access to uninitialized content?
So we don't need write barrier here to make sure the resource being
initialized before reader accessing it. Right?

> diff --git a/net/netfilter/nfnetlink.c b/net/netfilter/nfnetlink.c
> index 572d87d..649958b 100644
> --- a/net/netfilter/nfnetlink.c
> +++ b/net/netfilter/nfnetlink.c
> @@ -78,7 +78,7 @@ EXPORT_SYMBOL_GPL(nfnetlink_subsys_register);
>  int nfnetlink_subsys_unregister(const struct nfnetlink_subsystem *n)
>  {
>  	nfnl_lock(n->subsys_id);
> -	table[n->subsys_id].subsys = NULL;
> +	RCU_INIT_POINTER(table[n->subsys_id].subsys, NULL);
>  	nfnl_unlock(n->subsys_id);
>  	synchronize_rcu();
>  	return 0;
> 
> 
> 
> 
> 

