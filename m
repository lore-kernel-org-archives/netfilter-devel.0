Return-Path: <SRS0=aLv2=BJ=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.5 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A5B8BC433E0
	for <netfilter-devel@archiver.kernel.org>; Thu, 30 Jul 2020 19:27:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 889EC2083B
	for <netfilter-devel@archiver.kernel.org>; Thu, 30 Jul 2020 19:27:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728625AbgG3T1u (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 30 Jul 2020 15:27:50 -0400
Received: from correo.us.es ([193.147.175.20]:43964 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726581AbgG3T1u (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 30 Jul 2020 15:27:50 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 419B512BFF6
        for <netfilter-devel@vger.kernel.org>; Thu, 30 Jul 2020 21:27:48 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 30E41DA78B
        for <netfilter-devel@vger.kernel.org>; Thu, 30 Jul 2020 21:27:48 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 2675CDA722; Thu, 30 Jul 2020 21:27:48 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 0EE34DA78E;
        Thu, 30 Jul 2020 21:27:46 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Thu, 30 Jul 2020 21:27:46 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from us.es (unknown [90.77.255.23])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: 1984lsi)
        by entrada.int (Postfix) with ESMTPSA id E35544265A2F;
        Thu, 30 Jul 2020 21:27:45 +0200 (CEST)
Date:   Thu, 30 Jul 2020 21:27:45 +0200
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Timo Sigurdsson <public_timo.s@silentcreek.de>
Cc:     netfilter-devel@vger.kernel.org
Subject: Re: Moving from ipset to nftables: Sets not ready for prime time yet?
Message-ID: <20200730192745.GA5293@salvia>
References: <20200702223010.C282E6C848EC@dd34104.kasserver.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200702223010.C282E6C848EC@dd34104.kasserver.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Fri, Jul 03, 2020 at 12:30:10AM +0200, Timo Sigurdsson wrote:
> Hi,
> 
> I'm currently migrating my various iptables/ipset setups to nftables. The nftables syntax is a pleasure and for the most part the transition of my rulesets has been smooth. Moving my ipsets to nftables sets, however, has proven to be a major pain point - to a degree where I started wondering whether nftables sets are actually ready to replace existing ipset workflows yet.
[...]
> 2) Atomic reload of large sets unbearably slow
> Moving on without the auto-merge feature, I started testing sets with actual lists I use. The initial setup (meaning populating the sets for the first time) went fine. But when I tried to update them atomically, i.e. use a script file that would have a 'flush set' statement in the beginning and then an 'add element' statement with all the addresses I wanted to add to it, the system seemed to lock up. As it turns out, updating existing large sets is excessively slow - to a point where it becomes unusable if you work with multiple large sets. I reported the details including an example and performance indicators here [4]. The only workaround for this (that keeps atomicity) I found so far is to reload the complete firewall configuration including the set definitions. But that has other unwanted side-effects such as resetting all counters and so on.
> 
> 3) Referencing sets within a set not possible
> As a workaround for the auto-merge issues described above (and also for another use case), I was looking into the possibility to reference sets within a set so I could create a set for each source list I use and reference them in a single set so I could match them all at once without duplicating rules for multiple sets. To be clear, I'm not really sure whether this is supposed to work all. I found some commits which suggested to me it might be possible [5][6]. Nevertheless, I couldn't get this to work.

For the record, these two issues are now fixed in git.

Thank you for reporting.
