From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH nf-next 1/3] netfilter: nf_tables: add generation mask to
 table objects
Date: Tue, 4 Aug 2015 19:04:47 +0200
Message-ID: <20150804170447.GA3355@salvia>
References: <1438679128-4146-1-git-send-email-pablo@netfilter.org>
 <20150804090917.GA6033@acer.localdomain>
 <20150804092905.GA7944@salvia>
 <20150804102635.GC6033@acer.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:55390 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752607AbbHDQ6z (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 4 Aug 2015 12:58:55 -0400
Content-Disposition: inline
In-Reply-To: <20150804102635.GC6033@acer.localdomain>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Tue, Aug 04, 2015 at 12:26:35PM +0200, Patrick McHardy wrote:
> On 04.08, Pablo Neira Ayuso wrote:
> > On Tue, Aug 04, 2015 at 11:09:17AM +0200, Patrick McHardy wrote:
[...]
> > > I have a similar patch queued up, however there seems to be something missing
> > > in this patch. The lookup functions need to take the genmask into account.
> > 
> > They already do for the deletion case, so we hit -ENOENT for objects
> > that has been deleted in this batch, so we cannot delete objects
> > twice.
> 
> > @@ -829,10 +860,10 @@ static int nf_tables_deltable(struct sock *nlsk, struct sk_buff *skb,
> >       if (IS_ERR(afi))
> >               return PTR_ERR(afi);
> 
> > -	table = nf_tables_table_lookup(afi, nla[NFTA_TABLE_NAME]);
> > +	table = nf_tables_table_lookup(net, afi, nla[NFTA_TABLE_NAME], true);
> >       if (IS_ERR(table))
> >               return PTR_ERR(table);
> > -	if (table->flags & NFT_TABLE_INACTIVE)
> > +	if (!nft_table_is_active(net, table))
>                 return -ENOENT;
> 
> Looking at it, that part seems wrong. They need to be active in the *next*
> generation, not the current one, to be deleted. All netlink actions only
> affect the next generation.
> 
> The same bug is present in multiple locations.

That check is there to avoid the deletion of a table that has been
added in this batch, unlike the delete + add, the add + delete in the
same batch doesn't make much sense.

Revisiting this scenario, this how this looks if we remove that check:

preparation starts:

add: table X (10), added to table list (now inactive)
del: table X (11), inactive next.
              ^
              gencursor

commit starts (update gencursor):

add: table X (01): clear past and report event, *NOTE*: the rule table is inactive.
add: table X (01): delete from list and report event.
               ^
               gencursor

So it seems it should be fine to remove it as it is defensive. I think
robots can generate this kind of command placing updates in a batch,
anyway that should come in a follow up patch IMO.

> > > Otherwise you can not delete and add a new table in the same batch. The same
> > > holds for all other object types.
> > 
> > I can with this patch, we always operate with the *next* bit to
> > indicate that the object will be inactive in the future.
> > 
> > > > +static struct nft_table *nf_tables_table_lookup(struct net *net,
> > > > +						const struct nft_af_info *afi,
> > > > +						const struct nlattr *nla,
> > > > +						bool trans)
> > > >  {
> > > >  	struct nft_table *table;
> > > >  
> > > > @@ -382,10 +411,10 @@ static struct nft_table *nf_tables_table_lookup(const struct nft_af_info *afi,
> > > >  		return ERR_PTR(-EINVAL);
> > > >  
> > > >  	table = nft_table_lookup(afi, nla);
> > > > -	if (table != NULL)
> > > > -		return table;
> > > > +	if (table == NULL || (trans && !nft_table_is_active_next(net, table)))
> > > > +		return ERR_PTR(-ENOENT);
> > > 
> > > We really need to check the genid itself, in some cases we *only* want
> > > currently active tables, f.i. gettable and dumps.
> > 
> > This is what this patch is doing from the dump path.
> > 
> > We shouldn't check if the object is active from the lookup function if
> > we're in the middle of a transaction, since we hold the lock there is
> > no way we can see inactive objects in the list. There's only one
> > transaction at the same time.
> 
> That's not entirely correct. Dump continuations happen asynchronously to
> netlink modifications and commit operations, so the genid may bump in the
> middle. We can get an inconsistent view if we have:
> 
> 			dump set elements from set x table y
> delete table y
> create table y
> create set x
> begin commit
> 			continue dump from new set

We catch this from the nfnlhdr->res_id field in the nfnetlink message,
but see below.

> commit, send NEWGEN
> 
> Sure, we will get a NEWGEN message, but at that time we might already have
> sent a full message for the new table/set since that message is only send
> after the commit is completed.

I agree in that an event message at the beginning of the commit phase
to announce the beginning new generation and another one to indicate
of this transaction.

- preparation phase -
delete table y
create table y
create set x
- commit phase -
send NEWGEN, attribute type: begin
delete table y
create table y
create set x
send NEWGEN, attribute type: end

Thanks for your feedback!
