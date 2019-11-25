Return-Path: <SRS0=kuYc=ZR=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 448FDC432C0
	for <netfilter-devel@archiver.kernel.org>; Mon, 25 Nov 2019 20:42:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1B7302071E
	for <netfilter-devel@archiver.kernel.org>; Mon, 25 Nov 2019 20:42:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725912AbfKYUmB (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 25 Nov 2019 15:42:01 -0500
Received: from correo.us.es ([193.147.175.20]:60008 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725818AbfKYUmB (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 25 Nov 2019 15:42:01 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 0DF7B4FFE03
        for <netfilter-devel@vger.kernel.org>; Mon, 25 Nov 2019 21:41:57 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id F0FA5DA7B6
        for <netfilter-devel@vger.kernel.org>; Mon, 25 Nov 2019 21:41:56 +0100 (CET)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id E5502B7FF6; Mon, 25 Nov 2019 21:41:56 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 03413DA801;
        Mon, 25 Nov 2019 21:41:55 +0100 (CET)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Mon, 25 Nov 2019 21:41:55 +0100 (CET)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from us.es (sys.soleta.eu [212.170.55.40])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: 1984lsi)
        by entrada.int (Postfix) with ESMTPSA id D542941E4800;
        Mon, 25 Nov 2019 21:41:54 +0100 (CET)
Date:   Mon, 25 Nov 2019 21:41:56 +0100
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Phil Sutter <phil@nwl.cc>
Cc:     netfilter-devel@vger.kernel.org
Subject: Re: [iptables PATCH v4 00/12] Implement among match support
Message-ID: <20191125204155.xfjp66i7jz5vl6uu@salvia>
References: <20191121173647.31488-1-phil@nwl.cc>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191121173647.31488-1-phil@nwl.cc>
User-Agent: NeoMutt/20170113 (1.7.2)
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Thu, Nov 21, 2019 at 06:36:35PM +0100, Phil Sutter wrote:
> Changes since v3:
> - Rebase onto current master.
> - Whitespace fixup in patch 7.
> 
> Changes since v2:
> - Rebased onto current master branch. With cache levels being upstream,
>   no dependencies on unfinished work remains.
> - Integrate sets caching into cache level infrastructure.
> - Fixed temporary build breakage within series.
> - Larger review of last patch containing the actual among match
>   extension.
> 
> Changes since v1:
> - Rebased onto my performance improvements patch series.
> - Aligned set caching routines with changes in above series.
> - Fixed patch ordering so builds are not broken intermittently.
> - Replaced magic numbers by defines or offsetof() statements. Note that
>   I did not move any defines into libnftnl; the remaining ones are for
>   values in sets' key_type attribute which neither libnftnl nor kernel
>   care about. Setting that is merely for compatibility with nft tool.
> 
> This series ultimately adds among match support to ebtables-nft. The
> implementation merely shares the user interface with legacy one,
> internally the code is distinct: libebt_among.c does not make use of the
> wormhash data structure but a much simpler one for "temporary" storage
> of data until being converted into an anonymous set and associated
> lookup expression.
> 
> Patches 1 to 5 implement required changes and are rather boring by
> themselves: When converting an nftnl rule to iptables command state,
> cache access is required (to lookup set references).
> 
> Patch 6 simplifies things a bit with the above in place.
> 
> Patches 7 to 11 implement anonymous set support.
> 
> Patch 12 then adds the actual among match implementation for
> ebtables-nft.

For this series:

Acked-by: Pablo Neira Ayuso <pablo@netfilter.org>

Thanks Phil.
