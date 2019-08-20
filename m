Return-Path: <SRS0=ly5L=WQ=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AE36DC3A589
	for <netfilter-devel@archiver.kernel.org>; Tue, 20 Aug 2019 11:37:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7B74E20C01
	for <netfilter-devel@archiver.kernel.org>; Tue, 20 Aug 2019 11:37:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729458AbfHTLhV (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 20 Aug 2019 07:37:21 -0400
Received: from correo.us.es ([193.147.175.20]:51834 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729421AbfHTLhV (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 20 Aug 2019 07:37:21 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 52B12BA1B2
        for <netfilter-devel@vger.kernel.org>; Tue, 20 Aug 2019 13:37:18 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 4730FD2B1E
        for <netfilter-devel@vger.kernel.org>; Tue, 20 Aug 2019 13:37:18 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 3CB0DDA4CA; Tue, 20 Aug 2019 13:37:18 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 3F3A6DA801;
        Tue, 20 Aug 2019 13:37:16 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Tue, 20 Aug 2019 13:37:16 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from us.es (unknown [47.60.43.0])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: 1984lsi)
        by entrada.int (Postfix) with ESMTPSA id F23744265A2F;
        Tue, 20 Aug 2019 13:37:15 +0200 (CEST)
Date:   Tue, 20 Aug 2019 13:37:14 +0200
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Juliana Rodrigueiro <juliana.rodrigueiro@intra2net.com>
Cc:     netfilter-devel@vger.kernel.org, thomas.jarosch@intra2net.com
Subject: Re: [PATCH iptables] extensions: nfacct: Fix alignment mismatch in
 xt_nfacct_match_info
Message-ID: <20190820113714.roesxsucx5v2zpog@salvia>
References: <3495054.C9FayD4L8h@rocinante.m.i2n>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3495054.C9FayD4L8h@rocinante.m.i2n>
User-Agent: NeoMutt/20170113 (1.7.2)
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Tue, Aug 20, 2019 at 01:30:39PM +0200, Juliana Rodrigueiro wrote:
> When running a 64-bit kernel with a 32-bit iptables binary, the
> size of the xt_nfacct_match_info struct diverges.
> 
>     kernel: sizeof(struct xt_nfacct_match_info) : 40
>     iptables: sizeof(struct xt_nfacct_match_info)) : 36
> 
> This patch is the userspace fix of the memory misalignment.
> 
> It introduces a v1 ABI with the correct alignment and stays
> compatible with unfixed revision 0 kernels.

Applied, thanks.
