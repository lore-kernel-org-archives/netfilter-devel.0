Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6F470C64E7C
	for <netfilter-devel@archiver.kernel.org>; Wed,  2 Dec 2020 09:47:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0FD9B206F9
	for <netfilter-devel@archiver.kernel.org>; Wed,  2 Dec 2020 09:47:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729255AbgLBJrr (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 2 Dec 2020 04:47:47 -0500
Received: from correo.us.es ([193.147.175.20]:34274 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726708AbgLBJrr (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 2 Dec 2020 04:47:47 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id D44065E476B
        for <netfilter-devel@vger.kernel.org>; Wed,  2 Dec 2020 10:47:02 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id C5C06FC5E6
        for <netfilter-devel@vger.kernel.org>; Wed,  2 Dec 2020 10:47:02 +0100 (CET)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id BB636DA73D; Wed,  2 Dec 2020 10:47:02 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id A5D93DA722;
        Wed,  2 Dec 2020 10:47:00 +0100 (CET)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Wed, 02 Dec 2020 10:47:00 +0100 (CET)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from us.es (unknown [90.77.255.23])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: 1984lsi)
        by entrada.int (Postfix) with ESMTPSA id 88EFC4265A5A;
        Wed,  2 Dec 2020 10:47:00 +0100 (CET)
Date:   Wed, 2 Dec 2020 10:47:02 +0100
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     "Jose M. Guisado" <guigom@riseup.net>
Cc:     Phil Sutter <phil@nwl.cc>, netfilter-devel@vger.kernel.org,
        Derek Dai <daiderek@gmail.com>
Subject: Re: [nft PATCH] json: echo: Speedup seqnum_to_json()
Message-ID: <20201202094702.GA6888@salvia>
References: <20201120191640.21243-1-phil@nwl.cc>
 <20201121121724.GA21214@salvia>
 <20201122235612.GP11766@orbyte.nwl.cc>
 <62770c7d-8c44-e50a-a1dd-9829e660e499@riseup.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <62770c7d-8c44-e50a-a1dd-9829e660e499@riseup.net>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Virus-Scanned: ClamAV using ClamSMTP
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Mon, Nov 30, 2020 at 09:43:04PM +0100, Jose M. Guisado wrote:
> On 23/11/20 0:56, Phil Sutter wrote:
> > Hi,
> > 
> > On Sat, Nov 21, 2020 at 01:17:24PM +0100, Pablo Neira Ayuso wrote:
> > > On Fri, Nov 20, 2020 at 08:16:40PM +0100, Phil Sutter wrote:
> > > > Derek Dai reports:
> > > > "If there are a lot of command in JSON node, seqnum_to_json() will slow
> > > > down application (eg: firewalld) dramatically since it iterate whole
> > > > command list every time."
> > > > 
> > > > He sent a patch implementing a lookup table, but we can do better: Speed
> > > > this up by introducing a hash table to store the struct json_cmd_assoc
> > > > objects in, taking their netlink sequence number as key.
> > > > 
> > > > Quickly tested restoring a ruleset containing about 19k rules:
> > > > 
> > > > | # time ./before/nft -jeaf large_ruleset.json >/dev/null
> > > > | 4.85user 0.47system 0:05.48elapsed 97%CPU (0avgtext+0avgdata 69732maxresident)k
> > > > | 0inputs+0outputs (15major+16937minor)pagefaults 0swaps
> > > > 
> > > > | # time ./after/nft -jeaf large_ruleset.json >/dev/null
> > > > | 0.18user 0.44system 0:00.70elapsed 89%CPU (0avgtext+0avgdata 68484maxresident)k
> > > > | 0inputs+0outputs (15major+16645minor)pagefaults 0swaps
> > > 
> > > LGTM.
> > > 
> > > BTW, Jose (he's on Cc) should rewrite his patch to exercise the
> > > monitor path when --echo and --json are combined _and_ input is _not_
> > > json.
> 
> IIRC v4 of the patch already takes into account this situation. Specifically
> this piece of code inside netlink_echo_callback. Returning the
> json_events_cb (the path leading to the seqnum_to_json call) when input is
> json.

OK, I have pushed out this patch. Thanks for clarifying.
