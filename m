Return-Path: <SRS0=/Fuh=VN=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8F276C76188
	for <netfilter-devel@archiver.kernel.org>; Tue, 16 Jul 2019 11:18:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 632042173B
	for <netfilter-devel@archiver.kernel.org>; Tue, 16 Jul 2019 11:18:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387579AbfGPLSC (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 16 Jul 2019 07:18:02 -0400
Received: from mail.us.es ([193.147.175.20]:42416 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1733269AbfGPLSC (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 16 Jul 2019 07:18:02 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 2838F20A52B
        for <netfilter-devel@vger.kernel.org>; Tue, 16 Jul 2019 13:18:00 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 1AA8CA6DA
        for <netfilter-devel@vger.kernel.org>; Tue, 16 Jul 2019 13:18:00 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 0E9FDDA732; Tue, 16 Jul 2019 13:18:00 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 18A6AD2F98;
        Tue, 16 Jul 2019 13:17:58 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Tue, 16 Jul 2019 13:17:58 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from us.es (sys.soleta.eu [212.170.55.40])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: 1984lsi)
        by entrada.int (Postfix) with ESMTPSA id EAB7A4265A2F;
        Tue, 16 Jul 2019 13:17:57 +0200 (CEST)
Date:   Tue, 16 Jul 2019 13:17:57 +0200
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Yonatan Goldschmidt <yon.goldschmidt@gmail.com>
Cc:     netfilter-devel@vger.kernel.org
Subject: Re: [PATCH v2] netfilter: Update obsolete comments referring to
 ip_conntrack
Message-ID: <20190716111757.nnwsfaikazxppotc@salvia>
References: <20190708225632.12366-1-yon.goldschmidt@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190708225632.12366-1-yon.goldschmidt@gmail.com>
User-Agent: NeoMutt/20170113 (1.7.2)
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Tue, Jul 09, 2019 at 01:56:32AM +0300, Yonatan Goldschmidt wrote:
> In 9fb9cbb1082d ("[NETFILTER]: Add nf_conntrack subsystem.") the new
> generic nf_conntrack was introduced, and it came to supersede the
> old ip_conntrack.
> This change updates (some) of the obsolete comments referring to old
> file/function names of the ip_conntrack mechanism, as well as removes
> a few self-referencing comments that we shouldn't maintain anymore.
> 
> I did not update any comments referring to historical actions (e.g,
> comments like "this file was derived from ..." were left untouched,
> even if the referenced file is no longer here).

Applied to nf.git, thanks.
