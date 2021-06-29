Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 991E2C11F66
	for <netfilter-devel@archiver.kernel.org>; Tue, 29 Jun 2021 08:37:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6E43761DE5
	for <netfilter-devel@archiver.kernel.org>; Tue, 29 Jun 2021 08:37:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232454AbhF2Iju (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 29 Jun 2021 04:39:50 -0400
Received: from mail.netfilter.org ([217.70.188.207]:33428 "EHLO
        mail.netfilter.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232429AbhF2Ijt (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 29 Jun 2021 04:39:49 -0400
Received: from netfilter.org (unknown [90.77.255.23])
        by mail.netfilter.org (Postfix) with ESMTPSA id E2DAF60788;
        Tue, 29 Jun 2021 10:37:16 +0200 (CEST)
Date:   Tue, 29 Jun 2021 10:37:18 +0200
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     "Neal P. Murphy" <neal.p.murphy@alum.wpi.edu>
Cc:     netfilter@vger.kernel.org, netfilter-devel@vger.kernel.org
Subject: Re: Reload IPtables
Message-ID: <20210629083718.GA10943@salvia>
References: <f5314629-8a08-3b5f-cfad-53bf13483ec3@hajes.org>
 <adc28927-724f-2cdb-ca6a-ff39be8de3ba@thelounge.net>
 <96559e16-e3a6-cefd-6183-1b47f31b9345@hajes.org>
 <16b55f10-5171-590f-f9d2-209cfaa7555d@thelounge.net>
 <54e70d0a-0398-16e4-a79e-ec96a8203b22@tana.it>
 <f0daea91-4d12-1605-e6df-e7f95ba18cac@thelounge.net>
 <8395d083-022b-f6f7-b2d3-e2a83b48c48a@tana.it>
 <20210628104310.61bd287ff147a59b12e23533@plushkava.net>
 <20210628220241.64f9af54@playground>
 <20210629083652.GA10896@salvia>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20210629083652.GA10896@salvia>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Mon, Jun 28, 2021 at 10:02:41PM -0400, Neal P. Murphy wrote:
> On Mon, 28 Jun 2021 10:43:10 +0100
> Kerin Millar <kfm@plushkava.net> wrote:
> 
> > Now you benefit from atomicity (the rules will either be committed at once, in full, or not at all) and proper error handling (the exit status value of iptables-restore is meaningful and acted upon). Further, should you prefer to indent the body of the heredoc, you may write <<-EOF, though only leading tab characters will be stripped out.
> > 
> 
> [minor digression]
> 
> Is iptables-restore truly atomic in *all* cases?

Packets either see the old table or the new table, no intermediate
ruleset state is exposed to packet path.

> Some years ago, I found through experimentation that some rules were
> 'lost' when restoring more than 25 000 rules.

Could you specify kernel and userspace versions? Rules are not 'lost'
when restoring large rulesets.

> If I placed a COMMIT every 20 000 rules or so, then all rules would
> be properly loaded. I think COMMITs break atomicity.

Why are you placing COMMIT in every few rules 20 000 rules?

> I tested with 100k to 1M rules.

iptables is handling very large rulesets already.

> I was comparing the efficiency of iptables-restore with another tool
> that read from STDIN; the other tool was about 5% more efficient.

Could you please specify what other tool are you refering to?

iptables-restore is the best practise to restore your ruleset.

You should also iptables-restore to perform incremental updates via
--noflush.
