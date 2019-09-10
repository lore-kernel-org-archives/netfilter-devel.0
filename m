Return-Path: <SRS0=BTt+=XF=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AA652C49ED9
	for <netfilter-devel@archiver.kernel.org>; Tue, 10 Sep 2019 18:33:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 84D0D2082C
	for <netfilter-devel@archiver.kernel.org>; Tue, 10 Sep 2019 18:33:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727096AbfIJSdx (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 10 Sep 2019 14:33:53 -0400
Received: from correo.us.es ([193.147.175.20]:60416 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726148AbfIJSdx (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 10 Sep 2019 14:33:53 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id CAEE6B6C64
        for <netfilter-devel@vger.kernel.org>; Tue, 10 Sep 2019 20:33:48 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id BA6A2B7FF2
        for <netfilter-devel@vger.kernel.org>; Tue, 10 Sep 2019 20:33:48 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id B0017B7FFE; Tue, 10 Sep 2019 20:33:48 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 85F78B7FF2;
        Tue, 10 Sep 2019 20:33:46 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Tue, 10 Sep 2019 20:33:46 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from us.es (unknown [31.4.177.17])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: 1984lsi)
        by entrada.int (Postfix) with ESMTPSA id 321664265A5A;
        Tue, 10 Sep 2019 20:33:46 +0200 (CEST)
Date:   Tue, 10 Sep 2019 20:33:45 +0200
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Phil Sutter <phil@nwl.cc>
Cc:     netfilter-devel@vger.kernel.org
Subject: Re: [conntrack-tools PATCH] nfct: helper: Fix NFCTH_ATTR_PROTO_L4NUM
 size
Message-ID: <20190910183345.2fn5prc4yt3rwvnl@salvia>
References: <20190910120631.20817-1-phil@nwl.cc>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190910120631.20817-1-phil@nwl.cc>
User-Agent: NeoMutt/20170113 (1.7.2)
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Tue, Sep 10, 2019 at 02:06:31PM +0200, Phil Sutter wrote:
> Kernel defines NFCTH_TUPLE_L4PROTONUM as of type NLA_U8. When adding a
> helper, NFCTH_ATTR_PROTO_L4NUM attribute is correctly set using
> nfct_helper_attr_set_u8(), though when deleting
> nfct_helper_attr_set_u32() was incorrectly used. Due to alignment, this
> causes trouble only on Big Endian.
> 
> Fixes: 5e8f64f46cb1d ("conntrackd: add cthelper infrastructure (+ example FTP helper)")
> Signed-off-by: Phil Sutter <phil@nwl.cc>

Acked-by: Pablo Neira Ayuso <pablo@netfilter.org>
