Return-Path: <SRS0=qEnH=WK=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EDFAEC433FF
	for <netfilter-devel@archiver.kernel.org>; Wed, 14 Aug 2019 07:42:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C42EF20843
	for <netfilter-devel@archiver.kernel.org>; Wed, 14 Aug 2019 07:42:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726365AbfHNHmE (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 14 Aug 2019 03:42:04 -0400
Received: from correo.us.es ([193.147.175.20]:41890 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725895AbfHNHmE (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 14 Aug 2019 03:42:04 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 7958DEDB10
        for <netfilter-devel@vger.kernel.org>; Wed, 14 Aug 2019 09:42:01 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 6B3C2DA7B9
        for <netfilter-devel@vger.kernel.org>; Wed, 14 Aug 2019 09:42:01 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 60EE1DA730; Wed, 14 Aug 2019 09:42:01 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 4A704DA7B9;
        Wed, 14 Aug 2019 09:41:59 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Wed, 14 Aug 2019 09:41:59 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from us.es (unknown [31.4.218.116])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: 1984lsi)
        by entrada.int (Postfix) with ESMTPSA id 1DD9C4265A2F;
        Wed, 14 Aug 2019 09:41:59 +0200 (CEST)
Date:   Wed, 14 Aug 2019 09:41:58 +0200
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Florian Westphal <fw@strlen.de>
Cc:     netfilter-devel@vger.kernel.org
Subject: Re: [PATCH nftables 1/3] src: fix jumps on bigendian arches
Message-ID: <20190814074158.qmk6k3rissqbtmcw@salvia>
References: <20190813201246.5543-1-fw@strlen.de>
 <20190813201246.5543-2-fw@strlen.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190813201246.5543-2-fw@strlen.de>
User-Agent: NeoMutt/20170113 (1.7.2)
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Tue, Aug 13, 2019 at 10:12:44PM +0200, Florian Westphal wrote:
> table bla {
>   chain foo { }
>   chain bar { jump foo }
>  }
> }
> 
> Fails to restore on big-endian platforms:
> jump.nft:5:2-9: Error: Could not process rule: No such file or directory
>  jump foo
> 
> nft passes a 0-length name to the kernel.
> 
> This is because when we export the value (the string), we provide
> the size of the destination buffer.
> 
> In earlier versions, the parser allocated the name with the same
> fixed size and all was fine.
> 
> After the fix, the export places the name in the wrong location
> in the destination buffer.
> 
> This makes tests/shell/testcases/chains/0001jumps_0 work on s390x.
> 
> v2: convert one error check to a BUG(), it should not happen unless
>     kernel abi is broken.
> 
> Fixes: 142350f154c78 ("src: invalid read when importing chain name")
> Signed-off-by: Florian Westphal <fw@strlen.de>

Acked-by: Pablo Neira Ayuso <pablo@netfilter.org>
