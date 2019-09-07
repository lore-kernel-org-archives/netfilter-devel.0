Return-Path: <SRS0=QWtc=XC=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AC903C43331
	for <netfilter-devel@archiver.kernel.org>; Sat,  7 Sep 2019 09:18:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7DBD021871
	for <netfilter-devel@archiver.kernel.org>; Sat,  7 Sep 2019 09:18:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2394588AbfIGJSy (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sat, 7 Sep 2019 05:18:54 -0400
Received: from correo.us.es ([193.147.175.20]:55028 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726486AbfIGJSx (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Sat, 7 Sep 2019 05:18:53 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id CE41B103283
        for <netfilter-devel@vger.kernel.org>; Sat,  7 Sep 2019 11:18:49 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id C17C1B7FFE
        for <netfilter-devel@vger.kernel.org>; Sat,  7 Sep 2019 11:18:49 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id B740BB7FF6; Sat,  7 Sep 2019 11:18:49 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 7E461A594;
        Sat,  7 Sep 2019 11:18:47 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Sat, 07 Sep 2019 11:18:47 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from us.es (sys.soleta.eu [212.170.55.40])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: 1984lsi)
        by entrada.int (Postfix) with ESMTPSA id 60E354251480;
        Sat,  7 Sep 2019 11:18:47 +0200 (CEST)
Date:   Sat, 7 Sep 2019 11:18:48 +0200
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Florian Westphal <fw@strlen.de>
Cc:     netfilter-devel@vger.kernel.org
Subject: Re: [PATCH nft] evaluate: flag fwd and queue statements as terminal
Message-ID: <20190907091848.2yn2tokbnyewm7mc@salvia>
References: <20190906144337.25367-1-fw@strlen.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190906144337.25367-1-fw@strlen.de>
User-Agent: NeoMutt/20170113 (1.7.2)
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Fri, Sep 06, 2019 at 04:43:37PM +0200, Florian Westphal wrote:
> Both queue and fwd statement end evaluation of a rule:
> 
> in
> ... fwd to "eth0" accept
> ... queue accept
> 
> "accept" is redundant and never evaluated in the kernel.
> Add the missing "TERMINAL" flag so the evaluation step will catch
> any trailing expressions:
> 
> nft add rule filter input queue counter
> Error: Statement after terminal statement has no effect
> 
> Signed-off-by: Florian Westphal <fw@strlen.de>

Acked-by: Pablo Neira Ayuso <pablo@netfilter.org>
