Return-Path: <SRS0=FCuH=V3=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1E7F6C433FF
	for <netfilter-devel@archiver.kernel.org>; Tue, 30 Jul 2019 11:42:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id EE89420644
	for <netfilter-devel@archiver.kernel.org>; Tue, 30 Jul 2019 11:42:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730831AbfG3LmC (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 30 Jul 2019 07:42:02 -0400
Received: from correo.us.es ([193.147.175.20]:36412 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725947AbfG3LmC (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 30 Jul 2019 07:42:02 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id B0FC5B5AA0
        for <netfilter-devel@vger.kernel.org>; Tue, 30 Jul 2019 13:42:00 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 9FF8718539
        for <netfilter-devel@vger.kernel.org>; Tue, 30 Jul 2019 13:42:00 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 959BCD190F; Tue, 30 Jul 2019 13:42:00 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id A71FEDA704;
        Tue, 30 Jul 2019 13:41:58 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Tue, 30 Jul 2019 13:41:58 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from us.es (unknown [47.60.32.83])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: 1984lsi)
        by entrada.int (Postfix) with ESMTPSA id 4BCFE4265A2F;
        Tue, 30 Jul 2019 13:41:58 +0200 (CEST)
Date:   Tue, 30 Jul 2019 13:41:55 +0200
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Cc:     netfilter-devel@vger.kernel.org
Subject: Re: [PATCH 0/3] ipset patches for the nf tree
Message-ID: <20190730114155.vdtiwehxju55arzj@salvia>
References: <20190729193354.26559-1-kadlec@blackhole.kfki.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190729193354.26559-1-kadlec@blackhole.kfki.hu>
User-Agent: NeoMutt/20170113 (1.7.2)
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Mon, Jul 29, 2019 at 09:33:51PM +0200, Jozsef Kadlecsik wrote:
> Hi Pablo,
> 
> Please consider to apply the next patches to the nf tree:
> 
> - When the support of destination MAC addresses for hash:mac sets was
>   introduced, it was forgotten to add the same functionality to hash:ip,mac
>   types of sets. The patch from Stefano Brivio adds the missing part.
> - When the support of destination MAC addresses for hash:mac sets was
>   introduced, a copy&paste error was made in the code of the hash:ip,mac
>   and bitmap:ip,mac types: the MAC address in these set types is in
>   the second position and not in the first one. Stefano Brivio's patch
>   fixes the issue.
> - There was still a not properly handled concurrency handling issue
>   between renaming and listing sets at the same time, reported by
>   Shijie Luo.

Pulled, thanks Jozsef.
