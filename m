Return-Path: <SRS0=6lPY=BO=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.5 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3CC0DC433DF
	for <netfilter-devel@archiver.kernel.org>; Tue,  4 Aug 2020 11:44:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2046F20738
	for <netfilter-devel@archiver.kernel.org>; Tue,  4 Aug 2020 11:44:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729698AbgHDLoY (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 4 Aug 2020 07:44:24 -0400
Received: from correo.us.es ([193.147.175.20]:60208 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726086AbgHDLoD (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 4 Aug 2020 07:44:03 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 06D57F2DE6
        for <netfilter-devel@vger.kernel.org>; Tue,  4 Aug 2020 13:44:03 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id ED217DA78D
        for <netfilter-devel@vger.kernel.org>; Tue,  4 Aug 2020 13:44:02 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id E1F0DDA792; Tue,  4 Aug 2020 13:44:02 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id BEF9EDA722;
        Tue,  4 Aug 2020 13:44:00 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Tue, 04 Aug 2020 13:44:00 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from us.es (unknown [213.143.49.65])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: 1984lsi)
        by entrada.int (Postfix) with ESMTPSA id 471AD4265A32;
        Tue,  4 Aug 2020 13:44:00 +0200 (CEST)
Date:   Tue, 4 Aug 2020 13:43:57 +0200
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Stefano Brivio <sbrivio@redhat.com>
Cc:     Mike Dillinger <miked@softtalker.com>, Phil Sutter <phil@nwl.cc>,
        netfilter-devel@vger.kernel.org
Subject: Re: [PATCH nft v2] tests: 0044interval_overlap_0: Repeat insertion
 tests with timeout
Message-ID: <20200804114357.GA21665@salvia>
References: <3154841e672db057d6b4a8428743a9202e87be5e.1596461315.git.sbrivio@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3154841e672db057d6b4a8428743a9202e87be5e.1596461315.git.sbrivio@redhat.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Mon, Aug 03, 2020 at 04:06:21PM +0200, Stefano Brivio wrote:
> Mike Dillinger reported issues with insertion of entries into sets
> supporting intervals that were denied because of false conflicts with
> elements that were already expired. Partial failures would occur to,
> leading to the generation of new intervals the user didn't specify,
> as only the opening or the closing elements wouldn't be inserted.

Applied, thanks.
