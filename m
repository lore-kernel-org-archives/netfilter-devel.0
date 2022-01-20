Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0EF6AC433F5
	for <netfilter-devel@archiver.kernel.org>; Thu, 20 Jan 2022 00:09:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344803AbiATAJI (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 19 Jan 2022 19:09:08 -0500
Received: from mail.netfilter.org ([217.70.188.207]:37250 "EHLO
        mail.netfilter.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1357655AbiATAJC (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 19 Jan 2022 19:09:02 -0500
Received: from netfilter.org (unknown [78.30.32.163])
        by mail.netfilter.org (Postfix) with ESMTPSA id 1B16F60027;
        Thu, 20 Jan 2022 01:06:03 +0100 (CET)
Date:   Thu, 20 Jan 2022 01:08:57 +0100
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Phil Sutter <phil@nwl.cc>, netfilter-devel@vger.kernel.org
Subject: Re: [libnftnl PATCH 3/7] set: Introduce NFTNL_SET_DESC_CONCAT_DATA
Message-ID: <YeioGRrkH1wptut9@salvia>
References: <20211124172242.11402-1-phil@nwl.cc>
 <20211124172242.11402-4-phil@nwl.cc>
 <YaYrUvXHfPLBYskH@salvia>
 <20211130174558.GF29413@orbyte.nwl.cc>
 <YdXEp0TLNzkk1tBF@salvia>
 <YdbqYswNOc+Me71m@orbyte.nwl.cc>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <YdbqYswNOc+Me71m@orbyte.nwl.cc>
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Hi Phil,

On Thu, Jan 06, 2022 at 02:10:58PM +0100, Phil Sutter wrote:
> Hey Pablo,
> 
> On Wed, Jan 05, 2022 at 05:17:43PM +0100, Pablo Neira Ayuso wrote:
> > Sorry for taking a while to catch up on this.
> 
> No worries, thanks for looking into it.
> 
> > On Tue, Nov 30, 2021 at 06:45:58PM +0100, Phil Sutter wrote:
> > > Hi Pablo,
> > > 
> > > On Tue, Nov 30, 2021 at 02:46:58PM +0100, Pablo Neira Ayuso wrote:
> > > > On Wed, Nov 24, 2021 at 06:22:38PM +0100, Phil Sutter wrote:
> > > > > Analogous to NFTNL_SET_DESC_CONCAT, introduce a data structure
> > > > > describing individual data lengths of elements' concatenated data
> > > > > fields.
> > > > > 
> > > > > Signed-off-by: Phil Sutter <phil@nwl.cc>
> > > > > ---
> > > > >  include/libnftnl/set.h | 1 +
> > > > >  include/set.h          | 2 ++
> > > > >  src/set.c              | 8 ++++++++
> > > > >  3 files changed, 11 insertions(+)
> > > > > 
> > > > > diff --git a/include/libnftnl/set.h b/include/libnftnl/set.h
> > > > > index 1ffb6c415260d..958bbc9065f67 100644
> > > > > --- a/include/libnftnl/set.h
> > > > > +++ b/include/libnftnl/set.h
> > > > > @@ -33,6 +33,7 @@ enum nftnl_set_attr {
> > > > >  	NFTNL_SET_EXPR,
> > > > >  	NFTNL_SET_EXPRESSIONS,
> > > > >  	NFTNL_SET_DESC_BYTEORDER,
> > > > > +	NFTNL_SET_DESC_CONCAT_DATA,
> > > > 
> > > > This information is already encoded in NFTNL_SET_DATA_TYPE, the
> > > > datatypes that are defined in libnftables have an explicit byteorder
> > > > and length.
> > > 
> > > We don't define data types in libnftnl, merely expressions and (with
> > > your patch) those define what byteorder the source/destination registers
> > > are supposed to be.
> > 
> > OK.
> > 
> > > > For concatenation, this information is stored in 6 bits (see
> > > > TYPE_BITS). By parsing the NFTNL_SET_DATA_TYPE field you can extract
> > > > both types (and byteorders) of the set definition.
> > > 
> > > For this to work, I would have to duplicate nftables' enum datatypes and
> > > in addition to that add an array defining each type's byteorder. I had
> > > considered this once, but didn't like the amount of duplication.
> > > 
> > > > For the typeof case, where a generic datatype such as integer is used,
> > > > this information is stored in the SET_USERDATA area.
> > > 
> > > This does not work for concatenated elements, right? At least I see e.g.
> > > NFTNL_UDATA_SET_KEYBYTEORDER being set to set->key->byteorder, so that's
> > > just a single value, no?
> > > 
> > > > This update for libnftnl is adding a third way to describe the
> > > > datatypes in the set, right?
> > > 
> > > Well, it extends the logic around NFTNL_SET_DESC_CONCAT to non-interval
> > > sets and to maps (adding the same data for the target part).
> > > 
> > > Then there is the new NFTNL_SET_DESC_BYTEORDER which defines the
> > > byteorder of each part of the key (and value in maps).
> > 
> > I think it would be good to skip these new NFTNL_SET_DESC_* attributes
> > since they are not used to pass a description to the kernel to help it
> > select the best set type. So, instead of nftnl_set_elem_snprintf_desc(),
> > it should be possible to add:
> > 
> > int nftnl_set_elem_snprintf2(char *buf, size_t size,
> >                              const struct nftnl_set *s,
> >                              const struct nftnl_set_elem *e,
> >                              uint32_t type, uint32_t flags)
> > 
> > (or pick a better name if you come up with any other alternative).
> > 
> > So the nftnl_set object provides the byteorder notation to display the
> > set element accordingly.
> 
> This is not sufficient per se - my series adds attributes to nftnl_set
> to cover that. Passing the set itself is doable, I chose the
> nftnl_set_desc way as it appeared a bit cleaner to me.

I agree some sort of description is needed.

> > This requires an extra conversion from struct set to struct nftnl_set
> > for the debug case, that should be fine (--debug is slow path anyway).
> > If this needs to be speed up later on, it should be possible to keep
> > the nftnl_set object around as context.
> > 
> > Then, there is already NFTNL_UDATA_SET_KEYBYTEORDER and
> > NFTNL_UDATA_SET_DATABYTEORDER which store the byteorder for key and
> > data. I'm going to have a look at the userdata API since to see if I
> > can propose an easy API to set and to get userdata information (this
> > is currently a blob using TLVs that are stored in the kernel, but they
> > are not interpreted by the kernel, it's only useful context
> > information for userspace which is included in netlink dumps). This
> > should fill missing gap in my proposal.
> 
> The two attributes hold a single byteorder value each. In order to
> correctly print set elements, we need a value for each part of
> concatenated elements. So for both key and data (key_end is always
> identical to key), we need concat part length and byteorder.

Yes, NFTNL_UDATA_SET_KEYBYTEORDER and NFTNL_UDATA_SET_DATABYTEORDER do
not support for concatenations.

There is also NFTA_SET_DATA_TYPE which should be deprecated in favour
if the userdata area.

> > Looking at your series, I think it's better it's better to avoid the
> > struct nftnl_set_desc definition that is exposed in the libnftnl
> > header, this will not allow for future extensions without breaking
> > binary compatibility. I understand your motivation is to avoid a
> > duplicated definition in the libnftnl and nftables codebase.
> 
> I could introduce userdata attributes for the extra info to make things
> more flexible, but it would bloat the data in kernel. OTOH this would
> fix reverse path, when fetching data from kernel libnftnl lacks the
> extra info to correctly dump the elements.

There is a need to store the byteorder and length for integer types,
we agreed to not add integer_u{8,16,32,64} and integer_be{8,16,32,64}
to promote typeof to declare sets. This needs to be store in the
userdata area so the userspace set listing path have context to
interpret the netlink dump from the kernel.

I have scratch a bit of time to bootstrap this series:

https://patchwork.ozlabs.org/project/netfilter-devel/list/?series=281902

Let me know, thanks for your patience.
