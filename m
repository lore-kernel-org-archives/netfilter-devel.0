From: Jackson Alberto <superj_2004@hotmail.com>
Subject: RE: Question about using "Expect" from Netfilter hook
Date: Mon, 2 Aug 2010 17:36:13 -0400
Message-ID: <BAY121-W42C372297D7FD64DE9DF469DAD0@phx.gbl>
References: <BAY121-W19EB6FC57269CBEAC35B8B9DA90@phx.gbl>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
To: <netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from bay0-omc1-s20.bay0.hotmail.com ([65.54.190.31]:24623 "EHLO
	bay0-omc1-s20.bay0.hotmail.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755410Ab0HBVgO convert rfc822-to-8bit
	(ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 2 Aug 2010 17:36:14 -0400
In-Reply-To: <BAY121-W19EB6FC57269CBEAC35B8B9DA90@phx.gbl>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


Can someone please help me with this?

----------------------------------------
> From: superj_2004@hotmail.com
> To: netfilter-devel@vger.kernel.org
> Subject: Question about using "Expect" from Netfilter hook
> Date: Thu, 29 Jul 2010 13:58:03 -0400
>
>
> Hello!,
>
> Is it possible to work with "expect" from a netfilter hook (not from a
> conntrack helper)?
>
> When I run the code below, I get:
>
> BUG: unable to handle kernel NULL pointer dereference at (null)
> IP [] nf_ct_expect_related_report+0x63/0x427
> *pde = 3df8d067
> Oops: 000 [#1] SMP
>
> ------
>
> int np_exp(struct nf_conn *ct){
>     struct nf_conntrack_expect *exp;
>     struct nf_conntrack_tuple *tuple;
>
>     exp = nf_ct_expect_alloc(ct);
>     if(exp == NULL){
>         printk("Couldn't allocate exp!\n");
>         return -1;
>     }
>
>     tuple = &ct->tuplehash[IP_CT_DIR_REPLY].tuple;
>
>     nf_ct_expect_init(exp, NF_CT_EXPECT_CLASS_DEFAULT, nf_ct_l3num(ct),
> &tuple->src.u3, &tuple->dst.u3, IPPROTO_TCP,
> NULL, &tuple->dst.u.tcp.port);
>
> nf_ct_expect_put(exp);
>
>     return 1;
> }
>
> hook_func(...){
>     if(!(conntrack = nf_ct_get(sock_buff, &ctinfo)) ||
> !(master_conntrack = nf_ct_get(skb, &master_ctinfo))){
>         spin_unlock_bh(&np_lock);
>         return NF_ACCEPT; /* Couldn't get conntrack */
> }
>
>     np_exp(conntrack);
> }
>
> _________________________________________________________________
> Hotmail: Powerful Free email with security by Microsoft.
> https://signup.live.com/signup.aspx?id=60969--
> To unsubscribe from this list: send the line "unsubscribe netfilter-devel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at http://vger.kernel.org/majordomo-info.html
 		 	   		  