Return-Path: <SRS0=eJXe=SP=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_NEOMUTT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DB5B3C10F11
	for <netfilter-devel@archiver.kernel.org>; Sat, 13 Apr 2019 12:58:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9DDE620848
	for <netfilter-devel@archiver.kernel.org>; Sat, 13 Apr 2019 12:58:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727104AbfDMM6U (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sat, 13 Apr 2019 08:58:20 -0400
Received: from mail.us.es ([193.147.175.20]:51794 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727066AbfDMM6U (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Sat, 13 Apr 2019 08:58:20 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 78B68DC9BE
        for <netfilter-devel@vger.kernel.org>; Sat, 13 Apr 2019 14:58:18 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 68CD2DA70D
        for <netfilter-devel@vger.kernel.org>; Sat, 13 Apr 2019 14:58:18 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 5E708DA708; Sat, 13 Apr 2019 14:58:18 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 5C9F6DA703;
        Sat, 13 Apr 2019 14:58:16 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Sat, 13 Apr 2019 14:58:16 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from us.es (sys.soleta.eu [212.170.55.40])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: 1984lsi)
        by entrada.int (Postfix) with ESMTPSA id 38E614265A31;
        Sat, 13 Apr 2019 14:58:16 +0200 (CEST)
Date:   Sat, 13 Apr 2019 14:58:15 +0200
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Dan Carpenter <dan.carpenter@oracle.com>
Cc:     Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>,
        Florian Westphal <fw@strlen.de>,
        netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
        kernel-janitors@vger.kernel.org
Subject: Re: [PATCH v2] netfilter: nf_tables: prevent shift wrap in
 nft_chain_parse_hook()
Message-ID: <20190413125815.oiefilsilitqf2cm@salvia>
References: <20190402133038.GA18575@kadam>
 <20190406052652.GA20963@kadam>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190406052652.GA20963@kadam>
User-Agent: NeoMutt/20170113 (1.7.2)
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Sat, Apr 06, 2019 at 08:26:52AM +0300, Dan Carpenter wrote:
> I believe that "hook->num" can be up to UINT_MAX.  Shifting more than
> 31 bits would is undefined in C but in practice it would lead to shift
> wrapping.  That would lead to an array overflow in nf_tables_addchain():
> 
> 	ops->hook       = hook.type->hooks[ops->hooknum];

Applied, thanks.
