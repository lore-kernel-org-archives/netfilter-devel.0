From: Paul Moore <paul.moore@hp.com>
Subject: Re: [PATCH 4/5] conntrack: export lsm context rather than internal
 secid via netlink
Date: Wed, 13 Oct 2010 09:41:44 -0400
Message-ID: <1286977304.5007.5.camel@sifl>
References: <20101012154008.26943.44399.stgit@paris.rdu.redhat.com>
	 <20101012154028.26943.6918.stgit@paris.rdu.redhat.com>
	 <1286925284.5133.98.camel@sifl>
	 <1286925891.2614.13.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: linux-kernel@vger.kernel.org, netfilter-devel@vger.kernel.org,
	netfilter@vger.kernel.org, jmorris@namei.org,
	selinux@tycho.nsa.gov, sds@tycho.nsa.gov, jengelh@medozas.de,
	linux-security-module@vger.kernel.org, mr.dash.four@googlemail.com,
	pablo@netfilter.org
To: Eric Paris <eparis@redhat.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from g1t0026.austin.hp.com ([15.216.28.33]:7045 "EHLO
	g1t0026.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752464Ab0JMNlt (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 13 Oct 2010 09:41:49 -0400
In-Reply-To: <1286925891.2614.13.camel@localhost.localdomain>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Tue, 2010-10-12 at 19:24 -0400, Eric Paris wrote:
> On Tue, 2010-10-12 at 19:14 -0400, Paul Moore wrote:
> > > -ctnetlink_dump_secmark(struct sk_buff *skb, const struct nf_conn *ct)
> > > +ctnetlink_dump_secctx(struct sk_buff *skb, const struct nf_conn *ct)
> > >  {
> > > -	NLA_PUT_BE32(skb, CTA_SECMARK, htonl(ct->secmark));
> > > -	return 0;
> > > +	struct nlattr *nest_secctx;
> > > +	int len, ret;
> > > +	char *secctx;
> > > +
> > > +	ret = security_secid_to_secctx(ct->secmark, &secctx, &len);
> > > +	if (ret)
> > > +		return ret;
> > > +
> > > +	ret = -1;
> > > +	nest_secctx = nla_nest_start(skb, CTA_SECCTX | NLA_F_NESTED);
> > > +	if (!nest_secctx)
> > > +		goto nla_put_failure;
> > >  
> > > +	NLA_PUT_STRING(skb, CTA_SECCTX_NAME, secctx);
> > > +	nla_nest_end(skb, nest_secctx);
> > > +
> > > +	ret = 0;
> > >  nla_put_failure:
> > > -	return -1;
> > > +	security_release_secctx(secctx, len);
> > > +	return ret;
> > >  }
> > 
> > All the ret assignments bother me, I also don't think "nla_put_failure"
> > is a good choice since we run this code both on success and failure -
> > how about this:
> 
> #define NLA_PUT(skb, attrtype, attrlen, data) \
>         do { \
>                 if (unlikely(nla_put(skb, attrtype, attrlen, data) < 0)) \
>                         goto nla_put_failure; \
>         } while(0)
> 
> #define NLA_PUT_STRING(skb, attrtype, value) \
>         NLA_PUT(skb, attrtype, strlen(value) + 1, value)
> 
> so we can't get rid of the nla_put_failure tag and it also means your
> ret values aren't quite right, we have to set ret = -1 before the
> NLA_PUT_STRING()....

Ah, yes, forgot about those stupid macros and their pre-defined goto
labels ... I'm sure someone had a good reason for doing it that way, but
I've never been a fan of that approach (case in point).  I'd ask you to
use the "normal" nla_put_*() functions but I see that the rest of the
file uses the macros so it probably isn't worth it ... oh well.

Reviewed-by: Paul Moore <paul.moore@hp.com>

-- 
paul moore
linux @ hp


