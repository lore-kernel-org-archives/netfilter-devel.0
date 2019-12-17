Return-Path: <SRS0=i/iJ=2H=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 10075C2D0CD
	for <netfilter-devel@archiver.kernel.org>; Tue, 17 Dec 2019 21:59:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D928A20733
	for <netfilter-devel@archiver.kernel.org>; Tue, 17 Dec 2019 21:59:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726510AbfLQV7G (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 17 Dec 2019 16:59:06 -0500
Received: from correo.us.es ([193.147.175.20]:42022 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726143AbfLQV7F (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 17 Dec 2019 16:59:05 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 225D21176CF
        for <netfilter-devel@vger.kernel.org>; Tue, 17 Dec 2019 22:59:03 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 15EABDA70B
        for <netfilter-devel@vger.kernel.org>; Tue, 17 Dec 2019 22:59:03 +0100 (CET)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 0AA3CDA70A; Tue, 17 Dec 2019 22:59:03 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 0C35CDA707;
        Tue, 17 Dec 2019 22:59:01 +0100 (CET)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Tue, 17 Dec 2019 22:59:01 +0100 (CET)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from us.es (sys.soleta.eu [212.170.55.40])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: 1984lsi)
        by entrada.int (Postfix) with ESMTPSA id E1D474265A5A;
        Tue, 17 Dec 2019 22:59:00 +0100 (CET)
Date:   Tue, 17 Dec 2019 22:59:01 +0100
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Lukas Wunner <lukas@wunner.de>
Cc:     Jozsef Kadlecsik <kadlec@netfilter.org>,
        Florian Westphal <fw@strlen.de>,
        netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
        netdev@vger.kernel.org, Daniel Borkmann <daniel@iogearbox.net>
Subject: Re: [PATCH nf-next] netfilter: Document ingress hook
Message-ID: <20191217215901.aecmpxg3cb2xlc6z@salvia>
References: <348a3eb1c4348391e1836d858f24bd118934703f.1574247360.git.lukas@wunner.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <348a3eb1c4348391e1836d858f24bd118934703f.1574247360.git.lukas@wunner.de>
User-Agent: NeoMutt/20170113 (1.7.2)
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Wed, Nov 20, 2019 at 12:33:59PM +0100, Lukas Wunner wrote:
> Amend kerneldoc of struct net_device to fix a "make htmldocs" warning:
> 
> include/linux/netdevice.h:2045: warning: Function parameter or member 'nf_hooks_ingress' not described in 'net_device'

Also applied, thanks.
