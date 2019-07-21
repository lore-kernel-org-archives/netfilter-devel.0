Return-Path: <SRS0=p03Y=VS=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 316C7C76186
	for <netfilter-devel@archiver.kernel.org>; Sun, 21 Jul 2019 00:27:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0CE7420823
	for <netfilter-devel@archiver.kernel.org>; Sun, 21 Jul 2019 00:27:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726167AbfGUA0k (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sat, 20 Jul 2019 20:26:40 -0400
Received: from Chamillionaire.breakpoint.cc ([193.142.43.52]:48930 "EHLO
        Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725972AbfGUA0k (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sat, 20 Jul 2019 20:26:40 -0400
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.89)
        (envelope-from <fw@strlen.de>)
        id 1hozgF-0001k4-W7; Sun, 21 Jul 2019 02:26:24 +0200
Date:   Sun, 21 Jul 2019 02:26:23 +0200
From:   Florian Westphal <fw@strlen.de>
To:     Wenwen Wang <wang6495@umn.edu>
Cc:     Wenwen Wang <wenwen@cs.uga.edu>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Jozsef Kadlecsik <kadlec@netfilter.org>,
        Florian Westphal <fw@strlen.de>,
        Roopa Prabhu <roopa@cumulusnetworks.com>,
        Nikolay Aleksandrov <nikolay@cumulusnetworks.com>,
        "David S. Miller" <davem@davemloft.net>,
        "open list:NETFILTER" <netfilter-devel@vger.kernel.org>,
        "open list:NETFILTER" <coreteam@netfilter.org>,
        "moderated list:ETHERNET BRIDGE" <bridge@lists.linux-foundation.org>,
        "open list:ETHERNET BRIDGE" <netdev@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] netfilter: ebtables: compat: fix a memory leak bug
Message-ID: <20190721002623.27wac36rkwa5v5lg@breakpoint.cc>
References: <1563625366-3602-1-git-send-email-wang6495@umn.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1563625366-3602-1-git-send-email-wang6495@umn.edu>
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Wenwen Wang <wang6495@umn.edu> wrote:
> From: Wenwen Wang <wenwen@cs.uga.edu>
> 
> In compat_do_replace(), a temporary buffer is allocated through vmalloc()
> to hold entries copied from the user space. The buffer address is firstly
> saved to 'newinfo->entries', and later on assigned to 'entries_tmp'. Then
> the entries in this temporary buffer is copied to the internal kernel
> structure through compat_copy_entries(). If this copy process fails,
> compat_do_replace() should be terminated. However, the allocated temporary
> buffer is not freed on this path, leading to a memory leak.
> 
> To fix the bug, free the buffer before returning from compat_do_replace().
> 
> Signed-off-by: Wenwen Wang <wenwen@cs.uga.edu>

Reviewed-by: Florian Westphal <fw@strlen.de>
