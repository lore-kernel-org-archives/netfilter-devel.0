From: Patrick McHardy <kaber@trash.net>
Subject: Re: patch for conntrack expectations
Date: Thu, 04 Mar 2004 00:23:23 +0100
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <404668EB.1080400@trash.net>
References: <403014C5.8080102@eurodev.net> <20040217213217.GF30968@obroa-skai.de.gnumonks.org> <4032F4DE.3050402@eurodev.net> <20040218172539.GX9464@sunbeam.de.gnumonks.org> <4038B14C.901@eurodev.net> <20040224094014.GV13386@sunbeam.de.gnumonks.org> <403B1F5F.6010004@trash.net> <20040224102432.GX13386@sunbeam.de.gnumonks.org> <403B7CAA.3060005@trash.net> <403CD128.40101@eurodev.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Harald Welte <laforge@netfilter.org>,
 netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Pablo Neira <pablo@eurodev.net>
In-Reply-To: <403CD128.40101@eurodev.net>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

Hi Pablo,
this patch is not correct as far as I can see. With your new API,
ip_contrack_expect_related owns the memory after beeing called.
The cleaned up amanda helper reuses the same memory for all
expectations and expects ip_conntrack_expect_related to allocate
new memory and copy the data, so this will result in corruption.
It also leaks memory if the loop is left early. One thing that
seems to affect all changed helpers, you return -ENOMEM when
ip_conntrack_expect_alloc() fails, in this case while holding
a lock. You should return NF_DROP instead.

Can you please send a new patch ?

Regards
Patrick

Pablo Neira wrote:
> Attached my patch for the patrick's amanda helper to use the new 
> expect_alloc api.
> 
> Pablo
> 
> --- linux-2.6.3-old/net/ipv4/netfilter/ip_conntrack_amanda.c	2004-02-25 17:34:05.000000000 +0100
> +++ linux-2.6.3/net/ipv4/netfilter/ip_conntrack_amanda.c	2004-02-25 17:39:34.000000000 +0100
> @@ -46,7 +46,7 @@
>  static int help(struct sk_buff *skb,
>                  struct ip_conntrack *ct, enum ip_conntrack_info ctinfo)
>  {
> -	struct ip_conntrack_expect exp;
> +	struct ip_conntrack_expect *exp;
>  	struct ip_ct_amanda_expect *exp_amanda_info;
>  	char *data, *data_limit, *tmp;
>  	unsigned int dataoff, i;
> @@ -79,20 +79,22 @@
>  		goto out;
>  	data += strlen("CONNECT ");
>  
> -	memset(&exp, 0, sizeof(exp));
> -	exp.tuple.src.ip = ct->tuplehash[IP_CT_DIR_ORIGINAL].tuple.src.ip;
> -	exp.tuple.dst.ip = ct->tuplehash[IP_CT_DIR_ORIGINAL].tuple.dst.ip;
> -	exp.tuple.dst.protonum = IPPROTO_TCP;
> -	exp.mask.src.ip = 0xFFFFFFFF;
> -	exp.mask.dst.ip = 0xFFFFFFFF;
> -	exp.mask.dst.protonum = 0xFFFF;
> -	exp.mask.dst.u.tcp.port = 0xFFFF;
> +	if (ip_conntrack_expect_alloc(&exp) < 0)
> +		return -ENOMEM;
> +	
> +	exp->tuple.src.ip = ct->tuplehash[IP_CT_DIR_ORIGINAL].tuple.src.ip;
> +	exp->tuple.dst.ip = ct->tuplehash[IP_CT_DIR_ORIGINAL].tuple.dst.ip;
> +	exp->tuple.dst.protonum = IPPROTO_TCP;
> +	exp->mask.src.ip = 0xFFFFFFFF;
> +	exp->mask.dst.ip = 0xFFFFFFFF;
> +	exp->mask.dst.protonum = 0xFFFF;
> +	exp->mask.dst.u.tcp.port = 0xFFFF;
>  
>  	/* Only search first line. */	
>  	if ((tmp = strchr(data, '\n')))
>  		*tmp = '\0';
>  
> -	exp_amanda_info = &exp.help.exp_amanda_info;
> +	exp_amanda_info = &exp->help.exp_amanda_info;
>  	for (i = 0; i < ARRAY_SIZE(conns); i++) {
>  		char *match = strstr(data, conns[i]);
>  		if (!match)
> @@ -104,8 +106,8 @@
>  		if (exp_amanda_info->port == 0 || exp_amanda_info->len > 5)
>  			break;
>  
> -		exp.tuple.dst.u.tcp.port = htons(exp_amanda_info->port);
> -		ip_conntrack_expect_related(ct, &exp);
> +		exp->tuple.dst.u.tcp.port = htons(exp_amanda_info->port);
> +		ip_conntrack_expect_related(exp, ct);
>  	}
>  
>  out:
