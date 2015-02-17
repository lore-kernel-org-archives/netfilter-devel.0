From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [libnftnl PATCH v2] ruleset: fix crash if we free sets included
 in the set_list
Date: Tue, 17 Feb 2015 15:28:23 +0100
Message-ID: <20150217142823.GA3950@salvia>
References: <1424181831-9027-1-git-send-email-alvaroneay@gmail.com>
 <20150217142609.GA3888@salvia>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Alvaro Neira Ayuso <alvaroneay@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:48852 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933347AbbBQOZJ (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 17 Feb 2015 09:25:09 -0500
Content-Disposition: inline
In-Reply-To: <20150217142609.GA3888@salvia>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Tue, Feb 17, 2015 at 03:26:09PM +0100, Pablo Neira Ayuso wrote:
> On Tue, Feb 17, 2015 at 03:03:51PM +0100, Alvaro Neira Ayuso wrote:
> > When we parse a ruleset which has a rule using a set. First step is parse the
> > set, set up an id and add it to a set list. Later, we use this set list to find
> > the set associated to the rule and we set up the set id to the expression
> > (lookup expression) of the rule.
> > 
> > The problem is if we return this set using the function
> > nft_ruleset_parse_file_cb and we free this set. We have a crash when we try to
> > iterate in the set list.
> > 
> > This patch solves it, cloning the set and adding the new set to the set list.
> > 
> > Signed-off-by: Alvaro Neira Ayuso <alvaroneay@gmail.com>
> > ---
> > [changes in v2]
> >  * Added the function to clone set and set elems.
> > 
> >  include/libnftnl/set.h |    2 ++
> >  src/ruleset.c          |    8 +++++++-
> >  src/set.c              |   52 ++++++++++++++++++++++++++++++++++++++++++++++++
> >  src/set_elem.c         |   27 +++++++++++++++++++++++++
> >  4 files changed, 88 insertions(+), 1 deletion(-)
> > 
> > diff --git a/include/libnftnl/set.h b/include/libnftnl/set.h
> > index 7f3504f..3f8ef87 100644
> > --- a/include/libnftnl/set.h
> > +++ b/include/libnftnl/set.h
> > @@ -42,6 +42,7 @@ const void *nft_set_attr_get_data(struct nft_set *s, uint16_t attr,
> >  				  uint32_t *data_len);
> >  const char *nft_set_attr_get_str(struct nft_set *s, uint16_t attr);
> >  uint32_t nft_set_attr_get_u32(struct nft_set *s, uint16_t attr);
> > +struct nft_set *nft_set_clone(const struct nft_set *set);
> >  
> >  struct nlmsghdr;
> >  
> > @@ -103,6 +104,7 @@ const char *nft_set_elem_attr_get_str(struct nft_set_elem *s, uint16_t attr);
> >  uint32_t nft_set_elem_attr_get_u32(struct nft_set_elem *s, uint16_t attr);
> >  
> >  bool nft_set_elem_attr_is_set(const struct nft_set_elem *s, uint16_t attr);
> > +struct nft_set_elem *nft_set_elem_clone(struct nft_set_elem *elem);
> >  
> >  #define nft_set_elem_nlmsg_build_hdr	nft_nlmsg_build_hdr
> >  void nft_set_elems_nlmsg_build_payload(struct nlmsghdr *nlh, struct nft_set *s);
> > diff --git a/src/ruleset.c b/src/ruleset.c
> > index 89ea344..bc669c0 100644
> > --- a/src/ruleset.c
> > +++ b/src/ruleset.c
> > @@ -312,8 +312,14 @@ static int nft_ruleset_parse_set(struct nft_parse_ctx *ctx,
> >  				 struct nft_set *set, uint32_t type,
> >  				 struct nft_parse_err *err)
> >  {
> > +	struct nft_set *newset;
> > +
> >  	nft_set_attr_set_u32(set, NFT_SET_ATTR_ID, ctx->set_id++);
> > -	nft_set_list_add_tail(set, ctx->set_list);
> > +	newset = nft_set_clone(set);
> > +	if (newset == NULL)
> > +		goto err;
> > +
> > +	nft_set_list_add_tail(newset, ctx->set_list);
> >  
> >  	nft_ruleset_ctx_set_u32(ctx, NFT_RULESET_CTX_TYPE, type);
> >  	nft_ruleset_ctx_set(ctx, NFT_RULESET_CTX_SET, set);
> > diff --git a/src/set.c b/src/set.c
> > index c6c3301..5fd5245 100644
> > --- a/src/set.c
> > +++ b/src/set.c
> > @@ -249,6 +249,58 @@ uint32_t nft_set_attr_get_u32(struct nft_set *s, uint16_t attr)
> >  }
> >  EXPORT_SYMBOL(nft_set_attr_get_u32);
> >  
> > +struct nft_set *nft_set_clone(const struct nft_set *set)
> > +{
> > +	struct nft_set *newset;
> > +	struct nft_set_elem *elem, *tmp, *newelem;
> > +
> > +	newset = nft_set_alloc();
> > +	if (newset == NULL)
> > +		return NULL;
> > +
> 
> You better memcmpy() to save these many LOCs...
> 
> > +	if (set->flags & (1 << NFT_SET_ATTR_TABLE))
> > +		nft_set_attr_set_str(newset, NFT_SET_ATTR_TABLE, set->table);
> > +	if (set->flags & (1 << NFT_SET_ATTR_NAME))
> > +		nft_set_attr_set_str(newset, NFT_SET_ATTR_NAME, set->name);

Wait, you can memcpy of course. But make sure you clone fields that
are pointers too, otherwise both objects will pointer to the same
table and name. This will result in a crash if one of the objects is
releases and the second will have invalid references to released
memory.
