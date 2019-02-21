Return-Path: <SRS0=37uZ=Q4=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_NEOMUTT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4C6E3C00319
	for <netfilter-devel@archiver.kernel.org>; Thu, 21 Feb 2019 10:23:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 17EFC204EC
	for <netfilter-devel@archiver.kernel.org>; Thu, 21 Feb 2019 10:23:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727634AbfBUKXy (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 21 Feb 2019 05:23:54 -0500
Received: from mail.us.es ([193.147.175.20]:44622 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725932AbfBUKXy (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 21 Feb 2019 05:23:54 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 92DEEF2687
        for <netfilter-devel@vger.kernel.org>; Thu, 21 Feb 2019 11:23:43 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 8165EDA872
        for <netfilter-devel@vger.kernel.org>; Thu, 21 Feb 2019 11:23:43 +0100 (CET)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 80299DA86F; Thu, 21 Feb 2019 11:23:43 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id ACA77DA87D;
        Thu, 21 Feb 2019 11:23:40 +0100 (CET)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Thu, 21 Feb 2019 11:23:40 +0100 (CET)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from us.es (sys.soleta.eu [212.170.55.40])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: 1984lsi)
        by entrada.int (Postfix) with ESMTPSA id 7D8804265A2F;
        Thu, 21 Feb 2019 11:23:40 +0100 (CET)
Date:   Thu, 21 Feb 2019 11:23:48 +0100
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Phil Sutter <phil@nwl.cc>
Cc:     netfilter-devel@vger.kernel.org
Subject: Re: [iptables PATCH] arptables: Print space before comma and counters
Message-ID: <20190221102348.lcqzm35hcxla47hq@salvia>
References: <20190215142743.8287-1-phil@nwl.cc>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190215142743.8287-1-phil@nwl.cc>
User-Agent: NeoMutt/20170113 (1.7.2)
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Fri, Feb 15, 2019 at 03:27:43PM +0100, Phil Sutter wrote:
> Legacy arptables separates counters from rest of rule by ' , '. Assuming
> that scripts scraping 'arptables -vL' output match on this, make
> arptables-nft output conformant.

Applied, thanks Phil.
