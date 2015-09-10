From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH RFC 1/3] netfilter: ctnetlink: remove
 ctnetlink_nfqueue_build_size()
Date: Thu, 10 Sep 2015 02:12:17 +0200
Message-ID: <20150910001217.GD5734@salvia>
References: <1441731291-21342-1-git-send-email-pablo@netfilter.org>
 <1441731291-21342-2-git-send-email-pablo@netfilter.org>
 <20150909095321.GB11843@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Ken-ichirou MATSUZAWA <chamaken@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:33183 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752283AbbIJAFl (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 9 Sep 2015 20:05:41 -0400
Content-Disposition: inline
In-Reply-To: <20150909095321.GB11843@gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Wed, Sep 09, 2015 at 06:53:21PM +0900, Ken-ichirou MATSUZAWA wrote:
> On Tue, Sep 08, 2015 at 06:54:49PM +0200, Pablo Neira Ayuso wrote:
> [...]
> > diff --git a/net/netfilter/nf_conntrack_netlink.c b/net/netfilter/nf_conntrack_netlink.c
> > index 94a6654..5fd3d48 100644
> > --- a/net/netfilter/nf_conntrack_netlink.c
> > +++ b/net/netfilter/nf_conntrack_netlink.c
> > @@ -596,11 +596,9 @@ ctnetlink_timestamp_size(const struct nf_conn *ct)
> >  #endif
> >  }
> >  
> > -static inline size_t
> > -ctnetlink_nlmsg_size(const struct nf_conn *ct)
> > +static size_t ctnetlink_nlmsg_payload_size(const struct nf_conn *ct)
> >  {
> > -	return NLMSG_ALIGN(sizeof(struct nfgenmsg))
> > -	       + 3 * nla_total_size(0) /* CTA_TUPLE_ORIG|REPL|MASTER */
> > +	return   3 * nla_total_size(0) /* CTA_TUPLE_ORIG|REPL|MASTER */
> >  	       + 3 * nla_total_size(0) /* CTA_TUPLE_IP */
> >  	       + 3 * nla_total_size(0) /* CTA_TUPLE_PROTO */
> >  	       + 3 * nla_total_size(sizeof(u_int8_t)) /* CTA_PROTO_NUM */
> > @@ -628,6 +626,12 @@ ctnetlink_nlmsg_size(const struct nf_conn *ct)
> >  	       ;
> >  }
> >  
> > +static size_t ctnetlink_nlmsg_size(const struct nf_conn *ct)
> > +{
> > +	return NLMSG_ALIGN(sizeof(struct nfgenmsg)) +
> > +	       ctnetlink_nlmsg_payload_size(ct);
> > +}
> > +
> >  #ifdef CONFIG_NF_CONNTRACK_EVENTS
> >  static int
> >  ctnetlink_conntrack_event(unsigned int events, struct nf_ct_event *item)
> > @@ -2134,34 +2138,6 @@ ctnetlink_alloc_expect(const struct nlattr *const cda[], struct nf_conn *ct,
> >  		       struct nf_conntrack_tuple *mask);
> >  
> >  #ifdef CONFIG_NETFILTER_NETLINK_QUEUE_CT
> > -static size_t
> > -ctnetlink_nfqueue_build_size(const struct nf_conn *ct)
> 
> A little apart from this issue, it seems that original
> ctnetlink_nlmsg_size() lacks CTA_USE size.
> 
> A conntrack information attached to nfqueue does not have
> CTA_COUNTERS_ and also CTA_USE attrs, but this change allocates
> a space for it. If we reuse ctnetlink_nlmsg_size() to avoid a
> code duplication, I think it would be better to comment it.

You're right, I have to revisit this. Will send a v2 of this patchset.
