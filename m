Return-Path: <SRS0=l6lg=33=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 89272C352A2
	for <netfilter-devel@archiver.kernel.org>; Fri,  7 Feb 2020 10:25:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 613F12082E
	for <netfilter-devel@archiver.kernel.org>; Fri,  7 Feb 2020 10:25:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726956AbgBGKZl (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 7 Feb 2020 05:25:41 -0500
Received: from correo.us.es ([193.147.175.20]:39622 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726899AbgBGKZl (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 7 Feb 2020 05:25:41 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id BB74717989E
        for <netfilter-devel@vger.kernel.org>; Fri,  7 Feb 2020 11:25:39 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id AED76DA723
        for <netfilter-devel@vger.kernel.org>; Fri,  7 Feb 2020 11:25:39 +0100 (CET)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id A3157DA71A; Fri,  7 Feb 2020 11:25:39 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id CAE6CDA701;
        Fri,  7 Feb 2020 11:25:37 +0100 (CET)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Fri, 07 Feb 2020 11:25:37 +0100 (CET)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from us.es (unknown [90.77.255.23])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: 1984lsi)
        by entrada.int (Postfix) with ESMTPSA id AB10842EF42A;
        Fri,  7 Feb 2020 11:25:37 +0100 (CET)
Date:   Fri, 7 Feb 2020 11:25:36 +0100
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Stefano Brivio <sbrivio@redhat.com>
Cc:     netfilter-devel@vger.kernel.org, Florian Westphal <fw@strlen.de>,
        Kadlecsik =?iso-8859-1?Q?J=F3zsef?= <kadlec@blackhole.kfki.hu>,
        Eric Garver <eric@garver.life>, Phil Sutter <phil@nwl.cc>
Subject: Re: [PATCH nft v4 2/4] src: Add support for NFTNL_SET_DESC_CONCAT
Message-ID: <20200207102536.z24533bex6n6qhsg@salvia>
References: <cover.1580342294.git.sbrivio@redhat.com>
 <1edea54ac5bc93158c52152214a9e0d44a0aa111.1580342294.git.sbrivio@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1edea54ac5bc93158c52152214a9e0d44a0aa111.1580342294.git.sbrivio@redhat.com>
User-Agent: NeoMutt/20170113 (1.7.2)
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Thu, Jan 30, 2020 at 01:16:56AM +0100, Stefano Brivio wrote:
> To support arbitrary range concatenations, the kernel needs to know
> how long each field in the concatenation is. The new libnftnl
> NFTNL_SET_DESC_CONCAT set attribute describes this as an array of
> lengths, in bytes, of concatenated fields.
> 
> While evaluating concatenated expressions, export the datatype size
> into the new field_len array, and hand the data over via libnftnl.
> 
> Similarly, when data is passed back from libnftnl, parse it into
> the set description.
> 
> When set data is cloned, we now need to copy the additional fields
> in set_clone(), too.
> 
> This change depends on the libnftnl patch with title:
>   set: Add support for NFTA_SET_DESC_CONCAT attributes

Also applied, thanks.
