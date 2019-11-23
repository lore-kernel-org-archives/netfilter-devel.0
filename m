Return-Path: <SRS0=6h+B=ZP=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BB36FC432C3
	for <netfilter-devel@archiver.kernel.org>; Sat, 23 Nov 2019 20:05:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A06CB206D4
	for <netfilter-devel@archiver.kernel.org>; Sat, 23 Nov 2019 20:05:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726767AbfKWUFX (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sat, 23 Nov 2019 15:05:23 -0500
Received: from correo.us.es ([193.147.175.20]:48062 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726620AbfKWUFX (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Sat, 23 Nov 2019 15:05:23 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 18B9DA1A33E
        for <netfilter-devel@vger.kernel.org>; Sat, 23 Nov 2019 21:05:19 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 0C524D1DBB
        for <netfilter-devel@vger.kernel.org>; Sat, 23 Nov 2019 21:05:19 +0100 (CET)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 011CDDA4CA; Sat, 23 Nov 2019 21:05:18 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 1F4FADA7B6;
        Sat, 23 Nov 2019 21:05:17 +0100 (CET)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Sat, 23 Nov 2019 21:05:17 +0100 (CET)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from us.es (sys.soleta.eu [212.170.55.40])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: 1984lsi)
        by entrada.int (Postfix) with ESMTPSA id ECB894301DE1;
        Sat, 23 Nov 2019 21:05:16 +0100 (CET)
Date:   Sat, 23 Nov 2019 21:05:18 +0100
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Stefano Brivio <sbrivio@redhat.com>
Cc:     netfilter-devel@vger.kernel.org, Florian Westphal <fw@strlen.de>,
        Kadlecsik =?iso-8859-1?Q?J=F3zsef?= <kadlec@blackhole.kfki.hu>,
        Eric Garver <eric@garver.life>, Phil Sutter <phil@nwl.cc>
Subject: Re: [PATCH nf-next v2 0/8] nftables: Set implementation for
 arbitrary concatenation of ranges
Message-ID: <20191123200518.t2we5nqmmh62g5b6@salvia>
References: <cover.1574428269.git.sbrivio@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1574428269.git.sbrivio@redhat.com>
User-Agent: NeoMutt/20170113 (1.7.2)
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Fri, Nov 22, 2019 at 02:39:59PM +0100, Stefano Brivio wrote:
[...]
> Patch 1/8 implements the needed UAPI bits: additions to the existing
> interface are kept to a minimum by recycling existing concepts for
> both ranging and concatenation, as suggested by Florian.
> 
> Patch 2/8 adds a new bitmap operation that copies the source bitmap
> onto the destination while removing a given region, and is needed to
> delete regions of arrays mapping between lookup tables.
> 
> Patch 3/8 is the actual set implementation.
> 
> Patch 4/8 introduces selftests for the new implementation.
[...]

After talking to Florian, I'm inclined to merge upstream up to patch
4/8 in this merge window, once the UAPI discussion is sorted out.

Thanks.
