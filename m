Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B14C5C4361B
	for <netfilter-devel@archiver.kernel.org>; Tue,  8 Dec 2020 20:59:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8A4AA239FD
	for <netfilter-devel@archiver.kernel.org>; Tue,  8 Dec 2020 20:59:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729106AbgLHU7r (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 8 Dec 2020 15:59:47 -0500
Received: from correo.us.es ([193.147.175.20]:34208 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728469AbgLHU7r (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 8 Dec 2020 15:59:47 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id A2711D2C9D
        for <netfilter-devel@vger.kernel.org>; Tue,  8 Dec 2020 21:58:56 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 94268FC5E2
        for <netfilter-devel@vger.kernel.org>; Tue,  8 Dec 2020 21:58:56 +0100 (CET)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 89B8CDA73D; Tue,  8 Dec 2020 21:58:56 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id E5856DA73F;
        Tue,  8 Dec 2020 21:58:53 +0100 (CET)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Tue, 08 Dec 2020 21:58:53 +0100 (CET)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from us.es (unknown [90.77.255.23])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: 1984lsi)
        by entrada.int (Postfix) with ESMTPSA id C67764265A5A;
        Tue,  8 Dec 2020 21:58:53 +0100 (CET)
Date:   Tue, 8 Dec 2020 21:59:02 +0100
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Andreas Sundstrom <sunkan@zappa.cx>
Cc:     netfilter-devel@vger.kernel.org
Subject: Re: [PATCH] Remove IP_NF_IPTABLES dependency for NET_ACT_CONNMARK
Message-ID: <20201208205902.GA12294@salvia>
References: <c9657e87-731c-3219-62eb-0cc15b0ff4cd@zappa.cx>
 <20201208163926.GA10267@salvia>
 <978c5ab8-a0ff-76a5-0549-1b0617eb7e17@zappa.cx>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <978c5ab8-a0ff-76a5-0549-1b0617eb7e17@zappa.cx>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Virus-Scanned: ClamAV using ClamSMTP
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Tue, Dec 08, 2020 at 09:32:29PM +0100, Andreas Sundstrom wrote:
> On 2020-12-08 17:39, Pablo Neira Ayuso wrote:
> > Hi Andreas,
> > 
> > On Tue, Dec 08, 2020 at 12:55:30PM +0100, Andreas Sundstrom wrote:
> > > IP_NF_IPTABLES is a superfluous dependency
> > > 
> > > To be able to select NET_ACT_CONNMARK when iptables has not been
> > > enabled this dependency needs to be removed.
> > I just looked at other dependencies in the Kconfig file, these need to
> > be adjusted too.
> > 
> > NET_ACT_IPT actually depends on NETFILTER_XTABLES.
> > 
> > Is the patch I'm attaching looking good to you?
> 
> Yes it looks good, I can now also enable NET_ACT_CTINFO with my config.
> 
> Am now running 5.9.13 with it applied.

Thanks, I have submitted this patch:

https://patchwork.ozlabs.org/project/netfilter-devel/patch/20201208204707.11268-1-pablo@netfilter.org/
