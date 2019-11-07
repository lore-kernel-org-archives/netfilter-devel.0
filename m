Return-Path: <SRS0=biDG=Y7=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 337C8C5DF61
	for <netfilter-devel@archiver.kernel.org>; Thu,  7 Nov 2019 12:06:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E7B552187F
	for <netfilter-devel@archiver.kernel.org>; Thu,  7 Nov 2019 12:06:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388137AbfKGMGK (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 7 Nov 2019 07:06:10 -0500
Received: from correo.us.es ([193.147.175.20]:40358 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388022AbfKGMGK (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 7 Nov 2019 07:06:10 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 11D025E4789
        for <netfilter-devel@vger.kernel.org>; Thu,  7 Nov 2019 13:06:05 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 03CCAD2B1E
        for <netfilter-devel@vger.kernel.org>; Thu,  7 Nov 2019 13:06:05 +0100 (CET)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id ED81DDA3A9; Thu,  7 Nov 2019 13:06:04 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 0D7C9B8001;
        Thu,  7 Nov 2019 13:06:03 +0100 (CET)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Thu, 07 Nov 2019 13:06:03 +0100 (CET)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from us.es (sys.soleta.eu [212.170.55.40])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: 1984lsi)
        by entrada.int (Postfix) with ESMTPSA id DBC9D42EE38E;
        Thu,  7 Nov 2019 13:06:02 +0100 (CET)
Date:   Thu, 7 Nov 2019 13:06:04 +0100
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Phil Sutter <phil@nwl.cc>
Cc:     netfilter-devel@vger.kernel.org
Subject: Re: [nft PATCH 2/2] files: Install sample scripts from files/examples
Message-ID: <20191107120604.xrgrr5b24ewhtar2@salvia>
References: <20191107114516.9258-1-phil@nwl.cc>
 <20191107114516.9258-2-phil@nwl.cc>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191107114516.9258-2-phil@nwl.cc>
User-Agent: NeoMutt/20170113 (1.7.2)
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Hi,

On Thu, Nov 07, 2019 at 12:45:16PM +0100, Phil Sutter wrote:
> Assuming these are still relevant and useful as a source of inspiration,
> install them into DATAROOTDIR/doc/nftables/examples.

I think I found the intention of this update, it's something that
Arturo made IIRC. I forgot about this. The idea with this shebang is
to allow for this.

        # ./x.nft

to allow to restore a ruleset without invoking nft -f.

You have to give execution permission to nft script.
