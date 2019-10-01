Return-Path: <SRS0=ZC8Q=X2=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D5C4DC352AA
	for <netfilter-devel@archiver.kernel.org>; Tue,  1 Oct 2019 16:43:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id AB6D32168B
	for <netfilter-devel@archiver.kernel.org>; Tue,  1 Oct 2019 16:43:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732788AbfJAQnd (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 1 Oct 2019 12:43:33 -0400
Received: from correo.us.es ([193.147.175.20]:36420 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732762AbfJAQnc (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 1 Oct 2019 12:43:32 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id F232911EB98
        for <netfilter-devel@vger.kernel.org>; Tue,  1 Oct 2019 18:43:26 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id E466CCA0F3
        for <netfilter-devel@vger.kernel.org>; Tue,  1 Oct 2019 18:43:26 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id D850FDA4D0; Tue,  1 Oct 2019 18:43:26 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id D0CDADA4CA;
        Tue,  1 Oct 2019 18:43:24 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Tue, 01 Oct 2019 18:43:24 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from us.es (sys.soleta.eu [212.170.55.40])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: 1984lsi)
        by entrada.int (Postfix) with ESMTPSA id AED974251480;
        Tue,  1 Oct 2019 18:43:24 +0200 (CEST)
Date:   Tue, 1 Oct 2019 18:43:26 +0200
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Florian Westphal <fw@strlen.de>
Cc:     netdev@vger.kernel.org, netfilter-devel@vger.kernel.org,
        edumazet@google.com
Subject: Re: [PATCH net] netfilter: drop bridge nf reset from nf_reset
Message-ID: <20191001164326.ifgirwawm52zcr7b@salvia>
References: <20190929185403.12116-1-fw@strlen.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190929185403.12116-1-fw@strlen.de>
User-Agent: NeoMutt/20170113 (1.7.2)
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Sun, Sep 29, 2019 at 08:54:03PM +0200, Florian Westphal wrote:
> commit 174e23810cd31
> ("sk_buff: drop all skb extensions on free and skb scrubbing") made napi
> recycle always drop skb extensions.  The additional skb_ext_del() that is
> performed via nf_reset on napi skb recycle is not needed anymore.
> 
> Most nf_reset() calls in the stack are there so queued skb won't block
> 'rmmod nf_conntrack' indefinitely.
> 
> This removes the skb_ext_del from nf_reset, and renames it to a more
> fitting nf_reset_ct().
> 
> In a few selected places, add a call to skb_ext_reset to make sure that
> no active extensions remain.
> 
> I am submitting this for "net", because we're still early in the release
> cycle.  The patch applies to net-next too, but I think the rename causes
> needless divergence between those trees.

Applied, thanks.
