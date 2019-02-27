Return-Path: <SRS0=q2Xo=RC=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_MUTT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 397DCC43381
	for <netfilter-devel@archiver.kernel.org>; Wed, 27 Feb 2019 11:15:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 13A5620851
	for <netfilter-devel@archiver.kernel.org>; Wed, 27 Feb 2019 11:15:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727967AbfB0LP1 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 27 Feb 2019 06:15:27 -0500
Received: from orbyte.nwl.cc ([151.80.46.58]:49796 "EHLO orbyte.nwl.cc"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726062AbfB0LP1 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 27 Feb 2019 06:15:27 -0500
Received: from n0-1 by orbyte.nwl.cc with local (Exim 4.91)
        (envelope-from <n0-1@orbyte.nwl.cc>)
        id 1gyxBO-0001hB-0U; Wed, 27 Feb 2019 12:15:26 +0100
Date:   Wed, 27 Feb 2019 12:15:26 +0100
From:   Phil Sutter <phil@nwl.cc>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org
Subject: Re: [nft PATCH 4/5] json: Fix memleaks in echo support
Message-ID: <20190227111525.GF2478@orbyte.nwl.cc>
Mail-Followup-To: Phil Sutter <phil@nwl.cc>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        netfilter-devel@vger.kernel.org
References: <20190226211342.15125-1-phil@nwl.cc>
 <20190226211342.15125-5-phil@nwl.cc>
 <20190227102920.waqyt4kp7e7bc7wo@salvia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190227102920.waqyt4kp7e7bc7wo@salvia>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Hi Pablo,

On Wed, Feb 27, 2019 at 11:29:20AM +0100, Pablo Neira Ayuso wrote:
> On Tue, Feb 26, 2019 at 10:13:41PM +0100, Phil Sutter wrote:
> > When extracting netlink message data for populating JSON objects with
> > handles, allocated nftnl objects were not freed. Though since freeing
> > these objects also frees retrieved string attributes, copy them using
> > strdupa() which takes care of memory deallocation upon function return.
> > This is ideal since these strings are used only to find the right JSON
> > object to insert the handle into.
> > 
> > Fixes: bb32d8db9a125 ("JSON: Add support for echo option")
> > Signed-off-by: Phil Sutter <phil@nwl.cc>
> > ---
> >  src/parser_json.c | 28 ++++++++++++++++++----------
> >  1 file changed, 18 insertions(+), 10 deletions(-)
> > 
> > diff --git a/src/parser_json.c b/src/parser_json.c
> > index 6755d39c34f0a..c92113ba516c2 100644
> > --- a/src/parser_json.c
> > +++ b/src/parser_json.c
> > @@ -1,3 +1,4 @@
> > +#define _GNU_SOURCE
> >  #include <errno.h>
> >  #include <stdint.h> /* needed by gmputil.h */
> >  #include <string.h>
> > @@ -3485,8 +3486,9 @@ static int json_update_table(struct netlink_mon_handler *monh,
> >  
> >  	nlt = netlink_table_alloc(nlh);
> >  	family = family2str(nftnl_table_get_u32(nlt, NFTNL_TABLE_FAMILY));
> > -	name = nftnl_table_get_str(nlt, NFTNL_TABLE_NAME);
> > +	name = strdupa(nftnl_table_get_str(nlt, NFTNL_TABLE_NAME));
> 
> Hm, I still don't see why we need this strdupa() call...
> 
> >  	handle = nftnl_table_get_u64(nlt, NFTNL_TABLE_HANDLE);
> > +	nftnl_table_free(nlt);
> 
> The table name attribute is owned by the nlt object.
> 
> This is used by obj_info_matches() which doesn't take this?

Strictly it is not necessary, but the call to nftnl_table_free() would
have to be delayed till after the search. Since the function either
returns from the loop or after it, I would either duplicate the free
call or have to introduce some return value handling.

The original problem is that I first extract the table name using
nftnl_table_get_str(), then two lines later free the nftnl_table object
(which makes the extracted const char *name point at freed memory).

The semantics I follow in all those update functions is:

1) parse netlink message into nftnl object
2) extract required info from nftnl object
3) free nftnl object again (since it's not used anymore afterwards)
4) lookup JSON object with data from (2) and insert handle (also from
(2)).

Using strdupa() allows for this without the need for a final cleanup
step.

Cheers, Phil


