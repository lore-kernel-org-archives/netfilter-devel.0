Return-Path: <SRS0=aqP0=2Y=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 407DDC2D0C2
	for <netfilter-devel@archiver.kernel.org>; Fri,  3 Jan 2020 17:57:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 11BA4215A4
	for <netfilter-devel@archiver.kernel.org>; Fri,  3 Jan 2020 17:57:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728150AbgACR5D (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 3 Jan 2020 12:57:03 -0500
Received: from correo.us.es ([193.147.175.20]:56688 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728110AbgACR5D (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 3 Jan 2020 12:57:03 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 9CE1A1E8B25
        for <netfilter-devel@vger.kernel.org>; Fri,  3 Jan 2020 18:57:01 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 90220DA709
        for <netfilter-devel@vger.kernel.org>; Fri,  3 Jan 2020 18:57:01 +0100 (CET)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 85EF3DA707; Fri,  3 Jan 2020 18:57:01 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 98148DA702;
        Fri,  3 Jan 2020 18:56:59 +0100 (CET)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Fri, 03 Jan 2020 18:56:59 +0100 (CET)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from us.es (unknown [90.77.255.23])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: 1984lsi)
        by entrada.int (Postfix) with ESMTPSA id 73119426CCB9;
        Fri,  3 Jan 2020 18:56:59 +0100 (CET)
Date:   Fri, 3 Jan 2020 18:56:59 +0100
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     wenxu@ucloud.cn
Cc:     netfilter-devel@vger.kernel.org
Subject: Re: [PATCH nf v3 0/3] netfilter: nf_flow_table_offload: something
 fixes
Message-ID: <20200103175659.4cgp4mbb7jc3mefy@salvia>
References: <1576815278-1283-1-git-send-email-wenxu@ucloud.cn>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1576815278-1283-1-git-send-email-wenxu@ucloud.cn>
User-Agent: NeoMutt/20170113 (1.7.2)
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Series applied.
