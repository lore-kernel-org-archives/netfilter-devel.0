Return-Path: <SRS0=20nZ=ZY=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 39D74C432C3
	for <netfilter-devel@archiver.kernel.org>; Mon,  2 Dec 2019 23:50:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1575F20640
	for <netfilter-devel@archiver.kernel.org>; Mon,  2 Dec 2019 23:50:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726186AbfLBXuc (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 2 Dec 2019 18:50:32 -0500
Received: from correo.us.es ([193.147.175.20]:45892 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725834AbfLBXuc (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 2 Dec 2019 18:50:32 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 9CAE4E1224
        for <netfilter-devel@vger.kernel.org>; Tue,  3 Dec 2019 00:50:28 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 8E652DA707
        for <netfilter-devel@vger.kernel.org>; Tue,  3 Dec 2019 00:50:28 +0100 (CET)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 842F7DA705; Tue,  3 Dec 2019 00:50:28 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 753ADDA703;
        Tue,  3 Dec 2019 00:50:26 +0100 (CET)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Tue, 03 Dec 2019 00:50:26 +0100 (CET)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from us.es (sys.soleta.eu [212.170.55.40])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: 1984lsi)
        by entrada.int (Postfix) with ESMTPSA id 49B7E4265A5A;
        Tue,  3 Dec 2019 00:50:26 +0100 (CET)
Date:   Tue, 3 Dec 2019 00:50:27 +0100
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Phil Sutter <phil@nwl.cc>
Cc:     netfilter-devel@vger.kernel.org
Subject: Re: [libnftnl PATCH 0/4] Fix covscan-detected issues
Message-ID: <20191202235027.yfsu7knelqz6rp2k@salvia>
References: <20191202222401.867-1-phil@nwl.cc>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191202222401.867-1-phil@nwl.cc>
User-Agent: NeoMutt/20170113 (1.7.2)
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Mon, Dec 02, 2019 at 11:23:57PM +0100, Phil Sutter wrote:
> These are merely memleaks in error paths related to multi device support
> in flowtables and netdev family chains.

Acked-by: Pablo Neira Ayuso <pablo@netfilter.org>

Thanks for fixing up these, Phil.
