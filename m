Return-Path: <SRS0=LRZR=3U=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AD060C33CB2
	for <netfilter-devel@archiver.kernel.org>; Fri, 31 Jan 2020 10:51:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7FC29206F0
	for <netfilter-devel@archiver.kernel.org>; Fri, 31 Jan 2020 10:51:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728342AbgAaKv3 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 31 Jan 2020 05:51:29 -0500
Received: from correo.us.es ([193.147.175.20]:47444 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728325AbgAaKv2 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 31 Jan 2020 05:51:28 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 640D680FE6
        for <netfilter-devel@vger.kernel.org>; Fri, 31 Jan 2020 11:51:27 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 57808DA714
        for <netfilter-devel@vger.kernel.org>; Fri, 31 Jan 2020 11:51:27 +0100 (CET)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 4CF98DA721; Fri, 31 Jan 2020 11:51:27 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 61AE8DA713;
        Fri, 31 Jan 2020 11:51:25 +0100 (CET)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Fri, 31 Jan 2020 11:51:25 +0100 (CET)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from us.es (unknown [90.77.255.23])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: 1984lsi)
        by entrada.int (Postfix) with ESMTPSA id 38F2B42EFB81;
        Fri, 31 Jan 2020 11:51:25 +0100 (CET)
Date:   Fri, 31 Jan 2020 11:51:23 +0100
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org, netfilter@vger.kernel.org
Subject: [MAINTENANCE] migrating git.netfilter.org
Message-ID: <20200131105123.dldbsjzqe6akaefr@salvia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: NeoMutt/20170113 (1.7.2)
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Hi,

A few of our volunteers have been working hard to migrate
git.netfilter.org to a new server. The dns entry also has been updated
accordingly. Just let us know if you experience any troubles.

Thanks.
