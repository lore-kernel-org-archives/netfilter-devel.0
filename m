Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 736B5C388F9
	for <netfilter-devel@archiver.kernel.org>; Sat, 21 Nov 2020 12:17:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3116A22226
	for <netfilter-devel@archiver.kernel.org>; Sat, 21 Nov 2020 12:17:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727717AbgKUMR3 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sat, 21 Nov 2020 07:17:29 -0500
Received: from correo.us.es ([193.147.175.20]:55040 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727668AbgKUMR2 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Sat, 21 Nov 2020 07:17:28 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id D070BE780F
        for <netfilter-devel@vger.kernel.org>; Sat, 21 Nov 2020 13:17:26 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id C301FDA78F
        for <netfilter-devel@vger.kernel.org>; Sat, 21 Nov 2020 13:17:26 +0100 (CET)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id B861ADA78C; Sat, 21 Nov 2020 13:17:26 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id A01D6DA73D;
        Sat, 21 Nov 2020 13:17:24 +0100 (CET)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Sat, 21 Nov 2020 13:17:24 +0100 (CET)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from us.es (unknown [90.77.255.23])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: 1984lsi)
        by entrada.int (Postfix) with ESMTPSA id 814694265A5A;
        Sat, 21 Nov 2020 13:17:24 +0100 (CET)
Date:   Sat, 21 Nov 2020 13:17:24 +0100
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Phil Sutter <phil@nwl.cc>
Cc:     netfilter-devel@vger.kernel.org, Derek Dai <daiderek@gmail.com>,
        guigom@riseup.net
Subject: Re: [nft PATCH] json: echo: Speedup seqnum_to_json()
Message-ID: <20201121121724.GA21214@salvia>
References: <20201120191640.21243-1-phil@nwl.cc>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20201120191640.21243-1-phil@nwl.cc>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Virus-Scanned: ClamAV using ClamSMTP
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Fri, Nov 20, 2020 at 08:16:40PM +0100, Phil Sutter wrote:
> Derek Dai reports:
> "If there are a lot of command in JSON node, seqnum_to_json() will slow
> down application (eg: firewalld) dramatically since it iterate whole
> command list every time."
> 
> He sent a patch implementing a lookup table, but we can do better: Speed
> this up by introducing a hash table to store the struct json_cmd_assoc
> objects in, taking their netlink sequence number as key.
> 
> Quickly tested restoring a ruleset containing about 19k rules:
> 
> | # time ./before/nft -jeaf large_ruleset.json >/dev/null
> | 4.85user 0.47system 0:05.48elapsed 97%CPU (0avgtext+0avgdata 69732maxresident)k
> | 0inputs+0outputs (15major+16937minor)pagefaults 0swaps
> 
> | # time ./after/nft -jeaf large_ruleset.json >/dev/null
> | 0.18user 0.44system 0:00.70elapsed 89%CPU (0avgtext+0avgdata 68484maxresident)k
> | 0inputs+0outputs (15major+16645minor)pagefaults 0swaps

LGTM.

BTW, Jose (he's on Cc) should rewrite his patch to exercise the
monitor path when --echo and --json are combined _and_ input is _not_
json.

Hence, leaving --echo and --json where input is json in the way you
need (using the sequence number to reuse the json input
representation).

OK?
