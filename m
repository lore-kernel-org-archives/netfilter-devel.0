Return-Path: <SRS0=NOIG=XP=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 557DAC49ED7
	for <netfilter-devel@archiver.kernel.org>; Fri, 20 Sep 2019 09:44:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 31E442086A
	for <netfilter-devel@archiver.kernel.org>; Fri, 20 Sep 2019 09:44:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2408573AbfITJo0 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 20 Sep 2019 05:44:26 -0400
Received: from correo.us.es ([193.147.175.20]:42386 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2408504AbfITJo0 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 20 Sep 2019 05:44:26 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id C6AFAC515D
        for <netfilter-devel@vger.kernel.org>; Fri, 20 Sep 2019 11:44:22 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id B7045DA840
        for <netfilter-devel@vger.kernel.org>; Fri, 20 Sep 2019 11:44:22 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id AA97EDA801; Fri, 20 Sep 2019 11:44:22 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id B6A70FF6E0;
        Fri, 20 Sep 2019 11:44:20 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Fri, 20 Sep 2019 11:44:20 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from us.es (unknown [5.182.56.138])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: 1984lsi)
        by entrada.int (Postfix) with ESMTPSA id 5F75E4265A5A;
        Fri, 20 Sep 2019 11:44:20 +0200 (CEST)
Date:   Fri, 20 Sep 2019 11:44:16 +0200
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Quentin Armitage <quentin@armitage.org.uk>
Cc:     netfilter-devel@vger.kernel.org
Subject: Re: [PATCH] extensions: fix iptables-{nft,translate} with conntrack
 EXPECTED
Message-ID: <20190920094416.rg3xopoxuwe6h7vx@salvia>
References: <1568745392.3595.107.camel@armitage.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1568745392.3595.107.camel@armitage.org.uk>
User-Agent: NeoMutt/20170113 (1.7.2)
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Tue, Sep 17, 2019 at 07:36:32PM +0100, Quentin Armitage wrote:
[...]
> Removing the lines:
>                 if (sinfo->status_mask == 1)
>                         return 0;
> resolves the problems, and
> iptables-translate -A INPUT -m conntrack --ctstatus EXPECTED
>   outputs:
> nft add rule ip filter INPUT ct status expected counter
>   and
> iptables-nft -A INPUT -m conntrack --ctstatus EXPECTED
>   produces nft list output:
> chain INPUT {
>         ct status expected counter packets 0 bytes 0 accept
> }

Applied, thanks.
