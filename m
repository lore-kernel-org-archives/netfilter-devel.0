Return-Path: <SRS0=l6lg=33=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1F990C3F68F
	for <netfilter-devel@archiver.kernel.org>; Fri,  7 Feb 2020 14:57:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id EB5CD21775
	for <netfilter-devel@archiver.kernel.org>; Fri,  7 Feb 2020 14:57:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727131AbgBGO5k (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 7 Feb 2020 09:57:40 -0500
Received: from correo.us.es ([193.147.175.20]:52022 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726674AbgBGO5j (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 7 Feb 2020 09:57:39 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 01FE6C106B
        for <netfilter-devel@vger.kernel.org>; Fri,  7 Feb 2020 15:57:39 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id E9643DA717
        for <netfilter-devel@vger.kernel.org>; Fri,  7 Feb 2020 15:57:38 +0100 (CET)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id DB4CDDA711; Fri,  7 Feb 2020 15:57:38 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 17F37DA70E;
        Fri,  7 Feb 2020 15:57:37 +0100 (CET)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Fri, 07 Feb 2020 15:57:37 +0100 (CET)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from us.es (unknown [84.78.24.221])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: 1984lsi)
        by entrada.int (Postfix) with ESMTPSA id CF4DF42EFB80;
        Fri,  7 Feb 2020 15:57:36 +0100 (CET)
Date:   Fri, 7 Feb 2020 15:57:34 +0100
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Cong Wang <xiyou.wangcong@gmail.com>
Cc:     netdev@vger.kernel.org, fw@strlen.de,
        netfilter-devel@vger.kernel.org,
        syzbot+adf6c6c2be1c3a718121@syzkaller.appspotmail.com,
        Jozsef Kadlecsik <kadlec@netfilter.org>
Subject: Re: [Patch nf v2 1/3] xt_hashlimit: avoid OOM for user-controlled
 vmalloc
Message-ID: <20200207145734.qhy53bxrqocvjb2d@salvia>
References: <20200203043053.19192-1-xiyou.wangcong@gmail.com>
 <20200203043053.19192-2-xiyou.wangcong@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200203043053.19192-2-xiyou.wangcong@gmail.com>
User-Agent: NeoMutt/20170113 (1.7.2)
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Sun, Feb 02, 2020 at 08:30:51PM -0800, Cong Wang wrote:
> The hashtable size could be controlled by user, so use flags
> GFP_USER | __GFP_NOWARN to avoid OOM warning triggered by user-space.
> 
> Also add __GFP_NORETRY to avoid retrying, as this is just a
> best effort and the failure is already handled gracefully.

I think OOM is unlikely to happen now that cfg->size is capped in
your patch 3/3.
