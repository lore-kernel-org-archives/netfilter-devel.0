Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6E043C433E0
	for <netfilter-devel@archiver.kernel.org>; Sun,  3 Jan 2021 19:06:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2BD1220786
	for <netfilter-devel@archiver.kernel.org>; Sun,  3 Jan 2021 19:06:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727118AbhACTFn (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sun, 3 Jan 2021 14:05:43 -0500
Received: from correo.us.es ([193.147.175.20]:37060 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725840AbhACTFm (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Sun, 3 Jan 2021 14:05:42 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 9CEBB1022A0
        for <netfilter-devel@vger.kernel.org>; Sun,  3 Jan 2021 20:04:25 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 90047DA704
        for <netfilter-devel@vger.kernel.org>; Sun,  3 Jan 2021 20:04:25 +0100 (CET)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 85BCFDA72F; Sun,  3 Jan 2021 20:04:25 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 33E45DA78A;
        Sun,  3 Jan 2021 20:04:23 +0100 (CET)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Sun, 03 Jan 2021 20:04:23 +0100 (CET)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from us.es (unknown [90.77.255.23])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: 1984lsi)
        by entrada.int (Postfix) with ESMTPSA id 147E6426CC84;
        Sun,  3 Jan 2021 20:04:23 +0100 (CET)
Date:   Sun, 3 Jan 2021 20:04:58 +0100
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Eyal Birger <eyal.birger@gmail.com>
Cc:     netfilter-devel@vger.kernel.org
Subject: Re: [PATCH libnetfilter_conntrack] examples: check return value of
 nfct_nlmsg_build()
Message-ID: <20210103190458.GA17660@salvia>
References: <20210101090226.3237589-1-eyal.birger@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20210101090226.3237589-1-eyal.birger@gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Virus-Scanned: ClamAV using ClamSMTP
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Fri, Jan 01, 2021 at 11:02:26AM +0200, Eyal Birger wrote:
> nfct_nlmsg_build() may fail for different reasons, for example if
> insufficient parameters exist in the ct object. The resulting nlh would
> not contain any of the ct attributes.
> 
> Some conntrack operations would still operate in such case, for example
> an IPCTNL_MSG_CT_DELETE message would just delete all existing conntrack
> entries.
> 
> While the example as it is does supply correct parameters, it's safer
> as reference to validate the return value.

Applied, thanks.
