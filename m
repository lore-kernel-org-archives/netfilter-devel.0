Return-Path: <SRS0=uYLw=7H=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4F49EC433E0
	for <netfilter-devel@archiver.kernel.org>; Mon, 25 May 2020 20:04:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 28C482071A
	for <netfilter-devel@archiver.kernel.org>; Mon, 25 May 2020 20:04:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388885AbgEYUEd (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 25 May 2020 16:04:33 -0400
Received: from correo.us.es ([193.147.175.20]:34574 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388794AbgEYUEc (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 25 May 2020 16:04:32 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 2D65AFA4DB
        for <netfilter-devel@vger.kernel.org>; Mon, 25 May 2020 22:04:31 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 1F54DDA712
        for <netfilter-devel@vger.kernel.org>; Mon, 25 May 2020 22:04:31 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 14949DA703; Mon, 25 May 2020 22:04:31 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 2C4E4DA79C;
        Mon, 25 May 2020 22:04:29 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Mon, 25 May 2020 22:04:29 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from us.es (unknown [90.77.255.23])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: 1984lsi)
        by entrada.int (Postfix) with ESMTPSA id 0722342EFB80;
        Mon, 25 May 2020 22:04:28 +0200 (CEST)
Date:   Mon, 25 May 2020 22:04:28 +0200
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Stefano Brivio <sbrivio@redhat.com>
Cc:     Ana Rey <anarey@gmail.com>, netfilter-devel@vger.kernel.org
Subject: Re: [PATCH nft] tests: py: Actually use all available hooks in
 bridge/chains.t
Message-ID: <20200525200428.GB14991@salvia>
References: <2b98ba50fa537d10dfb535aff4ad34b00ec53cdd.1590323965.git.sbrivio@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2b98ba50fa537d10dfb535aff4ad34b00ec53cdd.1590323965.git.sbrivio@redhat.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Sun, May 24, 2020 at 03:00:07PM +0200, Stefano Brivio wrote:
> Despite being explicitly mentioned as available, prerouting and
> postrouting hooks are not used, filter-pre and filter-post chains
> are both built to hook on input.

Applied, thanks.
