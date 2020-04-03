Return-Path: <SRS0=NeGz=5T=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 47E38C43331
	for <netfilter-devel@archiver.kernel.org>; Fri,  3 Apr 2020 10:40:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id ED4A220737
	for <netfilter-devel@archiver.kernel.org>; Fri,  3 Apr 2020 10:40:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727993AbgDCKkB (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 3 Apr 2020 06:40:01 -0400
Received: from correo.us.es ([193.147.175.20]:58516 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727774AbgDCKkB (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 3 Apr 2020 06:40:01 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 7D9662A2BB3
        for <netfilter-devel@vger.kernel.org>; Fri,  3 Apr 2020 12:39:57 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 6DC98100799
        for <netfilter-devel@vger.kernel.org>; Fri,  3 Apr 2020 12:39:57 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 62DA110078A; Fri,  3 Apr 2020 12:39:57 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 0F6F7FA551;
        Fri,  3 Apr 2020 12:39:55 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Fri, 03 Apr 2020 12:39:55 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from us.es (unknown [90.77.255.23])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: 1984lsi)
        by entrada.int (Postfix) with ESMTPSA id E416B42EF42B;
        Fri,  3 Apr 2020 12:39:54 +0200 (CEST)
Date:   Fri, 3 Apr 2020 12:39:54 +0200
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Stefano Brivio <sbrivio@redhat.com>
Cc:     fw@strlen.de, netfilter-devel@vger.kernel.org
Subject: Re: [PATCH] segtree: bail out on concatenations
Message-ID: <20200403103954.jwmk5ijfoi7ggaxe@salvia>
References: <20200402214941.60097-1-pablo@netfilter.org>
 <20200403025453.7c5f00ba@elisabeth>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200403025453.7c5f00ba@elisabeth>
User-Agent: NeoMutt/20170113 (1.7.2)
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Hi,

On Fri, Apr 03, 2020 at 02:54:53AM +0200, Stefano Brivio wrote:
> Hi,
> 
> On Thu,  2 Apr 2020 23:49:41 +0200
> Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> 
> > This patch adds a lazy check to validate that the first element is not a
> > concatenation. The segtree code does not support for concatenations,
> > bail out with EOPNOTSUPP.
> > 
> >  # nft add element x y { 10.0.0.0/8 . 192.168.1.3-192.168.1.9 . 1024-65535 }
> >  Error: Could not process rule: Operation not supported
> >  add element x y { 10.0.0.0/8 . 192.168.1.3-192.168.1.9 . 1024-65535 }
> >  ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
> > 
> > Otherwise, the segtree code barfs with:
> > 
> >  BUG: invalid range expression type concat
> > 
> > Reported-by: Florian Westphal <fw@strlen.de>
> > Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
> 
> I know you both reported this to me, sorry, I still have to polish up
> the actual fix before posting it. I'm not very familiar with this code
> yet, and it's taking ages.
> 
> It might be a few more days before I get to it, so I guess this patch
> might make sense for the moment being.

I think this one might not be worth to look further. This only happens
with old kernel and new nft binary.

After adding the set, for instance:

table x {
        set y {
                type ipv4_addr . ipv4_addr
                flags interval
        }
}

Old kernels accept this because the kernel has no concept of
concatenation, it's just a number of bytes. Then, the flag interval
selects the rbtree in the kernel.

Then, when listing back the set to userspace, the old kernel reports
no concatenation description, so nft userspace enters the segtree path
to deal with this concatenation.

I think the check in this patch is fine to report users that this
kernel is old and that adding interval concatenation is not supported
by this kernel.

Not related to this patch, Phil reported this one is still broken:

        ip daddr . tcp dport { 10.0.0.0/8 . 10-23, 192.168.1.1-192.168.3.8 . 80-443 } accept

Thanks.
