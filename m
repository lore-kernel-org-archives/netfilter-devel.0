Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.7 required=3.0 tests=BAYES_00,FORGED_MUA_MOZILLA,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 58A8BC433E0
	for <netfilter-devel@archiver.kernel.org>; Tue,  9 Feb 2021 16:33:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 00B9964EC0
	for <netfilter-devel@archiver.kernel.org>; Tue,  9 Feb 2021 16:33:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232889AbhBIQdC (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 9 Feb 2021 11:33:02 -0500
Received: from correo.us.es ([193.147.175.20]:42586 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232845AbhBIQdB (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 9 Feb 2021 11:33:01 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id BA2222AB099
        for <netfilter-devel@vger.kernel.org>; Tue,  9 Feb 2021 17:32:20 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id AC23EDA794
        for <netfilter-devel@vger.kernel.org>; Tue,  9 Feb 2021 17:32:20 +0100 (CET)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id AADD7DA793; Tue,  9 Feb 2021 17:32:20 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 94B5FDA78E;
        Tue,  9 Feb 2021 17:32:18 +0100 (CET)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Tue, 09 Feb 2021 17:32:18 +0100 (CET)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from us.es (unknown [90.77.255.23])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: 1984lsi)
        by entrada.int (Postfix) with ESMTPSA id 651CD42DC6E0;
        Tue,  9 Feb 2021 17:32:18 +0100 (CET)
Date:   Tue, 9 Feb 2021 17:32:17 +0100
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Etan Kissling <etan_kissling@apple.com>
Cc:     netfilter-devel@vger.kernel.org, laforge@netfilter.org
Subject: Re: [PATCH libnetfilter_queue] src: add pkt_buff function for ICMP
Message-ID: <20210209163217.GB6746@salvia>
References: <57E75703-5B8A-4E88-810C-E5F0963BF6E7@apple.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <57E75703-5B8A-4E88-810C-E5F0963BF6E7@apple.com>
User-Agent: Mozilla/5.0
X-Virus-Scanned: ClamAV using ClamSMTP
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Wed, Jan 13, 2021 at 10:37:30AM +0100, Etan Kissling wrote:
> Add support for processing ICMP packets using pkt_buff, similar to
> existing library support for TCP and UDP.

Applied, thanks.
