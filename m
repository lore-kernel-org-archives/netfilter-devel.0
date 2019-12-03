Return-Path: <SRS0=edwS=ZZ=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BC876C432C3
	for <netfilter-devel@archiver.kernel.org>; Tue,  3 Dec 2019 17:17:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8FDBC20637
	for <netfilter-devel@archiver.kernel.org>; Tue,  3 Dec 2019 17:17:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726363AbfLCRRa (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 3 Dec 2019 12:17:30 -0500
Received: from correo.us.es ([193.147.175.20]:46932 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726182AbfLCRRa (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 3 Dec 2019 12:17:30 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 0E638120836
        for <netfilter-devel@vger.kernel.org>; Tue,  3 Dec 2019 18:17:25 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 0053ADA70E
        for <netfilter-devel@vger.kernel.org>; Tue,  3 Dec 2019 18:17:25 +0100 (CET)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id EA2F8DA705; Tue,  3 Dec 2019 18:17:24 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id E28B5DA70D;
        Tue,  3 Dec 2019 18:17:22 +0100 (CET)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Tue, 03 Dec 2019 18:17:22 +0100 (CET)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from us.es (sys.soleta.eu [212.170.55.40])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: 1984lsi)
        by entrada.int (Postfix) with ESMTPSA id B430A4265A5A;
        Tue,  3 Dec 2019 18:17:22 +0100 (CET)
Date:   Tue, 3 Dec 2019 18:17:23 +0100
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Jan Engelhardt <jengelh@inai.de>
Cc:     netfilter-devel@vger.kernel.org
Subject: Re: [PATCH] build: remove stray @ sign in manpage
Message-ID: <20191203171723.a23osgueindpqdrs@salvia>
References: <20191202195204.23316-1-jengelh@inai.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191202195204.23316-1-jengelh@inai.de>
User-Agent: NeoMutt/20170113 (1.7.2)
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Mon, Dec 02, 2019 at 08:52:04PM +0100, Jan Engelhardt wrote:
> Because the sed command was not matching the trailing @, it
> was left in the manpage, leading to
> 
> NAME
>        ebtables-legacy (2.0.11@) - Ethernet bridge frame table administration (legacy)

Applied, thanks.
