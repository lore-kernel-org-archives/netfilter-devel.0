Return-Path: <SRS0=eJXe=SP=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_NEOMUTT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 02121C10F11
	for <netfilter-devel@archiver.kernel.org>; Sat, 13 Apr 2019 23:03:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B6C00208E3
	for <netfilter-devel@archiver.kernel.org>; Sat, 13 Apr 2019 23:03:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727048AbfDMXDc (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sat, 13 Apr 2019 19:03:32 -0400
Received: from mail.us.es ([193.147.175.20]:33798 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727042AbfDMXDb (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Sat, 13 Apr 2019 19:03:31 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id A8E58E7B88
        for <netfilter-devel@vger.kernel.org>; Sun, 14 Apr 2019 01:03:29 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 91937DA707
        for <netfilter-devel@vger.kernel.org>; Sun, 14 Apr 2019 01:03:29 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 87413DA705; Sun, 14 Apr 2019 01:03:29 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 74209DA704;
        Sun, 14 Apr 2019 01:03:27 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Sun, 14 Apr 2019 01:03:27 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from us.es (sys.soleta.eu [212.170.55.40])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: 1984lsi)
        by entrada.int (Postfix) with ESMTPSA id 51B904265A31;
        Sun, 14 Apr 2019 01:03:27 +0200 (CEST)
Date:   Sun, 14 Apr 2019 01:03:26 +0200
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Florian Westphal <fw@strlen.de>
Cc:     netfilter-devel@vger.kernel.org
Subject: Re: [PATCH nf] netfilter: nat: fix icmp id endianness when protocol
 mapping was given
Message-ID: <20190413230326.e4hjv4ejbivd2jh4@salvia>
References: <20190413212326.31187-1-fw@strlen.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190413212326.31187-1-fw@strlen.de>
User-Agent: NeoMutt/20170113 (1.7.2)
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Sat, Apr 13, 2019 at 11:23:26PM +0200, Florian Westphal wrote:
> net/netfilter/nf_nat_core.c:422:29: sparse: incorrect type in assignment (different base types)
> net/netfilter/nf_nat_core.c:422:29:    expected unsigned int [unsigned] [assigned] min
> net/netfilter/nf_nat_core.c:422:29:    got restricted __be16 const [usertype] id
> 
> The warning is correct, this needs ntohs treatment.
> 
> Reported-by: kbuild test robot <lkp@intel.com>
> Fixes: 203f2e78200c27e ("netfilter: nat: remove l4proto->unique_tuple")
> Signed-off-by: Florian Westphal <fw@strlen.de>
> ---
>  Pablo, feel free to squash this with commit 57be8a51f2a8ba390f7c5a03d2ae812a1b39c9bb
>  ("netfilter: nat: fix icmp id randomization"), it touched this area
>  already (and moved the faulty line to its current place).

I have collapsed it as suggested. Thanks.
