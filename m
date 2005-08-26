From: "JessePeng" <jesse@deansoft.com.tw>
Subject: Re: [PATCH] Don't increase master refcount on expectations
Date: Fri, 26 Aug 2005 20:33:27 +0800
Message-ID: <000801c5aa3a$5bd49250$1501a8c0@test1>
References: <430E2DF9.8060802@eurodev.net>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Cc: Harald Welte <laforge@netfilter.org>, Patrick McHardy <kaber@trash.net>,
	Yasuyuki Kozakai <yasuyuki.kozakai@toshiba.co.jp>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: "Pablo Neira" <pablo@eurodev.net>, "Netfilter Development Mailinglist"
	<netfilter-devel@lists.netfilter.org>
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

Dear Pablo:
According to issues concerning how to manage refcount which relate master
and its children once expected,please refer to the following link,which
suggesting patch remove_expectations(),and that's where the problem first
was issued.
[1]https://lists.netfilter.org/pipermail/netfilter-devel/2003-November/01310
5.html
The scenario is that then I had a custom solution which takes advantage on
helper-expectation framewrok.According to this scenario,a master will expect
many children simultaniously.And not only each child's first packet which
fullfill the expect relies on its master for nat decision,but also the
scenario relies on the master for decision made on itself while one of its
children's replying packet reaches.And each children's replying packet will
not only put itself but also remove its conntrack.So the scenarion raises 2
problems:
1.Then without responsing from netfilter,All I can do is but doing some
custimized work to ip_conntrack_put the master to prevent the master from
hanging forever.(After quite a period, they patched the context.)
2.After All expects being fullfilled,it is still nacessary that the master
be referenced.So it looks reserving a refcount on the master after the
fullfillment doesn't push things too far.

So,my opinion is if it is necessary to keep refcount after
fullfillment?And,I suggest that my past suggestion be referrenced.

Your sincerely
Jesse

----- Original Message -----
From: "Pablo Neira" <pablo@eurodev.net>
To: "Netfilter Development Mailinglist"
<netfilter-devel@lists.netfilter.org>
Cc: "Harald Welte" <laforge@netfilter.org>; "Patrick McHardy"
<kaber@trash.net>; "Yasuyuki Kozakai" <yasuyuki.kozakai@toshiba.co.jp>
Sent: Friday, August 26, 2005 4:45 AM
Subject: [PATCH] Don't increase master refcount on expectations


> As it's been discussed [1][2]. We shouldn't increase the master
> conntrack refcount for non-fulfilled conntracks. During the conntrack
> destruction, the expectations are always killed before the conntrack
> itself, this guarantees that there won't be any orphan expectation.
>
>
[1]https://lists.netfilter.org/pipermail/netfilter-devel/2005-August/020783.
html
>
[2]https://lists.netfilter.org/pipermail/netfilter-devel/2005-August/020904.
html
>
> Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
>


----------------------------------------------------------------------------
----


> Index: netfilter-2.6.14/net/ipv4/netfilter/ip_conntrack_core.c
> ===================================================================
> --- netfilter-2.6.14.orig/net/ipv4/netfilter/ip_conntrack_core.c
2005-08-20 18:19:44.000000000 +0200
> +++ netfilter-2.6.14/net/ipv4/netfilter/ip_conntrack_core.c 2005-08-20
18:27:59.000000000 +0200
> @@ -934,6 +934,9 @@
>   write_unlock_bh(&ip_conntrack_lock);
>  }
>
> +/* We don't increase the master conntrack refcount for non-fulfilled
> + * conntracks. During the conntrack destruction, the expectations are
> + * always killed before the conntrack itself */
>  struct ip_conntrack_expect *ip_conntrack_expect_alloc(struct ip_conntrack
*me)
>  {
>   struct ip_conntrack_expect *new;
> @@ -944,17 +947,14 @@
>   return NULL;
>   }
>   new->master = me;
> - atomic_inc(&new->master->ct_general.use);
>   atomic_set(&new->use, 1);
>   return new;
>  }
>
>  void ip_conntrack_expect_put(struct ip_conntrack_expect *exp)
>  {
> - if (atomic_dec_and_test(&exp->use)) {
> - ip_conntrack_put(exp->master);
> + if (atomic_dec_and_test(&exp->use))
>   kmem_cache_free(ip_conntrack_expect_cachep, exp);
> - }
>  }
>
>  static void ip_conntrack_expect_insert(struct ip_conntrack_expect *exp)
>
