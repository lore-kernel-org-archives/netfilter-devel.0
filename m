Return-Path: <SRS0=eJXe=SP=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,USER_AGENT_NEOMUTT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E46A4C10F11
	for <netfilter-devel@archiver.kernel.org>; Sat, 13 Apr 2019 23:03:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id BB642208E3
	for <netfilter-devel@archiver.kernel.org>; Sat, 13 Apr 2019 23:03:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727070AbfDMXDl (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sat, 13 Apr 2019 19:03:41 -0400
Received: from mail.us.es ([193.147.175.20]:33836 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727042AbfDMXDl (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Sat, 13 Apr 2019 19:03:41 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 01292E7B8C
        for <netfilter-devel@vger.kernel.org>; Sun, 14 Apr 2019 01:03:39 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id E218DDA70B
        for <netfilter-devel@vger.kernel.org>; Sun, 14 Apr 2019 01:03:38 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id D6D45DA70A; Sun, 14 Apr 2019 01:03:38 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id E251ADA705;
        Sun, 14 Apr 2019 01:03:36 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Sun, 14 Apr 2019 01:03:36 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from us.es (sys.soleta.eu [212.170.55.40])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: 1984lsi)
        by entrada.int (Postfix) with ESMTPSA id BD9E54265A31;
        Sun, 14 Apr 2019 01:03:36 +0200 (CEST)
Date:   Sun, 14 Apr 2019 01:03:36 +0200
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Florian Westphal <fw@strlen.de>
Cc:     netfilter-devel@vger.kernel.org
Subject: Re: [PATCH nf] netfilter: conntrack: fix build on 32bit arches
Message-ID: <20190413230336.g242ouykfhozoagu@salvia>
References: <20190413212421.31478-1-fw@strlen.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190413212421.31478-1-fw@strlen.de>
User-Agent: NeoMutt/20170113 (1.7.2)
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Sat, Apr 13, 2019 at 11:24:21PM +0200, Florian Westphal wrote:
> don't use hsiphash, it needs a hsiphash_key_t argument:
> error: passing argument 3 of 'hsiphash' from incompatible pointer type
> 
> Reported-by: kbuild test robot <lkp@intel.com>
> Fixes: 862ae3a4a07e4c22 ("netfilter: ctnetlink: don't use conntrack/expect object addresses as id")
> Signed-off-by: Florian Westphal <fw@strlen.de>
> ---
>  Pablo, feel free to squash this with 862ae3a4a07e4c22.

Squashed, thanks.
