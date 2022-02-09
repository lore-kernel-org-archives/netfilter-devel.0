Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8D99DC433EF
	for <netfilter-devel@archiver.kernel.org>; Wed,  9 Feb 2022 16:26:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234055AbiBIQ0E (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 9 Feb 2022 11:26:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56302 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237009AbiBIQ0B (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 9 Feb 2022 11:26:01 -0500
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:12e:520::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AA5BBC0613C9
        for <netfilter-devel@vger.kernel.org>; Wed,  9 Feb 2022 08:26:04 -0800 (PST)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@strlen.de>)
        id 1nHpn9-0004bS-4R; Wed, 09 Feb 2022 17:26:03 +0100
Date:   Wed, 9 Feb 2022 17:26:03 +0100
From:   Florian Westphal <fw@strlen.de>
To:     Florian Westphal <fw@strlen.de>
Cc:     netfilter-devel@vger.kernel.org
Subject: Re: [PATCH nf-next 0/7] metfilter: remove pcpu dying list
Message-ID: <20220209162603.GA11480@breakpoint.cc>
References: <20220209161057.30688-1-fw@strlen.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220209161057.30688-1-fw@strlen.de>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Florian Westphal <fw@strlen.de> wrote:
> This is part 1 of a series that aims to remove both the unconfirmed
> and dying lists.

The unconfirmed list is requirement only because some extensions place
pointers to objects that reside in kernel modules without taking any
references, e.g. the conntrack helpers or timeout policies.

For normal conntracks, rmmod code path can walk the table and
set the affected pointers in the extension to NULL.
For the unconfirmed conntracks, this list gets used to flag those
conntracks as dying so tehy won't get inserted into the table anymore.

The replacement idea for the unconfirmed list is as follows (I have no
code yet):

1. add a generation id to the ct extension area, set at allocation
   time.
2. extend nf_ct_ext_find(): if conntrack is unconfirmed, only return
   the extension area if ext->genid == global_id.
3. at confirm time, delete the nf_conn entry if ext->genid != global_id.
4. whenever a helper module is removed (or other problematic user such
   as the timeout conntrack module), increment the global_id.
   I.e. "walk unconfirmed list and flag entries as dying' becomes
   'global_extid++'.

This allows to detect conntracks that were not yet in the hashtable
but might reference a (now stale) pointer to a removed helper/timeout
policy object without the need to a special unconfirmed list.

After these changes change, the percpu lists can be removed which avoids
need for extra list insert/remove + spinlock at conntrack allocation
time.

Let me know if you spot a problem with the scheme above.
