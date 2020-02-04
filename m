Return-Path: <SRS0=DSQd=3Y=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7E747C35247
	for <netfilter-devel@archiver.kernel.org>; Tue,  4 Feb 2020 15:43:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5A30E20674
	for <netfilter-devel@archiver.kernel.org>; Tue,  4 Feb 2020 15:43:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727399AbgBDPnr (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 4 Feb 2020 10:43:47 -0500
Received: from correo.us.es ([193.147.175.20]:42104 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727369AbgBDPnq (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 4 Feb 2020 10:43:46 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 8F859130E24
        for <netfilter-devel@vger.kernel.org>; Tue,  4 Feb 2020 16:43:44 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 81BE1DA711
        for <netfilter-devel@vger.kernel.org>; Tue,  4 Feb 2020 16:43:44 +0100 (CET)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 776A1DA709; Tue,  4 Feb 2020 16:43:44 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 3BF8EDA702;
        Tue,  4 Feb 2020 16:43:42 +0100 (CET)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Tue, 04 Feb 2020 16:43:42 +0100 (CET)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from us.es (65.pool85-50-107.static.orange.es [85.50.107.65])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: 1984lsi)
        by entrada.int (Postfix) with ESMTPSA id 1B93742EF4E0;
        Tue,  4 Feb 2020 16:43:42 +0100 (CET)
Date:   Tue, 4 Feb 2020 16:43:40 +0100
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     =?iso-8859-1?Q?Jos=E9_M=2E?= Guisado <guigom@riseup.net>
Cc:     netfilter-devel@vger.kernel.org, netfilter@vger.kernel.org
Subject: Re: [MAINTENANCE] migrating git.netfilter.org
Message-ID: <20200204154340.6dw4z7rdqs32b32l@salvia>
References: <20200131105123.dldbsjzqe6akaefr@salvia>
 <fbd79f10-0e17-a46e-32f5-e079389ac1f6@riseup.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <fbd79f10-0e17-a46e-32f5-e079389ac1f6@riseup.net>
User-Agent: NeoMutt/20170113 (1.7.2)
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Tue, Feb 04, 2020 at 04:30:50PM +0100, José M. Guisado wrote:
> On 31/01/2020 11:51, Pablo Neira Ayuso wrote:
> > Hi,
> > 
> > A few of our volunteers have been working hard to migrate
> > git.netfilter.org to a new server. The dns entry also has been updated
> > accordingly. Just let us know if you experience any troubles.
> > 
> > Thanks.
> 
> Great!
> 
> https://git.netfilter.org/iptables/ has been showing "Repository seems
> to be empty" for a few hours but the git url
> (git://git.netfilter.org/iptables) is working fine.

Fixed, thanks.
