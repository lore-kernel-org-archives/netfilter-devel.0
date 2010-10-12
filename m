From: Eric Paris <eparis@redhat.com>
Subject: Re: [PATCH 4/5] conntrack: export lsm context rather than internal
 secid via netlink
Date: Tue, 12 Oct 2010 19:24:51 -0400
Message-ID: <1286925891.2614.13.camel@localhost.localdomain>
References: <20101012154008.26943.44399.stgit@paris.rdu.redhat.com>
	 <20101012154028.26943.6918.stgit@paris.rdu.redhat.com>
	 <1286925284.5133.98.camel@sifl>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Cc: linux-kernel@vger.kernel.org, netfilter-devel@vger.kernel.org,
	netfilter@vger.kernel.org, jmorris@namei.org,
	selinux@tycho.nsa.gov, sds@tycho.nsa.gov, jengelh@medozas.de,
	linux-security-module@vger.kernel.org, mr.dash.four@googlemail.com,
	pablo@netfilter.org
To: Paul Moore <paul.moore@hp.com>
Return-path: <linux-security-module-owner@vger.kernel.org>
In-Reply-To: <1286925284.5133.98.camel@sifl>
Sender: linux-security-module-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

On Tue, 2010-10-12 at 19:14 -0400, Paul Moore wrote:
> On Tue, 2010-10-12 at 11:40 -0400, Eric Paris wrote:
> > The conntrack code can export the internal secid to userspace.  These are
> > dynamic, can change on lsm changes, and have no meaning in userspace.  We
> > should instead be sending lsm contexts to userspace instead.  This patch sends
> > the secctx (rather than secid) to userspace over the netlink socket.  We use a
> > new field CTA_SECCTX and stop using the the old CTA_SECMARK field since it did
> > not send particularly useful information.
> 
> Looks fine to me in principal, just a nit-picky comment below ...
> 
> > -ctnetlink_dump_secmark(struct sk_buff *skb, const struct nf_conn *ct)
> > +ctnetlink_dump_secctx(struct sk_buff *skb, const struct nf_conn *ct)
> >  {
> > -	NLA_PUT_BE32(skb, CTA_SECMARK, htonl(ct->secmark));
> > -	return 0;
> > +	struct nlattr *nest_secctx;
> > +	int len, ret;
> > +	char *secctx;
> > +
> > +	ret = security_secid_to_secctx(ct->secmark, &secctx, &len);
> > +	if (ret)
> > +		return ret;
> > +
> > +	ret = -1;
> > +	nest_secctx = nla_nest_start(skb, CTA_SECCTX | NLA_F_NESTED);
> > +	if (!nest_secctx)
> > +		goto nla_put_failure;
> >  
> > +	NLA_PUT_STRING(skb, CTA_SECCTX_NAME, secctx);
> > +	nla_nest_end(skb, nest_secctx);
> > +
> > +	ret = 0;
> >  nla_put_failure:
> > -	return -1;
> > +	security_release_secctx(secctx, len);
> > +	return ret;
> >  }
> 
> All the ret assignments bother me, I also don't think "nla_put_failure"
> is a good choice since we run this code both on success and failure -
> how about this:

#define NLA_PUT(skb, attrtype, attrlen, data) \
        do { \
                if (unlikely(nla_put(skb, attrtype, attrlen, data) < 0)) \
                        goto nla_put_failure; \
        } while(0)

#define NLA_PUT_STRING(skb, attrtype, value) \
        NLA_PUT(skb, attrtype, strlen(value) + 1, value)

so we can't get rid of the nla_put_failure tag and it also means your
ret values aren't quite right, we have to set ret = -1 before the
NLA_PUT_STRING()....

> ctnetlink_dump_secctx(struct sk_buff *skb, const struct nf_conn *ct)
> {
> 	struct nlattr *nest_secctx;
> 	int len, ret;
> 	char *secctx;
> 
> 	ret = security_secid_to_secctx(ct->secmark, &secctx, &len);
> 	if (ret)
> 		return ret;
> 
> 	nest_secctx = nla_nest_start(skb, CTA_SECCTX | NLA_F_NESTED);
> 	if (!nest_secctx) {
> 		ret = -1;
> 		goto dump_secctx_out;
> 	}
> 
> 	NLA_PUT_STRING(skb, CTA_SECCTX_NAME, secctx);
> 	nla_nest_end(skb, nest_secctx);
> 
> dump_secctx_out:
> 	security_release_secctx(secctx, len);
> 	return ret;
> }
> 


