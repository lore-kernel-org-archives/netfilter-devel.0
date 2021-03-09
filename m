Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.4 required=3.0 tests=BAYES_00,FORGED_MUA_MOZILLA,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CB357C433E6
	for <netfilter-devel@archiver.kernel.org>; Tue,  9 Mar 2021 13:04:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 807996527C
	for <netfilter-devel@archiver.kernel.org>; Tue,  9 Mar 2021 13:04:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230476AbhCINEF (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 9 Mar 2021 08:04:05 -0500
Received: from correo.us.es ([193.147.175.20]:51784 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230086AbhCINDo (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 9 Mar 2021 08:03:44 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id E159B18CE7F
        for <netfilter-devel@vger.kernel.org>; Tue,  9 Mar 2021 14:03:42 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id CCB65DA844
        for <netfilter-devel@vger.kernel.org>; Tue,  9 Mar 2021 14:03:42 +0100 (CET)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id C150ADA7E4; Tue,  9 Mar 2021 14:03:42 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 8A12ADA78C
        for <netfilter-devel@vger.kernel.org>; Tue,  9 Mar 2021 14:03:40 +0100 (CET)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Tue, 09 Mar 2021 14:03:40 +0100 (CET)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from us.es (unknown [90.77.255.23])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: 1984lsi)
        by entrada.int (Postfix) with ESMTPSA id 6D92342DC703
        for <netfilter-devel@vger.kernel.org>; Tue,  9 Mar 2021 14:03:40 +0100 (CET)
Date:   Tue, 9 Mar 2021 14:03:40 +0100
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Subject: Re: [HEADS UP] bugzilla.netfilter.org is under maintainance
Message-ID: <20210309130340.GA1624@salvia>
References: <20210308232606.GA24377@salvia>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20210308232606.GA24377@salvia>
User-Agent: Mozilla/5.0
X-Virus-Scanned: ClamAV using ClamSMTP
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Tue, Mar 09, 2021 at 12:26:06AM +0100, Pablo Neira Ayuso wrote:
> Hi!
> 
> Short notice:
> 
> bugzilla.netfilter.org is currently down / under maintainance, we're
> expecting to bring it back soon.
> 
> I will keep you all posted with updates.

Netfilter's bugzilla is back to operation.

Thanks for your patience.
