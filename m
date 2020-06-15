Return-Path: <SRS0=VCDi=74=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E3D4CC433E0
	for <netfilter-devel@archiver.kernel.org>; Mon, 15 Jun 2020 22:00:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BF7E02071A
	for <netfilter-devel@archiver.kernel.org>; Mon, 15 Jun 2020 22:00:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726308AbgFOWAJ (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 15 Jun 2020 18:00:09 -0400
Received: from correo.us.es ([193.147.175.20]:52924 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725903AbgFOWAJ (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 15 Jun 2020 18:00:09 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 9B717124EE0
        for <netfilter-devel@vger.kernel.org>; Tue, 16 Jun 2020 00:00:07 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 8B7C1DA789
        for <netfilter-devel@vger.kernel.org>; Tue, 16 Jun 2020 00:00:07 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 80B58DA722; Tue, 16 Jun 2020 00:00:07 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 4F522DA789;
        Tue, 16 Jun 2020 00:00:05 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Tue, 16 Jun 2020 00:00:05 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from us.es (unknown [90.77.255.23])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: 1984lsi)
        by entrada.int (Postfix) with ESMTPSA id 2E136426CCB9;
        Tue, 16 Jun 2020 00:00:05 +0200 (CEST)
Date:   Tue, 16 Jun 2020 00:00:04 +0200
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Stefano Brivio <sbrivio@redhat.com>
Cc:     netfilter-devel@vger.kernel.org
Subject: Re: [PATCH nft] tests: shell: Allow wrappers to be passed as nft
 command
Message-ID: <20200615220004.GA25745@salvia>
References: <4e47c812a2cbe17159393d8d2667e28b3c0ba79d.1592170384.git.sbrivio@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4e47c812a2cbe17159393d8d2667e28b3c0ba79d.1592170384.git.sbrivio@redhat.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Sun, Jun 14, 2020 at 11:41:37PM +0200, Stefano Brivio wrote:
> The current check on $NFT only allows to directly pass an executable,
> so I've been commenting it out locally for a while to run tests with
> valgrind.
> 
> Instead of using the -x test, run nft without arguments and check the
> exit status. POSIX.1-2017, Shell and Utilities volume, par. 2.8.2
> ("Exit Status for Commands") states:
> 
>   If a command is not found, the exit status shall be 127. If the
>   command name is found, but it is not an executable utility, the
>   exit status shall be 126. Applications that invoke utilities
>   without using the shell should use these exit status values to
>   report similar errors.
> 
> While this script isn't POSIX-compliant, it requires bash, and any
> modern version of bash complies with those exit status requirements.
> Also valgrind complies with this.
> 
> We need to quote the NFT variable passed to execute the commands in
> the main loop and adjust error and informational messages, too.
> 
> This way, for example, export NFT="valgrind nft" can be issued to
> run tests with valgrind.

Applied, thanks.
