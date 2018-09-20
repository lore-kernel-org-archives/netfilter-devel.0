From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH] netfilter: nf_tables: add SECMARK support
Date: Thu, 20 Sep 2018 11:30:18 +0200
Message-ID: <20180920093018.qliwjvkeqjrouvsw@salvia>
References: <20180919231402.4482-1-cgzones@googlemail.com>
 <75b3fed9-e549-4ed0-c435-ec4795fc1e39@schaufler-ca.com>
 <20180920085048.tps2v4jkko7zjav4@breakpoint.cc>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Cc: Casey Schaufler <casey@schaufler-ca.com>,
        Christian =?iso-8859-1?Q?G=F6ttsche?= <cgzones@googlemail.com>,
        kadlec@blackhole.kfki.hu, davem@davemloft.net,
        netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        paul@paul-moore.com, sds@tycho.nsa.gov, eparis@parisplace.org,
        jmorris@namei.org, serge@hallyn.com, selinux@tycho.nsa.gov,
        linux-security-module@vger.kernel.org
To: Florian Westphal <fw@strlen.de>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20180920085048.tps2v4jkko7zjav4@breakpoint.cc>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

On Thu, Sep 20, 2018 at 10:50:48AM +0200, Florian Westphal wrote:
> Casey Schaufler <casey@schaufler-ca.com> wrote:
> > On 9/19/2018 4:14 PM, Christian Göttsche wrote:
> > > Add the ability to set the security context of packets within the nf_tables framework.
> > > Add a nft_object for holding security contexts in the kernel and manipulating packets on the wire.
> > > The contexts are kept as strings and are evaluated to security identifiers at runtime (packet arrival),
> > > so that the nft_objects do not need to be refreshed after security changes.
> > > The maximum security context length is set to 256.
> > >
> > > Based on v4.18.6
> > >
> > > Signed-off-by: Christian Göttsche <cgzones@googlemail.com>
> > 
> > I've only had a cursory look at your patch, but how is it
> > different from what's in xt_SECMARK.c ?
> 
> this change is supposed to make secmark labeling accessible from
> nftables.
> 
> The advantage is that its now possible to use
> maps to assign secmarks from a single rule instead of using
> several rules:
> 
> nft add rule meta secmark set tcp dport map { 22 : tag-ssh, 80 :
> 	tag-http }
> 
> and so on.
> 
> > > +	for (i = 0; i < ARRAY_SIZE(nft_basic_objects); i++) {
> > > +		err = nft_register_obj(nft_basic_objects[i]);
> > > +		if (err)
> > > +			goto err;
> > > +	}
> > >  
> > > -	for (i = 0; i < ARRAY_SIZE(nft_basic_types); i++) {
> > > -		err = nft_register_expr(nft_basic_types[i]);
> > > +	for (j = 0; j < ARRAY_SIZE(nft_basic_types); j++) {
> > > +		err = nft_register_expr(nft_basic_types[j]);
> > >  		if (err)
> > >  			goto err;
> > >  	}
> > > @@ -248,8 +260,12 @@ int __init nf_tables_core_module_init(void)
> > >  	return 0;
> > >  
> > >  err:
> > > +	while (j-- > 0)
> > > +		nft_unregister_expr(nft_basic_types[j]);
> > > +
> > >  	while (i-- > 0)
> > > -		nft_unregister_expr(nft_basic_types[i]);
> > > +		nft_unregister_obj(nft_basic_objects[i]);
> > > +
> > >  	return err;
> 
> Do I read this right in that this is a error unroll bug fix?
> If so, could you please submit this as indepentent patch?
> 
> Fixes should go into nf.git whereas feature goes to nf-next.git.

nft_register_expr() never actually fails, so probably we can just turn
this into void.

@Christian: Please make sure you rebase your secmark patch on top of
nf-next.git.
