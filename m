Return-Path: <SRS0=RVZI=YP=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BCD40CA9EB9
	for <netfilter-devel@archiver.kernel.org>; Tue, 22 Oct 2019 07:42:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 92B3121783
	for <netfilter-devel@archiver.kernel.org>; Tue, 22 Oct 2019 07:42:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387962AbfJVHmC (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 22 Oct 2019 03:42:02 -0400
Received: from correo.us.es ([193.147.175.20]:42906 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387967AbfJVHmC (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 22 Oct 2019 03:42:02 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id C91EBDA55F
        for <netfilter-devel@vger.kernel.org>; Tue, 22 Oct 2019 09:41:56 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id B8F6B6DA3A
        for <netfilter-devel@vger.kernel.org>; Tue, 22 Oct 2019 09:41:56 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id AE94DDA4CA; Tue, 22 Oct 2019 09:41:56 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 730A9CE15C;
        Tue, 22 Oct 2019 09:41:54 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Tue, 22 Oct 2019 09:41:54 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from us.es (sys.soleta.eu [212.170.55.40])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: 1984lsi)
        by entrada.int (Postfix) with ESMTPSA id 5193C42EF4E2;
        Tue, 22 Oct 2019 09:41:54 +0200 (CEST)
Date:   Tue, 22 Oct 2019 09:41:56 +0200
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Jeremy Sowden <jeremy@azazel.net>
Cc:     Netfilter Devel <netfilter-devel@vger.kernel.org>
Subject: Re: [PATCH nft v3 0/2] Add option to omit sets elements from
 listings.
Message-ID: <20191022074156.bhz3dfxg6kdcllu2@salvia>
References: <20191021214922.8943-1-jeremy@azazel.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191021214922.8943-1-jeremy@azazel.net>
User-Agent: NeoMutt/20170113 (1.7.2)
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Mon, Oct 21, 2019 at 10:49:20PM +0100, Jeremy Sowden wrote:
> From https://bugzilla.netfilter.org/show_bug.cgi?id=1374:
> 
>   Listing an entire ruleset or a table with 'nft list ...' will also
>   print all elements of all set definitions within the ruleset or
>   requested table. Seeing the full set contents is not often necessary
>   especially when requesting to see someone's ruleset for help and
>   support purposes. It would be helpful if there was an option/flag for
>   the nft tool to suppress set contents when listing.
> 
> This patch series implements the request by adding a new option: `-t`,
> `--terse`.

Series applied, thanks Jeremy.

BTW, not your fault, but it seems libnftables documentation is missing
an update for the (1 << 10) flag.
