Return-Path: <SRS0=aq0Q=4C=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7BB1EC3B1AB
	for <netfilter-devel@archiver.kernel.org>; Fri, 14 Feb 2020 17:33:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 59BE52082F
	for <netfilter-devel@archiver.kernel.org>; Fri, 14 Feb 2020 17:33:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390637AbgBNRdu (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 14 Feb 2020 12:33:50 -0500
Received: from correo.us.es ([193.147.175.20]:39204 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388693AbgBNRdt (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 14 Feb 2020 12:33:49 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 15FEB130E22
        for <netfilter-devel@vger.kernel.org>; Fri, 14 Feb 2020 18:33:50 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 08A27DA705
        for <netfilter-devel@vger.kernel.org>; Fri, 14 Feb 2020 18:33:50 +0100 (CET)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id F2687DA701; Fri, 14 Feb 2020 18:33:49 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 2FD6BDA710;
        Fri, 14 Feb 2020 18:33:48 +0100 (CET)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Fri, 14 Feb 2020 18:33:48 +0100 (CET)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from us.es (unknown [90.77.255.23])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: 1984lsi)
        by entrada.int (Postfix) with ESMTPSA id 1145242EF4E0;
        Fri, 14 Feb 2020 18:33:48 +0100 (CET)
Date:   Fri, 14 Feb 2020 18:33:46 +0100
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Stefano Brivio <sbrivio@redhat.com>
Cc:     netfilter-devel@vger.kernel.org
Subject: Re: [PATCH nf-next 0/2] Two non-functional fixes for nft_set_pipapo
Message-ID: <20200214173346.rbf2jkr5q6n532sw@salvia>
References: <cover.1581699548.git.sbrivio@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1581699548.git.sbrivio@redhat.com>
User-Agent: NeoMutt/20170113 (1.7.2)
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Fri, Feb 14, 2020 at 06:14:12PM +0100, Stefano Brivio wrote:
> Patch 1/2 fixes examples of mapping table values in comments,
> patch 2/2 drops an abuse of unlikely(), both reported by Pablo.
> 
> No functional changes are intended here. I'm not entirely sure
> these should be for nf-next, but I guess so as they don't carry
> any functional fix.

These are small, they can be placed into nf.git and I think they
qualify as fixes.

Thanks.
