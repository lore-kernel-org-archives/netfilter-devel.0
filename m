Return-Path: <SRS0=TYlN=YI=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5D9FAC10F14
	for <netfilter-devel@archiver.kernel.org>; Tue, 15 Oct 2019 15:51:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 34AB120854
	for <netfilter-devel@archiver.kernel.org>; Tue, 15 Oct 2019 15:51:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728197AbfJOPvy (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 15 Oct 2019 11:51:54 -0400
Received: from correo.us.es ([193.147.175.20]:49256 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727478AbfJOPvx (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 15 Oct 2019 11:51:53 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 4E10AC1A11
        for <netfilter-devel@vger.kernel.org>; Tue, 15 Oct 2019 17:51:49 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 4110EB8007
        for <netfilter-devel@vger.kernel.org>; Tue, 15 Oct 2019 17:51:49 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 36D55B8001; Tue, 15 Oct 2019 17:51:49 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 3A1FBDA8E8;
        Tue, 15 Oct 2019 17:51:47 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Tue, 15 Oct 2019 17:51:47 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from us.es (sys.soleta.eu [212.170.55.40])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: 1984lsi)
        by entrada.int (Postfix) with ESMTPSA id 10C9642EE38E;
        Tue, 15 Oct 2019 17:51:47 +0200 (CEST)
Date:   Tue, 15 Oct 2019 17:51:49 +0200
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Phil Sutter <phil@nwl.cc>
Cc:     netfilter-devel@vger.kernel.org
Subject: Re: [libnftnl PATCH 2/6] set_elem: Fix return code of
 nftnl_set_elem_set()
Message-ID: <20191015155149.d2xyguafxthiquv5@salvia>
References: <20191015141658.11325-1-phil@nwl.cc>
 <20191015141658.11325-3-phil@nwl.cc>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191015141658.11325-3-phil@nwl.cc>
User-Agent: NeoMutt/20170113 (1.7.2)
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Tue, Oct 15, 2019 at 04:16:54PM +0200, Phil Sutter wrote:
> The function returned -1 on success.
> 
> Signed-off-by: Phil Sutter <phil@nwl.cc>

Acked-by: Pablo Neira Ayuso <pablo@netfilter.org>
