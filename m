Return-Path: <SRS0=TR/Z=U2=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_NEOMUTT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 72330C48BD6
	for <netfilter-devel@archiver.kernel.org>; Thu, 27 Jun 2019 12:20:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 428572085A
	for <netfilter-devel@archiver.kernel.org>; Thu, 27 Jun 2019 12:20:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726441AbfF0MUX (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 27 Jun 2019 08:20:23 -0400
Received: from mail.us.es ([193.147.175.20]:56868 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726308AbfF0MUW (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 27 Jun 2019 08:20:22 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id EB88411ED85
        for <netfilter-devel@vger.kernel.org>; Thu, 27 Jun 2019 14:20:20 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id D2A72114D9C
        for <netfilter-devel@vger.kernel.org>; Thu, 27 Jun 2019 14:20:20 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id D157F114D71; Thu, 27 Jun 2019 14:20:20 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id A44FB6E7C1;
        Thu, 27 Jun 2019 14:20:18 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Thu, 27 Jun 2019 14:20:18 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from us.es (sys.soleta.eu [212.170.55.40])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: 1984lsi)
        by entrada.int (Postfix) with ESMTPSA id 7FA374265A2F;
        Thu, 27 Jun 2019 14:20:18 +0200 (CEST)
Date:   Thu, 27 Jun 2019 14:20:18 +0200
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Arturo Borrero Gonzalez <arturo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org
Subject: Re: [nft PATCH 2/3] libnftables: reallocate definition of
 nft_print() and nft_gmp_print()
Message-ID: <20190627122018.sipjj2eyu7w3edut@salvia>
References: <156163260014.22035.13586288868224137755.stgit@endurance>
 <156163261193.22035.5939540630503363251.stgit@endurance>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <156163261193.22035.5939540630503363251.stgit@endurance>
User-Agent: NeoMutt/20170113 (1.7.2)
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Thu, Jun 27, 2019 at 12:50:11PM +0200, Arturo Borrero Gonzalez wrote:
> They are not part of the libnftables library API, they are not public symbols,
> so it doesn't not make sense to have them there. Move the two functions to a
> different source file.

Probably move them to src/print.c ?

I like the idea that only the API is placed in libnftables.c.

Thanks.
