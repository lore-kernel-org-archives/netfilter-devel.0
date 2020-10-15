Return-Path: <SRS0=46WK=DW=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 32701C43457
	for <netfilter-devel@archiver.kernel.org>; Thu, 15 Oct 2020 09:26:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CE33221D7F
	for <netfilter-devel@archiver.kernel.org>; Thu, 15 Oct 2020 09:26:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730694AbgJOJ0u (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 15 Oct 2020 05:26:50 -0400
Received: from correo.us.es ([193.147.175.20]:40846 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728083AbgJOJ0u (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 15 Oct 2020 05:26:50 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 708C6C0B2D
        for <netfilter-devel@vger.kernel.org>; Thu, 15 Oct 2020 11:26:46 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 5D928DA792
        for <netfilter-devel@vger.kernel.org>; Thu, 15 Oct 2020 11:26:46 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 523DDDA78A; Thu, 15 Oct 2020 11:26:46 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 574A2DA78C;
        Thu, 15 Oct 2020 11:26:44 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Thu, 15 Oct 2020 11:26:44 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from us.es (unknown [90.77.255.23])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: 1984lsi)
        by entrada.int (Postfix) with ESMTPSA id 26D5F42EF42C;
        Thu, 15 Oct 2020 11:26:44 +0200 (CEST)
Date:   Thu, 15 Oct 2020 11:26:43 +0200
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Naresh Kamboju <naresh.kamboju@linaro.org>
Cc:     "open list:KERNEL SELFTEST FRAMEWORK" 
        <linux-kselftest@vger.kernel.org>, netfilter-devel@vger.kernel.org,
        Netdev <netdev@vger.kernel.org>, lkft-triage@lists.linaro.org,
        Florian Westphal <fw@strlen.de>, fabf@skynet.be,
        Shuah Khan <shuah@kernel.org>,
        Kees Cook <keescook@chromium.org>,
        Anders Roxell <anders.roxell@linaro.org>
Subject: Re: selftests: netfilter: nft_nat.sh: /dev/stdin:2:9-15: Error:
 syntax error, unexpected counter
Message-ID: <20201015092643.GB3468@salvia>
References: <CA+G9fYv=zPRGCKyhi9DeUsvyb6ZLVVXdV3hW+15XnQN2R3ircQ@mail.gmail.com>
 <20201014193034.GA14337@salvia>
 <CA+G9fYsnPH4nQWoY0bpdw+DS5sqO4xcxDXuu-tfEHxXEGrMyUA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <CA+G9fYsnPH4nQWoY0bpdw+DS5sqO4xcxDXuu-tfEHxXEGrMyUA@mail.gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Virus-Scanned: ClamAV using ClamSMTP
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Thu, Oct 15, 2020 at 08:31:52AM +0530, Naresh Kamboju wrote:
> On Thu, 15 Oct 2020 at 01:00, Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> >
> > On Wed, Oct 14, 2020 at 05:19:33PM +0530, Naresh Kamboju wrote:
> > > While running kselftest netfilter test on x86_64 devices linux next
> > > tag 20201013 kernel
> > > these errors are noticed. This not specific to kernel version we have
> > > noticed these errors
> > > earlier also.
> > >
> > > Am I missing configs ?
> >
> > What nftables version are you using?
> 
> nft --version
> nftables v0.7 (Scrooge McDuck)

That's very very old.

Latest is 0.9.6, please run latest in your CI testbed.
