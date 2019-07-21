Return-Path: <SRS0=p03Y=VS=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A414DC76191
	for <netfilter-devel@archiver.kernel.org>; Sun, 21 Jul 2019 18:56:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7483A206BF
	for <netfilter-devel@archiver.kernel.org>; Sun, 21 Jul 2019 18:56:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727032AbfGUS4e (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sun, 21 Jul 2019 14:56:34 -0400
Received: from mail.us.es ([193.147.175.20]:44618 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726484AbfGUS4e (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Sun, 21 Jul 2019 14:56:34 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 31C95C3301
        for <netfilter-devel@vger.kernel.org>; Sun, 21 Jul 2019 20:56:32 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 21444A6A8
        for <netfilter-devel@vger.kernel.org>; Sun, 21 Jul 2019 20:56:32 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 16F3EFF6CC; Sun, 21 Jul 2019 20:56:32 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 27CA9DA708;
        Sun, 21 Jul 2019 20:56:30 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Sun, 21 Jul 2019 20:56:30 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from us.es (unknown [31.4.214.120])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: 1984lsi)
        by entrada.int (Postfix) with ESMTPSA id E19A04265A2F;
        Sun, 21 Jul 2019 20:56:29 +0200 (CEST)
Date:   Sun, 21 Jul 2019 20:56:28 +0200
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Phil Sutter <phil@nwl.cc>
Cc:     netfilter-devel@vger.kernel.org
Subject: Re: [iptables PATCH 00/12] Larger xtables-save review
Message-ID: <20190721185628.zvzvw3vpiik36prl@salvia>
References: <20190720163026.15410-1-phil@nwl.cc>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190720163026.15410-1-phil@nwl.cc>
User-Agent: NeoMutt/20170113 (1.7.2)
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Sat, Jul 20, 2019 at 06:30:14PM +0200, Phil Sutter wrote:
> This series started as a fix to program names mentioned in *-save
> outputs and ended in merging ebtables-save and arptables-save code into
> xtables_save_main used by ip{6,}tables-nft-save.
> 
> The first patch is actually unrelated but was discovered when testing
> counter output - depending on environment, ebtables-nft might segfault.
> 
> The second patch fixes option '-c' of ebtables-nft-save which enables
> counter prefixes in dumped rules but failed to disable the classical
> ebtables-style counters.
> 
> Patch three sorts program names quoted in output of any of the *-save
> programs, patch four unifies the header/footer comments in the same. The
> latter also drops the extra newline printed in ebtables- and
> arptables-save output, so test scripts need adjustments beyond dropping
> the new comment lines from output.
> 
> Patch five fixes the table compatibility check in ip{6,}tables-nft-save.
> 
> Patches six and eight to ten prepare for integrating arptables- and
> ebtables-save into the xtables-save code.
> 
> Patch seven merely fixes a minor coding-style issue.
> 
> Patches eleven and twelve finally perform the actual merge.

Series look good after quick review.
