Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.6 required=3.0 tests=BAYES_00,FORGED_MUA_MOZILLA,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 65BD6C433E0
	for <netfilter-devel@archiver.kernel.org>; Tue,  2 Feb 2021 23:29:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1C72564E31
	for <netfilter-devel@archiver.kernel.org>; Tue,  2 Feb 2021 23:29:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233077AbhBBX3u (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 2 Feb 2021 18:29:50 -0500
Received: from correo.us.es ([193.147.175.20]:47098 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232201AbhBBX3u (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 2 Feb 2021 18:29:50 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id BEF4F18D006
        for <netfilter-devel@vger.kernel.org>; Wed,  3 Feb 2021 00:29:07 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id C2C60DA73D
        for <netfilter-devel@vger.kernel.org>; Wed,  3 Feb 2021 00:29:07 +0100 (CET)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id B7A02DA72F; Wed,  3 Feb 2021 00:29:07 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id A2E85DA730;
        Wed,  3 Feb 2021 00:29:05 +0100 (CET)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Wed, 03 Feb 2021 00:29:05 +0100 (CET)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from us.es (unknown [90.77.255.23])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: 1984lsi)
        by entrada.int (Postfix) with ESMTPSA id 8976142DF561;
        Wed,  3 Feb 2021 00:29:05 +0100 (CET)
Date:   Wed, 3 Feb 2021 00:29:05 +0100
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     sven.auhagen@voleatech.de
Cc:     netfilter-devel@vger.kernel.org
Subject: Re: [PATCH] netfilter: flowtable: fix tcp and udp header checksum
 update
Message-ID: <20210202232905.GA29511@salvia>
References: <20210202170116.8763-1-sven.auhagen@voleatech.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20210202170116.8763-1-sven.auhagen@voleatech.de>
User-Agent: Mozilla/5.0
X-Virus-Scanned: ClamAV using ClamSMTP
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Hi Sven,

On Tue, Feb 02, 2021 at 06:01:16PM +0100, sven.auhagen@voleatech.de wrote:
> From: Sven Auhagen <sven.auhagen@voleatech.de>
> 
> When updating the tcp or udp header checksum on port nat
> the function inet_proto_csum_replace2 with the last parameter
> pseudohdr as true.
> This leads to an error in the case that GRO is used and packets
> are split up in GSO.
> The tcp or udp checksum of all packets is incorrect.
> 
> The error is probably masked due to the fact the most network driver
> implement tcp/udp checksum offloading.
> It also only happens when GRO is applied and not on single packets.
> 
> The error is most visible when using a pppoe connection which is not
> triggering the tcp/udp checksum offload.

Good catch.

I'll apply this patch to nf.git.
