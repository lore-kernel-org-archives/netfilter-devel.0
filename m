Return-Path: <SRS0=aMTL=TF=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_NEOMUTT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 79CAFC04AAB
	for <netfilter-devel@archiver.kernel.org>; Sun,  5 May 2019 22:25:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 46261205C9
	for <netfilter-devel@archiver.kernel.org>; Sun,  5 May 2019 22:25:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728033AbfEEWZv (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sun, 5 May 2019 18:25:51 -0400
Received: from mail.us.es ([193.147.175.20]:50244 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728011AbfEEWZu (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Sun, 5 May 2019 18:25:50 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id C27D7DA70A
        for <netfilter-devel@vger.kernel.org>; Mon,  6 May 2019 00:25:48 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id B440ADA705
        for <netfilter-devel@vger.kernel.org>; Mon,  6 May 2019 00:25:48 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id A9F15DA703; Mon,  6 May 2019 00:25:48 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id BEEA2DA706;
        Mon,  6 May 2019 00:25:46 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Mon, 06 May 2019 00:25:46 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from us.es (sys.soleta.eu [212.170.55.40])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: 1984lsi)
        by entrada.int (Postfix) with ESMTPSA id 9BA684265A31;
        Mon,  6 May 2019 00:25:46 +0200 (CEST)
Date:   Mon, 6 May 2019 00:25:46 +0200
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Jakub Jankowski <shasta@toxcorp.com>
Cc:     netfilter-devel@vger.kernel.org
Subject: Re: [PATCH net] netfilter: nf_ct_h323: restore boundary check
 correctness
Message-ID: <20190505222546.o6zzdwn7jk23jvtr@salvia>
References: <20190425214650.518-1-shasta@toxcorp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190425214650.518-1-shasta@toxcorp.com>
User-Agent: NeoMutt/20170113 (1.7.2)
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Thu, Apr 25, 2019 at 11:46:50PM +0200, Jakub Jankowski wrote:
> Since commit bc7d811ace4a ("netfilter: nf_ct_h323: Convert
> CHECK_BOUND macro to function"), NAT traversal for H.323
> doesn't work, failing to parse H323-UserInformation.
> nf_h323_error_boundary() compares contents of the bitstring,
> not the addresses, preventing valid H.323 packets from being
> conntrack'd.
> 
> This looks like an oversight from when CHECK_BOUND macro was
> converted to a function.
> 
> To fix it, stop dereferencing bs->cur and bs->end.

Applied, thanks.
