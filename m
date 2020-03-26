Return-Path: <SRS0=p5Wx=5L=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9F978C43331
	for <netfilter-devel@archiver.kernel.org>; Thu, 26 Mar 2020 14:09:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7E7C2206F8
	for <netfilter-devel@archiver.kernel.org>; Thu, 26 Mar 2020 14:09:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727912AbgCZOJB (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 26 Mar 2020 10:09:01 -0400
Received: from correo.us.es ([193.147.175.20]:54534 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727831AbgCZOJB (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 26 Mar 2020 10:09:01 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 6B36612BFFA
        for <netfilter-devel@vger.kernel.org>; Thu, 26 Mar 2020 15:08:59 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 5CCFDDA3A4
        for <netfilter-devel@vger.kernel.org>; Thu, 26 Mar 2020 15:08:59 +0100 (CET)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 52709DA38D; Thu, 26 Mar 2020 15:08:59 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 81243DA7B2;
        Thu, 26 Mar 2020 15:08:57 +0100 (CET)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Thu, 26 Mar 2020 15:08:57 +0100 (CET)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from us.es (unknown [90.77.255.23])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: 1984lsi)
        by entrada.int (Postfix) with ESMTPSA id 6358242EF4E2;
        Thu, 26 Mar 2020 15:08:57 +0100 (CET)
Date:   Thu, 26 Mar 2020 15:08:57 +0100
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Stefano Brivio <sbrivio@redhat.com>
Cc:     Phil Sutter <phil@nwl.cc>, netfilter-devel@vger.kernel.org
Subject: Re: [PATCH nft] tests: Introduce test for insertion of overlapping
 and non-overlapping ranges
Message-ID: <20200326140857.cveevfqf4rvmofjj@salvia>
References: <a0fbd674a9df38fddd9066dd4762d551c207d66a.1583438395.git.sbrivio@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a0fbd674a9df38fddd9066dd4762d551c207d66a.1583438395.git.sbrivio@redhat.com>
User-Agent: NeoMutt/20170113 (1.7.2)
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Thu, Mar 05, 2020 at 09:34:11PM +0100, Stefano Brivio wrote:
> Insertion of overlapping ranges should return success only if the new
> elements are identical to existing ones, or, for concatenated ranges,
> if the new element is less specific (in all its fields) than any
> existing one.
> 
> Note that, in case the range is identical to an existing one, insertion
> won't actually be performed, but no error will be returned either on
> 'add element'.
> 
> This was inspired by a failing case reported by Phil Sutter (where
> concatenated overlapping ranges would fail insertion silently) and is
> fixed by kernel series with subject:
> 	nftables: Consistently report partial and entire set overlaps
> 
> With that series, these tests now pass also if the call to set_overlap()
> on insertion is skipped. Partial or entire overlapping was already
> detected by the kernel for concatenated ranges (nft_set_pipapo) from
> the beginning, and that series makes the nft_set_rbtree implementation
> consistent in terms of detection and reporting. Without that, overlap
> checks are performed by nft but not guaranteed by the kernel.
> 
> However, we can't just drop set_overlap() now, as we need to preserve
> compatibility with older kernels.

Applied, thanks.
