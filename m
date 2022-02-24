Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0072AC43217
	for <netfilter-devel@archiver.kernel.org>; Thu, 24 Feb 2022 16:32:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229977AbiBXQc7 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 24 Feb 2022 11:32:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59722 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230076AbiBXQcz (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 24 Feb 2022 11:32:55 -0500
Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 9601720DB0E
        for <netfilter-devel@vger.kernel.org>; Thu, 24 Feb 2022 08:32:16 -0800 (PST)
Received: from netfilter.org (unknown [78.30.32.163])
        by mail.netfilter.org (Postfix) with ESMTPSA id 076076434E;
        Thu, 24 Feb 2022 17:02:59 +0100 (CET)
Date:   Thu, 24 Feb 2022 17:04:03 +0100
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Florian Westphal <fw@strlen.de>
Cc:     netfilter-devel@vger.kernel.org
Subject: Re: [PATCH nf-next 0/7] metfilter: remove pcpu dying list
Message-ID: <Yhesc6YcUBrl27HX@salvia>
References: <20220209161057.30688-1-fw@strlen.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20220209161057.30688-1-fw@strlen.de>
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Hi Florian,

On Wed, Feb 09, 2022 at 05:10:50PM +0100, Florian Westphal wrote:
> This is part 1 of a series that aims to remove both the unconfirmed
> and dying lists.
> 
> This moves the dying list into the ecache infrastructure.
> Entries are placed on this list only if the delivery of the destroy
> event has failed (which implies that at least one userspace listener
> did request redelivery).
> 
> The percpu dying list is removed in the last patch as it has no
> functionality anymore.  This avoids the extra spinlock for conntrack
> removal.

net/netfilter/nf_conntrack_ecache.c:48:19: error: ‘nf_conn_retrans_list_head’ undeclared here (not in a function)

related to patch ("netfilter: conntrack: include ecache dying list in
dumps")

I don't find the declaration in this patchset.
