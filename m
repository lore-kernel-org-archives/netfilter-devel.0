Return-Path: <SRS0=v4nU=CP=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.5 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	UNWANTED_LANGUAGE_BODY,USER_AGENT_SANE_1 autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 10244C43461
	for <netfilter-devel@archiver.kernel.org>; Sun,  6 Sep 2020 21:49:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BA313207BB
	for <netfilter-devel@archiver.kernel.org>; Sun,  6 Sep 2020 21:49:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726587AbgIFVtK (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sun, 6 Sep 2020 17:49:10 -0400
Received: from correo.us.es ([193.147.175.20]:51702 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726292AbgIFVtK (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Sun, 6 Sep 2020 17:49:10 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 7607B1F0CE4
        for <netfilter-devel@vger.kernel.org>; Sun,  6 Sep 2020 23:49:07 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 673EFDA722
        for <netfilter-devel@vger.kernel.org>; Sun,  6 Sep 2020 23:49:07 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 5CE2EDA704; Sun,  6 Sep 2020 23:49:07 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 06096DA72F
        for <netfilter-devel@vger.kernel.org>; Sun,  6 Sep 2020 23:49:05 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Sun, 06 Sep 2020 23:49:05 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from us.es (unknown [90.77.255.23])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: 1984lsi)
        by entrada.int (Postfix) with ESMTPSA id D303A41E4800
        for <netfilter-devel@vger.kernel.org>; Sun,  6 Sep 2020 23:49:04 +0200 (CEST)
Date:   Sun, 6 Sep 2020 23:49:04 +0200
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Netfilter Development <netfilter-devel@vger.kernel.org>
Subject: Re: Can someone please update libnetfilter_queue online documentation
Message-ID: <20200906214904.GA7550@salvia>
References: <20200906001817.GB6585@dimstar.local.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20200906001817.GB6585@dimstar.local.net>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Sun, Sep 06, 2020 at 10:18:17AM +1000, Duncan Roe wrote:
> Hi everyone,
> 
> The online doc for libnetfilter_queue at
> https://netfilter.org/projects/libnetfilter_queue/doxygen/html/ is still at
> release 1.0.3.

Refreshed.
