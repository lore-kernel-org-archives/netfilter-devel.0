Return-Path: <SRS0=bd9C=D3=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EEE2CC4363A
	for <netfilter-devel@archiver.kernel.org>; Tue, 20 Oct 2020 15:18:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9821C20757
	for <netfilter-devel@archiver.kernel.org>; Tue, 20 Oct 2020 15:18:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2408623AbgJTPSz convert rfc822-to-8bit (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 20 Oct 2020 11:18:55 -0400
Received: from correo.us.es ([193.147.175.20]:50222 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726689AbgJTPSz (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 20 Oct 2020 11:18:55 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 1A40B1761A7
        for <netfilter-devel@vger.kernel.org>; Tue, 20 Oct 2020 17:18:54 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 0C9B6FC600
        for <netfilter-devel@vger.kernel.org>; Tue, 20 Oct 2020 17:18:54 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 021A334EE; Tue, 20 Oct 2020 17:18:54 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id CA93534EE;
        Tue, 20 Oct 2020 17:18:51 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Tue, 20 Oct 2020 17:18:51 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from us.es (unknown [90.77.255.23])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: 1984lsi)
        by entrada.int (Postfix) with ESMTPSA id AD3C34301DE1;
        Tue, 20 Oct 2020 17:18:51 +0200 (CEST)
Date:   Tue, 20 Oct 2020 17:18:51 +0200
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     timothee.cocault@orange.com
Cc:     Florian Westphal <fw@strlen.de>,
        "netfilter-devel@vger.kernel.org" <netfilter-devel@vger.kernel.org>
Subject: Re: [PATCH] Fixes dropping of small packets in bridge nat
Message-ID: <20201020151851.GA19821@salvia>
References: <585B71F7B267D04784B84104A88F7DEE0DB503A6@OPEXCAUBM34.corporate.adroot.infra.ftgroup>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
In-Reply-To: <585B71F7B267D04784B84104A88F7DEE0DB503A6@OPEXCAUBM34.corporate.adroot.infra.ftgroup>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Virus-Scanned: ClamAV using ClamSMTP
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Wed, Oct 14, 2020 at 12:36:15PM +0000, timothee.cocault@orange.com wrote:
> Fixes an error causing small packets to get dropped. skb_ensure_writable
> expects the second parameter to be a length in the ethernet payload. 
> If we want to write the ethernet header (src, dst), we should pass 0.
> Otherwise, packets with small payloads (< ETH_ALEN) will get dropped.

Applied, thanks.
