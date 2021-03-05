Return-Path: <SRS0=VHt6=ID=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.4 required=3.0 tests=BAYES_00,FORGED_MUA_MOZILLA,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 57D72C433DB
	for <netfilter-devel@archiver.kernel.org>; Fri,  5 Mar 2021 20:16:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id F14866509F
	for <netfilter-devel@archiver.kernel.org>; Fri,  5 Mar 2021 20:16:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229465AbhCEUQO (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 5 Mar 2021 15:16:14 -0500
Received: from correo.us.es ([193.147.175.20]:41538 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229488AbhCEUQG (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 5 Mar 2021 15:16:06 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 6A424E8E85
        for <netfilter-devel@vger.kernel.org>; Fri,  5 Mar 2021 21:16:05 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 572F9DA73D
        for <netfilter-devel@vger.kernel.org>; Fri,  5 Mar 2021 21:16:05 +0100 (CET)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 4AF21DA722; Fri,  5 Mar 2021 21:16:05 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 25978DA73D;
        Fri,  5 Mar 2021 21:16:03 +0100 (CET)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Fri, 05 Mar 2021 21:16:03 +0100 (CET)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from us.es (unknown [90.77.255.23])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: 1984lsi)
        by entrada.int (Postfix) with ESMTPSA id F09D942DC700;
        Fri,  5 Mar 2021 21:16:02 +0100 (CET)
Date:   Fri, 5 Mar 2021 21:16:02 +0100
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Florian Westphal <fw@strlen.de>
Cc:     netfilter-devel@vger.kernel.org
Subject: Re: [PATCH nft 2/3] parser: compact map RHS type
Message-ID: <20210305201602.GB9635@salvia>
References: <20210304010735.28683-1-fw@strlen.de>
 <20210304010735.28683-2-fw@strlen.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20210304010735.28683-2-fw@strlen.de>
User-Agent: Mozilla/5.0
X-Virus-Scanned: ClamAV using ClamSMTP
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Thu, Mar 04, 2021 at 02:07:34AM +0100, Florian Westphal wrote:
> Similar to previous patch, we can avoid duplication.

LGTM
