Return-Path: <SRS0=aNn+=SO=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_NEOMUTT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DB560C10F14
	for <netfilter-devel@archiver.kernel.org>; Fri, 12 Apr 2019 16:36:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B32FC2077C
	for <netfilter-devel@archiver.kernel.org>; Fri, 12 Apr 2019 16:36:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726872AbfDLQgT convert rfc822-to-8bit (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 12 Apr 2019 12:36:19 -0400
Received: from mail.us.es ([193.147.175.20]:52938 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726685AbfDLQgT (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 12 Apr 2019 12:36:19 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id CD82311EF53
        for <netfilter-devel@vger.kernel.org>; Fri, 12 Apr 2019 18:36:14 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id BDC13DA701
        for <netfilter-devel@vger.kernel.org>; Fri, 12 Apr 2019 18:36:14 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 9E796DA70C; Fri, 12 Apr 2019 18:36:14 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 8DD65DA701;
        Fri, 12 Apr 2019 18:36:12 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Fri, 12 Apr 2019 18:36:12 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from us.es (sys.soleta.eu [212.170.55.40])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: 1984lsi)
        by entrada.int (Postfix) with ESMTPSA id 6B76C4265A32;
        Fri, 12 Apr 2019 18:36:12 +0200 (CEST)
Date:   Fri, 12 Apr 2019 18:36:12 +0200
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Stephen Rothwell <sfr@canb.auug.org.au>
Cc:     NetFilter <netfilter-devel@vger.kernel.org>,
        Linux Next Mailing List <linux-next@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Florian Westphal <fw@strlen.de>,
        "David S. Miller" <davem@davemloft.net>,
        Nikolay Aleksandrov <nikolay@cumulusnetworks.com>
Subject: Re: linux-next: build failure after merge of the netfilter-next tree
Message-ID: <20190412163612.zpshjw774aqjdked@salvia>
References: <20190412163720.576c6610@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
In-Reply-To: <20190412163720.576c6610@canb.auug.org.au>
User-Agent: NeoMutt/20170113 (1.7.2)
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Fri, Apr 12, 2019 at 04:37:20PM +1000, Stephen Rothwell wrote:
> Hi all,
> 
> After merging the netfilter tree, today's linux-next build (powerpc
> ppc44x_defconfig) failed like this:
> 
> In file included from /home/sfr/next/next/net/bridge/br_input.c:19:
> /home/sfr/next/next/include/net/netfilter/nf_queue.h:16:23: error: field 'state'
>  has incomplete type
>   struct nf_hook_state state;
>                        ^~~~~
> 
> Caused by commit
> 
>   971502d77faa ("bridge: netfilter: unroll NF_HOOK helper in bridge input path")
> 
> This build has CONFIG_NETFILTER not set.

I have applied this to nf-next, thanks.
