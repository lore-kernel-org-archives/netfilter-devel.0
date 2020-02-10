Return-Path: <SRS0=1PBg=36=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F2C2EC352A4
	for <netfilter-devel@archiver.kernel.org>; Mon, 10 Feb 2020 22:46:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C54DD2051A
	for <netfilter-devel@archiver.kernel.org>; Mon, 10 Feb 2020 22:46:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727505AbgBJWqv (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 10 Feb 2020 17:46:51 -0500
Received: from correo.us.es ([193.147.175.20]:58956 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727116AbgBJWqv (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 10 Feb 2020 17:46:51 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id C0C0BE8B6D
        for <netfilter-devel@vger.kernel.org>; Mon, 10 Feb 2020 23:46:50 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id B487DDA705
        for <netfilter-devel@vger.kernel.org>; Mon, 10 Feb 2020 23:46:50 +0100 (CET)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id AA101DA701; Mon, 10 Feb 2020 23:46:50 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id CB389DA705;
        Mon, 10 Feb 2020 23:46:48 +0100 (CET)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Mon, 10 Feb 2020 23:46:48 +0100 (CET)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from us.es (unknown [90.77.255.23])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: 1984lsi)
        by entrada.int (Postfix) with ESMTPSA id A107C426CCBA;
        Mon, 10 Feb 2020 23:46:48 +0100 (CET)
Date:   Mon, 10 Feb 2020 23:46:46 +0100
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Laurent Fasnacht <fasnacht@protonmail.ch>
Cc:     netfilter-devel@vger.kernel.org
Subject: Re: [PATCH nft include v2 3/7] scanner: move indesc list append in
 scanner_push_indesc
Message-ID: <20200210224646.mfqxffdeczayxi23@salvia>
References: <20200210101709.9182-1-fasnacht@protonmail.ch>
 <20200210101709.9182-4-fasnacht@protonmail.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200210101709.9182-4-fasnacht@protonmail.ch>
User-Agent: NeoMutt/20170113 (1.7.2)
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Mon, Feb 10, 2020 at 10:17:22AM +0000, Laurent Fasnacht wrote:
> Having a single point makes refactoring easier.

Also applied this one. Thanks.
