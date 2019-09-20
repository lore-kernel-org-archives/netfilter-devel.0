Return-Path: <SRS0=NOIG=XP=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9F8D5C49ED7
	for <netfilter-devel@archiver.kernel.org>; Fri, 20 Sep 2019 10:15:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7CF7D2054F
	for <netfilter-devel@archiver.kernel.org>; Fri, 20 Sep 2019 10:15:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2438047AbfITKPz (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 20 Sep 2019 06:15:55 -0400
Received: from correo.us.es ([193.147.175.20]:35770 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2438042AbfITKPy (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 20 Sep 2019 06:15:54 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id C963B15C113
        for <netfilter-devel@vger.kernel.org>; Fri, 20 Sep 2019 12:15:51 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id BA6B1FB362
        for <netfilter-devel@vger.kernel.org>; Fri, 20 Sep 2019 12:15:51 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id AFA75CA0F3; Fri, 20 Sep 2019 12:15:51 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 41C01B7FF6;
        Fri, 20 Sep 2019 12:15:48 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Fri, 20 Sep 2019 12:15:48 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from us.es (unknown [5.182.56.138])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: 1984lsi)
        by entrada.int (Postfix) with ESMTPSA id E30BF42EE38E;
        Fri, 20 Sep 2019 12:15:47 +0200 (CEST)
Date:   Fri, 20 Sep 2019 12:15:47 +0200
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Jeremy Sowden <jeremy@azazel.net>
Cc:     Netfilter Devel <netfilter-devel@vger.kernel.org>,
        Sebastian Priebe <sebastian.priebe@de.sii.group>
Subject: Re: [PATCH RFC nftables 1/4] configure: remove unused AC_SUBST
 macros.
Message-ID: <20190920101547.hinszzar7sfz6dfj@salvia>
References: <4df20614cd10434b9f91080d0862dd0c@de.sii.group>
 <20190916124203.31380-1-jeremy@azazel.net>
 <20190916124203.31380-2-jeremy@azazel.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190916124203.31380-2-jeremy@azazel.net>
User-Agent: NeoMutt/20170113 (1.7.2)
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Mon, Sep 16, 2019 at 01:42:00PM +0100, Jeremy Sowden wrote:
> configure.ac contains a couple of AC_SUBST macros which serve no
> purpose.  Remove them.

Applied this patch to reduce your next batch, thanks.
