Return-Path: <SRS0=suf1=VM=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EBA62C76190
	for <netfilter-devel@archiver.kernel.org>; Mon, 15 Jul 2019 08:15:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C0B1420C01
	for <netfilter-devel@archiver.kernel.org>; Mon, 15 Jul 2019 08:15:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729392AbfGOIPv (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 15 Jul 2019 04:15:51 -0400
Received: from mail.us.es ([193.147.175.20]:49646 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729360AbfGOIPv (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 15 Jul 2019 04:15:51 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id DB094DA737
        for <netfilter-devel@vger.kernel.org>; Mon, 15 Jul 2019 10:15:48 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id CB3C0115104
        for <netfilter-devel@vger.kernel.org>; Mon, 15 Jul 2019 10:15:48 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id C0B80115101; Mon, 15 Jul 2019 10:15:48 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 6D3B5203F3;
        Mon, 15 Jul 2019 10:15:46 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Mon, 15 Jul 2019 10:15:46 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from us.es (sys.soleta.eu [212.170.55.40])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: 1984lsi)
        by entrada.int (Postfix) with ESMTPSA id 4C89C4265A32;
        Mon, 15 Jul 2019 10:15:46 +0200 (CEST)
Date:   Mon, 15 Jul 2019 10:15:45 +0200
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Florian Westphal <fw@strlen.de>
Cc:     Ander Juaristi <a@juaristi.eus>, netfilter-devel@vger.kernel.org
Subject: Re: [PATCH v2] netfilter: nft_meta: support for time matching
Message-ID: <20190715081545.bzbnoz4swoclbrgk@salvia>
References: <20190707205707.6728-1-a@juaristi.eus>
 <20190714232808.rb3wc44ij7ixz376@breakpoint.cc>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190714232808.rb3wc44ij7ixz376@breakpoint.cc>
User-Agent: NeoMutt/20170113 (1.7.2)
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Mon, Jul 15, 2019 at 01:28:08AM +0200, Florian Westphal wrote:
> Ander Juaristi <a@juaristi.eus> wrote:
> > This patch introduces meta matches in the kernel for time (a UNIX timestamp),
> > day (a day of week, represented as an integer between 0-6), and
> > hour (an hour in the current day, or: number of seconds since midnight).
> > 
> > All values are taken as unsigned 64-bit integers.
> > 
> > The 'time' keyword is internally converted to nanoseconds by nft in
> > userspace, and hence the timestamp is taken in nanoseconds as well.
> 
> I think this is conceptually fine, thanks Ander.
> 
> Can you run this throuch scripts/checkpatch.pl and fix up the style
> nits?
> 
> > +	case NFT_META_TIME_HOUR:
> > +		len = sizeof(u64);
> 
> As in my other comment, I think this can be u32.

Florian requested changes, so please follow up on this one and send v3.

BTW, I thought you agreed to stick to u32 (second resolution) for this
patch.

If you decide to go for u64, then get_unaligned() is missing in your
patch, just like in nft_byteorder.c.
