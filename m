Return-Path: <SRS0=sEEs=Z2=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8074EC43603
	for <netfilter-devel@archiver.kernel.org>; Wed,  4 Dec 2019 17:49:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 15BB120661
	for <netfilter-devel@archiver.kernel.org>; Wed,  4 Dec 2019 17:49:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728065AbfLDRtc (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 4 Dec 2019 12:49:32 -0500
Received: from correo.us.es ([193.147.175.20]:38148 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726934AbfLDRtc (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 4 Dec 2019 12:49:32 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 88E9F5E5394
        for <netfilter-devel@vger.kernel.org>; Wed,  4 Dec 2019 18:49:29 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 7A286DA70A
        for <netfilter-devel@vger.kernel.org>; Wed,  4 Dec 2019 18:49:29 +0100 (CET)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 6FD13DA709; Wed,  4 Dec 2019 18:49:29 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 75B7BDA705;
        Wed,  4 Dec 2019 18:49:27 +0100 (CET)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Wed, 04 Dec 2019 18:49:27 +0100 (CET)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from us.es (sys.soleta.eu [212.170.55.40])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: 1984lsi)
        by entrada.int (Postfix) with ESMTPSA id 512DE42EE38F;
        Wed,  4 Dec 2019 18:49:27 +0100 (CET)
Date:   Wed, 4 Dec 2019 18:49:27 +0100
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Phil Sutter <phil@nwl.cc>
Cc:     netfilter-devel@vger.kernel.org
Subject: Re: [iptables PATCH 1/2] Fix DEBUG build
Message-ID: <20191204174927.5eylewkivztqwmzh@salvia>
References: <20191204090606.2088-1-phil@nwl.cc>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191204090606.2088-1-phil@nwl.cc>
User-Agent: NeoMutt/20170113 (1.7.2)
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Wed, Dec 04, 2019 at 10:06:05AM +0100, Phil Sutter wrote:
> Fixed commit missed to update this conditional call to
> nft_rule_print_save().
> 
> Fixes: 1e8ef6a584754 ("nft: family_ops: Pass nft_handle to 'rule_to_cs' callback")
> Signed-off-by: Phil Sutter <phil@nwl.cc>

If you still find all this debugging useful.

Acked-by: Pablo Neira Ayuso <pablo@netfilter.org>

Otherwise, remove the nft DEBUG is another option. IIRC those were
added at very early stage to fix a few issues with -D and -C commands.

Pick the one you prefer. Thanks!
