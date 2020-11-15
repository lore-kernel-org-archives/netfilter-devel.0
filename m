Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0AABDC2D0E4
	for <netfilter-devel@archiver.kernel.org>; Sun, 15 Nov 2020 11:19:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B3935223BD
	for <netfilter-devel@archiver.kernel.org>; Sun, 15 Nov 2020 11:19:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726928AbgKOLT1 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sun, 15 Nov 2020 06:19:27 -0500
Received: from correo.us.es ([193.147.175.20]:45528 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726510AbgKOLT1 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Sun, 15 Nov 2020 06:19:27 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 91998E4B88
        for <netfilter-devel@vger.kernel.org>; Sun, 15 Nov 2020 12:19:22 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 82EE1DA722
        for <netfilter-devel@vger.kernel.org>; Sun, 15 Nov 2020 12:19:22 +0100 (CET)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 69F60FC5E1; Sun, 15 Nov 2020 12:19:22 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 517F8DA704;
        Sun, 15 Nov 2020 12:19:20 +0100 (CET)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Sun, 15 Nov 2020 12:19:20 +0100 (CET)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from us.es (unknown [90.77.255.23])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: 1984lsi)
        by entrada.int (Postfix) with ESMTPSA id 30D1A4265A5A;
        Sun, 15 Nov 2020 12:19:20 +0100 (CET)
Date:   Sun, 15 Nov 2020 12:19:19 +0100
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Lukas Bulwahn <lukas.bulwahn@gmail.com>
Cc:     Jozsef Kadlecsik <kadlec@netfilter.org>,
        Florian Westphal <fw@strlen.de>,
        netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
        Ralf Ramsauer <ralf.ramsauer@oth-regensburg.de>,
        Pia Eichinger <pia.eichinger@st.oth-regensburg.de>,
        Joe Perches <joe@perches.com>, kernel-janitors@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] MAINTAINERS: rectify file patterns for NETFILTER
Message-ID: <20201115111919.GA24901@salvia>
References: <20201109091942.32280-1-lukas.bulwahn@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20201109091942.32280-1-lukas.bulwahn@gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Virus-Scanned: ClamAV using ClamSMTP
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Mon, Nov 09, 2020 at 10:19:42AM +0100, Lukas Bulwahn wrote:
> The two file patterns in the NETFILTER section:
> 
>   F:      include/linux/netfilter*
>   F:      include/uapi/linux/netfilter*
> 
> intended to match the directories:
> 
>   ./include{/uapi}/linux/netfilter_{arp,bridge,ipv4,ipv6}
> 
> A quick check with ./scripts/get_maintainer.pl --letters -f will show that
> they are not matched, though, because this pattern only matches files, but
> not directories.
> 
> Rectify the patterns to match the intended directories.

Applied, thanks.
