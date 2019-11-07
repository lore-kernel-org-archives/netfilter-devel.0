Return-Path: <SRS0=biDG=Y7=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E52C1C5DF61
	for <netfilter-devel@archiver.kernel.org>; Thu,  7 Nov 2019 09:37:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id ACE792084C
	for <netfilter-devel@archiver.kernel.org>; Thu,  7 Nov 2019 09:37:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727549AbfKGJhu convert rfc822-to-8bit (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 7 Nov 2019 04:37:50 -0500
Received: from correo.us.es ([193.147.175.20]:48718 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726866AbfKGJhu (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 7 Nov 2019 04:37:50 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id B074611EB94
        for <netfilter-devel@vger.kernel.org>; Thu,  7 Nov 2019 10:37:45 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id A2D65B7FF2
        for <netfilter-devel@vger.kernel.org>; Thu,  7 Nov 2019 10:37:45 +0100 (CET)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id A24CBDA72F; Thu,  7 Nov 2019 10:37:45 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 4D2C8B7FF2;
        Thu,  7 Nov 2019 10:37:43 +0100 (CET)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Thu, 07 Nov 2019 10:37:43 +0100 (CET)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from us.es (sys.soleta.eu [212.170.55.40])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: 1984lsi)
        by entrada.int (Postfix) with ESMTPSA id 2ACBA41E4801;
        Thu,  7 Nov 2019 10:37:43 +0100 (CET)
Date:   Thu, 7 Nov 2019 10:37:44 +0100
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Jan-Martin Raemer <raemer@zit-rlp.de>
Cc:     netfilter-devel@vger.kernel.org
Subject: Re: [PATCH] conntrackd UDP IPv6 destination address not usable (Bug
 1378)
Message-ID: <20191107093744.2nlajg7xvuoqacxk@salvia>
References: <20191107081710.GC5020@laptop-jmr.hs-koblenz.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
In-Reply-To: <20191107081710.GC5020@laptop-jmr.hs-koblenz.de>
User-Agent: NeoMutt/20170113 (1.7.2)
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Thu, Nov 07, 2019 at 09:17:10AM +0100, Jan-Martin Raemer wrote:
> Hi,
> 
> as reported in https://bugzilla.netfilter.org/show_bug.cgi?id=1378,
> conntrackd refuses to start with a vaild IPv6_Destination_Address,
> reporting "inet_pton(): IPv6 unsupported" due to a forgotten handling of
> err>0 (i.e. success). This patch fixes the issue:

Applied, thanks.
