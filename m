Return-Path: <SRS0=p03Y=VS=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1931AC76196
	for <netfilter-devel@archiver.kernel.org>; Sun, 21 Jul 2019 18:59:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id F2DDE208E4
	for <netfilter-devel@archiver.kernel.org>; Sun, 21 Jul 2019 18:59:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727296AbfGUS7w (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sun, 21 Jul 2019 14:59:52 -0400
Received: from mail.us.es ([193.147.175.20]:45020 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727032AbfGUS7w (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Sun, 21 Jul 2019 14:59:52 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 5DB82C3302
        for <netfilter-devel@vger.kernel.org>; Sun, 21 Jul 2019 20:59:50 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 4E513115111
        for <netfilter-devel@vger.kernel.org>; Sun, 21 Jul 2019 20:59:50 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 4296D115101; Sun, 21 Jul 2019 20:59:50 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id D618CDA704;
        Sun, 21 Jul 2019 20:59:47 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Sun, 21 Jul 2019 20:59:47 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from us.es (unknown [31.4.214.120])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: 1984lsi)
        by entrada.int (Postfix) with ESMTPSA id 8999F4265A2F;
        Sun, 21 Jul 2019 20:59:47 +0200 (CEST)
Date:   Sun, 21 Jul 2019 20:59:45 +0200
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Wenwen Wang <wang6495@umn.edu>
Cc:     Wenwen Wang <wenwen@cs.uga.edu>,
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
Message-ID: <20190721185945.76vsrm6ruge64das@salvia>
References: <1563625366-3602-1-git-send-email-wang6495@umn.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1563625366-3602-1-git-send-email-wang6495@umn.edu>
User-Agent: NeoMutt/20170113 (1.7.2)
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Sat, Jul 20, 2019 at 07:22:45AM -0500, Wenwen Wang wrote:
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

Applied, thanks.
