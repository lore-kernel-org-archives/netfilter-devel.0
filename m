Return-Path: <SRS0=6DSs=4A=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0A3BEC352A4
	for <netfilter-devel@archiver.kernel.org>; Wed, 12 Feb 2020 20:44:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D7A5E24682
	for <netfilter-devel@archiver.kernel.org>; Wed, 12 Feb 2020 20:44:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727791AbgBLUoo (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 12 Feb 2020 15:44:44 -0500
Received: from correo.us.es ([193.147.175.20]:44370 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727111AbgBLUoo (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 12 Feb 2020 15:44:44 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 3896CE122F
        for <netfilter-devel@vger.kernel.org>; Wed, 12 Feb 2020 21:44:43 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 299C3DA703
        for <netfilter-devel@vger.kernel.org>; Wed, 12 Feb 2020 21:44:43 +0100 (CET)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 1F295DA709; Wed, 12 Feb 2020 21:44:43 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 2AF24DA703;
        Wed, 12 Feb 2020 21:44:41 +0100 (CET)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Wed, 12 Feb 2020 21:44:41 +0100 (CET)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from us.es (unknown [90.77.255.23])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: 1984lsi)
        by entrada.int (Postfix) with ESMTPSA id 0CA1D42EF42C;
        Wed, 12 Feb 2020 21:44:41 +0100 (CET)
Date:   Wed, 12 Feb 2020 21:44:39 +0100
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     fasnacht@protonmail.ch
Subject: Re: [PATCH nft 0/4] glob and maximum number of includes
Message-ID: <20200212204439.h44tjfvdz45ydkk3@salvia>
References: <20200211202308.90575-1-pablo@netfilter.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200211202308.90575-1-pablo@netfilter.org>
User-Agent: NeoMutt/20170113 (1.7.2)
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Tue, Feb 11, 2020 at 09:23:04PM +0100, Pablo Neira Ayuso wrote:
> Hi Laurent,
> 
> This approach maintains an array of stacks per depth.
> 
> The initial three patches comes as a preparation. The last patch is
> aiming to fix the issue with glob and the maximum number of includes.

Hm, unfortunately, my patchset does not work. I'm going to toss this
and go back to your approach.
