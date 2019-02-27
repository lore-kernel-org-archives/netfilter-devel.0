Return-Path: <SRS0=q2Xo=RC=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_NEOMUTT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DD5C6C43381
	for <netfilter-devel@archiver.kernel.org>; Wed, 27 Feb 2019 22:29:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B13862183F
	for <netfilter-devel@archiver.kernel.org>; Wed, 27 Feb 2019 22:29:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730326AbfB0W3c (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 27 Feb 2019 17:29:32 -0500
Received: from mail.us.es ([193.147.175.20]:46554 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728397AbfB0W3c (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 27 Feb 2019 17:29:32 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 0A7871E8F82
        for <netfilter-devel@vger.kernel.org>; Wed, 27 Feb 2019 23:29:30 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id E9064DA856
        for <netfilter-devel@vger.kernel.org>; Wed, 27 Feb 2019 23:29:29 +0100 (CET)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id DE8FBDA84E; Wed, 27 Feb 2019 23:29:29 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 192D6DA844;
        Wed, 27 Feb 2019 23:29:27 +0100 (CET)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Wed, 27 Feb 2019 23:29:27 +0100 (CET)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from us.es (sys.soleta.eu [212.170.55.40])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: 1984lsi)
        by entrada.int (Postfix) with ESMTPSA id E7B054265A2F;
        Wed, 27 Feb 2019 23:29:26 +0100 (CET)
Date:   Wed, 27 Feb 2019 23:29:26 +0100
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Phil Sutter <phil@nwl.cc>, netfilter-devel@vger.kernel.org
Subject: Re: [nft PATCH 4/5] json: Fix memleaks in echo support
Message-ID: <20190227222926.bfj5p2d4civilbao@salvia>
References: <20190226211342.15125-1-phil@nwl.cc>
 <20190226211342.15125-5-phil@nwl.cc>
 <20190227102920.waqyt4kp7e7bc7wo@salvia>
 <20190227111525.GF2478@orbyte.nwl.cc>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190227111525.GF2478@orbyte.nwl.cc>
User-Agent: NeoMutt/20170113 (1.7.2)
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Wed, Feb 27, 2019 at 12:15:26PM +0100, Phil Sutter wrote:
> Hi Pablo,
> 
> On Wed, Feb 27, 2019 at 11:29:20AM +0100, Pablo Neira Ayuso wrote:
> > On Tue, Feb 26, 2019 at 10:13:41PM +0100, Phil Sutter wrote:
> > > When extracting netlink message data for populating JSON objects with
> > > handles, allocated nftnl objects were not freed. Though since freeing
> > > these objects also frees retrieved string attributes, copy them using
> > > strdupa() which takes care of memory deallocation upon function return.
> > > This is ideal since these strings are used only to find the right JSON
> > > object to insert the handle into.
> > > 
> > > Fixes: bb32d8db9a125 ("JSON: Add support for echo option")
> > > Signed-off-by: Phil Sutter <phil@nwl.cc>
> > > ---
> > >  src/parser_json.c | 28 ++++++++++++++++++----------
> > >  1 file changed, 18 insertions(+), 10 deletions(-)
> > > 
> > > diff --git a/src/parser_json.c b/src/parser_json.c
> > > index 6755d39c34f0a..c92113ba516c2 100644
> > > --- a/src/parser_json.c
> > > +++ b/src/parser_json.c
> > > @@ -1,3 +1,4 @@
> > > +#define _GNU_SOURCE
> > >  #include <errno.h>
> > >  #include <stdint.h> /* needed by gmputil.h */
> > >  #include <string.h>
> > > @@ -3485,8 +3486,9 @@ static int json_update_table(struct netlink_mon_handler *monh,
> > >  
> > >  	nlt = netlink_table_alloc(nlh);
> > >  	family = family2str(nftnl_table_get_u32(nlt, NFTNL_TABLE_FAMILY));
> > > -	name = nftnl_table_get_str(nlt, NFTNL_TABLE_NAME);
> > > +	name = strdupa(nftnl_table_get_str(nlt, NFTNL_TABLE_NAME));
> > 
> > Hm, I still don't see why we need this strdupa() call...
> > 
> > >  	handle = nftnl_table_get_u64(nlt, NFTNL_TABLE_HANDLE);
> > > +	nftnl_table_free(nlt);
> > 
> > The table name attribute is owned by the nlt object.
> > 
> > This is used by obj_info_matches() which doesn't take this?
> 
> Strictly it is not necessary, but the call to nftnl_table_free() would
> have to be delayed till after the search. Since the function either
> returns from the loop or after it, I would either duplicate the free
> call or have to introduce some return value handling.
>
> The original problem is that I first extract the table name using
> nftnl_table_get_str(), then two lines later free the nftnl_table object
> (which makes the extracted const char *name point at freed memory).
>
> The semantics I follow in all those update functions is:
> 
> 1) parse netlink message into nftnl object
> 2) extract required info from nftnl object
> 3) free nftnl object again (since it's not used anymore afterwards)
> 4) lookup JSON object with data from (2) and insert handle (also from
> (2)).
> 
> Using strdupa() allows for this without the need for a final cleanup
> step.

OK, so the object is released and you just clone the fields that you
need around for the lookup, that's fine with me.

Not related to this patch: IIRC this echo support is not using the
nlmsg_seq to correlate the command and the result that we obtain,
right? Telling this because this should work with a batch that
contains several requests to create rules, then use this sequence
number to correlate things the reply with the original rule creation
command.
