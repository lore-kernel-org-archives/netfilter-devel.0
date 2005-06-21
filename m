From: Roberto Nibali <ratz@tac.ch>
Subject: Re: [PATCH] update raw patch in POM [2.4.x]
Date: Tue, 21 Jun 2005 16:17:27 +0200
Message-ID: <42B82177.5010101@tac.ch>
References: <42A57FC4.7010508@tac.ch>	<42A5B144.3090005@tac.ch>	<42A625DA.7090807@eurodev.net>	<42A6AB19.2040106@tac.ch>	<42A6E685.3060408@eurodev.net>	<42AEF774.8060300@tac.ch>	<42B67BEC.1090105@tac.ch>	<20050621003441.GI8335@postel.suug.ch>	<42B76474.8080209@eurodev.net>	<20050621111328.GK8335@postel.suug.ch>
	<42B81D75.8090205@trash.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: Netfilter Developers <netfilter-devel@lists.netfilter.org>,
	Pablo Neira <pablo@eurodev.net>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Patrick McHardy <kaber@trash.net>
In-Reply-To: <42B81D75.8090205@trash.net>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: </pipermail/netfilter-devel>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
Sender: netfilter-devel-bounces@lists.netfilter.org
Errors-To: netfilter-devel-bounces@lists.netfilter.org
List-Id: netfilter-devel.vger.kernel.org

Hello Patrick,

Thanks for looking into this. I've added a 2.4.x into the subject because it
seems people forget it sometimes :)

>>>If the module gets unloaded, ip_conntrack_untracked refcount isn't 
>>>decreased, it's still 1. So destroy() is never called. In that case it 
>>>should be really easy to trigger on my slow laptop ;->.
>>
>>How do you explain the BUG() being triggered then?
> 
> Pablo mentioned to me in private mail that he believes the reason
> is packets holding references to ip_conntrack_untracked on module
> removal. I agree, and this patch should fix it. Roberto, could
> you please try it and tell me if it helps?

I already did. Here's an excerpt of an earlier email in this thread regarding
this patch:

>--- linux-2.4.orig/net/ipv4/netfilter/ip_conntrack_core.c	2005-06-15
>> 23:16:43.000000000 +0200
>> +++ linux-2.4/net/ipv4/netfilter/ip_conntrack_core.c	2005-06-17
>> 20:44:18.000000000 +0200
>> @@ -1391,6 +1391,8 @@
>>  		schedule();
>>  		goto i_see_dead_people;
>>  	}
>> +	while (atomic_read(&ip_conntrack_untracked.ct_general.use) != 1)
>> +		schedule();
>>
>>  	kmem_cache_destroy(ip_conntrack_cachep);
>>  	vfree(ip_conntrack_hash);


This results in an endless loop when calling rmmod ip_conntrack. lsmod shows
(deleted) but the process is in D state. No oops of course and no hang.

But I cannot remove the ip_conntrack kernel module anymore. It's "stuck".

> diff --git a/net/ipv4/netfilter/ip_conntrack_core.c b/net/ipv4/netfilter/ip_conntrack_core.c
> --- a/net/ipv4/netfilter/ip_conntrack_core.c
> +++ b/net/ipv4/netfilter/ip_conntrack_core.c
> @@ -1111,7 +1111,9 @@ void ip_conntrack_cleanup(void)
>  		schedule();
>  		goto i_see_dead_people;
>  	}
> -
> +	/* wait until all references to ip_conntrack_untracked are dropped */
> +	while (atomic_read(&ip_conntrack_untracked.ct_general.use) > 1)
> +		schedule();
>  	kmem_cache_destroy(ip_conntrack_cachep);
>  	kmem_cache_destroy(ip_conntrack_expect_cachep);
>  	free_conntrack_hash();

This is not a pristine 2.4.x kernel source you diffed against, rather a 2.6.x
one. The ip_conntrack_expect_cachep kmem cache was not used in 2.4.x AFAIK.

Do you want me to rerun the test for more precise statements?

Best regards,
Roberto Nibali, ratz
-- 
-------------------------------------------------------------
addr://Rathausgasse 31, CH-5001 Aarau  tel://++41 62 823 9355
http://www.terreactive.com             fax://++41 62 823 9356
-------------------------------------------------------------
terreActive AG                       Wir sichern Ihren Erfolg
-------------------------------------------------------------
