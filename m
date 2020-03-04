Return-Path: <SRS0=EiUA=4V=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 208B6C3F2D1
	for <netfilter-devel@archiver.kernel.org>; Wed,  4 Mar 2020 12:31:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E6FBF20838
	for <netfilter-devel@archiver.kernel.org>; Wed,  4 Mar 2020 12:31:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388019AbgCDMbf (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 4 Mar 2020 07:31:35 -0500
Received: from correo.us.es ([193.147.175.20]:54340 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387975AbgCDMbf (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 4 Mar 2020 07:31:35 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 9B36AE34E4
        for <netfilter-devel@vger.kernel.org>; Wed,  4 Mar 2020 13:31:18 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 8CEC3DA3A9
        for <netfilter-devel@vger.kernel.org>; Wed,  4 Mar 2020 13:31:18 +0100 (CET)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 7F637DA38F; Wed,  4 Mar 2020 13:31:18 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 97027FB378;
        Wed,  4 Mar 2020 13:31:16 +0100 (CET)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Wed, 04 Mar 2020 13:31:16 +0100 (CET)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from us.es (unknown [90.77.255.23])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: 1984lsi)
        by entrada.int (Postfix) with ESMTPSA id 706DD42EF52A;
        Wed,  4 Mar 2020 13:31:16 +0100 (CET)
Date:   Wed, 4 Mar 2020 13:31:30 +0100
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Lukas Wunner <lukas@wunner.de>
Cc:     Jozsef Kadlecsik <kadlec@netfilter.org>,
        Florian Westphal <fw@strlen.de>,
        netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
        netdev@vger.kernel.org, Martin Mares <mj@ucw.cz>,
        Daniel Borkmann <daniel@iogearbox.net>
Subject: Re: [PATCH nf-next,RFC 0/5] Netfilter egress hook
Message-ID: <20200304123130.yyb3miizk6yez4od@salvia>
References: <cover.1572528496.git.lukas@wunner.de>
 <20191107225149.5t4sg35b5gwuwawa@salvia>
 <20200304095032.s6ypvmo45d75wkr7@wunner.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200304095032.s6ypvmo45d75wkr7@wunner.de>
User-Agent: NeoMutt/20170113 (1.7.2)
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Wed, Mar 04, 2020 at 10:50:32AM +0100, Lukas Wunner wrote:
[...]
> So what's the consensus?  Shall I post a non-RFC version, rebased on
> current nf-next/master?

Please, move on and rebase on top of nf-next/master.

Thank you.
