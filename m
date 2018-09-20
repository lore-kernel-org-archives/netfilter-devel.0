From: Florian Westphal <fw@strlen.de>
Subject: Re: [PATCH] netfilter: nf_tables: add SECMARK support
Date: Thu, 20 Sep 2018 10:50:48 +0200
Message-ID: <20180920085048.tps2v4jkko7zjav4@breakpoint.cc>
References: <20180919231402.4482-1-cgzones@googlemail.com>
 <75b3fed9-e549-4ed0-c435-ec4795fc1e39@schaufler-ca.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Transfer-Encoding: 8bit
Cc: Christian =?iso-8859-15?Q?G=F6ttsche?= <cgzones@googlemail.com>,
        pablo@netfilter.org, kadlec@blackhole.kfki.hu, fw@strlen.de,
        davem@davemloft.net, netfilter-devel@vger.kernel.org,
        coreteam@netfilter.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, paul@paul-moore.com,
        sds@tycho.nsa.gov, eparis@parisplace.org, jmorris@namei.org,
        serge@hallyn.com, selinux@tycho.nsa.gov,
        linux-security-module@vger.kernel.org
To: Casey Schaufler <casey@schaufler-ca.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <75b3fed9-e549-4ed0-c435-ec4795fc1e39@schaufler-ca.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

Casey Schaufler <casey@schaufler-ca.com> wrote:
> On 9/19/2018 4:14 PM, Christian Göttsche wrote:
> > Add the ability to set the security context of packets within the nf_tables framework.
> > Add a nft_object for holding security contexts in the kernel and manipulating packets on the wire.
> > The contexts are kept as strings and are evaluated to security identifiers at runtime (packet arrival),
> > so that the nft_objects do not need to be refreshed after security changes.
> > The maximum security context length is set to 256.
> >
> > Based on v4.18.6
> >
> > Signed-off-by: Christian Göttsche <cgzones@googlemail.com>
> 
> I've only had a cursory look at your patch, but how is it
> different from what's in xt_SECMARK.c ?

this change is supposed to make secmark labeling accessible from
nftables.

The advantage is that its now possible to use
maps to assign secmarks from a single rule instead of using
several rules:

nft add rule meta secmark set tcp dport map { 22 : tag-ssh, 80 :
	tag-http }

and so on.

> > +	for (i = 0; i < ARRAY_SIZE(nft_basic_objects); i++) {
> > +		err = nft_register_obj(nft_basic_objects[i]);
> > +		if (err)
> > +			goto err;
> > +	}
> >  
> > -	for (i = 0; i < ARRAY_SIZE(nft_basic_types); i++) {
> > -		err = nft_register_expr(nft_basic_types[i]);
> > +	for (j = 0; j < ARRAY_SIZE(nft_basic_types); j++) {
> > +		err = nft_register_expr(nft_basic_types[j]);
> >  		if (err)
> >  			goto err;
> >  	}
> > @@ -248,8 +260,12 @@ int __init nf_tables_core_module_init(void)
> >  	return 0;
> >  
> >  err:
> > +	while (j-- > 0)
> > +		nft_unregister_expr(nft_basic_types[j]);
> > +
> >  	while (i-- > 0)
> > -		nft_unregister_expr(nft_basic_types[i]);
> > +		nft_unregister_obj(nft_basic_objects[i]);
> > +
> >  	return err;

Do I read this right in that this is a error unroll bug fix?
If so, could you please submit this as indepentent patch?

Fixes should go into nf.git whereas feature goes to nf-next.git.

> > +struct nft_secmark {
> > +	char ctx[NFT_SECMARK_CTX_MAXLEN];
> > +	int len;
> > +};
> > +
> > +static const struct nla_policy nft_secmark_policy[NFTA_SECMARK_MAX + 1] = {
> > +	[NFTA_SECMARK_CTX]     = { .type = NLA_STRING, .len = NFT_SECMARK_CTX_MAXLEN },
> > +};
> > +
> > +static void nft_secmark_obj_eval(struct nft_object *obj, struct nft_regs *regs, const struct nft_pktinfo *pkt)
> > +{
> > +	const struct nft_secmark *priv = nft_obj_data(obj);
> > +	struct sk_buff *skb = pkt->skb;
> > +	int err;
> > +	u32 secid = 0;
> > +
> > +	/* skip if packet has already a secmark */
> > +	if (skb->secmark)
> > +		return;

xt_SECMARK doesn't do this and will allow relabeling.
What do the LSM experts think?

> > +	err = security_secctx_to_secid(priv->ctx, priv->len, &secid);

Could someone familiar with how LSMs work clarify if this has to be
called per-packet?

xt_SECMARK.c does this ctx -> secid mapping once, when the iptables rule
gets added, whereas this patch does it once for each packet.

Is the ctx -> secid mapping stable?

If yes, the code above should be moved to the ->init() hook, otherwise
we'll need to fix xt_SECMARK.c.

> > +	if (err) {
> > +		if (err == -EINVAL)
> > +			pr_notice_ratelimited("invalid security context \'%s\'\n", priv->ctx);
> > +		else
> > +			pr_notice_ratelimited("unable to convert security context \'%s\': %d\n", priv->ctx, -err);
> > +		return;
> > +	}

Please remove these printks(), they do not really help as user can't
take any action anyway.

> > +	err = security_secmark_relabel_packet(secid);

Hmm, this function uses current() to check permissions of calling
task, so this function canot be used in ->eval() path.

Network stack causes random results of "current()", as network
processing can "steal" cpu from some arbitrary task when
softinterrupt kicks in.

->init() is fine, as its in process context and current will be the task
installing the nftables rule.
