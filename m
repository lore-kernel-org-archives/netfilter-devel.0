Return-Path: <SRS0=WT5G=RJ=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_NEOMUTT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 876D1C43381
	for <netfilter-devel@archiver.kernel.org>; Wed,  6 Mar 2019 18:24:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 62A99205F4
	for <netfilter-devel@archiver.kernel.org>; Wed,  6 Mar 2019 18:24:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726635AbfCFSYq (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 6 Mar 2019 13:24:46 -0500
Received: from mail.us.es ([193.147.175.20]:51082 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725747AbfCFSYp (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 6 Mar 2019 13:24:45 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id C0337190F62
        for <netfilter-devel@vger.kernel.org>; Wed,  6 Mar 2019 19:24:43 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id AE47BDA846
        for <netfilter-devel@vger.kernel.org>; Wed,  6 Mar 2019 19:24:43 +0100 (CET)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id AD3A4DA796; Wed,  6 Mar 2019 19:24:43 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id DA384DA86E;
        Wed,  6 Mar 2019 19:24:41 +0100 (CET)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Wed, 06 Mar 2019 19:24:41 +0100 (CET)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from us.es (sys.soleta.eu [212.170.55.40])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: 1984lsi)
        by entrada.int (Postfix) with ESMTPSA id AE3774265A2F;
        Wed,  6 Mar 2019 19:24:41 +0100 (CET)
Date:   Wed, 6 Mar 2019 19:24:41 +0100
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Fernando Fernandez Mancera <ffmancera@riseup.net>
Cc:     netfilter-devel@vger.kernel.org
Subject: Re: [PATCH nf-next] netfilter: nft_osf: Add version option support
Message-ID: <20190306182441.sv3ik3quthe6bpx4@salvia>
References: <20190306124435.708-1-ffmancera@riseup.net>
 <20190306161502.ur4zm3arcdcfc6bn@salvia>
 <805cae0b-3458-5bf0-9be0-2698b90d097f@riseup.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <805cae0b-3458-5bf0-9be0-2698b90d097f@riseup.net>
User-Agent: NeoMutt/20170113 (1.7.2)
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Wed, Mar 06, 2019 at 05:55:11PM +0100, Fernando Fernandez Mancera wrote:
> Sorry about the wrong mailing list, it was a mistake.

No worries :-)
