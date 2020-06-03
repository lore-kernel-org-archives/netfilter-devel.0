Return-Path: <SRS0=kXi6=7Q=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C52F0C433DF
	for <netfilter-devel@archiver.kernel.org>; Wed,  3 Jun 2020 11:37:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A844A206C3
	for <netfilter-devel@archiver.kernel.org>; Wed,  3 Jun 2020 11:37:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726086AbgFCLhS (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 3 Jun 2020 07:37:18 -0400
Received: from correo.us.es ([193.147.175.20]:45406 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725906AbgFCLhR (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 3 Jun 2020 07:37:17 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 4A6F415AEB6
        for <netfilter-devel@vger.kernel.org>; Wed,  3 Jun 2020 13:37:15 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 3B0A1DA73F
        for <netfilter-devel@vger.kernel.org>; Wed,  3 Jun 2020 13:37:15 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 306F5DA791; Wed,  3 Jun 2020 13:37:15 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 9BE0DDA73F;
        Wed,  3 Jun 2020 13:37:12 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Wed, 03 Jun 2020 13:37:12 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from us.es (unknown [90.77.255.23])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: 1984lsi)
        by entrada.int (Postfix) with ESMTPSA id 7E3ED42EF42B;
        Wed,  3 Jun 2020 13:37:12 +0200 (CEST)
Date:   Wed, 3 Jun 2020 13:37:12 +0200
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter@vger.kernel.org, netfilter-devel@vger.kernel.org,
        netfilter-announce@lists.netfilter.org
Subject: [MAINTENANCE] Shutting down FTP services at netfilter.org
Message-ID: <20200603113712.GA24918@salvia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Hi,

Kernel.org already disabled FTP years ago [1]:

 "... we're thinking it's time to terminate another service that has
  important protocol and security implications -- our FTP servers."

So netfilter.org will also be shutting down FTP services by
June 12th 2020.

As an alternative, you can still reach the entire netfilter.org
software repository through HTTP at this new location:

        https://netfilter.org/pub/

Thanks.

Pablo,
on behalf of the Netfilter coreteam.

[1] https://www.kernel.org/shutting-down-ftp-services.html
