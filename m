Return-Path: <SRS0=RE83=6O=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7EEE7C47247
	for <netfilter-devel@archiver.kernel.org>; Thu, 30 Apr 2020 15:41:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5A2BE20661
	for <netfilter-devel@archiver.kernel.org>; Thu, 30 Apr 2020 15:41:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726757AbgD3PlS (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 30 Apr 2020 11:41:18 -0400
Received: from correo.us.es ([193.147.175.20]:33062 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726745AbgD3PlR (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 30 Apr 2020 11:41:17 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 090072EFEA3
        for <netfilter-devel@vger.kernel.org>; Thu, 30 Apr 2020 17:41:16 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id EE328BAC2F
        for <netfilter-devel@vger.kernel.org>; Thu, 30 Apr 2020 17:41:15 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id E3D06615CF; Thu, 30 Apr 2020 17:41:15 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 0C03EBAAA1;
        Thu, 30 Apr 2020 17:41:14 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Thu, 30 Apr 2020 17:41:14 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from us.es (unknown [90.77.255.23])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: 1984lsi)
        by entrada.int (Postfix) with ESMTPSA id E410642EFB83;
        Thu, 30 Apr 2020 17:41:13 +0200 (CEST)
Date:   Thu, 30 Apr 2020 17:41:13 +0200
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Phil Sutter <phil@nwl.cc>
Cc:     netfilter-devel@vger.kernel.org
Subject: Re: [nft PATCH 3/4] segtree: Merge get_set_interval_find() and
 get_set_interval_end()
Message-ID: <20200430154113.GB3602@salvia>
References: <20200430151408.32283-1-phil@nwl.cc>
 <20200430151408.32283-4-phil@nwl.cc>
 <20200430153729.GA3602@salvia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200430153729.GA3602@salvia>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Thu, Apr 30, 2020 at 05:37:29PM +0200, Pablo Neira Ayuso wrote:
> On Thu, Apr 30, 2020 at 05:14:07PM +0200, Phil Sutter wrote:
> > Both functions were very similar already. Under the assumption that they
> > will always either see a range (or start of) that matches exactly or not
> > at all, reduce complexity and make get_set_interval_find() accept NULL
> > (left or) right values. This way it becomes a full replacement for
> > get_set_interval_end().
> 
> I have to go back to the commit log of this patch, IIRC my intention
> here was to allow users to ask for a single element, then return the
> range that contains it.

# nft add table x
# nft add set x y { type ipv4_addr\; flags interval\; }
# nft add element x y { 1.1.1.1-2.2.2.2 }
# nft get element x y { 1.1.1.2 }
table ip x {
        set y {
                type ipv4_addr
                flags interval
                elements = { 1.1.1.1-2.2.2.2 }
        }
}

Otherwise it might not be so useful for users.

If the number of elements is huge, then this 'get' command is not so
useful, right?

BTW, are get commands to the pipapo set working like this too?

Thanks.
