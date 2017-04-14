From: "Gao Feng" <gfree.wind@foxmail.com>
Subject: RE: [PATCH nf v5 2/3] netfilter: nat_helper: Make sure every proto nat module uses its nat_helper
Date: Fri, 14 Apr 2017 08:46:44 +0800
Message-ID: <000001d2b4b8$97256c40$c57044c0$@foxmail.com>
References: <cover.1490955730.git.fgao@ikuai8.com> <74aaa9aaa69d65fa46d56faf5c4de671abf4a5cf.1490955730.git.fgao@ikuai8.com> <20170414001107.GA28754@salvia>
Mime-Version: 1.0
Content-Type: text/plain;
        charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: <netfilter-devel@vger.kernel.org>
To: "'Pablo Neira Ayuso'" <pablo@netfilter.org>,
        <gfree.wind@foxmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtpbguseast2.qq.com ([54.204.34.130]:38911 "EHLO
        smtpbguseast2.qq.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753400AbdDNAqs (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 13 Apr 2017 20:46:48 -0400
In-Reply-To: <20170414001107.GA28754@salvia>
Content-Language: zh-cn
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

> -----Original Message-----
> From: Pablo Neira Ayuso [mailto:pablo@netfilter.org]
> On Fri, Mar 31, 2017 at 06:38:20PM +0800, gfree.wind@foxmail.com wrote:
> > +static struct nf_ct_nat_helper pptp_nat = {
> > +	.name			= "pptp_nat",
> 
> Why all these with "xyz_nat" names?

I just used the variable name before.
How about rename it to "xyz_nat_helper"?
> 
> This is going to break ctnetlink, as this is the name that identifies the
NAT
> helper to be used.
> 
> > +	.expectfn		= pptp_expectfn,
> > +};
> > +
> >  static void pptp_expectfn(struct nf_conn *ct,
> >  			 struct nf_conntrack_expect *exp)
> >  {
> > @@ -221,7 +229,7 @@ static int exp_gre(struct nf_conn *ct, __be16
callid,
> __be16 peer_callid)
> >  			  &ct->tuplehash[dir].tuple.src.u3,
> >  			  &ct->tuplehash[dir].tuple.dst.u3,
> >  			  IPPROTO_GRE, &peer_callid, &callid);
> > -	exp_orig->expectfn = pptp_expectfn;
> > +	exp_orig->nat_helper = &pptp_nat;
> >
> >  	/* reply direction, PAC->PNS */
> >  	dir = IP_CT_DIR_REPLY;
> > @@ -230,7 +238,7 @@ static int exp_gre(struct nf_conn *ct, __be16
callid,
> __be16 peer_callid)
> >  			  &ct->tuplehash[dir].tuple.src.u3,
> >  			  &ct->tuplehash[dir].tuple.dst.u3,
> >  			  IPPROTO_GRE, &callid, &peer_callid);
> > -	exp_reply->expectfn = pptp_expectfn;
> > +	exp_reply->nat_helper = &pptp_nat;
> 
> Why do we need to attach nat_helper instead of expectfn? I would prefer we
> do not.

Because we need to introduce another member "expectfn_module" in the third
patch.
If insisted on the current style, the codes would look like the following:
	exp_reply->expectfn = pptp_expectfn;
	exp_reply->expectfn_module = THIS_MODULE;

There are two assignments when using expect_fn.
It isn't only a little duplicated, but also it is easy to lost the module
assignment and bring one bug.

If attached the nat_helper instead of expectfn, there would be only one
assignment.

Regards
Feng





