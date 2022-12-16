Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E14C3C4332F
	for <netfilter-devel@archiver.kernel.org>; Fri, 16 Dec 2022 11:16:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230465AbiLPLQs (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 16 Dec 2022 06:16:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54140 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230444AbiLPLQc (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 16 Dec 2022 06:16:32 -0500
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:237:300::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 99D12F58F
        for <netfilter-devel@vger.kernel.org>; Fri, 16 Dec 2022 03:16:31 -0800 (PST)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@strlen.de>)
        id 1p68hY-0002Nc-Md; Fri, 16 Dec 2022 12:16:28 +0100
Date:   Fri, 16 Dec 2022 12:16:28 +0100
From:   Florian Westphal <fw@strlen.de>
To:     netfilter-devel <netfilter-devel@vger.kernel.org>
Cc:     ffmancera@riseup.net
Subject: repeated nft set add ignores changed parameters
Message-ID: <20221216111628.GA8767@breakpoint.cc>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

When re-adding an existing set no error is returned
and any changed parameters are ignored.

$ nft list ruleset | tee A
table ip nat {
     map m {
	typeof meta mark : ip saddr
	flags dynamic,timeout timeout 1h
   }
  }
}
$ $EDITOR $A  # change timeout
grep timeout\   A
timeout 1m
$ nft -f A
$ nft list ruleset|grep timeout\ 
timeout 1h


Is this a bug?  Is there really no alternative than to completely
zap the entire set/map?

Similar issue:
adding set bla, followed by map bla passes without error but 'map bla'
gets ignored.

On a related note, what happened to 'netfilter: nf_tables: add support
to destroy operation':

https://patchwork.ozlabs.org/project/netfilter-devel/patch/20221028100531.58666-1-ffmancera@riseup.net/

?

Some people are (rightfully) complaining that they need to do stupid
'add','delete' (or even add/delete/add!) games.

I don't really mind if we go with new commands (Fernandos patch), if we
change behaviour to ignore -ENOENT errors (in which case does it
makes sense to return an error...?) or if we add a nlmsg flag (kinda
inverse to NLMSG_F_EXCL), but current state is not nice at all.
