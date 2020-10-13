Return-Path: <SRS0=fGlf=DU=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2B8BBC433E7
	for <netfilter-devel@archiver.kernel.org>; Tue, 13 Oct 2020 18:29:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BD088208D5
	for <netfilter-devel@archiver.kernel.org>; Tue, 13 Oct 2020 18:29:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727455AbgJMS3C (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 13 Oct 2020 14:29:02 -0400
Received: from correo.us.es ([193.147.175.20]:53272 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726899AbgJMS3C (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 13 Oct 2020 14:29:02 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id E22394A7063
        for <netfilter-devel@vger.kernel.org>; Tue, 13 Oct 2020 20:29:00 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id D4F30DA73F
        for <netfilter-devel@vger.kernel.org>; Tue, 13 Oct 2020 20:29:00 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id CA826DA730; Tue, 13 Oct 2020 20:29:00 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id F2534DA73F;
        Tue, 13 Oct 2020 20:28:58 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Tue, 13 Oct 2020 20:28:58 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from us.es (unknown [90.77.255.23])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: 1984lsi)
        by entrada.int (Postfix) with ESMTPSA id CBA2042EFB80;
        Tue, 13 Oct 2020 20:28:58 +0200 (CEST)
Date:   Tue, 13 Oct 2020 20:28:58 +0200
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Mikhail Sennikovsky <mikhail.sennikovskii@cloud.ionos.com>
Cc:     netfilter-devel@vger.kernel.org
Subject: Re: [PATCH 1/8] tests: icmp entry create/delete
Message-ID: <20201013182858.GA2069@salvia>
References: <20200925124919.9389-1-mikhail.sennikovskii@cloud.ionos.com>
 <20200925124919.9389-2-mikhail.sennikovskii@cloud.ionos.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20200925124919.9389-2-mikhail.sennikovskii@cloud.ionos.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Virus-Scanned: ClamAV using ClamSMTP
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Fri, Sep 25, 2020 at 02:49:12PM +0200, Mikhail Sennikovsky wrote:
> Add test to cover icmp entry creation/deletion with conntrack

Applied, thanks.
