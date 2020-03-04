Return-Path: <SRS0=EiUA=4V=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AE5F7C3F2D1
	for <netfilter-devel@archiver.kernel.org>; Wed,  4 Mar 2020 09:40:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8D6A82073D
	for <netfilter-devel@archiver.kernel.org>; Wed,  4 Mar 2020 09:40:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387688AbgCDJk0 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 4 Mar 2020 04:40:26 -0500
Received: from orbyte.nwl.cc ([151.80.46.58]:57500 "EHLO orbyte.nwl.cc"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728955AbgCDJk0 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 4 Mar 2020 04:40:26 -0500
Received: from n0-1 by orbyte.nwl.cc with local (Exim 4.91)
        (envelope-from <n0-1@orbyte.nwl.cc>)
        id 1j9QVr-0007kY-UP; Wed, 04 Mar 2020 10:40:23 +0100
Date:   Wed, 4 Mar 2020 10:40:23 +0100
From:   Phil Sutter <phil@nwl.cc>
To:     Florian Westphal <fw@strlen.de>
Cc:     Pablo Neira Ayuso <pablo@netfilter.org>,
        netfilter-devel@vger.kernel.org
Subject: Re: [iptables PATCH] connlabel: Allow numeric labels even if
 connlabel.conf exists
Message-ID: <20200304094023.GI5627@orbyte.nwl.cc>
Mail-Followup-To: Phil Sutter <phil@nwl.cc>,
        Florian Westphal <fw@strlen.de>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        netfilter-devel@vger.kernel.org
References: <20200304022459.6433-1-phil@nwl.cc>
 <20200304081651.GE979@breakpoint.cc>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200304081651.GE979@breakpoint.cc>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Hi,

On Wed, Mar 04, 2020 at 09:16:51AM +0100, Florian Westphal wrote:
> Phil Sutter <phil@nwl.cc> wrote:
> > Existing code is a bit quirky: If no connlabel.conf was found, the local
> > function connlabel_value_parse() is called which tries to interpret
> > given label as a number. If the config exists though,
> > nfct_labelmap_get_bit() is called instead which doesn't care about
> > "undefined" connlabel names. So unless installed connlabel.conf contains
> > entries for all possible numeric labels, rules added by users may stop
> > working if a connlabel.conf is created. Fix this by falling back to
> > connlabel_value_parse() function also if connlabel_open() returned 0 but
> > nfct_labelmap_get_bit() returned an error.
> 
> Acked-by: Florian Westphal <fw@strlen.de>

When checking whether documentation needs an update, I stumbled upon the
following sentences:

"Instead of a name (which will be translated to a number, see EXAMPLE
below), a number may be used instead.  Using a number always overrides
connlabel.conf."

So actually I should change the code to try numeric parsing first and
only then fall back to nfct_labelmap_get_bit(). Commit 51340f7b6a110
("extensions: libxt_connlabel: use libnetfilter_conntrack") broke this
in 2013. I'll send a v2.

Thanks, Phil


