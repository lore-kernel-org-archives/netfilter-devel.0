Return-Path: <SRS0=Ro/3=TA=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_NEOMUTT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8BECDC43219
	for <netfilter-devel@archiver.kernel.org>; Tue, 30 Apr 2019 12:19:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5D03320652
	for <netfilter-devel@archiver.kernel.org>; Tue, 30 Apr 2019 12:19:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726715AbfD3MTx (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 30 Apr 2019 08:19:53 -0400
Received: from mail.us.es ([193.147.175.20]:43604 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726053AbfD3MTw (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 30 Apr 2019 08:19:52 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 027E411FBF4
        for <netfilter-devel@vger.kernel.org>; Tue, 30 Apr 2019 14:19:51 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id E904EDA717
        for <netfilter-devel@vger.kernel.org>; Tue, 30 Apr 2019 14:19:50 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id DEB5EDA716; Tue, 30 Apr 2019 14:19:50 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id E7EE0DA705;
        Tue, 30 Apr 2019 14:19:48 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Tue, 30 Apr 2019 14:19:48 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from us.es (129.166.216.87.static.jazztel.es [87.216.166.129])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: 1984lsi)
        by entrada.int (Postfix) with ESMTPSA id B17724265A31;
        Tue, 30 Apr 2019 14:19:48 +0200 (CEST)
Date:   Tue, 30 Apr 2019 14:19:48 +0200
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     xiangxia.m.yue@gmail.com
Cc:     netfilter-devel@vger.kernel.org
Subject: Re: [PATCH] netfilter: conntrack: limit sysctl setting for boolean
 options
Message-ID: <20190430121948.oysh346ign4ebtcw@salvia>
References: <1554650060-34568-1-git-send-email-xiangxia.m.yue@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1554650060-34568-1-git-send-email-xiangxia.m.yue@gmail.com>
User-Agent: NeoMutt/20170113 (1.7.2)
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Sun, Apr 07, 2019 at 08:14:20AM -0700, xiangxia.m.yue@gmail.com wrote:
> From: Tonghao Zhang <xiangxia.m.yue@gmail.com>
> 
> We use the zero and one to limit the boolean options setting.
> After this patch we only set 0 or 1 to boolean options for nf
> conntrack sysctl.

Applied.
