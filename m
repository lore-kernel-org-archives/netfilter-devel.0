Return-Path: <SRS0=/SeC=YO=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6E1FDCA9EB7
	for <netfilter-devel@archiver.kernel.org>; Mon, 21 Oct 2019 16:35:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 44D422084B
	for <netfilter-devel@archiver.kernel.org>; Mon, 21 Oct 2019 16:35:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729597AbfJUQfR (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 21 Oct 2019 12:35:17 -0400
Received: from correo.us.es ([193.147.175.20]:46180 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728495AbfJUQfR (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 21 Oct 2019 12:35:17 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id A4E1818FD8B
        for <netfilter-devel@vger.kernel.org>; Mon, 21 Oct 2019 18:35:12 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 95A2CCA0F1
        for <netfilter-devel@vger.kernel.org>; Mon, 21 Oct 2019 18:35:12 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 94F99D190C; Mon, 21 Oct 2019 18:35:12 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 50D13B7FF9;
        Mon, 21 Oct 2019 18:35:10 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Mon, 21 Oct 2019 18:35:10 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from us.es (sys.soleta.eu [212.170.55.40])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: 1984lsi)
        by entrada.int (Postfix) with ESMTPSA id 2688442EF4E1;
        Mon, 21 Oct 2019 18:35:10 +0200 (CEST)
Date:   Mon, 21 Oct 2019 18:35:12 +0200
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Jeremy Sowden <jeremy@azazel.net>
Cc:     Netfilter Devel <netfilter-devel@vger.kernel.org>
Subject: Re: [PATCH nft v2] src: extend --stateless to suppress output of
 non-dynamic set elements.
Message-ID: <20191021163512.mxdcoscmtbb55dga@salvia>
References: <20191021161148.582-1-jeremy@azazel.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191021161148.582-1-jeremy@azazel.net>
User-Agent: NeoMutt/20170113 (1.7.2)
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Mon, Oct 21, 2019 at 05:11:48PM +0100, Jeremy Sowden wrote:
> Currently, --stateless only suppresses the output of the contents of
> dynamic sets.  Extend it to support an optional parameter, `all`.  If it
> is given, `nft list` will also omit the elements of sets which are not
> marked `dynamic`.

I would suggest a new option? I don't think set elements are stateful
information.

Probably something like ipset --terse option?

-t is already taken, althout not yet in a public release.

I'd suggest this is updated to use -T as --numeric-time (update patch
https://git.netfilter.org/nftables/commit/?id=f8f32deda31df597614d9f1f64ffb0c0320f4d54)
then use --terse/-t for this option?

Thanks.
