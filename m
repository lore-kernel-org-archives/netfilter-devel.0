From: Davide Caratti <dcaratti@redhat.com>
Subject: Re: [PATCH nf-next v2] netfilter: conntrack: simplify init/uninit
 of L4 protocol trackers
Date: Wed, 02 Nov 2016 11:38:52 +0100
Message-ID: <1478083132.2624.62.camel@redhat.com>
References: <2b862e9bc046bc42def1a56611265ddbc640fddd.1477643522.git.dcaratti@redhat.com>
         <20161101221102.GA26385@salvia>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
Cc: Patrick McHardy <kaber@trash.net>,
        Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>,
        "David S . Miller" <davem@davemloft.net>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        James Morris <jmorris@namei.org>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        netfilter-devel@vger.kernel.org, coreteam@netfilter.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:45266 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751130AbcKBKi5 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 2 Nov 2016 06:38:57 -0400
In-Reply-To: <20161101221102.GA26385@salvia>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Tue, 2016-11-01 at 23:11 +0100, Pablo Neira Ayuso wrote:
> Minor nitpicks as I said, see below.
> 
hello Pablo,

thank you for reviewing!

> On Fri, Oct 28, 2016 at 10:42:09AM +0200, Davide Caratti wrote:
> > 
> >  static struct pernet_operations ipv4_net_ops = {
> > @@ -410,37 +397,21 @@ static int __init
> > nf_conntrack_l3proto_ipv4_init(void)
> >  		goto cleanup_pernet;
> >  	}
> >  
> > -	ret = nf_ct_l4proto_register(&nf_conntrack_l4proto_tcp4);
> > -	if (ret < 0) {
> > -		pr_err("nf_conntrack_ipv4: can't register tcp4
> > proto.\n");
> > +	ret = nf_ct_l4proto_register(builtin_l4proto4,
> > +				     ARRAY_SIZE(builtin_l4proto4));
> > +	if (ret < 0)
> >  		goto cleanup_hooks;
> > -	}
> > -
> > -	ret = nf_ct_l4proto_register(&nf_conntrack_l4proto_udp4);
> > -	if (ret < 0) {
> > -		pr_err("nf_conntrack_ipv4: can't register udp4
> > proto.\n");
> > -		goto cleanup_tcp4;
> > -	}
> > -
> > -	ret = nf_ct_l4proto_register(&nf_conntrack_l4proto_icmp);
> > -	if (ret < 0) {
> > -		pr_err("nf_conntrack_ipv4: can't register icmpv4
> > proto.\n");
> > -		goto cleanup_udp4;
> > -	}
> >  
> >  	ret = nf_ct_l3proto_register(&nf_conntrack_l3proto_ipv4);
> >  	if (ret < 0) {
> >  		pr_err("nf_conntrack_ipv4: can't register ipv4
> > proto.\n");
> > -		goto cleanup_icmpv4;
> > +		goto cleanup_l4proto;
> 
> Is this correct?
> 
> nf_ct_l4proto_register() has failed, then we jump to cleanup_l4proto ...
> 

It looks correct to me - and the behavior is not changed with this patch:
when the code hits

	if (ret < 0) {
		pr_err("nf_conntrack_ipv4: can't register ipv4 proto.\n");
		goto cleanup_icmpv4; /* before patch */
	}
or

	if (ret < 0) {
		pr_err("nf_conntrack_ipv4: can't register ipv4 proto.\n");
		goto cleanup_l4proto; /* after patch */
	}


nf_ct_l4proto_register() surely didn't fail: 'ret' is return value of
nf_ct_l3proto_register(&nf_conntrack_l3proto_ipv4). 'cleanup_l4proto'
label is there to unregister all L4 protocols in the builtin list, in case
any failure follows a successful call to nf_ct_l4proto_register().

> > 
> >  	}
> >  
> >  	return ret;
> > - cleanup_icmpv4:
> > -	nf_ct_l4proto_unregister(&nf_conntrack_l4proto_icmp);
> > - cleanup_udp4:
> > -	nf_ct_l4proto_unregister(&nf_conntrack_l4proto_udp4);
> > - cleanup_tcp4:
> > -	nf_ct_l4proto_unregister(&nf_conntrack_l4proto_tcp4);
> > +cleanup_l4proto:
> > +	nf_ct_l4proto_unregister(builtin_l4proto4,
> > +				 ARRAY_SIZE(builtin_l4proto4));
> 
> ... that is unregistering what we failed to register. So
> nf_ct_l4proto_register() should clean up this internally.

Yes, and the patched code already does this actually. If a failure happens
in nf_ct_l4proto_register(), rollback of all previously registered L4
protocols in the builtin list is done before function returns a negative
value of 'ret':

	if (j < num_proto) {
		int ver = l4->l3proto == PF_INET6 ? 6 : 4;

		pr_err(".... "); /* <-- same printout as before patch */
		while (--j >= 0) {
			l4 = l4proto[j];
			rcu_assign_pointer(
				nf_ct_protos[l4->l3proto][l4->l4proto],
				&nf_conntrack_l4proto_generic);
		}
	}

and in this case

	if (ret < 0)
		goto cleanup_hooks;
       
is hit.

But I understand it's not so evident, nf_ct_l4proto_register() is very
long
and contains two lines copypasted from nf_ct_l4proto_unregister().
So I will follow the advice you did below and write 

nf_ct_l4proto_unregister_one()

that will be called in the while() loops of nf_ct_l4proto_register()
when the function is going to return a negative value, and in 
nf_ct_l4proto_unregister().


> > +			return -EINVAL;
> > +	}
> >  
> >  	mutex_lock(&nf_ct_proto_mutex);
> > -	if (!nf_ct_protos[l4proto->l3proto]) {
> > -		/* l3proto may be loaded latter. */
> > -		struct nf_conntrack_l4proto __rcu **proto_array;
> > -		int i;
> > -
> > -		proto_array = kmalloc(MAX_NF_CT_PROTO *
> > -				      sizeof(struct
> > nf_conntrack_l4proto *),
> > -				      GFP_KERNEL);
> > -		if (proto_array == NULL) {
> > -			ret = -ENOMEM;
> > -			goto out_unlock;
> > -		}
> > +	for (j = 0; j < num_proto; j++) {
> 
> I wonder if you can wrap this code below into a function, to save one
> level of indentation and improve maintainability. Probably in an
> initial patch so the indent happening here doesn't generate so many
> changes. This becomes harder to review.
> 
> Suggested name: nf_ct_l4proto_register_one()

ok,

<...>
> And same thing here, wrap this code into a function so you don't need
> to reindent.

and ok. Also this one is a preparatory commit for something else (i.e.
builtinization of conntrack for SCTP, DCCP, UDPlite), so I'm going to
repost this patch as a series.

regards,
--
davide


