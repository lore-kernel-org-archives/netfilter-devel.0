Return-Path: <SRS0=+R7G=3E=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 90E95C33CB1
	for <netfilter-devel@archiver.kernel.org>; Wed, 15 Jan 2020 09:29:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 628BE207FF
	for <netfilter-devel@archiver.kernel.org>; Wed, 15 Jan 2020 09:29:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729393AbgAOJ3w (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 15 Jan 2020 04:29:52 -0500
Received: from correo.us.es ([193.147.175.20]:49246 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729143AbgAOJ3w (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 15 Jan 2020 04:29:52 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 367A3FF9AD
        for <netfilter-devel@vger.kernel.org>; Wed, 15 Jan 2020 10:29:50 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 2992BDA729
        for <netfilter-devel@vger.kernel.org>; Wed, 15 Jan 2020 10:29:50 +0100 (CET)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 1F081DA717; Wed, 15 Jan 2020 10:29:50 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 23DBDDA718;
        Wed, 15 Jan 2020 10:29:48 +0100 (CET)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Wed, 15 Jan 2020 10:29:48 +0100 (CET)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from us.es (unknown [90.77.255.23])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: 1984lsi)
        by entrada.int (Postfix) with ESMTPSA id 07E0B42EF42A;
        Wed, 15 Jan 2020 10:29:48 +0100 (CET)
Date:   Wed, 15 Jan 2020 10:29:47 +0100
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Jeremy Sowden <jeremy@azazel.net>
Cc:     Netfilter Devel <netfilter-devel@vger.kernel.org>
Subject: Re: [PATCH nf-next v2 00/10] netfilter: nft_bitwise: shift support
Message-ID: <20200115092947.ilduxznl3w36fq3m@salvia>
References: <20200114212918.134062-1-jeremy@azazel.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200114212918.134062-1-jeremy@azazel.net>
User-Agent: NeoMutt/20170113 (1.7.2)
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Tue, Jan 14, 2020 at 09:29:08PM +0000, Jeremy Sowden wrote:
> The connmark xtables extension supports bit-shifts.  Add support for
> shifts to nft_bitwise in order to allow nftables to do likewise, e.g.:
> 
>   nft add rule t c oif lo ct mark set meta mark << 8 | 0xab
>   nft add rule t c iif lo meta mark & 0xff 0xab ct mark set meta mark >> 8

Apart from the minor nitpick regard _DATA, this series LGTM, thanks
Jeremy.
