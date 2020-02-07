Return-Path: <SRS0=l6lg=33=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 73B57C35242
	for <netfilter-devel@archiver.kernel.org>; Fri,  7 Feb 2020 17:00:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 47DE320838
	for <netfilter-devel@archiver.kernel.org>; Fri,  7 Feb 2020 17:00:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727403AbgBGRAM (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 7 Feb 2020 12:00:12 -0500
Received: from correo.us.es ([193.147.175.20]:37984 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726867AbgBGRAL (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 7 Feb 2020 12:00:11 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 6797D11EB99
        for <netfilter-devel@vger.kernel.org>; Fri,  7 Feb 2020 18:00:11 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 56874DA703
        for <netfilter-devel@vger.kernel.org>; Fri,  7 Feb 2020 18:00:11 +0100 (CET)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 4B6F9DA701; Fri,  7 Feb 2020 18:00:11 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 81C47DA713;
        Fri,  7 Feb 2020 18:00:09 +0100 (CET)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Fri, 07 Feb 2020 18:00:09 +0100 (CET)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from us.es (unknown [84.78.24.221])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: 1984lsi)
        by entrada.int (Postfix) with ESMTPSA id 6238142EFB82;
        Fri,  7 Feb 2020 18:00:08 +0100 (CET)
Date:   Fri, 7 Feb 2020 18:00:02 +0100
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Laurent Fasnacht <fasnacht@protonmail.ch>
Cc:     netfilter-devel@vger.kernel.org
Subject: Re: [PATCH nft 2/3] scanner: correctly compute include depth
Message-ID: <20200207170002.qlq7jvwuw2b6sgvr@salvia>
References: <20200205122858.20575-1-fasnacht@protonmail.ch>
 <20200205122858.20575-3-fasnacht@protonmail.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200205122858.20575-3-fasnacht@protonmail.ch>
User-Agent: NeoMutt/20170113 (1.7.2)
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Wed, Feb 05, 2020 at 12:30:13PM +0000, Laurent Fasnacht wrote:
> Inclusion depth was computed incorrectly for glob includes.

I get a segfault here when running your test after your patch 2/3 is
applied. I'm going to keep back this series, sorry.
