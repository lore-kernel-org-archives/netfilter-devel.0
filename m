Return-Path: <SRS0=fTMW=VP=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 27E76C7618F
	for <netfilter-devel@archiver.kernel.org>; Thu, 18 Jul 2019 18:02:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 02A9820873
	for <netfilter-devel@archiver.kernel.org>; Thu, 18 Jul 2019 18:02:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727928AbfGRSCl (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 18 Jul 2019 14:02:41 -0400
Received: from mail.us.es ([193.147.175.20]:59634 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726649AbfGRSCl (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 18 Jul 2019 14:02:41 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id B115CBAEF0
        for <netfilter-devel@vger.kernel.org>; Thu, 18 Jul 2019 20:02:39 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 908351158EB
        for <netfilter-devel@vger.kernel.org>; Thu, 18 Jul 2019 20:02:39 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 8AC191158E7; Thu, 18 Jul 2019 20:02:39 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 59CFD11A053;
        Thu, 18 Jul 2019 20:01:31 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Thu, 18 Jul 2019 20:01:31 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from us.es (sys.soleta.eu [212.170.55.40])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: 1984lsi)
        by entrada.int (Postfix) with ESMTPSA id 256074265A2F;
        Thu, 18 Jul 2019 20:01:31 +0200 (CEST)
Date:   Thu, 18 Jul 2019 20:01:30 +0200
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Phil Sutter <phil@nwl.cc>
Cc:     netfilter-devel@vger.kernel.org
Subject: Re: [nft PATCH] json: Fix memleak in timeout_policy_json()
Message-ID: <20190718180130.laekio5e3754b3cf@salvia>
References: <20190718151656.19820-1-phil@nwl.cc>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190718151656.19820-1-phil@nwl.cc>
User-Agent: NeoMutt/20170113 (1.7.2)
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Thu, Jul 18, 2019 at 05:16:56PM +0200, Phil Sutter wrote:
> Use the correct function when populating policy property value,
> otherwise the temporary objects' refcounts are incremented.

Applied, thanks Phil.
