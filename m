Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A1ED3C433F5
	for <netfilter-devel@archiver.kernel.org>; Tue, 30 Nov 2021 17:46:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245169AbhK3Rt1 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 30 Nov 2021 12:49:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45922 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245156AbhK3RtV (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 30 Nov 2021 12:49:21 -0500
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 90A81C061574
        for <netfilter-devel@vger.kernel.org>; Tue, 30 Nov 2021 09:46:01 -0800 (PST)
Received: from n0-1 by orbyte.nwl.cc with local (Exim 4.94.2)
        (envelope-from <n0-1@orbyte.nwl.cc>)
        id 1ms7CY-00032Z-HP; Tue, 30 Nov 2021 18:45:58 +0100
Date:   Tue, 30 Nov 2021 18:45:58 +0100
From:   Phil Sutter <phil@nwl.cc>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org
Subject: Re: [libnftnl PATCH 3/7] set: Introduce NFTNL_SET_DESC_CONCAT_DATA
Message-ID: <20211130174558.GF29413@orbyte.nwl.cc>
Mail-Followup-To: Phil Sutter <phil@nwl.cc>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        netfilter-devel@vger.kernel.org
References: <20211124172242.11402-1-phil@nwl.cc>
 <20211124172242.11402-4-phil@nwl.cc>
 <YaYrUvXHfPLBYskH@salvia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YaYrUvXHfPLBYskH@salvia>
Sender:  <n0-1@orbyte.nwl.cc>
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Hi Pablo,

On Tue, Nov 30, 2021 at 02:46:58PM +0100, Pablo Neira Ayuso wrote:
> On Wed, Nov 24, 2021 at 06:22:38PM +0100, Phil Sutter wrote:
> > Analogous to NFTNL_SET_DESC_CONCAT, introduce a data structure
> > describing individual data lengths of elements' concatenated data
> > fields.
> > 
> > Signed-off-by: Phil Sutter <phil@nwl.cc>
> > ---
> >  include/libnftnl/set.h | 1 +
> >  include/set.h          | 2 ++
> >  src/set.c              | 8 ++++++++
> >  3 files changed, 11 insertions(+)
> > 
> > diff --git a/include/libnftnl/set.h b/include/libnftnl/set.h
> > index 1ffb6c415260d..958bbc9065f67 100644
> > --- a/include/libnftnl/set.h
> > +++ b/include/libnftnl/set.h
> > @@ -33,6 +33,7 @@ enum nftnl_set_attr {
> >  	NFTNL_SET_EXPR,
> >  	NFTNL_SET_EXPRESSIONS,
> >  	NFTNL_SET_DESC_BYTEORDER,
> > +	NFTNL_SET_DESC_CONCAT_DATA,
> 
> This information is already encoded in NFTNL_SET_DATA_TYPE, the
> datatypes that are defined in libnftables have an explicit byteorder
> and length.

We don't define data types in libnftnl, merely expressions and (with
your patch) those define what byteorder the source/destination registers
are supposed to be.

> For concatenation, this information is stored in 6 bits (see
> TYPE_BITS). By parsing the NFTNL_SET_DATA_TYPE field you can extract
> both types (and byteorders) of the set definition.

For this to work, I would have to duplicate nftables' enum datatypes and
in addition to that add an array defining each type's byteorder. I had
considered this once, but didn't like the amount of duplication.

> For the typeof case, where a generic datatype such as integer is used,
> this information is stored in the SET_USERDATA area.

This does not work for concatenated elements, right? At least I see e.g.
NFTNL_UDATA_SET_KEYBYTEORDER being set to set->key->byteorder, so that's
just a single value, no?

> This update for libnftnl is adding a third way to describe the
> datatypes in the set, right?

Well, it extends the logic around NFTNL_SET_DESC_CONCAT to non-interval
sets and to maps (adding the same data for the target part).

Then there is the new NFTNL_SET_DESC_BYTEORDER which defines the
byteorder of each part of the key (and value in maps).

Cheers, Phil
