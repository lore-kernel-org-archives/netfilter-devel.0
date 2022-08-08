Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 44D45C00140
	for <netfilter-devel@archiver.kernel.org>; Mon,  8 Aug 2022 17:49:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233488AbiHHRts (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 8 Aug 2022 13:49:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54422 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244117AbiHHRt0 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 8 Aug 2022 13:49:26 -0400
Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id D670217AB4
        for <netfilter-devel@vger.kernel.org>; Mon,  8 Aug 2022 10:48:46 -0700 (PDT)
Date:   Mon, 8 Aug 2022 19:48:44 +0200
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     "Keller, Jacob E" <jacob.e.keller@intel.com>
Cc:     Netfilter Devel <netfilter-devel@vger.kernel.org>,
        Duncan Roe <duncan_roe@optusnet.com.au>
Subject: Re: [PATCH libmnl v2 2/2] libmnl: add support for signed types
Message-ID: <YvFMfK5eeDbr2n0t@salvia>
References: <20220805210040.2827875-1-jacob.e.keller@intel.com>
 <20220805210040.2827875-2-jacob.e.keller@intel.com>
 <YvEZEcLT5t1SBVcc@salvia>
 <PH0PR11MB50955D3ADF0ED245A778D94FD6639@PH0PR11MB5095.namprd11.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <PH0PR11MB50955D3ADF0ED245A778D94FD6639@PH0PR11MB5095.namprd11.prod.outlook.com>
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Mon, Aug 08, 2022 at 05:46:50PM +0000, Keller, Jacob E wrote:
> 
> 
> > -----Original Message-----
> > From: Pablo Neira Ayuso <pablo@netfilter.org>
> > Sent: Monday, August 08, 2022 7:09 AM
> > To: Keller, Jacob E <jacob.e.keller@intel.com>
> > Cc: Netfilter Devel <netfilter-devel@vger.kernel.org>; Duncan Roe
> > <duncan_roe@optusnet.com.au>
> > Subject: Re: [PATCH libmnl v2 2/2] libmnl: add support for signed types
> > 
> > Hi,
> > 
> > On Fri, Aug 05, 2022 at 02:00:40PM -0700, Jacob Keller wrote:
> > > libmnl has get and put functions for unsigned integer types. It lacks
> > > support for the signed variations. On some level this is technically
> > > sufficient. A user could use the unsigned variations and then cast to a
> > > signed value at use. However, this makes resulting code in the application
> > > more difficult to follow. Introduce signed variations of the integer get
> > > and put functions.
> > >
> > > Signed-off-by: Jacob Keller <jacob.e.keller@intel.com>
> > > ---
> > >  include/libmnl/libmnl.h |  16 ++++
> > >  src/attr.c              | 194 +++++++++++++++++++++++++++++++++++++++-
> > >  2 files changed, 209 insertions(+), 1 deletion(-)
> > >
> > [...]
> > > @@ -127,6 +139,10 @@ enum mnl_attr_data_type {
> > >  	MNL_TYPE_U16,
> > >  	MNL_TYPE_U32,
> > >  	MNL_TYPE_U64,
> > > +	MNL_TYPE_S8,
> > > +	MNL_TYPE_S16,
> > > +	MNL_TYPE_S32,
> > > +	MNL_TYPE_S64,
> > 
> > This breaks ABI, you have to add new types at the end of the
> > enumeration.
> > 
> 
> To clarify, I believe this would be at the end just before MNL_TYPE_MAX?

Right after MNL_TYPE_BINARY, it is ok to update MNL_TYPE_MAX.
