Return-Path: <SRS0=RE83=6O=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0ADD4C47247
	for <netfilter-devel@archiver.kernel.org>; Thu, 30 Apr 2020 14:05:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E9A132076D
	for <netfilter-devel@archiver.kernel.org>; Thu, 30 Apr 2020 14:05:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728074AbgD3OFV (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 30 Apr 2020 10:05:21 -0400
Received: from orbyte.nwl.cc ([151.80.46.58]:40466 "EHLO orbyte.nwl.cc"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728595AbgD3NxD (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 30 Apr 2020 09:53:03 -0400
Received: from n0-1 by orbyte.nwl.cc with local (Exim 4.91)
        (envelope-from <n0-1@orbyte.nwl.cc>)
        id 1jU9ca-0006KD-Nb; Thu, 30 Apr 2020 15:53:00 +0200
Date:   Thu, 30 Apr 2020 15:53:00 +0200
From:   Phil Sutter <phil@nwl.cc>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org
Subject: Re: [iptables PATCH v2 00/18] iptables: introduce cache evaluation
 phase
Message-ID: <20200430135300.GK15009@orbyte.nwl.cc>
Mail-Followup-To: Phil Sutter <phil@nwl.cc>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        netfilter-devel@vger.kernel.org
References: <20200428121013.24507-1-phil@nwl.cc>
 <20200429213609.GA24368@salvia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200429213609.GA24368@salvia>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Hi Pablo,

On Wed, Apr 29, 2020 at 11:36:09PM +0200, Pablo Neira Ayuso wrote:
> On Tue, Apr 28, 2020 at 02:09:55PM +0200, Phil Sutter wrote:
> > Hi Pablo,
> > 
> > As promised, here's a revised version of your cache rework series from
> > January. It restores performance according to my tests (which are yet to
> > be published somewhere) and passes the testsuites.
> 
> I did not test this yet, and I made a few rounds of quick reviews
> alrady, but this series LGTM. Thank you for working on this.

Cool! Should I push it or do you want to have a closer look first?

Cheers, Phil
