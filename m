Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C7F42C47089
	for <netfilter-devel@archiver.kernel.org>; Wed,  7 Dec 2022 18:48:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229626AbiLGSsP (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 7 Dec 2022 13:48:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55016 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229593AbiLGSsO (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 7 Dec 2022 13:48:14 -0500
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C17562A426
        for <netfilter-devel@vger.kernel.org>; Wed,  7 Dec 2022 10:48:12 -0800 (PST)
Received: from n0-1 by orbyte.nwl.cc with local (Exim 4.94.2)
        (envelope-from <n0-1@orbyte.nwl.cc>)
        id 1p2zSk-0001FZ-V3; Wed, 07 Dec 2022 19:48:10 +0100
Date:   Wed, 7 Dec 2022 19:48:10 +0100
From:   Phil Sutter <phil@nwl.cc>
To:     Jan Engelhardt <jengelh@inai.de>
Cc:     netfilter-devel@vger.kernel.org
Subject: Re: [iptables PATCH 03/11] Makefile: Generate ip6tables man pages on
 the fly
Message-ID: <Y5Df6lfjn+He29vy@orbyte.nwl.cc>
Mail-Followup-To: Phil Sutter <phil@nwl.cc>,
        Jan Engelhardt <jengelh@inai.de>, netfilter-devel@vger.kernel.org
References: <20221207174430.4335-1-phil@nwl.cc>
 <20221207174430.4335-4-phil@nwl.cc>
 <q9532812-p481-rsr1-44ns-559482nqrq@vanv.qr>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <q9532812-p481-rsr1-44ns-559482nqrq@vanv.qr>
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Wed, Dec 07, 2022 at 07:36:50PM +0100, Jan Engelhardt wrote:
> 
> On Wednesday 2022-12-07 18:44, Phil Sutter wrote:
> > 	${AM_VERBOSE_GEN} echo '.so man8/xtables-translate.8' >$@
> > 
> >+ip6tables.8 ip6tables-apply.8 ip6tables-restore.8 ip6tables-save.8:
> >+	${AM_VERBOSE_GEN} sed 's|^ip6|.so man8/ip|' <<<$@ >$@
> 
> <<< is not sh-compatible

Oh, thanks. I'll resubmit using 'echo "$@" | sed ...' then.

Thanks, Phil
