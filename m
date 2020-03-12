Return-Path: <SRS0=u4Sz=45=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A498DC10DCE
	for <netfilter-devel@archiver.kernel.org>; Thu, 12 Mar 2020 13:44:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6EF8620650
	for <netfilter-devel@archiver.kernel.org>; Thu, 12 Mar 2020 13:44:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727289AbgCLNoD (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 12 Mar 2020 09:44:03 -0400
Received: from correo.us.es ([193.147.175.20]:52700 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727007AbgCLNoD (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 12 Mar 2020 09:44:03 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 1748715AEA3
        for <netfilter-devel@vger.kernel.org>; Thu, 12 Mar 2020 14:43:38 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 095B1DA39F
        for <netfilter-devel@vger.kernel.org>; Thu, 12 Mar 2020 14:43:38 +0100 (CET)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 08B4DDA390; Thu, 12 Mar 2020 14:43:38 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 447D2DA8E6
        for <netfilter-devel@vger.kernel.org>; Thu, 12 Mar 2020 14:43:36 +0100 (CET)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Thu, 12 Mar 2020 14:43:36 +0100 (CET)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from us.es (unknown [90.77.255.23])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: 1984lsi)
        by entrada.int (Postfix) with ESMTPSA id 1C59942EF42A
        for <netfilter-devel@vger.kernel.org>; Thu, 12 Mar 2020 14:43:36 +0100 (CET)
Date:   Thu, 12 Mar 2020 14:43:58 +0100
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Subject: rebasing nf-next...
Message-ID: <20200312134358.upfhkomfxyddpebd@salvia>
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

I'm removing a patch from nf-next to extend nft_bitwise after
discussing this with his author. This patch is not yet in net-next.

I have rebased nf-next, while at it, there was also a small conflict
with nf that is now solved.

Please, refresh your nf-next clone before moving ahead.

I'm sorry for the inconvenience.
