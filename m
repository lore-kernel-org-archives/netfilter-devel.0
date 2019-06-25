Return-Path: <SRS0=l45K=UY=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_NEOMUTT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 769DDC4646C
	for <netfilter-devel@archiver.kernel.org>; Tue, 25 Jun 2019 00:14:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5821F205ED
	for <netfilter-devel@archiver.kernel.org>; Tue, 25 Jun 2019 00:14:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726395AbfFYAOr (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 24 Jun 2019 20:14:47 -0400
Received: from mail.us.es ([193.147.175.20]:38478 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729254AbfFYAOn (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 24 Jun 2019 20:14:43 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id A0A8AC04B0
        for <netfilter-devel@vger.kernel.org>; Tue, 25 Jun 2019 02:14:41 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 92587DA70A
        for <netfilter-devel@vger.kernel.org>; Tue, 25 Jun 2019 02:14:41 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 87F0DDA708; Tue, 25 Jun 2019 02:14:41 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 90B68DA704;
        Tue, 25 Jun 2019 02:14:39 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Tue, 25 Jun 2019 02:14:39 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from us.es (sys.soleta.eu [212.170.55.40])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: 1984lsi)
        by entrada.int (Postfix) with ESMTPSA id 695DD4265A2F;
        Tue, 25 Jun 2019 02:14:39 +0200 (CEST)
Date:   Tue, 25 Jun 2019 02:14:39 +0200
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Jan Engelhardt <jengelh@inai.de>
Cc:     netfilter-devel@vger.kernel.org
Subject: Re: [PATCH 1/3] build: unbreak non-functionality of --disable-python
Message-ID: <20190625001439.cs4qhcppow3uuxlw@salvia>
References: <20190624221645.28591-1-jengelh@inai.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190624221645.28591-1-jengelh@inai.de>
User-Agent: NeoMutt/20170113 (1.7.2)
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Hi Jan,

Thanks for fixing up this Python dependencies, this is indeed not in
good shape.

Please, if not much asking, resend include Signed-off-by: tag.

Thanks.
