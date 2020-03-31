Return-Path: <SRS0=TvDw=5Q=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7C1E6C43331
	for <netfilter-devel@archiver.kernel.org>; Tue, 31 Mar 2020 20:12:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6155420787
	for <netfilter-devel@archiver.kernel.org>; Tue, 31 Mar 2020 20:12:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731160AbgCaUMc (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 31 Mar 2020 16:12:32 -0400
Received: from correo.us.es ([193.147.175.20]:38654 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727937AbgCaUMb (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 31 Mar 2020 16:12:31 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id F1F46E34CA
        for <netfilter-devel@vger.kernel.org>; Tue, 31 Mar 2020 22:12:29 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id E34C4100A52
        for <netfilter-devel@vger.kernel.org>; Tue, 31 Mar 2020 22:12:29 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id D6FDE100A4C; Tue, 31 Mar 2020 22:12:29 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id DD5F6100A42;
        Tue, 31 Mar 2020 22:12:27 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Tue, 31 Mar 2020 22:12:27 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from us.es (unknown [90.77.255.23])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: 1984lsi)
        by entrada.int (Postfix) with ESMTPSA id C08294301DE1;
        Tue, 31 Mar 2020 22:12:27 +0200 (CEST)
Date:   Tue, 31 Mar 2020 22:12:27 +0200
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Stefano Brivio <sbrivio@redhat.com>
Cc:     Phil Sutter <phil@nwl.cc>, netfilter-devel@vger.kernel.org
Subject: Re: [PATCH nf v2 4/4] nft_set_rbtree: Detect partial overlaps on
 insertion
Message-ID: <20200331201209.trdh3b4r3a5fd2fe@salvia>
References: <cover.1584841602.git.sbrivio@redhat.com>
 <fa9efa91cb1fb670f6fb248db3182c7c97fa3f70.1584841602.git.sbrivio@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <fa9efa91cb1fb670f6fb248db3182c7c97fa3f70.1584841602.git.sbrivio@redhat.com>
User-Agent: NeoMutt/20170113 (1.7.2)
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Hi Stefano,

On Sun, Mar 22, 2020 at 03:22:01AM +0100, Stefano Brivio wrote:
> ...and return -ENOTEMPTY to the front-end in this case, instead of
> proceeding. Currently, nft takes care of checking for these cases
> and not sending them to the kernel, but if we drop the set_overlap()
> call in nft we can end up in situations like:
> 
>  # nft add table t
>  # nft add set t s '{ type inet_service ; flags interval ; }'
>  # nft add element t s '{ 1 - 5 }'
>  # nft add element t s '{ 6 - 10 }'
>  # nft add element t s '{ 4 - 7 }'
>  # nft list set t s
>  table ip t {
>  	set s {
>  		type inet_service
>  		flags interval
>  		elements = { 1-3, 4-5, 6-7 }
>  	}
>  }
> 
> This change has the primary purpose of making the behaviour
> consistent with nft_set_pipapo, but is also functional to avoid
> inconsistent behaviour if userspace sends overlapping elements for
> any reason.

nftables/tests/py is reporting a regression that is related to this
patch. If I locally revert this patch here, tests/py works fine here.

Thanks.
