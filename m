Return-Path: <SRS0=6lPY=BO=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.5 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CD7BAC433DF
	for <netfilter-devel@archiver.kernel.org>; Tue,  4 Aug 2020 11:44:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B661420738
	for <netfilter-devel@archiver.kernel.org>; Tue,  4 Aug 2020 11:44:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730219AbgHDLo1 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 4 Aug 2020 07:44:27 -0400
Received: from correo.us.es ([193.147.175.20]:60356 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730211AbgHDLoV (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 4 Aug 2020 07:44:21 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 334F9F2DE8
        for <netfilter-devel@vger.kernel.org>; Tue,  4 Aug 2020 13:44:19 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 227CDDA722
        for <netfilter-devel@vger.kernel.org>; Tue,  4 Aug 2020 13:44:19 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 18238DA73F; Tue,  4 Aug 2020 13:44:19 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 123ECDA722;
        Tue,  4 Aug 2020 13:44:17 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Tue, 04 Aug 2020 13:44:17 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from us.es (unknown [213.143.49.65])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: 1984lsi)
        by entrada.int (Postfix) with ESMTPSA id 9060D4265A32;
        Tue,  4 Aug 2020 13:44:16 +0200 (CEST)
Date:   Tue, 4 Aug 2020 13:44:13 +0200
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Stefano Brivio <sbrivio@redhat.com>
Cc:     netfilter-devel@vger.kernel.org, Florian Westphal <fw@strlen.de>
Subject: Re: [PATCH nft] tests: 0043concatenated_ranges_0: Fix checks for
 add/delete failures
Message-ID: <20200804114413.GB21665@salvia>
References: <1201d76f21c3272d2e0db35326f3c64239f8a3dc.1596461357.git.sbrivio@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1201d76f21c3272d2e0db35326f3c64239f8a3dc.1596461357.git.sbrivio@redhat.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Mon, Aug 03, 2020 at 04:06:39PM +0200, Stefano Brivio wrote:
> The test won't stop if we simply precede commands expected to fail
> by !. POSIX.1-2017 says:
> 
>   -e
>       When this option is on, if a simple command fails for any of
>       the reasons listed in Consequences of Shell Errors or returns
>       an exit status value >0, and is not part of the compound list
>       following a while, until or if keyword, and is not a part of
>       an AND or OR list, and is not a pipeline preceded by the "!"
>       reserved word, then the shell will immediately exit.
> 
> ...but I didn't care about the last part.
> 
> Replace those '! nft ...' commands by 'nft ... && exit 1' to actually
> detect failures.
> 
> As a result, I didn't notice that now, correctly, inserting elements
> into a set that contains the same exact element doesn't actually
> fail, because nft doesn't pass NLM_F_EXCL on a simple 'add'. Drop
> re-insertions from the checks we perform here, overlapping elements
> are already covered by other tests.

Also applied, thanks.
