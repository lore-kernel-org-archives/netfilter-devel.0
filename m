Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F2D74394492
	for <netfilter-devel@vger.kernel.org>; Mon, 30 Mar 2026 19:45:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774899924; cv=none; b=bVlksnLld2Odhqdj5SXYcnCq6pZtrKR/osa5hD7qxapxr4H/1iLgCLsG1zngMXGtvddoqExyjH3UPIOQ9RPQg3UqIYRL8rqQAE5zOGQVgQcS0YVUVIreHsGm8amqTCVwrZ0Oa2ilNig5bz/5kq07SbPZw3phXKDBe/3ZzgTtAzU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774899924; c=relaxed/simple;
	bh=uslH2YgEdVzvNaETVqtUx3OR35jpia9iuL0Kn0LDHjE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=MNyuaHbuu3jrvm6OU2lJIWjyIzVNnvJcK0S8ILDxi9jxdMg5iq7EIX535vvd2XCHXmrjBuFEqrLIDlZOxqiolP9QVlRfYYh15Redw+wTfe7RpGLEW/brwuIeF3JOK+0Q0owDrMkhlScXQdfm4aZs7n6vDsIlFumw3BSRB9pnkH8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=dHFwmbry; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="dHFwmbry"
Received: from netfilter.org (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with UTF8SMTPSA id 62FF360264;
	Mon, 30 Mar 2026 21:45:19 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1774899919;
	bh=sl7Nj5lbHAknkqhpOQSls9wInh1Q3cIYdsPiApMKRHM=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=dHFwmbryZoxOyS0zyvUM16irTOh0BxpY113LX77bOO4NpUwCmEvfVc1VQ5qdxvmzT
	 AHnFr82+7WVDoR5t0C1MBjfdBMWLaVetguwmFmP6k8oQUZFt54P/S/IHP9V3cEkY0R
	 4Q/+Oyr2tBjPdSOz3cHZCkfG6/R2Bx4KQDq3vdQPgE8ICIui17/mTj392vmtXF1nbw
	 FXK2T88trZ//tqnJJ7ArMw48oujeR+yTfn/j6JaU9vjvdUn+kPHvwcAN5RF/quWqu8
	 NAIsjIWV8ch3fuL29yktVSYBf94kPE2roSWX145etMl4HWjGD4Z0p4cLmhsTef3TTa
	 qHFYOxju1QRdg==
Date: Mon, 30 Mar 2026 21:45:17 +0200
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Fernando Fernandez Mancera <fmancera@suse.de>
Cc: netfilter-devel@vger.kernel.org, fw@strlen.de, ffmancera@suse.de
Subject: Re: [PATCH nf,v4] netfilter: ctnetlink: ignore explicit helper on
 new expectations
Message-ID: <acrSzf1HIUhy8DTf@chamomile>
References: <20260330143627.892413-1-pablo@netfilter.org>
 <609becce-893f-43ea-ac1b-dbfd11a7e60d@suse.de>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <609becce-893f-43ea-ac1b-dbfd11a7e60d@suse.de>

On Mon, Mar 30, 2026 at 05:46:16PM +0200, Fernando Fernandez Mancera wrote:
> On 3/30/26 4:36 PM, Pablo Neira Ayuso wrote:
> > Use the existing master conntrack helper, anything else is not really
> > supported and it just makes validation more complicated, so just ignore
> > what helper userspace suggests for this expectation.
> > 
> > This was uncovered when validating CTA_EXPECT_CLASS via different helper
> > provided by userspace than the existing master conntrack helper:
> > 
> >    BUG: KASAN: slab-out-of-bounds in nf_ct_expect_related_report+0x2479/0x27c0
> >    Read of size 4 at addr ffff8880043fe408 by task poc/102
> >    Call Trace:
> >     nf_ct_expect_related_report+0x2479/0x27c0
> >     ctnetlink_create_expect+0x22b/0x3b0
> >     ctnetlink_new_expect+0x4bd/0x5c0
> >     nfnetlink_rcv_msg+0x67a/0x950
> >     netlink_rcv_skb+0x120/0x350
> > 
> > Allowing to read kernel memory bytes off the expectation boundary.
> > 
> > CTA_EXPECT_HELP_NAME is still used to offer the helper name to userspace
> > via netlink dump.
> > 
> > Fixes: bd0779370588 ("netfilter: nfnetlink_queue: allow to attach expectations to conntracks")
> > Reported-by: Qi Tang <tpluszz77@gmail.com>
> > Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
> > ---
> > v4: actually... remove this entire refetch
> > 
> > @@ -3576,8 +3569,6 @@ ctnetlink_alloc_expect(const struct nlattr * const cda[], struct nf_conn *ct,
> >   #ifdef CONFIG_NF_CONNTRACK_ZONES
> >          exp->zone = ct->zone;
> >   #endif
> > -       if (!helper)
> > -               helper = rcu_dereference(help->helper);
> >          rcu_assign_pointer(exp->helper, helper);
> >          exp->tuple = *tuple;
> >          exp->mask.src.u3 = mask->src.u3;
> > 
> 
> Just a note, I spend some time trying to apply the patch due to this. Drop
> it before running git am if you are experiencing the same problem.
> 
> > 
> >   net/netfilter/nf_conntrack_netlink.c | 54 +++++-----------------------
> >   1 file changed, 9 insertions(+), 45 deletions(-)
> > 
> > diff --git a/net/netfilter/nf_conntrack_netlink.c b/net/netfilter/nf_conntrack_netlink.c
> > index 35f859b24103..ec6771a0926c 100644
> > --- a/net/netfilter/nf_conntrack_netlink.c
> > +++ b/net/netfilter/nf_conntrack_netlink.c
> > @@ -2636,7 +2636,6 @@ static const struct nla_policy exp_nla_policy[CTA_EXPECT_MAX+1] = {
> >   static struct nf_conntrack_expect *
> >   ctnetlink_alloc_expect(const struct nlattr *const cda[], struct nf_conn *ct,
> > -		       struct nf_conntrack_helper *helper,
> >   		       struct nf_conntrack_tuple *tuple,
> >   		       struct nf_conntrack_tuple *mask);
> > @@ -2865,7 +2864,6 @@ ctnetlink_glue_attach_expect(const struct nlattr *attr, struct nf_conn *ct,
> >   {
> >   	struct nlattr *cda[CTA_EXPECT_MAX+1];
> >   	struct nf_conntrack_tuple tuple, mask;
> > -	struct nf_conntrack_helper *helper = NULL;
> >   	struct nf_conntrack_expect *exp;
> >   	int err;
> > @@ -2879,17 +2877,8 @@ ctnetlink_glue_attach_expect(const struct nlattr *attr, struct nf_conn *ct,
> >   	if (err < 0)
> >   		return err;
> > -	if (cda[CTA_EXPECT_HELP_NAME]) {
> > -		const char *helpname = nla_data(cda[CTA_EXPECT_HELP_NAME]);
> > -
> > -		helper = __nf_conntrack_helper_find(helpname, nf_ct_l3num(ct),
> > -						    nf_ct_protonum(ct));
> > -		if (helper == NULL)
> > -			return -EOPNOTSUPP;
> > -	}
> > -
> 
> I wonder if we should return -EOPNOTSUPP here and be explicit about it.

You mean:

        if (cda[CTA_EXPECT_HELP_NAME])
                return -EOPNOTSUPP;

I cannot do it, there is at least one userspace conntrack helper that
would break (ssdp).

> I know the rule is "do not break userspace" but as you mentioned on the
> commit message, this was not really supported. Better just explicitly fail
> so if by any chance someone expects this to work, they will notice.

What I could do is to check if the helper name specified by
CTA_EXPECT_HELP_NAME is the same as the master conntrack helper. But
then I have to keep this code only to validate that expectation is
using. And this attribute has been an optional attribute this far,
userspace could just skip it.

I could only find one conntrack helper in userspace that sets on this
attribute (ssdp), and it is setting it to the same helper that the
master conntrack is using.

I think it is not worth the effort, simply removing this code to fix
this issue should be fine, this simplifies this control plane path.
