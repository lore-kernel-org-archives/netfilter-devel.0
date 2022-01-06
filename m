Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 23BE6C433EF
	for <netfilter-devel@archiver.kernel.org>; Thu,  6 Jan 2022 13:11:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239396AbiAFNLE (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 6 Jan 2022 08:11:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39480 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238990AbiAFNLD (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 6 Jan 2022 08:11:03 -0500
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 14ED3C0611FF
        for <netfilter-devel@vger.kernel.org>; Thu,  6 Jan 2022 05:11:02 -0800 (PST)
Received: from n0-1 by orbyte.nwl.cc with local (Exim 4.94.2)
        (envelope-from <n0-1@orbyte.nwl.cc>)
        id 1n5SXi-0001Ny-J0; Thu, 06 Jan 2022 14:10:58 +0100
Date:   Thu, 6 Jan 2022 14:10:58 +0100
From:   Phil Sutter <phil@nwl.cc>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org
Subject: Re: [libnftnl PATCH 3/7] set: Introduce NFTNL_SET_DESC_CONCAT_DATA
Message-ID: <YdbqYswNOc+Me71m@orbyte.nwl.cc>
Mail-Followup-To: Phil Sutter <phil@nwl.cc>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        netfilter-devel@vger.kernel.org
References: <20211124172242.11402-1-phil@nwl.cc>
 <20211124172242.11402-4-phil@nwl.cc>
 <YaYrUvXHfPLBYskH@salvia>
 <20211130174558.GF29413@orbyte.nwl.cc>
 <YdXEp0TLNzkk1tBF@salvia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YdXEp0TLNzkk1tBF@salvia>
Sender:  <n0-1@orbyte.nwl.cc>
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Hey Pablo,

On Wed, Jan 05, 2022 at 05:17:43PM +0100, Pablo Neira Ayuso wrote:
> Sorry for taking a while to catch up on this.

No worries, thanks for looking into it.

> On Tue, Nov 30, 2021 at 06:45:58PM +0100, Phil Sutter wrote:
> > Hi Pablo,
> > 
> > On Tue, Nov 30, 2021 at 02:46:58PM +0100, Pablo Neira Ayuso wrote:
> > > On Wed, Nov 24, 2021 at 06:22:38PM +0100, Phil Sutter wrote:
> > > > Analogous to NFTNL_SET_DESC_CONCAT, introduce a data structure
> > > > describing individual data lengths of elements' concatenated data
> > > > fields.
> > > > 
> > > > Signed-off-by: Phil Sutter <phil@nwl.cc>
> > > > ---
> > > >  include/libnftnl/set.h | 1 +
> > > >  include/set.h          | 2 ++
> > > >  src/set.c              | 8 ++++++++
> > > >  3 files changed, 11 insertions(+)
> > > > 
> > > > diff --git a/include/libnftnl/set.h b/include/libnftnl/set.h
> > > > index 1ffb6c415260d..958bbc9065f67 100644
> > > > --- a/include/libnftnl/set.h
> > > > +++ b/include/libnftnl/set.h
> > > > @@ -33,6 +33,7 @@ enum nftnl_set_attr {
> > > >  	NFTNL_SET_EXPR,
> > > >  	NFTNL_SET_EXPRESSIONS,
> > > >  	NFTNL_SET_DESC_BYTEORDER,
> > > > +	NFTNL_SET_DESC_CONCAT_DATA,
> > > 
> > > This information is already encoded in NFTNL_SET_DATA_TYPE, the
> > > datatypes that are defined in libnftables have an explicit byteorder
> > > and length.
> > 
> > We don't define data types in libnftnl, merely expressions and (with
> > your patch) those define what byteorder the source/destination registers
> > are supposed to be.
> 
> OK.
> 
> > > For concatenation, this information is stored in 6 bits (see
> > > TYPE_BITS). By parsing the NFTNL_SET_DATA_TYPE field you can extract
> > > both types (and byteorders) of the set definition.
> > 
> > For this to work, I would have to duplicate nftables' enum datatypes and
> > in addition to that add an array defining each type's byteorder. I had
> > considered this once, but didn't like the amount of duplication.
> > 
> > > For the typeof case, where a generic datatype such as integer is used,
> > > this information is stored in the SET_USERDATA area.
> > 
> > This does not work for concatenated elements, right? At least I see e.g.
> > NFTNL_UDATA_SET_KEYBYTEORDER being set to set->key->byteorder, so that's
> > just a single value, no?
> > 
> > > This update for libnftnl is adding a third way to describe the
> > > datatypes in the set, right?
> > 
> > Well, it extends the logic around NFTNL_SET_DESC_CONCAT to non-interval
> > sets and to maps (adding the same data for the target part).
> > 
> > Then there is the new NFTNL_SET_DESC_BYTEORDER which defines the
> > byteorder of each part of the key (and value in maps).
> 
> I think it would be good to skip these new NFTNL_SET_DESC_* attributes
> since they are not used to pass a description to the kernel to help it
> select the best set type. So, instead of nftnl_set_elem_snprintf_desc(),
> it should be possible to add:
> 
> int nftnl_set_elem_snprintf2(char *buf, size_t size,
>                              const struct nftnl_set *s,
>                              const struct nftnl_set_elem *e,
>                              uint32_t type, uint32_t flags)
> 
> (or pick a better name if you come up with any other alternative).
> 
> So the nftnl_set object provides the byteorder notation to display the
> set element accordingly.

This is not sufficient per se - my series adds attributes to nftnl_set
to cover that. Passing the set itself is doable, I chose the
nftnl_set_desc way as it appeared a bit cleaner to me.

> This requires an extra conversion from struct set to struct nftnl_set
> for the debug case, that should be fine (--debug is slow path anyway).
> If this needs to be speed up later on, it should be possible to keep
> the nftnl_set object around as context.
> 
> Then, there is already NFTNL_UDATA_SET_KEYBYTEORDER and
> NFTNL_UDATA_SET_DATABYTEORDER which store the byteorder for key and
> data. I'm going to have a look at the userdata API since to see if I
> can propose an easy API to set and to get userdata information (this
> is currently a blob using TLVs that are stored in the kernel, but they
> are not interpreted by the kernel, it's only useful context
> information for userspace which is included in netlink dumps). This
> should fill missing gap in my proposal.

The two attributes hold a single byteorder value each. In order to
correctly print set elements, we need a value for each part of
concatenated elements. So for both key and data (key_end is always
identical to key), we need concat part length and byteorder.

> Looking at your series, I think it's better it's better to avoid the
> struct nftnl_set_desc definition that is exposed in the libnftnl
> header, this will not allow for future extensions without breaking
> binary compatibility. I understand your motivation is to avoid a
> duplicated definition in the libnftnl and nftables codebase.

I could introduce userdata attributes for the extra info to make things
more flexible, but it would bloat the data in kernel. OTOH this would
fix reverse path, when fetching data from kernel libnftnl lacks the
extra info to correctly dump the elements.

Cheers, Phil
