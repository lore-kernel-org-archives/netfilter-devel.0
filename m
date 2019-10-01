Return-Path: <SRS0=ZC8Q=X2=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7959BC352AA
	for <netfilter-devel@archiver.kernel.org>; Tue,  1 Oct 2019 18:27:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4F31E215EA
	for <netfilter-devel@archiver.kernel.org>; Tue,  1 Oct 2019 18:27:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727537AbfJAS1l (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 1 Oct 2019 14:27:41 -0400
Received: from correo.us.es ([193.147.175.20]:49900 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725951AbfJAS1k (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 1 Oct 2019 14:27:40 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 85EC51C4430
        for <netfilter-devel@vger.kernel.org>; Tue,  1 Oct 2019 20:27:35 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 78015B7FFB
        for <netfilter-devel@vger.kernel.org>; Tue,  1 Oct 2019 20:27:35 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 6DC2EB7FF6; Tue,  1 Oct 2019 20:27:35 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 832B2B8001;
        Tue,  1 Oct 2019 20:27:33 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Tue, 01 Oct 2019 20:27:33 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from us.es (sys.soleta.eu [212.170.55.40])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: 1984lsi)
        by entrada.int (Postfix) with ESMTPSA id 592FF4251480;
        Tue,  1 Oct 2019 20:27:33 +0200 (CEST)
Date:   Tue, 1 Oct 2019 20:27:35 +0200
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     "Jose M. Guisado Gomez" <guigom@riseup.net>
Cc:     netfilter-devel@vger.kernel.org
Subject: Re: [PATCH iptables] extensions: add libxt_SYNPROXY xlate method
Message-ID: <20191001182735.vnxfnvmzv67avkll@salvia>
References: <20190930172807.5452-1-guigom@riseup.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190930172807.5452-1-guigom@riseup.net>
User-Agent: NeoMutt/20170113 (1.7.2)
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Mon, Sep 30, 2019 at 07:28:07PM +0200, Jose M. Guisado Gomez wrote:
> This adds translation capabilities when encountering SYNPROXY inside
> iptables rules.

Applied, thanks.
