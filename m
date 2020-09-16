Return-Path: <SRS0=QZFf=CZ=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 259A2C43461
	for <netfilter-devel@archiver.kernel.org>; Wed, 16 Sep 2020 20:42:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DB0EE20770
	for <netfilter-devel@archiver.kernel.org>; Wed, 16 Sep 2020 20:42:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726987AbgIPUkx (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 16 Sep 2020 16:40:53 -0400
Received: from correo.us.es ([193.147.175.20]:49082 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726756AbgIPREz (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 16 Sep 2020 13:04:55 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id CDE54508CE0
        for <netfilter-devel@vger.kernel.org>; Wed, 16 Sep 2020 16:44:50 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id BD4C5DA78D
        for <netfilter-devel@vger.kernel.org>; Wed, 16 Sep 2020 16:44:50 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id B2244DA72F; Wed, 16 Sep 2020 16:44:50 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 9D14CDA722;
        Wed, 16 Sep 2020 16:44:48 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Wed, 16 Sep 2020 16:44:48 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from us.es (unknown [90.77.255.23])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: 1984lsi)
        by entrada.int (Postfix) with ESMTPSA id 8142842EFB81;
        Wed, 16 Sep 2020 16:44:48 +0200 (CEST)
Date:   Wed, 16 Sep 2020 16:44:48 +0200
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Gopal Yadav <gopunop@gmail.com>
Cc:     netfilter-devel@vger.kernel.org
Subject: Re: [PATCH] Solves Bug 1388 - Combining --terse with --json has no
 effect
Message-ID: <20200916144448.GA13562@salvia>
References: <CAAUOv8iVoKLZxx1xGVLj-=k4pSNyES5SWaaScx=17WV789Kw3Q@mail.gmail.com>
 <20200914104605.GA1617@salvia>
 <CAAUOv8i_1fx1OJFKtFAsU7Haq10qQisNqQhEGF75_+22_1A4pQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <CAAUOv8i_1fx1OJFKtFAsU7Haq10qQisNqQhEGF75_+22_1A4pQ@mail.gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Wed, Sep 16, 2020 at 07:07:40PM +0530, Gopal Yadav wrote:
> On Mon, Sep 14, 2020 at 4:16 PM Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> 
> > It would be also good if you can add a test. For instance, have a look at:
> >
> >         tests/shell/testcases/transactions/0049huge_0
> >
> > which also adds a shell tests for json. You can just get back the
> > listing in json and compare it. I suggest you use the
> > testcases/listing/ folder to store this new test.
> 
> Do you mean get back the terse json listing with "nft -j -t list
> ruleset" and compare it with "nft -j list ruleset" and check if they
> are different. And also check if attribute "elem" is present or
> something else?

I think you can add a set with elements, then run "nft -j -t list
ruleset" and check that the elements are not present in the json
output, keep it simple.
