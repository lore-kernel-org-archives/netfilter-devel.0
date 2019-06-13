Return-Path: <SRS0=MXD6=UM=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_MUTT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AEA57C31E4A
	for <netfilter-devel@archiver.kernel.org>; Thu, 13 Jun 2019 15:07:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 91C31207E0
	for <netfilter-devel@archiver.kernel.org>; Thu, 13 Jun 2019 15:07:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387546AbfFMPHF (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 13 Jun 2019 11:07:05 -0400
Received: from orbyte.nwl.cc ([151.80.46.58]:51092 "EHLO orbyte.nwl.cc"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732621AbfFMPHE (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 13 Jun 2019 11:07:04 -0400
Received: from n0-1 by orbyte.nwl.cc with local (Exim 4.91)
        (envelope-from <n0-1@orbyte.nwl.cc>)
        id 1hbRJd-0006jr-4a; Thu, 13 Jun 2019 17:07:01 +0200
Date:   Thu, 13 Jun 2019 17:07:01 +0200
From:   Phil Sutter <phil@nwl.cc>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     Nicolas Dichtel <nicolas.dichtel@6wind.com>,
        Florian Westphal <fw@strlen.de>,
        netfilter-devel <netfilter-devel@vger.kernel.org>
Subject: Re: nftables release
Message-ID: <20190613150701.GM31548@orbyte.nwl.cc>
Mail-Followup-To: Phil Sutter <phil@nwl.cc>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Nicolas Dichtel <nicolas.dichtel@6wind.com>,
        Florian Westphal <fw@strlen.de>,
        netfilter-devel <netfilter-devel@vger.kernel.org>
References: <65ec483a-b8d7-530b-373f-6dcdd5f668c6@6wind.com>
 <20190530211628.lxufmb3gqizywkxe@breakpoint.cc>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190530211628.lxufmb3gqizywkxe@breakpoint.cc>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Hi,

On Thu, May 30, 2019 at 11:16:28PM +0200, Florian Westphal wrote:
> Nicolas Dichtel <nicolas.dichtel@6wind.com> wrote:
> > Hi,
> > 
> > is there any plan to release an official version of the nftables user-space utility?
> > The last one (v0.9.0) is now one year old ;-)
> 
> There are a few bugs that are sorted out right now,
> a new release should happen soon once that is resolved.

From my side things seem fine meanwhile. Are there concrete plans
already?

Cheers, Phil
