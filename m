Return-Path: <SRS0=kGcq=BX=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.5 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 78944C433E0
	for <netfilter-devel@archiver.kernel.org>; Thu, 13 Aug 2020 02:11:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5F59820771
	for <netfilter-devel@archiver.kernel.org>; Thu, 13 Aug 2020 02:11:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726591AbgHMCLe (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 12 Aug 2020 22:11:34 -0400
Received: from correo.us.es ([193.147.175.20]:33104 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726167AbgHMCLd (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 12 Aug 2020 22:11:33 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 0076CDA3C3
        for <netfilter-devel@vger.kernel.org>; Thu, 13 Aug 2020 04:11:33 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id E6692DA789
        for <netfilter-devel@vger.kernel.org>; Thu, 13 Aug 2020 04:11:32 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id D9909DA73D; Thu, 13 Aug 2020 04:11:32 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id DE139DA722;
        Thu, 13 Aug 2020 04:11:30 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Thu, 13 Aug 2020 04:11:30 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from us.es (246.pool85-48-185.static.orange.es [85.48.185.246])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: 1984lsi)
        by entrada.int (Postfix) with ESMTPSA id 6A92542EE38E;
        Thu, 13 Aug 2020 04:11:30 +0200 (CEST)
Date:   Thu, 13 Aug 2020 04:11:27 +0200
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     "Jose M. Guisado Gomez" <guigom@riseup.net>
Cc:     netfilter-devel@vger.kernel.org
Subject: Re: [PATCH nft] src: add comment support for set declarations
Message-ID: <20200813021127.GB3336@salvia>
References: <20200811142719.328237-1-guigom@riseup.net>
 <20200811142719.328237-2-guigom@riseup.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200811142719.328237-2-guigom@riseup.net>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Tue, Aug 11, 2020 at 04:27:20PM +0200, Jose M. Guisado Gomez wrote:
> Allow users to add a comment when declaring a named set.

Applied, thanks.
